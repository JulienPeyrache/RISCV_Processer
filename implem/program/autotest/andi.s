# TAG = andi
	.text

	addi x1, x0, 9     
	addi x2, x0, 10
	addi x3, x0, 13
	andi x31, x1, x2 
	andi x31, x31, x3 

	# max_cycle 50
	# pout_start
	# 00000008
	# 0000000D
	# pout_end