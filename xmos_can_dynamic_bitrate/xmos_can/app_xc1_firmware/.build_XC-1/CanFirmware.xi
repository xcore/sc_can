# 1 ".././src/CanFirmware.xc"
# 1 "stdlib.h" 1 3
# 10 "stdlib.h" 3
# 1 "_ansi.h" 1 3
# 15 "_ansi.h" 3
# 1 "newlib.h" 1 3
# 16 "_ansi.h" 2 3
# 1 "sys/config.h" 1 3
# 4 "sys/config.h" 3
# 1 "machine/ieeefp.h" 1 3
# 5 "sys/config.h" 2 3
# 17 "_ansi.h" 2 3
# 11 "stdlib.h" 2 3
# 14 "stdlib.h" 3
# 1 "stddef.h" 1 3
# 214 "stddef.h" 3
typedef  unsigned int  size_t;
# 326 "stddef.h" 3
typedef  unsigned char  wchar_t;
# 15 "stdlib.h" 2 3
# 19 "stdlib.h" 3
# 1 "machine/stdlib.h" 1 3
# 20 "stdlib.h" 2 3
# 21 "stdlib.h" 3
# 1 "alloca.h" 1 3
# 22 "stdlib.h" 2 3
# 28 "stdlib.h" 3


typedef struct
{
  int quot;
  int rem;
} div_t;

typedef struct
{
  long quot;
  long rem;
} ldiv_t;
# 59 "stdlib.h" 3
extern   int __mb_cur_max;



void   abort ( void ) ;
int  abs (int) ;
# 72 "stdlib.h" 3
int  atoi (const char __nptr[]) ;
long  atol (const char __nptr[]) ;
# 82 "stdlib.h" 3
div_t  div (int __numer, int __denom) ;
void   exit (int __status) ;
# 89 "stdlib.h" 3
long  labs (long) ;
ldiv_t  ldiv (long __numer, long __denom) ;
# 109 "stdlib.h" 3
int  rand ( void ) ;
# 113 "stdlib.h" 3
void   srand (unsigned __seed) ;
# 127 "stdlib.h" 3
int  system (const char __string[]) ;
# 134 "stdlib.h" 3
void   _Exit (int __status) ;
# 154 "stdlib.h" 3
long  jrand48 (unsigned short [3]) ;
void   lcong48 (unsigned short [7]) ;
long  lrand48 ( void ) ;
long  mrand48 ( void ) ;
long  nrand48 (unsigned short [3]) ;
# 163 "stdlib.h" 3
void   srand48 (long) ;
# 195 "stdlib.h" 3

# 2 ".././src/CanFirmware.xc" 2
# 1 "platform.h" 1 3
# 21 "platform.h" 3
# 1 "D://XMOS//CAN//workspace_24Feb//xmos_can//app_xc1_firmware//.build_XC-1//XC-1.h" 1
# 4 "D://XMOS//CAN//workspace_24Feb//xmos_can//app_xc1_firmware//.build_XC-1//XC-1.h"
# 1 "xs1.h" 1 3
# 31 "xs1.h" 3
# 1 "xs1_g4000b-512.h" 1 3
# 32 "xs1.h" 2 3
# 37 "xs1.h" 3
# 1 "xs1_user.h" 1 3
# 20 "xs1_user.h" 3
# 1 "xs1b_user.h" 1 3
# 21 "xs1_user.h" 2 3
# 38 "xs1.h" 2 3
# 1 "xs1_kernel.h" 1 3
# 20 "xs1_kernel.h" 3
# 1 "xs1b_kernel.h" 1 3
# 21 "xs1_kernel.h" 2 3
# 39 "xs1.h" 2 3
# 1 "xs1_registers.h" 1 3
# 20 "xs1_registers.h" 3
# 1 "xs1b_registers.h" 1 3
# 28 "xs1b_registers.h" 3
# 1 "xs1_g_registers.h" 1 3
# 29 "xs1b_registers.h" 2 3
# 1 "xs1_l_registers.h" 1 3
# 30 "xs1b_registers.h" 2 3
# 21 "xs1_registers.h" 2 3
# 40 "xs1.h" 2 3
# 74 "xs1.h" 3
void configure_in_port_handshake(void port p, in port readyin,
                                 out port readyout,  __clock_t  clk);
