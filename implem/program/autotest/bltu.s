# TAG = bltu
    .text

    addi x31, x0, 5
    addi x30, x0, 5
loop1:
    addi x31, x31, -1
    bltu x31, x30, loop1

    # max_cycle 50
	# pout_start
    # 00000005
    # 00000004
    # 00000003
    # 00000002
    # 00000001
    # 00000000
    # FFFFFFFF
    # pout_end