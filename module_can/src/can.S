#include "can_defines.h"
#define STACK_WORDS 11
.align 4
.globl canRxTxImpl
.type  canRxTxImpl, @function
.cc_top canRxTxImpl.function
canRxTxImpl:
entsp STACK_WORDS
ldc r11, 2
stw r4, sp[0]
ldc r4, 0
stw r5, sp[1]
ldc r5, 0
stw r6, sp[2]
stw r7, sp[3]
stw r8, sp[4]
stw r9, sp[5]
stw r10, sp[6]
ldaw r10, dp[0]
stw r10, sp[S_DP_SPILL]
set dp, r3
ldw r3, r2[0]
ldw r2, r2[1]
lsub r6, r7, r5, r5, r5	//r5, r6, r7, r8, r9 and r11 must be 0
lsub r8, r9, r5, r5, r5
stw r5, sp[S_ARB]	//start with arbitration mode off
ldc r10, 0
stw r5, sp[S_TX_BIT]	//save the tx_bit to the stack
stw r11, sp[S_STATE]
// go straight to skip_xor as don't need to do crc or resync
bf r0, skip_xor
  start_tx_output_bit:
  out res[r3], r6		// @ time
  stw r10, sp[S_TX_BIT]	//save the tx_bit to the stack
  syncr res[r3]
  getts r1, res[r3]
  bu skip_xor
nop
begin_state:

.xtabranch sm_0, sm_1, sm_2, sm_3, sm_4, sm_5, sm_6, sm_7, sm_8, sm_9, sm_10, sm_11, sm_12, sm_13, sm_14, sm_15, sm_16, sm_17, sm_18, sm_19, sm_20, sm_21, sm_22, sm_23, sm_24, sm_25, sm_26, sm_27, sm_28, sm_29, sm_30, sm_31, sm_32, sm_33, sm_34, sm_35, sm_36, sm_37, sm_38, sm_39, sm_40, sm_41, sm_42, sm_43, sm_44, sm_45, sm_46, sm_47, sm_48, sm_49, sm_50, sm_51, sm_52, sm_53, sm_54, sm_55, sm_56, sm_57, sm_58, sm_59, sm_60, sm_61, sm_62, sm_63, sm_64, sm_65, sm_66, sm_67, sm_68, sm_69, sm_70, sm_71, sm_72, sm_73, sm_74, sm_75, sm_76, sm_77, sm_78, sm_79, sm_80, sm_81, sm_82, sm_83, sm_84, sm_85, sm_86, sm_87, sm_88, sm_89, sm_90, sm_91, sm_92, sm_93, sm_94, sm_95, sm_96, sm_97, sm_98, sm_99, sm_100, sm_101, sm_102, sm_103, sm_104, sm_105, sm_106, sm_107, sm_108, sm_109, sm_110, sm_111, sm_112, sm_113, sm_114, sm_115, sm_116, sm_117, sm_118
bru r11

