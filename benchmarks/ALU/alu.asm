addi r1, r0, 5	# testing addition
addi r2, r0, 6
addi r3, r0, 4
addi r4, r0, 7
addi r5, r0, 3
addi r6, r0, 1
add r7, r1, r2 
addi r8, r1, 1
sub r9, r4, r3  # testing subtraction
subi r10, r5, 1
and r11, r3, r4  # testing bitwise operations
andi r12, r1, 10
or r13, r3, r6
nop
ori r14, r7, 4
xor r15, r5, r6
sll r16, r3, r1  # testing shift
slli r17, r3, 2
srl r18, r7, r6
srli r19, r4, 2
xori r20, r0, 13
sge r21,r14,r1  # testing set operations
sgei r22,r5,1
sle r23,r6,r4
slei r24,r10, 13
sge r21,r6,r7
sgei r22,r9,6
sle r23,r2,r3
slei r24,r1,5
sne r25,r1,r2 
snei r26,r10,5
sne r25,r2,r8
snei r26,r11,4
nop
