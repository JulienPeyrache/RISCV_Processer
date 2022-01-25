#TAG = auipc
    .text

    lui x31, 0x00003
    auipc x31, 0x00006
    auipc x31, 0x00006
    auipc x31, 0x00006
    auipc x31, 0x00006

    # max_cycle 50
    # pout_start
    # 00003000
    # 00007008
    # 0000700c
    # 00007010
    # 00007014
    # pout_end