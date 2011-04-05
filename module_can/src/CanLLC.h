#ifndef _CANLLC_H_
#define _CANLLC_H_

#include <print.h>
#include <stdlib.h>
#include "CanIncludes.h"

#define TEST_VALUE 0xAA

#define STATUS int

#define CAN_EXTENDED_FRAME 1
#define CAN_STANDARD_FRAME 0
#define CAN_DATA_FRAME 0
#define CAN_REMOTE_FRAME 1


#define MALLOC malloc

#define MAX_MESSAGE_OBJECT 32

/*Global variable declaration for CAN LLC layer
 * msgObject : which is the RAM memory allocated for storing
 * 					received CAN packets with perticular configuration
 * MsgHandler : this is a state machine that takes care of message tranmission & reception
 * 					from PHY layer guaranting the data consistency
 *
 * mlBx : There is a mail box for each of the CAN node, which holds message object
 * 		  till 32 .Each message object within mail box has unique priority value
 *        For 1 it is maximum & for 32 it is minimum.
 */
//unsigned int Persistent_RAM[512];
//

typedef struct MessageRegister
{
	unsigned int reg_TxRequest;
	unsigned char flag_filter ;
}MSGOBJECTREGTER;



typedef struct MessageObject {
	unsigned DATA[8]; // First in struct so that worst-case path is quicker

	unsigned SOF;
	unsigned ID;
	unsigned SRR;
	unsigned IEB;
	unsigned EID;
	unsigned RTR;
	unsigned RB1;
	unsigned RB0;
	unsigned DLC;
	unsigned CRC;
	unsigned CRC_DEL;
	unsigned ACK_DEL;
	unsigned _EOF;
}MSGOBJECT;

typedef struct MailBox{
	MSGOBJECTREGTER MsgObjRegisterSet ;
	MSGOBJECT MessageObject[32];
}MSGMEMORY;

LLC_STATE can_open(MSGMEMORY stmsgMemory);
void can_read(struct CanPacket rxPacket,MSGOBJECT pstmsgObject[32],unsigned index);
void can_read_changed_content (struct CanPacket rxPacket,MSGOBJECT pstmsgObject[32],unsigned index);
void can_write(struct CanPacket &txPacket,MSGOBJECT pstmsgObject[32],unsigned index);
STATUS Set_acceptance_filter (struct CanPacket rxPacket, unsigned int Filter_Id, unsigned int Mask_Id);
void configure_transit_message(MSGMEMORY &stmsgMemory,unsigned int index);
void configure_receive_message(unsigned &Mask_Id,unsigned &Filter_Id);
void message_handler_state_machine(MSGOBJECTREGTER regs_status,struct CanLLCState &LLCState,unsigned int command,unsigned int threadNum);
void randomizeMsgObject(MSGOBJECT MessageObject[32], int bitZero,unsigned int index);
LLC_STATE can_close(MSGMEMORY stmsgMemory);

#ifdef __XC__
void canLLCRxTx(chanend controlChan, chanend rxChan, chanend txChan, chanend ledChan, int bitZero) ;
#endif

#endif


