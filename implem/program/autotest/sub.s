# TAG = sub
	.text

	addi x1, x0, 5       

	addi x2, x0, 2		
	sub x31, x1, x2	
	sub x31, x31, x2	

	# max_cycle 50
	# pout_start
	# 00000003
	# 00000001
	# pout_end