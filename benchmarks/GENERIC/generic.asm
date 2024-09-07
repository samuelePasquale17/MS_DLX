addi r1, r0, 1			# value, for testing
addi r2, r0, 4			# number of cycles
nop
nop
nop
sw (r1), r2				# r2 -> MEM[R1]
nop
nop
nop
subi r2, r2, 1			# r2 --
addi r1, r1, 1			# r1 ++
nop
nop
sne r3,r0,r2			# if r2 != 0 => r3 = 1
nop
nop
nop
beqz r3, 5				# if r3 = 0 end loop
nop
nop
nop
j -16					# jump back, loop
nop
addi r13, r0, 1
nop
