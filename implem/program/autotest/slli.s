TAG = slli 
    .text

    lui  x31, 0xCAFE
    slli x31, x31, 0x3
    slli x31, x31, 0x0
    slli x31, x31, 0x1F

    # max_cycle 50
	# pout_start
	# 0CAFE000
    # 657F0000
    # 657F0000
    # 00000000
    # pout_end