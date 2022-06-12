#TAG = bgeu
    .text

    addi x31, x0, -3
    addi x30, x0, 2

loop1 : 
    addi x31, x31, 1
    bgeu x31,x30, loop1

    # max_cycle 50
    # pout_start
    # FFFFFFFD
    # FFFFFFFE
    # FFFFFFFF
    # 00000000
    # pout_end