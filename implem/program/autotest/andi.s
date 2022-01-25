# TAG = andi
	.text

	addi x1, x0, 22       #Test chargement d'une valeur nulle
	andi x31, x1, 15 #Test chargement d'une valeur maximal sur 20 bits

	# max_cycle 50
	# pout_start
	# 00000006
	# pout_end