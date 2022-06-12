# TAG = sra
    .text

    lui  x31, 0xCAFE
    addi x30, x0, 0x4
    sra  x31, x31, x30
    lui  x31, 0xC0DE0
    sra  x31, x31, x30
    addi x30, x0, 0x1F
    sra  x31, x31, x30

    # max_cycle 50
	# pout_start
	# 0CAFE000
	# 00CAFE00
	# C0DE0000
	# FC0DE000
	# FFFFFFFF
	# pout_end