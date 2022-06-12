# TAG = jalr
    .text

    add x31, x0, x0   #1000
    lui x30, 0x1      #1004- x30 = 0x00001000
    addi x30, x30, 0x14   #1008-x30 = 0x00001014
    jalr x31, 4(x30)  #100C
    beq x0, x0, exit  #1010

test: 
    addi x31, x0, 10
    addi x31, x0, 9

exit:
    addi x31, x0, 1

    # max_cycle 50
	# pout_start
    # 00000000
    # 00001010
    # 00000009
    # 00000001
    # pout_end