#include "CanLLC.h"




inline STATUS Set_acceptance_filter (struct CanPacket rxPacket, unsigned int Filter_Id, unsigned int Mask_Id)
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
	unsigned int tXOR = 0;

    unsigned frame_format = 0;
    frame_format = (!(rxPacket.IEB^CAN_EXTENDED_FRAME));

    if(frame_format == CAN_STANDARD_FRAME )
    {

    }

    if(frame_format == CAN_EXTENDED_FRAME)
    {

    }

	Identifier = rxPacket.ID; //lower 11-bit value in case of Standrad Frame

	tXOR = !(Identifier^Filter_Id);
	if(((!Mask_Id)|tXOR)== 0xFFFF)
	{
		printstrln("Message with given identifier is accepted\n");
       return 0;
	}
	else
		return 1;

}
// can_read() will get called from client thread
//OR message handler state machine
inline void can_read(struct CanPacket rxPacket,MSGOBJECT pstmsgObject[32])
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
		//Todo : either to update only data field OR
		//         whole message object in RAM.
		// copy the data bytes from received CAN packet to message object
		for(i=0;i<4;i++)
		pstmsgObject[1].DATA[i] = rxPacket.DATA[i];
	}
	if(frame_type == CAN_REMOTE_FRAME)
	{
		//Todo : update the pending request for
		//		tranmission for this message object,
		//		which in turn update state to call can_write()

        //scan for the message matching with requested identifier
		for(i=0;i<32;i++)
		{
		if(pstmsgObject[i].ID == rxPacket.ID)
			break;
		}
		// Next message with pending transmission pstmsgObject[i]

		//Set the bit for tranmission for message object pstmsgObject[i]

	}



}
//can_write() will get called from client thread
//OR message handler state machine
inline void can_write(struct CanPacket &txPacket,MSGOBJECT &pstmsgObject)
{
	unsigned int i =0;

	for(i=0;i<4;i++)
	txPacket.DATA[i] = pstmsgObject.DATA[i];


}

