#include "CanLLC.h"

#define LED_RESOLUTION 16


STATUS Set_acceptance_filter (struct CanPacket rxPacket, unsigned int Filter_Id, unsigned int Mask_Id)
{

	//ToDo: check for Frame Formats

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
    	tOR = (rxPacket.ID) | Filter_Id ;
    	if((tOR & Mask_Id) == Mask_Id)
    		return 1;
    	else
    		return 0;

    }

    if(frame_format == CAN_EXTENDED_FRAME)
    {

    }

#if 0
	Identifier = rxPacket.ID; //lower 11-bit value in case of Standrad Frame


	tXOR = !(Identifier^Filter_Id);
	if(((!Mask_Id)|tXOR)== 0xFFFF)
	{
		printstrln("Message with given identifier is accepted\n");
       return 0;
       // return flag = 1;
	}
	else
		return 1;
	    //return flag = 0;
#endif



}
// can_read() will get called from client thread
//OR message handler state machine
void can_read(struct CanPacket rxPacket,MSGOBJECT pstmsgObject[32],unsigned index)
{
	//Todo : check for Frame Type : data frame OR Remote frame.

	unsigned int frame_type = 0;
	unsigned int i =0;

	frame_type = (rxPacket.RTR | CAN_DATA_FRAME);
	/* RTR bit | CAN_DATA_FRAME   frame_type
	 *   0	   |     0               0          - data frame
	 *   1     |     0               1          - remote frame
	 */

	if(frame_type == CAN_DATA_FRAME)
	{
		//Todo : either to update only data field(permanent message object) OR
		//         whole message object in RAM.
		// copy the data bytes from received CAN packet to message object
		for(i=0;i<8;i++)
		pstmsgObject[index].DATA[i] = rxPacket.DATA[i];
	}
	if(frame_type == CAN_REMOTE_FRAME)
	{
		//Todo : update the pending request for
		//		tranmission for this message object,
		//		which in turn update state to call can_write()

        //scan for the message matching with requested identifier
		for(i=0;i<32;i++)
		{
		if(pstmsgObject[index].ID == rxPacket.ID)
			break;
		}
		// Next message with pending transmission pstmsgObject[i]

		//Set the bit for tranmission for message object pstmsgObject[i]

	}



}
//can_write() will get called from client thread
//OR message handler state machine
void can_write(struct CanPacket &txPacket,MSGOBJECT pstmsgObject[32],unsigned index)
{
	unsigned int i =0;
    unsigned txIndex = 0;
    index = index & 0x1FFFFF ;
    txIndex = index>>LED_RESOLUTION ;

    txPacket.ID = pstmsgObject[index].ID ;

	for(i=0;i<8;i++)
		txPacket.DATA[i] = pstmsgObject[index].DATA[i];

}

void message_handler_state_machine(MSGOBJECTREGTER regs_status,struct CanLLCState &LLCState,unsigned int command,unsigned int threadNum)
{
   unsigned int done = 0;
#if 0
	// applying acceptance filter
	regs_status.flag_filter = ENABLE_FILTER ;
	// setting pending request for transmission
	regs_status.reg_TxRequest = 0xFFFFFFFF ; // set for tranmission of all 32 message objects

	while(!done)
	{
	switch(LLCState.state)
		{
		case STATE_CHK_COMMAND :
			if ((command == SEND_PACKET)&&(threadNum == THREAD_1))
			LLCState.state = STATE_COMMAND_SEND ;
			else
			LLCState.state = STATE_COMMAND_NONE ;
			break;
		case COMMAND_SEND:
			break;
		case CONFIG_TX :
			break;
		case TRANSMIT_MSG :
			break;
		case COMMAND_NONE :
			LLCState.state = RECEIVE_MSG ;
			break;
		case RECEIVE_MSG :
			break;
		case CONFIG_RX :
			break;

		}
	}
#endif

}


