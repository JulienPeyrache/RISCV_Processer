# TAG = sltu
    .text

    addi x30, x0, 1
    sltu x31, x0, x0 
    sltu x31, x0, x30
    sltu x31, x30, x0
    addi x30, x0, 1
    addi x31, x0, -2
    sltu x31, x31, x30

    # max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# 00000000
	# FFFFFFFE
	# 00000000
	# pout_end