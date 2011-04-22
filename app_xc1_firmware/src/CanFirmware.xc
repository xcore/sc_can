#include <stdlib.h>
#include <platform.h>
#include "CanLLC.h"
#include "CanIncludes.h"
#include "CanFunctions.h"
#include "CanPhy.h"


on stdcore[0] : clock               canClk_0   = XS1_CLKBLK_1;
on stdcore[0] : buffered in port:32 canRx_0    = XS1_PORT_1A;
on stdcore[0] :             port    canTx_0    = XS1_PORT_1B;
on stdcore[0] :             port    led0_0     = XS1_PORT_4A;
on stdcore[0] :             port    led1_0     = XS1_PORT_4B;
on stdcore[0] :             port    led2_0     = XS1_PORT_4C;
on stdcore[0] :             port    ledRed_0   = XS1_PORT_1F;
on stdcore[0] :             port    ledGreen_0 = XS1_PORT_1E;

on stdcore[0] : clock               canClk_2   = XS1_CLKBLK_2;
on stdcore[0] : buffered in port:32 canRx_2    = XS1_PORT_1C;
on stdcore[0] :             port    canTx_2    = XS1_PORT_1D;






#define MAX_DELAY     5000

void canController(chanend controlChan0, chanend controlChan1, chanend ledChan) {
	int completePacketCount = 0;
	timer t;
	unsigned int time;

	while (1) {
		int delay = rand() % MAX_DELAY;
		int numPackets = (rand() & 1) + 1;
		int chanNum = rand() & 1;
		int rxPacketCount = 0;

		t :> time;
		t when timerafter(time + delay) :> time;


					outuint(controlChan1, SEND_PACKET);
					//outuint(controlChan1, THREAD_2);



			{
			unsigned int ack = 0;
			select {
			case inuint_byref(controlChan0, ack):
				break;
			case inuint_byref(controlChan1, ack):
				break;
		    }

			if (ack == SEND_DONE) {
				rxPacketCount++;
			} else {
				exit(1);
			}
		}
		completePacketCount += numPackets;
		outuint(ledChan, completePacketCount >> LED_RESOLUTION);
		outct(ledChan, XS1_CT_END);
	}
}

void driveLeds(port led0, port led1, port led2, port ledGreen, port ledRed,
		unsigned int value, unsigned int green) {

	if (green) {
		ledRed :> void;
		ledGreen <: 1;
	} else {
		ledGreen :> void;
		ledRed <: 1;
	}

	led0 <: value;
	led1 <: (value >> 4);
	led2 <: (value >> 8);
}

void ledManager(chanend client0, chanend client1, chanend client2,
		port led0, port led1, port led2, port ledGreen, port ledRed) {

	unsigned int green = 1;
	unsigned int value = 0;
	unsigned value1 = 0;
	unsigned int i = 0;

	driveLeds(led0, led1, led2, ledGreen, ledRed, 1, 0xaaa);
	while(1) {
		unsigned int bits = 0;

		select {
		case inuint_byref(client0, green)://inuint_byref(client0, bits):
			inct(client0);
		    bits = 0xf;
			value = (value & 0xff0) | (bits & 0xf);
			value1 = (value1 & 0xff0) | (bits & 0xf);
			//driveLeds(led0, led1, led2, ledGreen, ledRed, value, green);
			break;
		case inuint_byref(client1, bits):
			inct(client1);
			if(bits ==2048)
			{
			driveLeds(led0, led1, led2, ledGreen, ledRed, 1, 0xaaa);
			}
			bits = inuint(client1);
			inct(client1);
			value = (value & 0xf0f) | (bits & 0xf) << 4;
		    value1 = 0 ;
			break;
		case inuint_byref(client2, bits):
			inct(client2);
		    green = 1;
			value = (value & 0x0ff) | (bits & 0xf) << 8;
			value1 = 0 ;
			break;
		}
#ifdef LLC
		driveLeds(led0, led1, led2, ledGreen, ledRed, value1, green);
#endif
	}
}

int main() {
	chan rxChan_0, txChan_0;
	chan rxChan_1, txChan_1;
	chan controlChan_0, controlChan_1;
	chan ledChan_0, ledChan_1, ledChan_2;

	par {
		on stdcore[0]: canPhyRxTx(rxChan_0, txChan_0, canClk_0, canRx_0, canTx_0);
		on stdcore[0]: canPhyRxTx(rxChan_1, txChan_1, canClk_2, canRx_2, canTx_2);
		on stdcore[0]: ledManager(ledChan_0, ledChan_1, ledChan_2,
				led0_0, led1_0, led2_0, ledGreen_0, ledRed_0);

		on stdcore[0]: canLLCRxTx(controlChan_0, rxChan_0, txChan_0, ledChan_0, 0);
		on stdcore[0]: canLLCRxTx(controlChan_1, rxChan_1, txChan_1, ledChan_1, 1);

		on stdcore[0]: canController(controlChan_0, controlChan_1, ledChan_2);
	}
	return 0;
}
