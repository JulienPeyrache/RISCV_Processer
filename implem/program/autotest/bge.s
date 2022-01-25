# TAG = bge
	.text

	addi x1, x0, 5       
	addi x2, x0, 2
	bge x1, x2, ge
	addi x31, x0, 1

ge:
	addi x31, x0, 3
	# max_cycle 50
	# pout_start
	# 00000003
	# pout_end