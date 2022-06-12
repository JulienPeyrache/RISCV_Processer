# TAG = slt
    .text

    addi x30, x0, 1
    slt x31, x0, x0
    slt x31, x0, x30
    slt x31, x30, 0
    addi x31, x0, -2
    slt x31, x31, x30

    # max_cycle 50
    # pout_start
    # 00000000
    # 00000001
    # 00000000
    # FFFFFFFE
    # 00000001
    # pout_end