# TAG = bne
    .text

    addi x31, x0, 10
    addi x30, x0, 5

loop1:
    addi x31, x31, -1
    bne x31, x30, loop1

    # max_cycle 50
    # pout_start
    # 0000000A
    # 00000009
    # 00000008
    # 00000007
    # 00000006
    # pout_end