sm_0:    BRFU_lu6 exit_rxtx				//0
sm_1:    BRFU_lu6 ID_STD_0				//2
sm_2:    BRFU_lu6 start_bit //ID_STD_1	//4
sm_3:    BRFU_lu6 start_bit //ID_STD_2	//6
sm_4:    BRFU_lu6 start_bit //ID_STD_3	//8
sm_5:    BRFU_lu6 start_bit //ID_STD_4	//10
sm_6:    BRFU_lu6 start_bit //ID_STD_5	//12
sm_7:    BRFU_lu6 start_bit //ID_STD_6	//14
sm_8:    BRFU_lu6 start_bit //ID_STD_7	//16
sm_9:    BRFU_lu6 start_bit //ID_STD_8	//18
sm_10:   BRFU_lu6 start_bit //ID_STD_9	//20
sm_11:   BRFU_lu6 start_bit //ID_STD_10	//22
sm_12:   BRFU_lu6 RTR_SRR				//24	//End arbitration if STD
sm_13:   BRFU_lu6 IDE					//26
sm_14:   BRFU_lu6 ID_EXT_0_or_R0		//28	//This is the Extended part
sm_15:   BRFU_lu6 start_bit //ID_EXT_1	//30
sm_16:   BRFU_lu6 start_bit //ID_EXT_2	//32
sm_17:   BRFU_lu6 start_bit //ID_EXT_3	//34
sm_18:   BRFU_lu6 start_bit //ID_EXT_4	//36
sm_19:   BRFU_lu6 start_bit //ID_EXT_5	//38
sm_20:   BRFU_lu6 start_bit //ID_EXT_6	//40
sm_21:   BRFU_lu6 start_bit //ID_EXT_7	//42
sm_22:   BRFU_lu6 start_bit //ID_EXT_8	//44
sm_23:   BRFU_lu6 start_bit //ID_EXT_9	//46
sm_24:   BRFU_lu6 start_bit //ID_EXT_10	//48
sm_25:   BRFU_lu6 start_bit //ID_EXT_11	//50
sm_26:   BRFU_lu6 start_bit //ID_EXT_12	//52
sm_27:   BRFU_lu6 start_bit //ID_EXT_13	//54
sm_28:   BRFU_lu6 start_bit //ID_EXT_14	//56
sm_29:   BRFU_lu6 start_bit //ID_EXT_15	//58
sm_30:   BRFU_lu6 start_bit //ID_EXT_16	//60
sm_31:   BRFU_lu6 start_bit //ID_EXT_17	//62
sm_32:   BRFU_lu6 RTR					//64
sm_33:   BRFU_lu6 R1					//66 	//End arbitration
sm_34:   BRFU_lu6 R0					//68
sm_35:   BRFU_lu6 DLC_0					//70
sm_36:   BRFU_lu6 start_bit //DLC_1		//72
sm_37:   BRFU_lu6 start_bit //DLC_2		//74
sm_38:   BRFU_lu6 start_bit //DLC_3		//76
sm_39:   BRFU_lu6 DATA_n_or_CRC			//78	//this is a special one for the first bit of a data byte or CRC
sm_40:   BRFU_lu6 start_bit //DATA_7_1	//80
sm_41:   BRFU_lu6 start_bit //DATA_7_2	//82
sm_42:   BRFU_lu6 start_bit //DATA_7_3	//84
sm_43:   BRFU_lu6 start_bit //DATA_7_4	//86
sm_44:   BRFU_lu6 start_bit //DATA_7_5	//88
sm_45:   BRFU_lu6 start_bit //DATA_7_6	//90
sm_46:   BRFU_lu6 start_bit //DATA_7_7	//92
sm_47:   BRFU_lu6 start_bit //DATA_6_0	//94
sm_48:   BRFU_lu6 start_bit //DATA_6_1	//96
sm_49:   BRFU_lu6 start_bit //DATA_6_2	//98
sm_50:   BRFU_lu6 start_bit //DATA_6_3	//100
sm_51:   BRFU_lu6 start_bit //DATA_6_4	//102
sm_52:   BRFU_lu6 start_bit //DATA_6_5	//104
sm_53:   BRFU_lu6 start_bit //DATA_6_6	//106
sm_54:   BRFU_lu6 start_bit //DATA_6_7	//108
sm_55:   BRFU_lu6 start_bit //DATA_5_0	//110
sm_56:   BRFU_lu6 start_bit //DATA_5_1	//112
sm_57:   BRFU_lu6 start_bit //DATA_5_2	//114
sm_58:   BRFU_lu6 start_bit //DATA_5_3	//116
sm_59:   BRFU_lu6 start_bit //DATA_5_4	//118
sm_60:   BRFU_lu6 start_bit //DATA_5_5	//120
sm_61:   BRFU_lu6 start_bit //DATA_5_6	//122
sm_62:   BRFU_lu6 start_bit //DATA_5_7	//124
sm_63:   BRFU_lu6 start_bit //DATA_4_0	//126
sm_64:   BRFU_lu6 start_bit //DATA_4_1	//128
sm_65:   BRFU_lu6 start_bit //DATA_4_2	//130
sm_66:   BRFU_lu6 start_bit //DATA_4_3	//132
sm_67:   BRFU_lu6 start_bit //DATA_4_4	//134
sm_68:   BRFU_lu6 start_bit //DATA_4_5	//136
sm_69:   BRFU_lu6 start_bit //DATA_4_6	//138
sm_70:   BRFU_lu6 start_bit //DATA_4_7	//140
sm_71:   BRFU_lu6 DATA_3_0				//142
sm_72:   BRFU_lu6 start_bit //DATA_3_1	//144
sm_73:   BRFU_lu6 start_bit //DATA_3_2	//146
sm_74:   BRFU_lu6 start_bit //DATA_3_3	//148
sm_75:   BRFU_lu6 start_bit //DATA_3_4	//150
sm_76:   BRFU_lu6 start_bit //DATA_3_5	//152
sm_77:   BRFU_lu6 start_bit //DATA_3_6	//154
sm_78:   BRFU_lu6 start_bit //DATA_3_7	//156
sm_79:   BRFU_lu6 start_bit //DATA_2_0	//158
sm_80:   BRFU_lu6 start_bit //DATA_2_1	//160
sm_81:   BRFU_lu6 start_bit //DATA_2_2	//162
sm_82:   BRFU_lu6 start_bit //DATA_2_3	//164
sm_83:   BRFU_lu6 start_bit //DATA_2_4	//166
sm_84:   BRFU_lu6 start_bit //DATA_2_5	//168
sm_85:   BRFU_lu6 start_bit //DATA_2_6	//170
sm_86:   BRFU_lu6 start_bit //DATA_2_7	//172
sm_87:   BRFU_lu6 start_bit //DATA_1_0	//174
sm_88:   BRFU_lu6 start_bit //DATA_1_1	//176
sm_89:   BRFU_lu6 start_bit //DATA_1_2	//178
sm_90:   BRFU_lu6 start_bit //DATA_1_3	//180
sm_91:   BRFU_lu6 start_bit //DATA_1_4	//182
sm_92:   BRFU_lu6 start_bit //DATA_1_5	//184
sm_93:   BRFU_lu6 start_bit //DATA_1_6	//186
sm_94:   BRFU_lu6 start_bit //DATA_1_7	//188
sm_95:   BRFU_lu6 start_bit //DATA_0_0	//190
sm_96:   BRFU_lu6 start_bit //DATA_0_1	//192
sm_97:   BRFU_lu6 start_bit //DATA_0_2	//194
sm_98:   BRFU_lu6 start_bit //DATA_0_3	//196
sm_99:   BRFU_lu6 start_bit //DATA_0_4	//198
sm_100:  BRFU_lu6 start_bit //DATA_0_5	//200
sm_101:  BRFU_lu6 start_bit //DATA_0_6	//202
sm_102:  BRFU_lu6 start_bit //DATA_0_7	//204
sm_103:  BRFU_lu6 CRC_0					//206
sm_104:  BRFU_lu6 start_bit //CRC_1		//208
sm_105:  BRFU_lu6 start_bit //CRC_2		//210
sm_106:  BRFU_lu6 start_bit //CRC_3		//212
sm_107:  BRFU_lu6 start_bit //CRC_4		//214
sm_108:  BRFU_lu6 start_bit //CRC_5		//216
sm_109:  BRFU_lu6 start_bit //CRC_6		//218
sm_110:  BRFU_lu6 start_bit //CRC_7		//220
sm_111:  BRFU_lu6 start_bit //CRC_8		//222
sm_112:  BRFU_lu6 start_bit //CRC_9		//224
sm_113:  BRFU_lu6 start_bit //CRC_10	//226
sm_114:  BRFU_lu6 start_bit //CRC_11	//228
sm_115:  BRFU_lu6 start_bit //CRC_12	//230
sm_116:  BRFU_lu6 start_bit //CRC_13	//232
sm_117:  BRFU_lu6 start_bit //CRC_14	//234
sm_118:  BRFU_lu6 CRC_DELIM				//236
//end of jump table

