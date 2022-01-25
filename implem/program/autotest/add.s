# TAG = add
	.text

	addi x1, x0, 5       

	add x31, x0, x0		
	add x31, x0, x1 	
	add x31, x31, x31 	

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000005
	# 0000000A
	# pout_end