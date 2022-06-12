# TAG = sh
    .text

    lui  x31, 0x1
    addi x30, x0, 2047
    slli x30, x30, 4
    sh   x30, 0x12(x31)
    addi x31, x0, 0
    add  x31, x0, x0

    # max_cycle 50
	# pout_start 
    # 00001000
    # 000007FF
    # 00000000
    # pout_end