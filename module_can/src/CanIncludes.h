#ifndef _CAN_INCLUDES
#define _CAN_INCLUDES

#define LLC
//#define DEBUG

/*
 * Assuming 25 time quanta then the following baud rates are avaliable.
 * If the time quanta are changed then you will need to ensure that the
 * CLOCK_DIV is still a integer
 *
 * BAUD_RATE  CLOCK_DIV
 * 1000000      2
 *  500000      4
 *  400000      5
 *  250000      8
 *  200000     10
 *  125000     16
 *  100000     20
 *  80000      25
 *  62500      32
 *  50000      40
 *  40000      50
 *  31250      64
 *  25000      80
 *  20000     100
 *  16000     125
 *  15625     128
 *  12500     160
 *  10000     200
 *  8000      250
 *  7813      256
 *  5000      400
 */

/***/
#define COMMAND_NONE  0
#define SEND_PACKET   1
#define SEND_DONE     2
#define THREAD_1	  3
#define THREAD_2	  4
#define LED_RESOLUTION 11

/****/

#define SYSTEM_CLOCK 100000000
#define BAUD_RATE  500000 //1000000 //

#define QUANTA_SYNC      1
#define QUANTA_PROP      8
#define QUANTA_PHASE1    8
#define QUANTA_PHASE2    8
#define QUANTA_SJW       4
#define QUANTA_TOTAL    (QUANTA_SYNC + QUANTA_PROP + QUANTA_PHASE1 + QUANTA_PHASE2)
#define CLOCK_DIV       (SYSTEM_CLOCK / (BAUD_RATE * QUANTA_TOTAL * 2))

typedef enum {
	STATE_SOF          =  0,
	STATE_ID           =  1,
	STATE_SRR          =  2,
	STATE_IEB          =  3,
	STATE_EID          =  4,
	STATE_RTR          =  5,
	STATE_RB1          =  6,
	STATE_RB0          =  7,
	STATE_DLC          =  8,
	STATE_DATA_BIT7    =  9,
	STATE_DATA_BIT6    = 10,
	STATE_DATA_BIT5    = 11,
	STATE_DATA_BIT4    = 12,
	STATE_DATA_BIT3    = 13,
	STATE_DATA_BIT2    = 14,
	STATE_DATA_BIT1    = 15,
	STATE_DATA_BIT0    = 16,
	STATE_CRC          = 17,
	STATE_CRC_DEL      = 18,
	STATE_ACK          = 19,
	STATE_ACK_DEL      = 20,
	STATE_EOF          = 21,
	STATE_INTERMISSION = 22,
	STATE_OVERLOAD     = 23,
	STATE_OVERLOAD_DEL = 24,
	STATE_BUS_IDLE     = 25,

} STATE;

typedef enum {
   STATE_CAN_START    = 0,
   STATE_CHK_COMMAND  = 1,
   STATE_CONFIG_TX    = 2,
   STATE_TRNSMT_MSG_TO_PHY = 3,
   STATE_COMMAND_SEND = 4,
   STATE_COMMAND_NONE = 5,
   STATE_CONFIG_RX	  = 6,
   STATE_RECEIVE_MSG  = 7,
   STATE_CAN_STOP     = 8,

} LLC_STATE;

typedef enum {
	ERROR_NONE          = 0,
	ERROR_BIT_ERROR     = 1,
	ERROR_STUFF_ERROR   = 2,
	ERROR_FORM_ERROR    = 3,
	ERROR_CRC_ERROR     = 4,
	ERROR_ILLEGAL_STATE = 5,
	ERROR_NO_ACK        = 6,
} ERROR;

struct CanPacket {
	unsigned DATA[8]; // First in struct so that worst-case path is quicker
	unsigned CRC;     // Less than 12 to reduce worst-case path (2rus instead of 3r+load)
	unsigned SOF;
	unsigned ID;
	unsigned SRR;
	unsigned IEB;
	unsigned EID;
	unsigned RTR;
	unsigned RB1;
	unsigned RB0;
	unsigned DLC;
	unsigned CRC_DEL;
	unsigned ACK_DEL;
	unsigned _EOF; /* Uses _ because EOF is reserved */
//	unsigned THREADNUM;
};

struct CanPhyState {
	STATE        state;
	ERROR        error;
	unsigned int packetCrc;

	int          txActive;
	int          txComplete;

	int          activeError;
	int          rxErrorCount;
	int          txErrorCount;
	int          doCrc;
};

struct CanLLCState {
	LLC_STATE    state;
	ERROR        error;
	unsigned int packetCrc;

	int          txActive;
	int          txComplete;

	int          activeError;
	int          rxErrorCount;
	int          txErrorCount;
	int          doCrc;
};

#endif