ID_STD_0:
ldw r6, dp[TX_ID_STD]	//load tx_id_std into t_data
ldc r7, 1
stw r7, sp[S_ARB]		//switch arbitration mode on
ldc r7, 0				//clear r_data
bu start_bit

RTR_SRR:
stw r7, dp[RX_ID_STD]	//save r_data to rx_id_std
ldw r7, dp[TX_EXTENDED]	//load tx_remote
bf r7, case_SRR
  ldc r7, 0				//clear r_data
  ldc r6, 1				//set t_data to recessive
  bu start_bit
case_SRR:
  ldw r6, dp[TX_REMOTE]	//load tx_remote into t_data
  //no need to clear r_data(r7) as it already is
  bu start_bit

IDE:
stw r7, dp[RX_REMOTE]	//save r_data to rx_remote
ldc r7, 0				//clear r_data
ldw r6, dp[TX_EXTENDED]	//load tx_extended into t_data
bu start_bit

ID_EXT_0_or_R0:
stw r7, dp[RX_EXTENDED]	//save r_data to rx_extended
bt r7, extended_id
  //no need to clear r_data(r7) as it already is
  ldc r6, 0				//this bit is R0 so tx a 0
  ldc r11, 68	 		//set the state to be R0
  stw r6, sp[S_ARB]	    //end arbitration
  bu start_bit
