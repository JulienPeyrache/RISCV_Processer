# TAG = sltiu
    .text

    addi  x30, x0, 1
    sltiu x31, x0, 0
    sltiu x31, x0, 1
    sltiu x31, x30, 0
    addi  x31, x0, -2
    sltiu x31, x31, 1

    # max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# 00000000
	# FFFFFFFE
    # 00000000
    # pout_end