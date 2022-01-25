# TAG = xori 
    .text

    addi x1, x0, 9        
    addi x2, x0, 10
    xori x31, x1, x2        

    #max_cycle 50
    #pout_start
    #00000003
    #pout_end