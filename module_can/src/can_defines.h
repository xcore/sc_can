#include "can_conf.h"

//Error defines
#define  CAN_ERROR_RX_NONE   (0)
#define  CAN_ERROR_TX_NONE   (1)
#define  CAN_ERROR_RX_ERROR  (2)
#define  CAN_ERROR_TX_ERROR  (3)

#define  ERROR_BIT_ERROR     (0)
#define  ERROR_STUFF_ERROR   (1)
#define  ERROR_FORM_ERROR    (2)
#define  ERROR_CRC_ERROR     (3)
#define  ERROR_NO_ACK        (4)
#define  ERROR_SPECIAL_STUFF_ERROR (5)  //this is the error that happens in exception 2


#define RXTX_RET_TO_ERROR_COUNTER(X) ((X>>1)&0x3fff)
#define RXTX_RET_TO_ERROR_TYPE(X) (X&3)
#define RXTX_RET_TO_ERROR_CLASS(X) (X >> 16)


//RxTxFrame memory defines
#define RX_DATA_0   0
#define RX_DATA_1   1
#define TX_DATA_0   2
#define TX_DATA_1   3

#define RX_REMOTE   4
#define TX_REMOTE   5
#define RX_EXTENDED 6
#define TX_EXTENDED 7
#define RX_ID_STD   8
#define TX_ID_STD   9
#define RX_ID_EXT   10
#define TX_ID_EXT   11
#define RX_DLC      12
#define TX_DLC      13

// stack defines
#define S_DP_SPILL  7     //a spill slot for the dp
#define S_TX_BIT    8     //a spill slot for the most recently transmitted bit
#define S_STATE     9     //state machine state
#define S_ARB       10    //Determines if arbitration is on or off.
#define S_STATUS    11    //The error status

#define SYNC_SEG 1

#ifndef PROP_SEG
#error PROP_SEG is undefined.
#else
#if (PROP_SEG > 8)
#error PROP_SEG must be from 1 to 8 TIME QUANTUM long.
#endif
#endif
#ifndef PHASE_SEG1
#error PHASE_SEG1 is undefined.
#else
#if (PHASE_SEG1 > 8)
#error PHASE_SEG1 must be from 1 to 8 TIME QUANTUM long.
#endif
#endif
#ifndef PHASE_SEG2
#error PHASE_SEG2 is undefined.
#else
#if (PHASE_SEG2 < PHASE_SEG1)
#error PHASE_SEG2 not be shorter then PHASE_SEG1.
#endif
#endif

#define TOTAL_TIME (SYNC_SEG + PROP_SEG + PHASE_SEG1 + PHASE_SEG2)
#define SAMPLE_TIME (SYNC_SEG + PROP_SEG + PHASE_SEG1)
#define SAMPLE_PORT_CYCLES ((SAMPLE_TIME * 50) / TOTAL_TIME)
