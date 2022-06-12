# TAG = lh
    .text

    addi x31, x0, 1   #Donner x31
    sub  x29, x31, x27
    lui  x30, 0x1
    lh   x31, 4(x30)


    # max_cycle 50
	# pout_start
    # 00000001
    # FFFF8EB3
    # pout_end