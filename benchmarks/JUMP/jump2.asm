xori r1, r0, 5		# initialise register file
xori r2, r0, 7
j 4					# jump 4 instruction forward
nop 				# branch delay slot (1 for j only)
addi r3, r0, 2
addi r4, r0, 2
addi r5, r0, 1		# target for the jump
add r1, r1, r2
nop

