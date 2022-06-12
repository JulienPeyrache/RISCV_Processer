# TAG = lb
    .text

    addi x31, x0, x1   #Donner x31
    sub x29, x31, x27  #Instruction à 0x1004 et vaut 0x41BF8EB3 dans la mémoire
    lui x30, 0x1       #Charger 0x1000 dans x30
    lb x31, 4(x30)     #Lire l'octer mem[x30+4] = mem[0x1004] = 0xB3 + extension de signe

    # max_cycle 50
	# pout_start
    # 00000001
    # FFFFFFB3
    # pout_end