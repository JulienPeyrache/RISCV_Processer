# TAG = sb
    .text

    lui  x31, 0x1
    addi x30, x0, 4
    sb   x30, 0xf(x31)
    addi x31, x0, 0
    add  x31, x0, x0

    # max_cycle 50
	# pout_start
    # 00001000
    # 00000040
    # 00000000
    # pout_end