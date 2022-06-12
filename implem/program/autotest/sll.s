# TAG = sll
    .text

    lui  x31, 0xCAFE   #Valeur random
    addi x30, x0, 0x3  #valeur de shift
    sll  x31, x31, x30 #shift
    lui  x30, 0x0      #valeur de shift nulle
    sll  x31, x31, x30
    addi x30, x0, 0x1F #shift maximal sur 31 bits
    sll  x31, x31, x30

    # max_cycle 50
	# pout_start
    # 0CAFE000
    # 657F0000
    # 657F0000
    # 00000000
    # pout_end