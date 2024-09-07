# the purpose of this test is to implement 
# an infinite loop which alternates 0 and 1
# values into the register R1

xori r1, r0, 1
nop
nop
nop
subi r1, r1, 1
nop
nop
nop
slei r1, r1, #0
nop
nop
nop
j -8