# 103 "xs1.h" 3
void configure_out_port_handshake(void port p, in port readyin,
                                 out port readyout,  __clock_t  clk,
                                 unsigned initial);
# 129 "xs1.h" 3
void configure_in_port_strobed_master(void port p, out port readyout,
                                      const  __clock_t  clk);
# 152 "xs1.h" 3
void configure_out_port_strobed_master(void port p, out port readyout,
                                      const  __clock_t  clk, unsigned initial);
# 174 "xs1.h" 3
void configure_in_port_strobed_slave(void port p, in port readyin,  __clock_t  clk);
# 199 "xs1.h" 3
void configure_out_port_strobed_slave(void port p, in port readyin,  __clock_t  clk,
                                      unsigned initial);
# 223 "xs1.h" 3
void configure_in_port(void port p, const  __clock_t  clk);
# 251 "xs1.h" 3
void configure_out_port(void port p, const  __clock_t  clk, unsigned initial);
# 266 "xs1.h" 3
void configure_port_clock_output(void port p, const  __clock_t  clk);
# 275 "xs1.h" 3
void start_port(void port p);
# 282 "xs1.h" 3
void stop_port(void port p);
# 295 "xs1.h" 3
void configure_clock_src( __clock_t  clk, void port p);
# 309 "xs1.h" 3
void configure_clock_ref( __clock_t  clk, unsigned char divide);
# 325 "xs1.h" 3
void configure_clock_rate( __clock_t  clk, unsigned a, unsigned b);
# 339 "xs1.h" 3
void configure_clock_rate_at_least( __clock_t  clk, unsigned a, unsigned b);
# 353 "xs1.h" 3
void configure_clock_rate_at_most( __clock_t  clk, unsigned a, unsigned b);
# 366 "xs1.h" 3
void set_clock_src( __clock_t  clk, void port p);
# 379 "xs1.h" 3
void set_clock_ref( __clock_t  clk);
# 395 "xs1.h" 3
void set_clock_div( __clock_t  clk, unsigned char div);
# 410 "xs1.h" 3
void set_clock_rise_delay( __clock_t  clk, unsigned n);
# 425 "xs1.h" 3
void set_clock_fall_delay( __clock_t  clk, unsigned n);
# 445 "xs1.h" 3
void set_port_clock(void port p, const  __clock_t  clk);
# 463 "xs1.h" 3
void set_port_ready_src(void port p, void port ready);
# 481 "xs1.h" 3
void set_clock_ready_src( __clock_t  clk, void port ready);
# 491 "xs1.h" 3
void set_clock_on( __clock_t  clk);
# 501 "xs1.h" 3
void set_clock_off( __clock_t  clk);
# 511 "xs1.h" 3
void start_clock( __clock_t  clk);
# 519 "xs1.h" 3
void stop_clock( __clock_t  clk);
# 529 "xs1.h" 3
void set_port_use_on(void port p);
# 539 "xs1.h" 3
void set_port_use_off(void port p);
# 549 "xs1.h" 3
void set_port_mode_data(void port p);
# 561 "xs1.h" 3
void set_port_mode_clock(void port p);
# 582 "xs1.h" 3
void set_port_mode_ready(void port p);
# 593 "xs1.h" 3
void set_port_drive(void port p);
# 609 "xs1.h" 3
void set_port_drive_low(void port p);
# 624 "xs1.h" 3
void set_port_pull_up(void port p);
# 639 "xs1.h" 3
void set_port_pull_down(void port p);
# 649 "xs1.h" 3
void set_port_pull_none(void port p);
# 663 "xs1.h" 3
void set_port_master(void port p);
# 677 "xs1.h" 3
void set_port_slave(void port p);
# 691 "xs1.h" 3
void set_port_no_ready(void port p);
# 706 "xs1.h" 3
void set_port_strobed(void port p);
# 719 "xs1.h" 3
void set_port_handshake(void port p);
# 728 "xs1.h" 3
void set_port_no_sample_delay(void port p);
# 737 "xs1.h" 3
void set_port_sample_delay(void port p);
# 745 "xs1.h" 3
void set_port_no_inv(void port p);
# 756 "xs1.h" 3
void set_port_inv(void port p);
# 779 "xs1.h" 3
void set_port_shift_count( void port p, unsigned n);
# 794 "xs1.h" 3
void set_pad_delay(void port p, unsigned n);
# 809 "xs1.h" 3
void set_thread_fast_mode_on(void);
# 817 "xs1.h" 3
void set_thread_fast_mode_off(void);
# 843 "xs1.h" 3
void start_streaming_slave(chanend c);
# 862 "xs1.h" 3
void start_streaming_master(chanend c);
# 875 "xs1.h" 3
void stop_streaming_slave(chanend c);
# 888 "xs1.h" 3
void stop_streaming_master(chanend c);
# 903 "xs1.h" 3
void outuchar(chanend c, unsigned char val);
# 918 "xs1.h" 3
void outuint(chanend c, unsigned val);
# 934 "xs1.h" 3
unsigned char inuchar(chanend c);
# 950 "xs1.h" 3
unsigned inuint(chanend c);
# 967 "xs1.h" 3
void inuchar_byref(chanend c, unsigned char &val);
# 985 "xs1.h" 3
void inuint_byref(chanend c, unsigned &val);
# 995 "xs1.h" 3
void sync(void port p);
# 1006 "xs1.h" 3
unsigned peek(void port p);
# 1020 "xs1.h" 3
void clearbuf(void port p);
# 1036 "xs1.h" 3
unsigned endin( void port p);
# 1053 "xs1.h" 3
unsigned partin( void port p, unsigned n);
# 1069 "xs1.h" 3
void partout( void port p, unsigned n, unsigned val);
# 1087 "xs1.h" 3
unsigned partout_timed( void port p, unsigned n, unsigned val, unsigned t);
# 1105 "xs1.h" 3
{unsigned , unsigned } partin_timestamped( void port p, unsigned n);
# 1123 "xs1.h" 3
unsigned partout_timestamped( void port p, unsigned n, unsigned val);
# 1137 "xs1.h" 3
void outct(chanend c, unsigned char val);
# 1152 "xs1.h" 3
void chkct(chanend c, unsigned char val);
# 1167 "xs1.h" 3
unsigned char inct(chanend c);
# 1182 "xs1.h" 3
void inct_byref(chanend c, unsigned char &val);
# 1196 "xs1.h" 3
int testct(chanend c);
# 1209 "xs1.h" 3
int testwct(chanend c);
# 1223 "xs1.h" 3
void soutct(streaming chanend c, unsigned char val);
# 1239 "xs1.h" 3
void schkct(streaming chanend c, unsigned char val);
# 1255 "xs1.h" 3
unsigned char sinct(streaming chanend c);
# 1271 "xs1.h" 3
void sinct_byref(streaming chanend c, unsigned char &val);
# 1285 "xs1.h" 3
int stestct(streaming chanend c);
# 1299 "xs1.h" 3
int stestwct(streaming chanend c);
# 1314 "xs1.h" 3
transaction out_char_array(chanend c, const char src[], unsigned size);
# 1327 "xs1.h" 3
transaction in_char_array(chanend c, char src[], unsigned size);
# 1350 "xs1.h" 3
void crc32(unsigned &checksum, unsigned data, unsigned poly);
# 1374 "xs1.h" 3
unsigned crc8shr(unsigned &checksum, unsigned data, unsigned poly);
# 1388 "xs1.h" 3
{unsigned, unsigned} lmul(unsigned a, unsigned b, unsigned c, unsigned d);
# 1402 "xs1.h" 3
{unsigned, unsigned} mac(unsigned a, unsigned b, unsigned c, unsigned d);
# 1416 "xs1.h" 3
{signed, unsigned} macs(signed a, signed b, signed c, unsigned d);
# 1430 "xs1.h" 3
signed sext(unsigned a, unsigned b);
# 1444 "xs1.h" 3
unsigned zext(unsigned a, unsigned b);
# 1457 "xs1.h" 3
void pinseq(unsigned val);
# 1470 "xs1.h" 3
void pinsneq(unsigned val);
# 1485 "xs1.h" 3
void pinseq_at(unsigned val, unsigned time);
# 1500 "xs1.h" 3
void pinsneq_at(unsigned val, unsigned time);
# 1513 "xs1.h" 3
void timerafter(unsigned val);
# 1547 "xs1.h" 3
unsigned getps(unsigned reg);
# 1558 "xs1.h" 3
void setps(unsigned reg, unsigned value);
# 1582 "xs1.h" 3
int read_pswitch_reg(unsigned coreid, unsigned reg, unsigned &data);
# 1604 "xs1.h" 3
int read_sswitch_reg(unsigned coreid, unsigned reg, unsigned &data);
# 1624 "xs1.h" 3
int write_pswitch_reg(unsigned coreid, unsigned reg, unsigned data);
# 1642 "xs1.h" 3
int write_sswitch_reg(unsigned coreid, unsigned reg, unsigned data);
# 1650 "xs1.h" 3
unsigned get_core_id(void);
# 1658 "xs1.h" 3
unsigned get_thread_id(void);
# 1663 "xs1.h" 3
extern int __builtin_getid(void);
# 5 "D://XMOS//CAN//workspace_24Feb//xmos_can//app_xc1_firmware//.build_XC-1//XC-1.h" 2
# 13 "D://XMOS//CAN//workspace_24Feb//xmos_can//app_xc1_firmware//.build_XC-1//XC-1.h"
extern core stdcore[4];
# 22 "platform.h" 2 3
# 3 ".././src/CanFirmware.xc" 2
# 4 ".././src/CanFirmware.xc"
# 1 "CanIncludes.h" 1
# 46 "CanIncludes.h"
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
# 5 ".././src/CanFirmware.xc" 2
# 1 "CanFunctions.h" 1





