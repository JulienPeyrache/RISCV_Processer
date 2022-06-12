# TAG = srai
	.text


    lui  x31, 0xCAFE
    srai x31, x31, 0x4
    lui  x31, 0xC0DE0
    srai x31, x31, 0x4
    srai  x31, x31, 0x1F

    # max_cycle 50
	# pout_start
	# 0CAFE000
	# 00CAFE00
	# C0DE0000
	# FC0DE000
	# FFFFFFFF
	# pout_end