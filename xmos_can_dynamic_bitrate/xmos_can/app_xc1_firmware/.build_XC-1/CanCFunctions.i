# 1 ".././../../xmos_can/module_can/src/CanCFunctions.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 ".././../../xmos_can/module_can/src/CanCFunctions.c"

# 1 ".././../../xmos_can/module_can/src/CanIncludes.h" 1
# 46 ".././../../xmos_can/module_can/src/CanIncludes.h"
typedef enum {
 STATE_SOF = 0,
 STATE_ID = 1,
 STATE_SRR = 2,
 STATE_IEB = 3,
 STATE_EID = 4,
 STATE_RTR = 5,
 STATE_RB1 = 6,
 STATE_RB0 = 7,
 STATE_DLC = 8,
 STATE_DATA_BIT7 = 9,
 STATE_DATA_BIT6 = 10,
 STATE_DATA_BIT5 = 11,
 STATE_DATA_BIT4 = 12,
 STATE_DATA_BIT3 = 13,
 STATE_DATA_BIT2 = 14,
 STATE_DATA_BIT1 = 15,
 STATE_DATA_BIT0 = 16,
 STATE_CRC = 17,
 STATE_CRC_DEL = 18,
 STATE_ACK = 19,
 STATE_ACK_DEL = 20,
 STATE_EOF = 21,
 STATE_INTERMISSION = 22,
 STATE_OVERLOAD = 23,
 STATE_OVERLOAD_DEL = 24,
 STATE_BUS_IDLE = 25,

} STATE;

typedef enum {
 ERROR_NONE = 0,
 ERROR_BIT_ERROR = 1,
 ERROR_STUFF_ERROR = 2,
 ERROR_FORM_ERROR = 3,
 ERROR_CRC_ERROR = 4,
 ERROR_ILLEGAL_STATE = 5,
 ERROR_NO_ACK = 6,
} ERROR;

struct CanPacket {
 unsigned DATA[8];

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
};

struct CanPhyState {
 STATE state;
 ERROR error;
 unsigned int packetCrc;

 int txActive;
 int txComplete;

 int activeError;
 int rxErrorCount;
 int txErrorCount;
 int doCrc;
};
# 3 ".././../../xmos_can/module_can/src/CanCFunctions.c" 2

extern int alignTable[];

void initAlignTable() {
 int aligned = (1 + 8 + 8 + 8) - 8;

 for (int zeros = 0; zeros < 33; zeros++) {
  alignTable[zeros] = (1 + 8 + 8 + 8);
 }

 for (int zeros = 1; zeros < 32; zeros++) {
  if (zeros < aligned) {

   int phaseError = aligned - zeros;
   if (phaseError <= 4) {

    alignTable[zeros] = (1 + 8 + 8 + 8) + phaseError;
   }
  } else if (zeros > aligned) {

   int phaseError = zeros - aligned;
   if (phaseError <= 4) {

    alignTable[zeros] = (1 + 8 + 8 + 8) - phaseError;
   }
  }
 }





 alignTable[33] = (1 + 8 + 8 + 8) - 8;
}
