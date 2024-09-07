addi r1, r0, 5			# initialize register file
addi r2, r0, 7
addi r3, r0, 2
beqz r0, 5				# condition true, jump 5 instruction forward
nop
addi r4, r0, 4
xori r2, r0, 0			# target instruction BNEZ, R2 zeroed-out
nop
add r5, r1, r2			# target instruction BEQZ
bnez r2, -3			# condition true, jump 3 instruction backward
nop						# after jumping back the condition will be false and the jump won't take place anymore
