#TAG = beq 
    .text

	addi x1, x0, 5       
	addi x2, x0, 2
	beq x1, x2, eq
	addi x31, x0, 1

eq:
	addi x31, x0, 0
	# max_cycle 50
	# pout_start
	# 00000001
	# pout_end    