extended_id:
ldc r7, 0
ldw r6, dp[TX_ID_EXT]	//load tx_extended into t_data
bu start_bit

RTR:
stw r7, dp[RX_ID_EXT]	//save r_data to rx_extended
ldc r7, 0
ldw r6, dp[TX_REMOTE]	//load tx_extended into t_data
bu start_bit

R1:
stw r7, dp[RX_REMOTE]	//save r_data to tx_extended
ldc r7, 0				//clear r_data
stw r7, sp[S_ARB]	    //end arbitration
ldc r6, 0
bu start_bit

R0:
//r6 is necessarily 0
stw r6, sp[S_ARB]	    //end arbitration
bu start_bit

DLC_0:
ldc r7, 0				//clear r_data
ldw r6, dp[TX_DLC]
bu start_bit

.align 4
DATA_n_or_CRC:
stw r7, dp[RX_DLC]		//save to r_data to rx_dlc
bf r7, start_crc
ldw r10, dp[RX_REMOTE]
bt r10, start_crc
//this is a data message
.xtabranch jt_1, jt_2, jt_3,jt_4, jt_5,jt_6, jt_7,jt_8, jt_9,jt_10, jt_11,jt_12, jt_13,jt_14, jt_15
bru r7	//never goes to jt_0
jt_0:  BRFU_u6 start_crc
jt_1:  BRFU_u6 byte_count_1
jt_2:  BRFU_u6 byte_count_2
jt_3:  BRFU_u6 byte_count_3
jt_4:  BRFU_u6 byte_count_4
jt_5:  BRFU_u6 byte_count_5
jt_6:  BRFU_u6 byte_count_6
jt_7:  BRFU_u6 byte_count_7
jt_8:  BRFU_u6 byte_count_8
jt_9:  BRFU_u6 byte_count_8
jt_10: BRFU_u6 byte_count_8
jt_11: BRFU_u6 byte_count_8
jt_12: BRFU_u6 byte_count_8
jt_13: BRFU_u6 byte_count_8
jt_14: BRFU_u6 byte_count_8
jt_15: BRFU_u6 byte_count_8
.align 4
start_crc:
ldc r10, 0x4CD1
crc32 r9, r8, r10
shl r6, r9, 7
ldc r7, 0
crc8 r6, r7, r7, r10
ldc r11, 206
bt r0, tx_output_bit
bu end_tx

.align 4
byte_count_1:
ldc r7, 0			//FIXME i dont think the ldc r7, 0 are needed in this part
ldw r6, dp[TX_DATA_1]
ldc r11, 190
bu start_bit

byte_count_2:
ldc r7, 0
ldc r11, 174
ldw r6, dp[TX_DATA_1]
bu start_bit

byte_count_3:
ldc r7, 0
ldw r6, dp[TX_DATA_1]
ldc r11, 158
bu start_bit

byte_count_4:
ldc r7, 0
ldc r11, 142
ldw r6, dp[TX_DATA_1]
bu start_bit

byte_count_5:
ldc r7, 0
ldw r6, dp[TX_DATA_0]
ldc r11, 126
bu start_bit

byte_count_6:
ldc r7, 0
ldc r11, 110
ldw r6, dp[TX_DATA_0]
bu start_bit

byte_count_7:
ldc r7, 0
ldw r6, dp[TX_DATA_0]
ldc r11, 94
bu start_bit

