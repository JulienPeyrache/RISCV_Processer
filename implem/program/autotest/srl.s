# TAG = srl
	.text

	lui  x31, 0xCAFE
    addi x30, x0, 0x4
    srl  x31, x31, x30
    lui  x30, 0x0 
    srl  x31, x31, x30 
    addi x30, x0, 0x1F
    srl  x31, x31, x30

    # max_cycle 50
	# pout_start
	# 0CAFE000
	# 00CAFE00
	# 00CAFE00
	# 00000000
	# pout_end