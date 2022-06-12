# TAG = blt
	.text

	add x31, x0, x0
	addi x30, x0, -5
loop1:
	blt x31, x30, exit
	addi x31, x31, -2
	beq x0, x0, loop1
exit:
	addi x30, x0, 2
loop2:
	addi x31, x31, 2
	blt x31, x30, loop2

	# max_cycle 300
	# pout_start
	# 00000000
	# FFFFFFFE
	# FFFFFFFC
	# FFFFFFFA
	# FFFFFFFC
	# FFFFFFFE
	# 00000000
	# 00000002
	# pout_end