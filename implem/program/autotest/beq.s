#TAG = beq 
    .text

	addi x31, x0, 10
	addi x30, x0, 5
loop1:
	beq x31, x30, exit
	addi x31, x31, -1
	beq x0, x0, loop1
exit:

	# max_cycle 50
	# pout_start
	# 0000000A
	# 00000009
	# 00000008
	# 00000007
	# 00000006
	# pout_end   