byte_count_8:
ldc r7, 0
ldc r11, 78
ldw r6, dp[TX_DATA_0]
bu start_bit

DATA_3_0:
stw r7, dp[RX_DATA_0]
ldc r7, 0
ldw r6, dp[TX_DATA_1]
bu start_bit

CRC_DELIM:
//if we are doing tx then no need to check the crc
bt r0, not_rx_crc_delim
//if we are doing rx then the crc we are expecting is in r6
bitrev r7, r7
shr r7, r7, 16
#if 1
shr r7, r7, 1
sub r6, r6, r7
#else
lda16 r6, r6[r7]
#endif
bf r6, not_rx_crc_delim
//an error has occoured so after the ack delimiter start sending the error flag
  ldc r11, ERROR_CRC_ERROR
not_rx_crc_delim:
ldc r7, 1
bu crc_delim

.align 4
CRC_0:
ldc r10, 0x4CD1
crc32 r9, r8, r10
mov r8, r9
stw r7, dp[RX_DATA_1]
ldc r7, 0//probably dont need
sext r8, 1
shr r6, r9, 1
and r10, r10, r8
xor r6, r6, r10
//bu start_bit	//fall through

//------------------------------------------------------------------------
start_bit:

bf r0, end_tx
  tx_output_bit:
  out res[r3], r6		// @ time
  mov r10, r6
  zext r10, 1
  stw r10, sp[S_TX_BIT]	//save the tx_bit to the stack
  shr r6, r6, 1			//this shifts the t_data down 1
end_tx:

add r11, r11, 2			//move the state along one
stw r11, sp[S_STATE]

//calc clock drift
calc_clock_drift:
ldc r10, 0
bf r4, do_crc 			//if last_bit_on_pin was a 0 then don't resync
ldc r11, 12	            //as can only resync on recessive -> dominant edges.
add r10, r1, r11
setpt res[r2], r10
rx_clock_drift:
in r10, res[r2]			// @ time + 12
clz r10, r10			//r10 is now 4-20(12+-8)
bf r10, do_crc     		//if the most recent bit is a 0 then we don't care
sub r10, r11, r10		//r10 now holds the resync delta

//This will emit the code to do the crc if need be of the previous bit
do_crc:

add r5, r5, 1		//this is the delayed add to the bit run counter

bitrev r8, r8
mov r11, r9
zext r11, 1
shr r9, r9, 1
add r9, r9, r8
bf r11, skip_xor
  ldc r11, 0x4CD1
  xor r9, r9, r11
skip_xor:

//Emit the code to sample the CAN bus (part 1)
ldc r11, SAMPLE_PORT_CYCLES
add r11, r11, r1
setpt res[r2], r11

//Update the time for the next bit
update_time:
add r1, r1, r10
ldc r10, 50
add r1, r1, r10

//Emit the code to sample the CAN bus (part 2)
.align 4
ldw r11, sp[S_STATE]

//restore tx_bit to r10
ldw r10, sp[S_TX_BIT]	//r10 is tx_bit
setpt res[r3], r1

bt r0, tx_mode
  //this is that case where we are in rx mode
  mkmsk r10, 5
  rx_sample_bus:
  in r8, res[r2]		// @ time + 34
  shr r8, r8, r10		// r8 is the most recent bit (rx_bit)
  bu rx_no_change
tx_mode:
 //this is that case where we are in tx mode
//now do the recieve
bt r10, expecting_recessive_bit
  mkmsk r10, 5          //if tramsmitted a 0
  tx_0_sample_bus:
  in r8, res[r2]		// @ time + 34
  shr r8, r8, r10		// r8 is the most recent bit (rx_bit)
  bf r8, rx_no_change
    ldc r11, ERROR_BIT_ERROR    //if recieved a 1
    bu start_error_frame		//BIT_ERROR
expecting_recessive_bit:
//if transmitted a 1
ldw r10, sp[S_ARB]	    //load the arb from sp[10]
#if 1
bf r10, no_arb
  mkmsk r10, 5
  tx_1_sample_bus:
  in r8, res[r2]		// @ time + 34
  shr r8, r8, r10		// r8 is the most recent bit (rx_bit)
  and r0, r0, r8		// if arbitrating then: tx &= (rx_bit == tx_bit)
  bu rx_no_change
