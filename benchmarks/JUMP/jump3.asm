xori r15, r0, 2		# initialise register file
xori r17, r0, 80
jal 2				# jump 2 instruction forward
nop
addi r1, r0, 1
nop
