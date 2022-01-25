# TAG = blt
	.text

	addi x1, x0, 5       #Test chargement d'une valeur nulle
	addi x2, x0, 2
	blt x1, x2, lt
	addi x31, x0, 1

lt:
	addi x31, x0, 0
	# max_cycle 50
	# pout_start
	# 00000001
	# pout_end