no_arb:
  mkmsk r10, 5
  tx_2_sample_bus:
  in r8, res[r2]		// @ time + 34
  shr r8, r8, r10		// r8 is the most recent bit (rx_bit)
  bt r8, rx_no_change
    ldc r11, ERROR_BIT_ERROR    // received a 0
    bu start_error_frame		// BIT_ERROR
#else
bt r10, no_no_arb
  mkmsk r10, 5
  tx_2_sample_bus:
  in r8, res[r2]		// @ time + 34
  shr r8, r8, r10		// r8 is the most recent bit (rx_bit)
  bt r8, rx_no_change
    ldc r11, ERROR_BIT_ERROR    // received a 0
    bu start_error_frame		// BIT_ERROR
no_no_arb:
  mkmsk r10, 5
  tx_1_sample_bus:
  in r8, res[r2]		// @ time + 34
  shr r8, r8, r10		// r8 is the most recent bit (rx_bit)
  and r0, r0, r8		// if arbitrating then: tx &= (rx_bit == tx_bit)
  nop
#endif
rx_no_change:

lda16 r7, r8[r7]	//save rx_bit to r_data

//update bit_run_counter
eq r10, r4, r8
mul r5, r10, r5
mov r4, r8		//save last_bit_on_pin

sub r10, r5, 4		//decide if need to bit stuff

bt r10, begin_state

bit_stuff:
  bf r0, no_bit_stuff_tx
    not r10, r4
    bit_stuff_tx_output_bit:
    out res[r3], r10	// @ time
  no_bit_stuff_tx:
  ldc r10, 0
  bf r4, bs_no_resync 		//if last_bit_on_pin was a 1 then don't resync
  ldc r5, 12
  add r10, r1, r5
  setpt res[r2], r10
  bit_stuff_rx_clock_drift:
  in r10, res[r2]			// @ time + 12
  bf r10, bs_no_resync     		//if the most recent bit is a 0 then we don't care
  clz r10, r10			//r10 is now 4-20(12+-8)
  sub r10, r5, r10		//r10 now holds the resync delta
  bs_no_resync:

  ldc r5, SAMPLE_PORT_CYCLES
  add r5, r5, r1
  setpt res[r2], r5

  ldc r5, 0			//set the counter to 1

  //time += 50 + drift;
  add r1, r1, r10
  ldc r10, 50
  add r1, r1, r10
  setpt res[r3], r1

  bt r4, bit_stuff_last_bit_recessive
      bit_stuff_sample_bus_0:
	  in r10, res[r2]		// @ time + 34
	  shr r10, r10, 24
	  shr r10, r10, 7
	  mov r4, r10
	  bt r10, begin_state
	  bu stuff_error_case
bit_stuff_last_bit_recessive:
      bit_stuff_sample_bus_1:
	  in r10, res[r2]		// @ time + 34
	  shr r10, r10, 24
	  shr r10, r10, 7
	  mov r4, r10
	  bf r10, begin_state
stuff_error_case:
    ldw r10, sp[S_ARB]	//load the arb from sp[10]
    and r10, r4, r10
    bf r10, bit_stuff_not_arb
      ldc r11, ERROR_SPECIAL_STUFF_ERROR	//put error code in r11
      bu start_error_frame
    bit_stuff_not_arb:
    ldc r11, ERROR_STUFF_ERROR	//put error code in r11
    bu start_error_frame
//------------------------------------------------------------------------

//r0		tx
//r1		time
//r2		p.rx
//r3		p.tx
//r4		last_bit_on_pin = 1
//r5		bit_run_counter = 0;
//r6		t_data
//r7		r_data = 0;
//r8		rx_bit
//r9		crc = 0
//r10		temp
//r11		temp/state

crc_delim:
bf r0, crc_delim_no_tx
  ldc r6, 1
  out res[r3], r6	// @ time
crc_delim_no_tx:
//Emit the code to sample the CAN bus (part 1)
ldc r10, SAMPLE_PORT_CYCLES
add r10, r10, r1
setpt res[r2], r10

