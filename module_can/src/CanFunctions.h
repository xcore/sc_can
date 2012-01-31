#ifndef _CAN_FUNCTIONS
#define _CAN_FUNCTIONS

#ifdef __XC__

/**
 *  Clear the fields in a packet structure to zero
 *
 *  \param p   The packet to clear
 */
void initPacket(struct CanPacket &p);

/**
 *  Produce a random packet in the given packet structure
 *
 *  \param p        The packet to randomize
 *  \param bitZero  The least significant bit of the ID field
 */
void randomizePacket(struct CanPacket &p, int bitZero);

/**
 *  Send a packet to the CAN PHY thread
 *
 *  \note  Before calling this function, a single word should be
 *         pushed into the transmit channel, using outuint(c,0)
 *
 *  \param c  The transmit channel linked to the CAN Phy thread
 *  \param p  The packet structure to transmit
 */
void sendPacket(chanend c, struct CanPacket &p);

/**
 *  Receive a packet from the CAN Phy thread
 *
 *  \note  The CAN Phy thread will preceed the packet with a single
 *         unsigned integer.  This integer must be consumed, either
 *         using an inuint(), or by selecting on the channel in a
 *         select statement block using inuint_byref()
 *
 *  \param c  The receive channel of the CAN Phy thread
 *  \param p  The packet structure to receive data into
 */
void receivePacket(chanend c, struct CanPacket &p);

/**
 *  Used internally by the CAN Phy thread to check for a transition on
 *  the receive data port
 */
#pragma select handler
void rxReady(buffered in port:32 p, unsigned int &time);

#endif

#endif