void printPacket(struct CanPacket &p);
void initPacket(struct CanPacket &p);
void randomizePacket(struct CanPacket &p, int bitZero);
void sendPacket(chanend c, struct CanPacket &p);
void receivePacket(chanend c, struct CanPacket &p);
# 12 "CanFunctions.h"
#pragma select handler
void rxReady(buffered in port:32 p, unsigned int &time);
# 6 ".././src/CanFirmware.xc" 2
# 1 "CanPhy.h" 1




void canPhyRxTx(chanend rxChan, chanend txChan,  __clock_t  clk, buffered in port:32 canRx, port canTx);
# 7 ".././src/CanFirmware.xc" 2


on stdcore[0] :  __clock_t  canClk_0 =  0x106 ;
on stdcore[0] : buffered in port:32 canRx_0 =  0x10200 ;
on stdcore[0] : port canTx_0 =  0x10000 ;
on stdcore[0] : port led0_0 =  0x40000 ;
on stdcore[0] : port led1_0 =  0x40100 ;
on stdcore[0] : port led2_0 =  0x40200 ;
on stdcore[0] : port ledRed_0 =  0x10400 ;
on stdcore[0] : port ledGreen_0 =  0x10600 ;

on stdcore[0] :  __clock_t  canClk_2 =  0x206 ;
on stdcore[0] : buffered in port:32 canRx_2 =  0x10100 ;
on stdcore[0] : port canTx_2 =  0x10300 ;








