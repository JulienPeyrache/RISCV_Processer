# TAG = and
	.text

	addi x1, x0, 13       #Test chargement d'une valeur nulle
	addi x2, x0, 11
	addi x3, x0, 8
	and x31, x1, x2 #Test chargement d'une valeur maximal sur 20 bits
	and x31, x31, x3 #Test chargement d'une valeur quelconque

	# max_cycle 50
	# pout_start
	# 00000009
	# 00000008
	# pout_end