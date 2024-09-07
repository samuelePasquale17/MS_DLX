addi r1, r0, 5		# initialise the register file
addi r2, r0, 4
addi r3, r0, 3
addi r4, r0, 2
sw (r0), r1	
sw 1(r0), r2
sw 2(r0), r3
sw 3(r0), r4	
addi r5, r0, 1
addi r6, r0, 0
addi r7, r0, 7
addi r8, r0, 9
sw 4(r0), r5
sw 5(r0), r6
sw 6(r0), r7
sw 7(r0), r8
nop
nop
nop
lw r11, (r0)
lw r12, 1(r0)
lw r13, 2(r0)
lw r14, 3(r0)
lw r15, 4(r0)
lw r16, 5(r0)
lw r17, 6(r0)
lw r18, 7(r0)
nop