//Emit the code to sample the CAN bus (part 2)
ldc r10, 50
add r1, r1, r10
setpt res[r3], r1

mkmsk r10, 5
in r8, res[r2]		// @ time + 34
shr r8, r8, r10		// r8 is the most recent bit (rx_bit)
bt r8, ack
  ldc r11, ERROR_FORM_ERROR
  bu start_error_frame		//ERROR_FORM_ERROR

mov r4, r8		//save last_bit_on_pin

//------------------------------------------------------------------------
ack:
eq r10, r11, ERROR_CRC_ERROR
or r10, r10, r0
out res[r3], r10	// @ time

//calc clock drift
ldc r10, 0
bt r0, ack_no_resync 		//if tx mode then dont resync
ldc r9, 12
add r10, r1, r9
setpt res[r2], r10
in r10, res[r2]			// @ time + 12
bf r10, ack_no_resync   //if the most recent bit is a 0 then we don't care
clz r10, r10			//r10 is now 4-20(12+-8)
sub r10, r9, r10		//r10 now holds the resync delta
ack_no_resync:

//Emit the code to sample the CAN bus (part 1)
ldc r9, SAMPLE_PORT_CYCLES
add r9, r9, r1
setpt res[r2], r9

//Update the time for the next bit
add r1, r1, r10
ldc r10, 50
add r1, r1, r10
setpt res[r3], r1

mkmsk r10, 5
in r8, res[r2]		// @ time + 34
shr r8, r8, r10		// r8 is the most recent bit (rx_bit)

bt r0, ack_tx
  bf r8, start_ack
    ldc r11, ERROR_BIT_ERROR
    bu start_error_frame		//ERROR_BIT_ERROR

ack_tx:
bf r8, start_ack
  ldc r11, ERROR_NO_ACK
  bu start_error_frame		//ERROR_NO_ACK


start_ack:
bt r0, ggg
  ldc r6, 1
  out res[r3], r6	// @ time
ggg:

mov r4, r8		//save last_bit_on_pin

//------------------------------------------------------------------------
ldc r9, 7	//set r9 to be a run counter
ack_delim:
bf r0, ack_delim_no_tx
  ldc r6, 1
  out res[r3], r6	// @ time
ack_delim_no_tx:

//Emit the code to sample the CAN bus (part 1)
ldc r10, SAMPLE_PORT_CYCLES
add r10, r10, r1
setpt res[r2], r10

//Update the time for the next bit
ldc r10, 50
add r1, r1, r10
setpt res[r3], r1

mkmsk r10, 5
in r8, res[r2]		// @ time + 34
shr r8, r8, r10		// r8 is the most recent bit (rx_bit)
bt r8, crc_error_check
  ldc r11, ERROR_FORM_ERROR
  bu start_error_frame		//ERROR_FORM_ERROR

mov r4, r8		//save last_bit_on_pin

crc_error_check:
//if the count(r9) is 7 (i.e.) end of first one then
//check to see if we have had a crc error
sub r10, r9, 7
bt r10, next_bit
sub r10, r11, ERROR_CRC_ERROR
bt r10, next_bit
  bu start_error_frame		//ERROR_FORM_ERROR

next_bit:
sub r9, r9, 1
bt r9, ack_delim

//------------------------------------------------------------------------

eof_last_bit:

bf r0, eof_last_bit_no_tx
  ldc r6, 1
  out res[r3], r6	// @ time
eof_last_bit_no_tx:

//Emit the code to sample the CAN bus (part 1)
ldc r10, SAMPLE_PORT_CYCLES
add r10, r10, r1
setpt res[r2], r10

//Update the time for the next bit
ldc r10, 50
add r1, r1, r10
setpt res[r3], r1

mkmsk r10, 5
in r8, res[r2]		// @ time + 34
shr r8, r8, r10		// r8 is the most recent bit (rx_bit)
bf r0, eof_last_bit_no_error
  bt r8, eof_last_bit_no_error
    ldc r11, ERROR_BIT_ERROR
    bu start_error_frame		//ERROR_BIT_ERROR

eof_last_bit_no_error:
//this is going to return:
// ERROR_RX_NONE       0 (if rx)
// or
// ERROR_TX_NONE       1 (if tx)
bu exit_rxtx
//------------------------------------------------------------------------
start_error_frame:
ldw r4, sp[12]	//load the error status

