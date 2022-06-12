# TAG = lhu
    .text

    addi x31, x0, 1
    sub  x29, x31, x27
    lui  x30, 0x1
    lhu  x31, 4(x30)    # 0xB3 sans signe


    # max_cycle 50
	# pout_start
    # 00000001
    # 00008EB3
    # pout_end