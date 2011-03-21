#include <stdlib.h>
#include <platform.h>
#include "CanLLC.h"
#include "CanIncludes.h"
#include "CanFunctions.h"
#include "CanPhy.h"

#define LLC
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

#define COMMAND_NONE  0
#define SEND_PACKET   1
#define SEND_DONE     2
#define THREAD_1	  3
#define THREAD_2	  4

#define LED_RESOLUTION 11
#define LED_RESOLUTION1 0
void init_LLC(MSGMEMORY &stmsgMemory,unsigned int NodeId);
void canTestRxTx(chanend controlChan, chanend rxChan, chanend txChan, chanend ledChan, int bitZero) {
	struct CanPacket txPacket;
	struct CanPacket rxPacket;
	MSGMEMORY stmsgMemory;
	MSGOBJECT tMessageObject[32];
	struct CanLLCState LLCState;
	unsigned int index = 0 ;
	unsigned int txIndex = 0;
	unsigned int bits = 0;
	 	unsigned char flag_set_filter = 0;
	unsigned int Filter_Id = 0;
	unsigned int Mask_Id = 0;


	unsigned int txPacketCount = 0;
	unsigned int rxPacketCount = 0;

	randomizePacket(txPacket, bitZero);
	init_LLC(stmsgMemory, 2);
	LLCState.state = 0;
	while (1) {
		unsigned int command = COMMAND_NONE;
		unsigned int txAck;
		unsigned int rxAck;
		unsigned int threadNum = 0;
		unsigned int i = 0;
		 unsigned int done = 0;
		LLCState.state = STATE_CHK_COMMAND;



		select {
		case inuint_byref(controlChan, command):
			threadNum = inuint(controlChan);
			 break;
		case inuint_byref(rxChan, rxAck):
			receivePacket(rxChan, rxPacket);
			break;
		}


#ifdef LLC
    	while(!done)
		{
		switch(LLCState.state)
			{
			case STATE_CHK_COMMAND :

			   if ((command == SEND_PACKET)&&(threadNum == THREAD_2))
				LLCState.state = STATE_CONFIG_TX ;
			   else
				LLCState.state = STATE_COMMAND_NONE ;
				break;
			case STATE_COMMAND_SEND://case STATE_COMMAND_SEND:
				outuint(txChan, txPacketCount);
				sendPacket(txChan, txPacket);
				randomizePacket(txPacket, bitZero);
				txPacketCount++;
				done = 1;
				break;
			case STATE_CONFIG_TX :
				//call configure_transit_message()//set the bit corresponding to message with pending req. for transmission
				index++ ;
				index = index %32;
				LLCState.state = STATE_TRNSMT_MSG_TO_PHY ;
				break;
			case STATE_TRNSMT_MSG_TO_PHY :
				can_write(txPacket,stmsgMemory.MessageObject,index);
				LLCState.state = STATE_COMMAND_SEND ;
				break;
			case STATE_COMMAND_NONE :
				outuint(controlChan, SEND_DONE);
				rxPacketCount++;
				LLCState.state = STATE_CONFIG_RX ;
				break;
			case STATE_CONFIG_RX :
				//configure_receive_message();//set the bit corresponding to new message to be stored at perticular msg object.
		    	if(ENABLE_FILTER)
					flag_set_filter = Set_acceptance_filter (rxPacket, Filter_Id,Mask_Id);
					flag_set_filter = 0 ; //temporary set . It should return 0 for specific Filter ID , which is for allowing all message.
				if(!flag_set_filter) // accept the message for receiving in message RAM
					LLCState.state = STATE_RECEIVE_MSG ;
				else
				{
					outuint(ledChan,rxPacketCount>>LED_RESOLUTION);
					outct(ledChan, XS1_CT_END);
					done = 1;
				}
				break;
			case STATE_RECEIVE_MSG :
				can_read(rxPacket,stmsgMemory.MessageObject,index);
				//outuint(ledChan,rxPacketCount>>LED_RESOLUTION);
				if((rxPacket.DATA[1]==0x0)&&(threadNum != THREAD_2))
				outuint(ledChan,0x55);
				else if((rxPacket.DATA[0]==0x1)&&(threadNum == THREAD_2))
				outuint(ledChan,0x0);
				else if ((rxPacket.DATA[0]!=0x0)&&(threadNum != THREAD_2))
				outuint(ledChan,0x0);
				else
				outuint(ledChan,0x0);
				//outuint(ledChan,rxPacket.DATA[0]);
				outct(ledChan, XS1_CT_END);
				index++;
				index = index%32;
				done = 1;
				break;
			}
		}



#endif







#ifndef LLC
		if ((command == SEND_PACKET)&&(threadNum == THREAD_1)) {
			outuint(txChan, txPacketCount);
#ifndef LLC
			for(i=0;i<8;i++)
			txPacket.DATA[i] = 0x7F;
			txPacket.THREADNUM = THREAD_1;
			sendPacket(txChan, txPacket);
			randomizePacket(txPacket, bitZero);
#else

			can_write(txPacket,stmsgMemory.MessageObject,txIndex);
			txIndex++;
	//		txIndex = txIndex%32;
#endif
			txPacketCount++;
		}else if((command == SEND_PACKET)&&(threadNum == THREAD_2)) {
			outuint(txChan, txPacketCount);
			for(i=0;i<8;i++)
			txPacket.DATA[i] = 0x3F;
			//txPacket.THREADNUM = THREAD_2;
			sendPacket(txChan, txPacket);
			randomizePacket(txPacket, bitZero);
			txPacketCount++;
		}else if (command == COMMAND_NONE) {
			outuint(controlChan, SEND_DONE);
			rxPacketCount++;
			can_read(rxPacket,stmsgMemory.MessageObject,index);
			//outuint(ledChan,(stmsgMemory.MessageObject[index].DATA[0])>>LED_RESOLUTION1);
			outuint(ledChan,rxPacketCount>>LED_RESOLUTION);
			outct(ledChan, XS1_CT_END);
			index++;
			index = index%32;

		}
#endif


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


					outuint(controlChan1, SEND_PACKET);
					outuint(controlChan1, THREAD_2);

/*
		if (numPackets == 2) {
			outuint(controlChan0, SEND_PACKET);
			outuint(controlChan0, THREAD_1);
			outuint(controlChan1, SEND_PACKET);
			outuint(controlChan1, THREAD_2);
		} else {
			if (chanNum) {
				outuint(controlChan0, SEND_PACKET);
				outuint(controlChan0, THREAD_1);
			} else {
				outuint(controlChan1, SEND_PACKET);
				outuint(controlChan1, THREAD_2);
			}
		}

  */
	//	while (rxPacketCount < numPackets)
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
		case inuint_byref(client0, bits):
			inct(client0);
			green = 0;
			value = (value & 0xff0) | (bits & 0xf);
			value1 = (value1 & 0xff0) | (bits & 0xf);
			//driveLeds(led0, led1, led2, ledGreen, ledRed, value, green);
			break;
		case inuint_byref(client1, bits):
			inct(client1);
//			if(bits ==2048)
//			{
//			driveLeds(led0, led1, led2, ledGreen, ledRed, 1, 0xaaa);
//			}
//			bits = inuint(client1);
//			inct(client1);
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

		on stdcore[1]: canTestRxTx(controlChan_0, rxChan_0, txChan_0, ledChan_0, 0);
		on stdcore[1]: canTestRxTx(controlChan_1, rxChan_1, txChan_1, ledChan_1, 1);

		on stdcore[1]: canController(controlChan_0, controlChan_1, ledChan_2);
	}
	return 0;
}