void canTestRxTx(chanend controlChan, chanend rxChan, chanend txChan, chanend rateChan,chanend ledChan, int bitZero) {
	struct CanPacket txPacket;
	struct CanPacket rxPacket;
	unsigned int txPacketCount = 0;
	unsigned int rxPacketCount = 0;

	unsigned int clkDiv = 0;
	int setclk = rand()% 200 ;

	randomizePacket(txPacket, bitZero);

	while (1) {
		unsigned int command =  0 ;
		unsigned int txAck;
		unsigned int rxAck;

		select {
		case  __builtin_in_uint_byref(controlChan, command) :
			break;
		case  __builtin_in_uint_byref(rxChan, rxAck) :
			receivePacket(rxChan, rxPacket);
			break;
		}

		if(setclk == 0){
			__builtin_out_uint(rateChan, clkDiv) ;
		}

		if (command ==  1 ) {
			__builtin_out_uint(txChan, txPacketCount) ;
			sendPacket(txChan, txPacket);
			randomizePacket(txPacket, bitZero);
			txPacketCount++;
		} else if (command ==  0 ) {
			__builtin_out_uint(controlChan, 2 ) ;
			rxPacketCount++;
			__builtin_out_uint(ledChan, rxPacketCount >> 11 ) ;
			__builtin_outct(ledChan, 0x1 ) ;
		}


	}
}



