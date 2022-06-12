# TAG = jal
    .text

    add x31, x0, x0 #1000
    jal x31, test   #1004
    beq x0, x0,     #1008

test: 
    addi x31, x0, 2

exit:
    addi x31, x0, 1

    # max_cycle 50
	# pout_start
    # 00000000
    # 00001008
    # 00000002
    # 00000001
    # pout_end