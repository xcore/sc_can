#include <print.h>
#include <stdlib.h>
#include <xs1.h>
#include "CanLLC.h"
#include "CanIncludes.h"
#include "CanFunctions.h"

void printPacket(struct CanPacket &p) {
	printstr("SOF: ");
	printhexln(p.SOF);
	printstr("ID: ");
	printhexln(p.ID);
	if (p.IEB == 1) {
		printstr("SRR: ");
		printhexln(p.SRR);
		printstr("IEB: ");
		printhexln(p.IEB);
		printstr("EID: ");
		printhexln(p.EID);
		printstr("RTR: ");
		printhexln(p.RTR);
		printstr("RB1: ");
		printhexln(p.RB1);
	} else {
		printstr("RTR: ");
		printhexln(p.RTR);
		printstr("IEB: ");
		printhexln(p.IEB);
	}
	printstr("RB0: ");
	printhexln(p.RB0);
	printstr("DLC: ");
	printhexln(p.DLC);

	for (int i = 0; i < 8; i++) {
		printstr("DATA[");
		printint(i);
		printstr("]:");
		printhexln(p.DATA[i]);
	}
	printstr("CRC: ");
	printhexln(p.CRC);
	printstr("CRCdel: ");
	printhexln(p.CRC_DEL);
	printstr("ACKdel: ");
	printhexln(p.ACK_DEL);
	printstr("EOF: ");
	printhexln(p._EOF);
}

void initPacket(struct CanPacket &p) {
	p.SOF = 0;
	p.ID  = 0;
	p.SRR = 0;
	p.IEB = 0;
	p.EID = 0;
	p.RTR = 0;
	p.RB1 = 0;
	p.RB0 = 0;
	p.DLC = 0;
	for (int i = 0; i < 8; i++) {
		p.DATA[i] = 0;
	}
	p.CRC = 0;
	p.CRC_DEL = 1;
	p.ACK_DEL = 1;
	p._EOF = 0xf7;
}

void randomizePacket(struct CanPacket &p, int bitZero) {
	// Fields which are fixed unless injecting errors
	p.SOF = 0;
	p.RB0 = 0;
	p.CRC_DEL = 1;
	p.ACK_DEL = 1;
	p._EOF = 0x7F;

	p.ID  = rand() & 0x7ff;
	//if (rand() & 0x1) {
	if (0) {
		// Create extended packet
		p.SRR = 0;
		p.IEB = 1;
		p.EID = rand() & 0x3ffff;
		p.RTR = 0;
		p.RB1 = 0;

		p.EID = (p.EID & ~1) | bitZero;
	} else {
		// Create normal packet
		p.SRR = 0;
		p.IEB = 0;
		p.EID = 0;
		p.RTR = 0;
		p.RB1 = 0;

		p.ID = (p.ID & ~1) | bitZero;
	}

	p.DLC = 8;//rand() % 9; // bug : it should be 8
	for (int i = 0; i < p.DLC; i++) {
		p.DATA[i] = rand() & 0xff;
	}

	// CRC is calculated by transmitter
	p.CRC = 0;
}

void clearMsgObject(MSGOBJECT MessageObject[32], unsigned int index){

		MessageObject[index].SOF = 0;
		MessageObject[index].RB0 = 0;
		MessageObject[index].CRC_DEL = 1;
		MessageObject[index].ACK_DEL = 1;
		MessageObject[index]._EOF = 0x7F;

		MessageObject[index].ID  = (31-index);

		// Create normal packet
		MessageObject[index].SRR = 0;
		MessageObject[index].IEB = 0;
		MessageObject[index].EID = 0;
		MessageObject[index].RTR = 0;
		MessageObject[index].RB1 = 0;

		MessageObject[index].ID = (31-index);

		MessageObject[index].DLC = 8;
		for (int i = 0; i < MessageObject[index].DLC; i++) {
			MessageObject[index].DATA[i] = index;
		}

		// CRC is calculated by transmitter
		MessageObject[index].CRC = 0;
}

#pragma unsafe arrays
void sendPacket(chanend c, struct CanPacket &p) {
	outuint(c, p.ID);
	outuint(c, p.SRR);
	outuint(c, p.IEB);
	outuint(c, p.EID);
	outuint(c, p.RTR);
	outuint(c, p.DLC);
	outuint(c, p.DATA[0]);
	outuint(c, p.DATA[1]);
	outuint(c, p.DATA[2]);
	outuint(c, p.DATA[3]);
	outuint(c, p.DATA[4]);
	outuint(c, p.DATA[5]);
	outuint(c, p.DATA[6]);
	outuint(c, p.DATA[7]);
}

#pragma unsafe arrays
void receivePacket(chanend c, struct CanPacket &p) {
	p.ID  = inuint(c);
	p.SRR = inuint(c);
	p.IEB = inuint(c);
	p.EID = inuint(c);
	p.RTR = inuint(c);
	p.DLC = inuint(c);
	p.DATA[0] = inuint(c);
	p.DATA[1] = inuint(c);
	p.DATA[2] = inuint(c);
	p.DATA[3] = inuint(c);
	p.DATA[4] = inuint(c);
	p.DATA[5] = inuint(c);
	p.DATA[6] = inuint(c);
	p.DATA[7] = inuint(c);
}

// Needing to be in a different file due to BUG 8295
void rxReady(buffered in port:32 p, unsigned int &time) {
}

void initLLC(MSGMEMORY &stmsgMemory,unsigned int NodeId)
{
	for(int j=0;j<32;j++){
	stmsgMemory.MessageObject[j].SOF = 0;
	stmsgMemory.MessageObject[j].ID  = 0;
	stmsgMemory.MessageObject[j].SRR = 0;
	stmsgMemory.MessageObject[j].IEB = 0;
	stmsgMemory.MessageObject[j].EID = 0;
	stmsgMemory.MessageObject[j].RTR = 0;
	stmsgMemory.MessageObject[j].RB1 = 0;
	stmsgMemory.MessageObject[j].RB0 = 0;
	stmsgMemory.MessageObject[j].DLC = 0;
	for (int i = 0; i < 8; i++) {
		stmsgMemory.MessageObject[j].DATA[i] = 0x55;//i+(j*100);
	}
	stmsgMemory.MessageObject[j].CRC = 0;
	stmsgMemory.MessageObject[j].CRC_DEL = 1;
	stmsgMemory.MessageObject[j].ACK_DEL = 1;
	stmsgMemory.MessageObject[j]._EOF = 0xf7;
	}

	stmsgMemory.MsgObjRegisterSet.reg_TxRequest = 0;
}