void canController(chanend controlChan0, chanend controlChan1,chanend ledChan) {
	int completePacketCount = 0;
	timer t;
	unsigned int time;

	while (1) {
		int delay = rand() %  5000 ;
		int numPackets = (rand() & 1) + 1;
		int chanNum = rand() & 1;
		int rxPacketCount = 0;


		t :> time;
		t when  __builtin_timer_after(time + delay)  :> time;

		if (numPackets == 2) {
			__builtin_out_uint(controlChan0, 1 ) ;
			__builtin_out_uint(controlChan1, 1 ) ;
		} else {
			if (chanNum) {
				__builtin_out_uint(controlChan0, 1 ) ;
			} else {
				__builtin_out_uint(controlChan1, 1 ) ;
			}
		}
# 105 ".././src/CanFirmware.xc"
		while (rxPacketCount < numPackets) {
			unsigned int ack = 0;
			select {
			case  __builtin_in_uint_byref(controlChan0, ack) :
				break;
			case  __builtin_in_uint_byref(controlChan1, ack) :
				break;
			}

			if (ack ==  2 ) {
				rxPacketCount++;
			} else {
				exit(1);
			}
		}
		completePacketCount += numPackets;
		__builtin_out_uint(ledChan, completePacketCount >> 11 ) ;
		__builtin_outct(ledChan, 0x1 ) ;
	}
}

void driveLeds(port led0, port led1, port led2, port ledGreen, port ledRed,
		unsigned int value, unsigned int green) {

	if (green) {
		ledRed :> void;
		ledGreen <: 1;
	} else {
		ledGreen :> void;
		ledRed <: 1;
	}

	led0 <: value;
	led1 <: (value >> 4);
	led2 <: (value >> 8);
}

void ledManager(chanend client0, chanend client1, chanend client2,
		port led0, port led1, port led2, port ledGreen, port ledRed) {

	unsigned int green = 0;
	unsigned int value = 0;

	driveLeds(led0, led1, led2, ledGreen, ledRed, 1, 0xaaa);
	while(1) {
		unsigned int bits = 0;

		select {
		case  __builtin_in_uint_byref(client0, bits) :
			__builtin_inct(client0) ;
			value = (value & 0xff0) | (bits & 0xf);
			break;
		case  __builtin_in_uint_byref(client1, bits) :
			__builtin_inct(client1) ;
			value = (value & 0xf0f) | (bits & 0xf) << 4;
			break;
		case  __builtin_in_uint_byref(client2, bits) :
			__builtin_inct(client2) ;
			value = (value & 0x0ff) | (bits & 0xf) << 8;
			break;
		}

		driveLeds(led0, led1, led2, ledGreen, ledRed, value, green);
	}
}

int main() {
	chan rxChan_0, txChan_0;
	chan rxChan_1, txChan_1;
	chan test_phy_clkChan,SetClkChan;
	chan controlChan_0, controlChan_1;
	chan ledChan_0, ledChan_1, ledChan_2;
	chan rateChan_0,rateChan_1;

	par {
		on stdcore[0]: canPhyRxTx(rxChan_0,txChan_0,rateChan_0,canClk_0, canRx_0, canTx_0);
		on stdcore[0]: canPhyRxTx(rxChan_1,txChan_1,rateChan_1,canClk_2, canRx_2, canTx_2);
		on stdcore[0]: ledManager(ledChan_0, ledChan_1, ledChan_2,
				led0_0, led1_0, led2_0, ledGreen_0, ledRed_0);

		on stdcore[1]: canTestRxTx(controlChan_0, rxChan_0, txChan_0,rateChan_0, ledChan_0, 0);
		on stdcore[1]: canTestRxTx(controlChan_1, rxChan_1, txChan_1,rateChan_1, ledChan_1, 1);

		on stdcore[1]: canController(controlChan_0, controlChan_1, ledChan_2);
	}
	return 0;
}
