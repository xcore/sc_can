#ifndef _CAN_FUNCTIONS
#define _CAN_FUNCTIONS

#ifdef __XC__

void printPacket(struct CanPacket &p);
void initPacket(struct CanPacket &p);
void randomizePacket(struct CanPacket &p, int bitZero);
void sendPacket(chanend c, struct CanPacket &p);
void receivePacket(chanend c, struct CanPacket &p);

#pragma select handler
void rxReady(buffered in port:32 p, unsigned int &time);

#endif

#endif
