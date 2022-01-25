# TAG = xor 
    .text

    addi x1, x0, 13         #Test chargeme,nt d'une valeur nulle
    addi x2, x0, 5
    xor x31, x1, x2         #Test chargement d'une valeur quelconque

    #max_cycle 50
    #pout_start
    #00000008
    #pout_end
    