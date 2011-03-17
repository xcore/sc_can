#ifndef _CAN_PHY
#define _CAN_PHY

#ifdef __XC__
void canPhyRxTx(chanend rxChan, chanend txChan, chanend rateChan,clock clk, buffered in port:32 canRx, port canTx);
#endif

#endif
