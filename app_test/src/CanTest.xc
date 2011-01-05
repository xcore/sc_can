#include <stdlib.h>
#include <platform.h>

#include "CanIncludes.h"
#include "CanFunctions.h"
#include "CanPhy.h"


//#define SIM_TESTING

/*
 * Test the CAN phy. Either in simulation or silicon. If running a simulation need to
 * loopback:
 *   -port stdcore[0] XS1_PORT_1A 0 1 -port stdcore[0] XS1_PORT_1B 0 1
 *   -port stdcore[1] XS1_PORT_1A 0 1 -port stdcore[1] XS1_PORT_1B 0 1
 *   -port stdcore[0] XS1_PORT_1A 0 1 -port stdcore[1] XS1_PORT_1A 0 1
 *   -port stdcore[0] XS1_PORT_1A 0 1 -port stdcore[1] XS1_PORT_1B 0 1
 *   -port stdcore[0] XS1_PORT_1B 0 1 -port stdcore[1] XS1_PORT_1A 0 1
 *
 * For hardware need to use the XC-1 made up by Suleiman.
 *
 */

on stdcore[0] : clock               canClk_0   = XS1_CLKBLK_1;
on stdcore[0] : buffered in port:32 canRx_0    = XS1_PORT_1A;
on stdcore[0] :             port    canTx_0    = XS1_PORT_1B;
on stdcore[0] :             port    led0_0     = XS1_PORT_4A;
on stdcore[0] :             port    led1_0     = XS1_PORT_4B;
on stdcore[0] :             port    led2_0     = XS1_PORT_4C;
on stdcore[0] :             port    ledRed_0   = XS1_PORT_1F;
on stdcore[0] :             port    ledGreen_0 = XS1_PORT_1E;

on stdcore[1] : clock               canClk_1   = XS1_CLKBLK_1;
on stdcore[1] : buffered in port:32 canRx_1    = XS1_PORT_1A;
on stdcore[1] :             port    canTx_1    = XS1_PORT_1B;
on stdcore[1] :             port    led0_1     = XS1_PORT_4A;
on stdcore[1] :             port    led1_1     = XS1_PORT_4B;
on stdcore[1] :             port    led2_1     = XS1_PORT_4C;
on stdcore[1] :             port    ledRed_1   = XS1_PORT_1F;
on stdcore[1] :             port    ledGreen_1 = XS1_PORT_1E;

on stdcore[0] : clock               canClk_2   = XS1_CLKBLK_2;
on stdcore[0] : buffered in port:32 canRx_2    = XS1_PORT_1C;
on stdcore[0] :             port    canTx_2    = XS1_PORT_1D;

#define COMMAND_NONE  0
#define SEND_PACKET   1
#define SEND_DONE     2

#define LED_RESOLUTION 11

void canTestRxTx(chanend controlChan, chanend rxChan, chanend txChan, chanend ledChan, int bitZero) {
	struct CanPacket txPacket;
	struct CanPacket rxPacket;
	unsigned int txPacketCount = 0;
	unsigned int rxPacketCount = 0;

	randomizePacket(txPacket, bitZero);

	while (1) {
		unsigned int command = COMMAND_NONE;
		unsigned int txAck;
		unsigned int rxAck;

		select {
		case inuint_byref(controlChan, command):
			break;
		case inuint_byref(rxChan, rxAck):
			receivePacket(rxChan, rxPacket);
			break;
		}

		if (command == SEND_PACKET) {
			outuint(txChan, txPacketCount);
			sendPacket(txChan, txPacket);
			randomizePacket(txPacket, bitZero);
			txPacketCount++;
		} else if (command == COMMAND_NONE) {
			outuint(controlChan, SEND_DONE);
			rxPacketCount++;
			outuint(ledChan, rxPacketCount >> LED_RESOLUTION);
			outct(ledChan, XS1_CT_END);
		}
	}
}

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

		if (numPackets == 2) {
			outuint(controlChan0, SEND_PACKET);
			outuint(controlChan1, SEND_PACKET);
		} else {
			if (chanNum) {
				outuint(controlChan0, SEND_PACKET);
			} else {
				outuint(controlChan1, SEND_PACKET);
			}
		}

		while (rxPacketCount < numPackets) {
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

	unsigned int green = 0;
	unsigned int value = 0;

	driveLeds(led0, led1, led2, ledGreen, ledRed, 1, 0xaaa);
	while(1) {
		unsigned int bits = 0;

		select {
		case inuint_byref(client0, bits):
			inct(client0);
			value = (value & 0xff0) | (bits & 0xf);
			break;
		case inuint_byref(client1, bits):
			inct(client1);
			value = (value & 0xf0f) | (bits & 0xf) << 4;
			break;
		case inuint_byref(client2, bits):
			inct(client2);
			value = (value & 0x0ff) | (bits & 0xf) << 8;
			break;
		}

		driveLeds(led0, led1, led2, ledGreen, ledRed, value, green);
	}
}

#ifdef SIM_TESTING
int main() {
	chan rxChan_0, txChan_0;
	chan rxChan_1, txChan_1;
	chan controlChan_0, controlChan_1;
	chan ledChan_0, ledChan_1, ledChan_2;

	par {
		on stdcore[0]: canPhyRxTx(rxChan_0, txChan_0, canClk_0, canRx_0, canTx_0);
		on stdcore[0]: canTestRxTx(controlChan_0, rxChan_0, txChan_0, ledChan_0, 0);

		on stdcore[1]: canPhyRxTx(rxChan_1, txChan_1, canClk_1, canRx_1, canTx_1);
		on stdcore[1]: canTestRxTx(controlChan_1, rxChan_1, txChan_1, ledChan_1, 1);

		on stdcore[2]: canController(controlChan_0, controlChan_1, ledChan_2);
	}
	return 0;
}
#else

#ifdef TEST_SINGLE_RXTX
#define COUNTER_MASK 0xfff
void canNetworkRx(chanend rxChan, chanend ledChan) {
	struct CanPacket p;
	unsigned count = 1;

	while(1) {
		unsigned int value = inuint(rxChan);
		receivePacket(rxChan, p);

		count = (count + 1) & COUNTER_MASK;
		outuint(ledChan, count);
	}
}

void canNetworkTx(chanend txChan, chanend ledChan, int bitZero) {
	struct CanPacket p;
	int count = 0;

	while (1) {
		randomizePacket(p, bitZero);

		outuint(txChan, count);
		sendPacket(txChan, p);

		count = (count + 1) & COUNTER_MASK;
		outuint(ledChan, count);
	}
}

int main() {
	chan rxChan, txChan;
	chan ledChan_0, ledChan_1;

	par {
		on stdcore[0]: canPhyRxTx(rxChan, txChan, canClk_0, canRx_0, canTx_0);
		on stdcore[0]: canNetworkRx(rxChan, ledChan_0);
//		on stdcore[0]: canNetworkTx(txChan, ledChan_1, 0);
		on stdcore[0]: ledManager(ledChan_0, ledChan_1,
				led0_0, led1_0, led2_0, ledGreen_0, ledRed_0);
	}
	return 0;
}
#endif

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

		on stdcore[1]: canTestRxTx(controlChan_0, rxChan_0, txChan_0, ledChan_0, 0);
		on stdcore[1]: canTestRxTx(controlChan_1, rxChan_1, txChan_1, ledChan_1, 1);

		on stdcore[1]: canController(controlChan_0, controlChan_1, ledChan_2);
	}
	return 0;
}

#endif
