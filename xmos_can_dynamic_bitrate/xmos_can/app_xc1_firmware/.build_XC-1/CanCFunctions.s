	.file	".././../../xmos_can/module_can/src/CanCFunctions.c"
	.section	.cp.const4,"aMc",@progbits,4
	.align	4
.LCPI1_0:					
	.long	4294967280			# 0xFFFFFFF0
	.text
	.cc_top initAlignTable.function,initAlignTable
	.globl	initAlignTable,"f{0}()"
	.align	2
	.type initAlignTable,@function
initAlignTable:
		entsp 7
		stw r4, sp[6]
		stw r5, sp[5]
		stw r6, sp[4]
		stw r7, sp[3]
		stw r8, sp[2]
		stw r9, sp[1]
		stw r10, sp[0]
		ldc r0, 0
		ldaw r1, dp[alignTable]
		ldc r2, 25
		ldc r3, 33

.LBB1_1:	# bb3
		stw r2, r1[r0]
		add r0, r0, 1
		eq r11, r0, r3
		bf r11, .LBB1_1	# bb3

.LBB1_2:	# bb3.bb6_crit_edge
		mkmsk r0, 1
		ldc r1, 4
		ldaw r2, dp[alignTable]
		mkmsk r3, 1
		ldc r11, 32
		ldc r4, 16
		ldc r5, 18
		bu .LBB1_5	# bb6

.LBB1_3:	# bb5
		lss r10, r4, r8
		bt r10, .LBB1_8	# bb8

.LBB1_4:	# bb6.loopexit31
		add r0, r0, 1

.LBB1_5:	# bb6
		ldc r6, 17
		sub r6, r6, r0
		lss r7, r1, r6
		bt r7, .LBB1_7	# bb12.preheader

.LBB1_6:	# bb7
		ldc r7, 25
		add r6, r6, r7
		stw r6, r2[r0]

.LBB1_7:	# bb12.preheader
		ldc r6, 41
		sub r6, r6, r0
		ldaw r7, r2[r0]
		add r9, r7, 4
		ldw r7, cp[.LCPI1_0]
		bu .LBB1_12	# bb12

.LBB1_8:	# bb8
		lss r8, r8, r5
		bt r8, .LBB1_11	# bb12.backedge

.LBB1_9:	# bb9
		add r8, r7, r0
		lss r8, r1, r8
		bt r8, .LBB1_11	# bb12.backedge

.LBB1_10:	# bb10
		stw r6, r9[0]

.LBB1_11:	# bb12.backedge
		add r9, r9, 4
		sub r6, r6, 1
		add r0, r0, 1

.LBB1_12:	# bb12
		add r8, r3, r0
		lss r10, r8, r11
		bt r10, .LBB1_3	# bb5

.LBB1_13:	# bb13
		ldc r0, 17
		stw r0, dp[alignTable+132]
		ldw r10, sp[0]
		ldw r9, sp[1]
		ldw r8, sp[2]
		ldw r7, sp[3]
		ldw r6, sp[4]
		ldw r5, sp[5]
		ldw r4, sp[6]
		retsp 7

	.cc_bottom initAlignTable.function
	.globl	initAlignTable.nstackwords
	.linkset	initAlignTable.nstackwords,7
	.globl	initAlignTable.maxthreads
	.linkset	initAlignTable.maxthreads,1
	.globl	initAlignTable.maxtimers
	.linkset	initAlignTable.maxtimers,0
	.globl	initAlignTable.maxchanends
	.linkset	initAlignTable.maxchanends,0
	.linkset	initAlignTable.locnochandec, 1
	.linkset	initAlignTable.locnoside, 1
	.extern	alignTable,"a(*:si)"

	.ident	"GCC: (GNU) 4.2.1 (LLVM build) XMOS '10.4.2' (build 1752)"
