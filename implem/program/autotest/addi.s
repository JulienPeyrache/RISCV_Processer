# TAG = addi
	.text

	addi x31, x0, 0       #Test chargement d'une valeur nulle
	addi x31, x0, 2 #Test chargement d'une valeur maximal sur 20 bits
	addi x31, x31, 4 #Test chargement d'une valeur quelconque

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000002
	# 00000006
	# pout_end

