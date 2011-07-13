#include <stdlib.h>
#include <platform.h>
#include "CanLLC.h"
#include "CanIncludes.h"
#include "CanFunctions.h"
#include "CanPhy.h"


#define LLC
void canLLCRxTx(chanend controlChan, chanend rxChan, chanend txChan, chanend ledChan, int bitZero) {
	struct CanPacket txPacket;
	struct CanPacket rxPacket;
	unsigned int txPacketCount = 0;
	unsigned int rxPacketCount = 0;


#ifdef LLC
	MSGMEMORY stmsgMemory;
	struct CanLLCState LLCState;
	unsigned int index = 0 ;

	unsigned int rxIndex = 0;
	unsigned char flag_set_filter = 0;
	unsigned int Filter_Id = 0;
	unsigned int Mask_Id = 0;
	unsigned char flgChangedContent =0;
	unsigned char Flag =0;
#endif
	randomizePacket(txPacket, bitZero);
#ifdef LLC
	initLLC(stmsgMemory, 2);
	randomizeMsgObject(stmsgMemory.MessageObject, bitZero,index);//randomizePacket(txPacket, bitZero);//

	LLCState.state = canOpen(stmsgMemory);

#endif


	while (1) {
		unsigned int command = COMMAND_NONE;
		unsigned int txAck;
		unsigned int rxAck;

#ifdef LLC
		unsigned int threadNum = 0;
		unsigned int i = 0;
		unsigned int done = 0;

		 LLCState.state = STATE_CHK_COMMAND;
#endif

#ifndef LLC
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
#endif
#ifdef LLC
		select {
		case inuint_byref(controlChan, command):
		//	threadNum = inuint(controlChan);
			 break;
		case inuint_byref(rxChan, rxAck):
			receivePacket(rxChan, rxPacket);
			break;
		}


    	while(!done)
		{
		switch(LLCState.state)
			{
			case STATE_CHK_COMMAND :
			   //if ((command == SEND_PACKET)&&(threadNum == THREAD_2))
				if (command == SEND_PACKET)
				LLCState.state = STATE_CONFIG_TX ;
			   else
				LLCState.state = STATE_COMMAND_NONE ;
				break;

			case STATE_COMMAND_SEND://case STATE_COMMAND_SEND:
				outuint(txChan, txPacketCount);
				sendPacket(txChan, txPacket);
				randomizeMsgObject(stmsgMemory.MessageObject,bitZero,index);//randomizePacket(txPacket, bitZero);//
				txPacketCount++;
				done = 1;
				break;

			case STATE_CONFIG_TX :
				//set the bit corresponding to message with pending req. for transmission
				configureTransitMessage(stmsgMemory,index);
				LLCState.state = STATE_TRNSMT_MSG_TO_PHY ;
				break;

			case STATE_TRNSMT_MSG_TO_PHY :
				canWrite(txPacket,stmsgMemory.MessageObject,index);
				index++ ;
				index = index %32;
				LLCState.state = STATE_COMMAND_SEND ;
				break;

			case STATE_COMMAND_NONE :

				outuint(controlChan, SEND_DONE);
				rxPacketCount++;
				LLCState.state = STATE_CONFIG_RX ;
				break;

			case STATE_CONFIG_RX :
				//set the bit corresponding to new message to be stored at perticular msg object.
				configureReceiveMessage(Mask_Id,Filter_Id);
				Flag = (rxIndex == rxPacket.ID);

				for(i=0;i<(rxPacket.DLC);i++)
				Flag &= (stmsgMemory.MessageObject[rxIndex].DATA[i] == rxPacket.DATA[i]);
				flgChangedContent = !(Flag) ;

		    	if(ENABLE_FILTER)
					flag_set_filter = SetAcceptanceFilter (rxPacket, Filter_Id,Mask_Id);
					flag_set_filter = 0 ; //temporary set . It should return 0 for specific Filter ID , which is for allowing all message.
				if(!flag_set_filter) {// accept the message for receiving in message RAM
					rxIndex = rxPacket.ID ;
					LLCState.state = STATE_RECEIVE_MSG ;
				}
				else
				{
					outuint(ledChan,rxPacketCount>>LED_RESOLUTION);
					outct(ledChan, XS1_CT_END);
					done = 1;
				}
				break;

			case STATE_RECEIVE_MSG :
				rxIndex = rxPacket.ID ;
				if(flgChangedContent){
					canReadChangedContent(rxPacket,stmsgMemory.MessageObject,rxIndex);
				}
				else{
				canRead(rxPacket,stmsgMemory.MessageObject,rxIndex);
				}
				//if((stmsgMemory.MessageObject[rxIndex].DATA[1]==(31-rxIndex))&&(threadNum != THREAD_2))
				if(stmsgMemory.MessageObject[rxIndex].DATA[1]==(31-rxIndex))
				outuint(ledChan,0x1);
				else
				outuint(ledChan,0x0);
				outct(ledChan, XS1_CT_END);
				done = 1;
				break;
			}
		}
#endif

	}
#ifdef LLC
	LLCState.state = canClose(stmsgMemory);
#endif
}