//if passive then output 6 ones
//if active then output 6 zeros
ldc r5, 0		//seen a dominant bit
sub r4, r4, 1	//what we want to output
ldc r6, 6		//counter
ldc r7, 0		//TRANSMIT/RECEIVE_ERROR_COUNT

output_error_bit:
out res[r3], r4	// @ time
ldc r10, SAMPLE_PORT_CYCLES
add r10, r10, r1
setpt res[r2], r10
ldc r10, 50
add r1, r1, r10
setpt res[r3], r1
mkmsk r10, 5
in r8, res[r2]		// @ time + 34
shr r8, r8, r10		// r8 is the most recent bit
or r5, r5, r8		// record if we have seen a dominant bit
bt r4, not_a_stuff_error
bf r8, not_a_stuff_error
add r7, r7, 8
not_a_stuff_error:
sub r6, r6, 1
bt r6, output_error_bit

ldc r5, 0			//this is a run counter for recessive bits
ldc r6, 0			//this is a run counter for dominant bits

bt r0, tx_case
//if rx then if the next bit is a 0 then +8
ldc r10, SAMPLE_PORT_CYCLES
add r10, r10, r1
setpt res[r2], r10
ldc r10, 50
add r1, r1, r10
mkmsk r10, 5
in r8, res[r2]		// @ time + 34
shr r8, r8, r10		// r8 is the most recent bit
add r5, r5, r8		//increment the recessive bit count
bt r8, error_delimiter
add r6, r6, 1		//increment the dominant bit count
add r7, r7, 8
bu error_delimiter

tx_case:
//This deals with Exception 1
bf r4, not_exception_1
sub r10, r11, ERROR_NO_ACK
bt r10, exception_1_or_2
not_exception_1:
//This deals with Exception 2
sub r10, r11, ERROR_SPECIAL_STUFF_ERROR
bf r10, exception_1_or_2
bu error_delimiter
//this is what a normal tx error does
add r7, r7, 8
exception_1_or_2:

error_delimiter:
ldc r4, 1
out res[r3], r4
ldc r10, SAMPLE_PORT_CYCLES
add r1, r10, r1

//frame will be ended when 8 consecutive recessive bits have been seen
wait_loop:
setpt res[r2], r1
ldc r10, 50
add r1, r1, r10
mkmsk r10, 5
in r8, res[r2]
shr r8, r8, r10		// r8 is the most recent bit
bf r8, dominant_bit
recessive_bit:
add r5, r5, 1		//increment the recessive bit count
ldc r6, 0			//reset dominant bit count
sub r10, r5, 8
bf r10, error_exit	//we have seen 8 recessive bits in a row
bu wait_loop
dominant_bit:
add r6, r6, 1		//increment the dominant bit count
ldc r5, 0			//reset recessive bit count
zext r6, 3
bt r6, wait_loop
add r7, r7, 8
bu wait_loop

error_exit:
//build up r0 to contain
//	- rx(0) or tx(1)
//	- the REC or TEC
//  - error type (optional)
shl r7, r7, 2
add r0, r0, 2	//we set bit 1 to denote this was an error
add r0, r0, r7  //then put REC or TEC in bits [2, 15]
shl r11, r11, 16
add r0, r0, r11

//------------------------------------------------------------------------
exit_rxtx:
ldw r10, sp[S_DP_SPILL]
set dp, r10
ldw r4, sp[0]
ldw r5, sp[1]
ldw r6, sp[2]
ldw r7, sp[3]
ldw r8, sp[4]
ldw r9, sp[5]
ldw r10, sp[6]
retsp STACK_WORDS

.globl canRxTxImpl.nstackwords
.linkset canRxTxImpl.nstackwords, 11
.globl canRxTxImpl.maxtimers
.linkset canRxTxImpl.maxtimers, 0
.globl canRxTxImpl.maxchanends
.linkset canRxTxImpl.maxchanends, 0
.globl canRxTxImpl.maxthreads
.linkset canRxTxImpl.maxthreads, 1
.size canRxTxImpl, .-canRxTxImpl
.cc_bottom canRxTxImpl.function
