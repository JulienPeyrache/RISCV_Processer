# TAG = srli
	.text

	lui  x31, 0xCAFE
    srli x31, x31, 0x4
    srli x31, x31, 0x0
    srli x31, x31, 0x1F

    # max_cycle 50
	# pout_start
	# 0CAFE000
	# 00CAFE00
	# 00CAFE00
	# 00000000
	# pout_end