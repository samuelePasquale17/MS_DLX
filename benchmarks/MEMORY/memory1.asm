addi r1, r0, 5		# initialise the register file
addi r2, r0, 4
xori r3, r0, 2
xori r4, r0, 1
sw (r1), r2			# store value in the register file
addi r5, r0, 4
addi r6, r0, 1
addi r7, r0, 8
addi r8, r0, 3
lw r9, 1(r2)		# load into the register file the value stored before, adding 1 as offset to the target address
nop	
