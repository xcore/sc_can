#ifndef _CAN_PHY
#define _CAN_PHY

#ifdef __XC__

/**
 *   The top level thread function for the CAN Phy interface.
 *
 *   \param rxChan  The channel to receive packets from the CAN Phy thread
 *   \param txChan  The channel to send packets to the CAN Phy thread
 *   \param clk     A clock block for associating with the CAN interface
 *   \param canRx   The CAN Rx port, a one bit port which is operated in buffered mode
 *   \param canTx   The CAN Tx port, a one bit port
 */
void canPhyRxTx(chanend rxChan, chanend txChan, clock clk, buffered in port:32 canRx, port canTx);
#endif

#endif