STATUS SetAcceptanceFilter (struct CanPacket rxPacket, unsigned int Filter_Id, unsigned int Mask_Id)
{


	/* MASK ID    FILTERID  IDENTIFIER    RECEPTION
	 *   0          X          X          ACCEPT
	 *   1          0          0          ACCEPT
	 *   1          0          1          REJECT
	 *   1          1          0          REJECT
	 *   1          1          1          ACCEPT
	 */
	unsigned int Identifier = 0;
	//unsigned int tXOR = 0;
	unsigned int tOR = 0;


    unsigned frame_format = 0;
    frame_format = (!(rxPacket.IEB^CAN_EXTENDED_FRAME));

    if(frame_format == CAN_STANDARD_FRAME )
    {
    	tOR = Identifier | Filter_Id ;
    	if((tOR & Mask_Id) == Mask_Id)
    		return 1;
    	else
    		return 0;

    }

    if(frame_format == CAN_EXTENDED_FRAME)
    {

    }
    return 0;
}

void canReadChangedContent (struct CanPacket rxPacket,MSGOBJECT pstmsgObject[32],unsigned index){
	unsigned int frame_type = 0;
	unsigned int i =0;

	pstmsgObject[index].SOF = rxPacket.SOF ;

	frame_type = (rxPacket.RTR | CAN_DATA_FRAME);

	if(frame_type == CAN_DATA_FRAME)
		{
			// copy the data bytes from received CAN packet to message object
			for(i=0;i<8;i++)
			pstmsgObject[index].DATA[i] = rxPacket.DATA[i];
		}

	if(frame_type == CAN_REMOTE_FRAME)
		{
		 //scan for the message matching with requested identifier
			for(i=0;i<32;i++)
			{
				if(pstmsgObject[index].ID == rxPacket.ID)
				break;
			}

		}

}

// can_read() will get called from client thread
//OR message handler state machine
void canRead(struct CanPacket rxPacket,MSGOBJECT pstmsgObject[32],unsigned index)
{
	unsigned int frame_type = 0;
	unsigned int i =0;

	pstmsgObject[index].SOF = rxPacket.SOF ;


	frame_type = (rxPacket.RTR | CAN_DATA_FRAME);
	/* RTR bit | CAN_DATA_FRAME   frame_type
	 *   0	   |     0               0          - data frame
	 *   1     |     0               1          - remote frame
	 */

	if(frame_type == CAN_DATA_FRAME)
	{

		for(i=0;i<8;i++)
		pstmsgObject[index].DATA[i] = rxPacket.DATA[i];
	}
	if(frame_type == CAN_REMOTE_FRAME)
	{

        //scan for the message matching with requested identifier
		for(i=0;i<32;i++)
		{
		if(pstmsgObject[index].ID == rxPacket.ID)
			break;
		}

	}



}
//can_write() will get called from client thread
//OR message handler state machine
void canWrite(struct CanPacket &txPacket,MSGOBJECT pstmsgObject[32],unsigned index)
{
	unsigned int i =0;
    unsigned txIndex = 0;
    index = index & 0x1FFFFF ;
    txIndex = index>>LED_RESOLUTION ;

    txPacket.ID = pstmsgObject[index].ID ;

	for(i=0;i<8;i++)
		txPacket.DATA[i] = pstmsgObject[index].DATA[i];

}

void configureTransitMessage(MSGMEMORY &stmsgMemory,unsigned int index)
{
	unsigned tReg = 0x1;
	stmsgMemory.MsgObjRegisterSet.reg_TxRequest = (tReg << index);
	// index - mesage object with pending request for tranmission

}

void configureReceiveMessage(unsigned &Mask_Id,unsigned &Filter_Id){
	Mask_Id = 0x0;
	Filter_Id = 0x0;

}

LLC_STATE canOpen(MSGMEMORY stmsgMemory){

	return STATE_CAN_START;
}



LLC_STATE canClose(MSGMEMORY stmsgMemory){

	return STATE_CAN_STOP;
}




