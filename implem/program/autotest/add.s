# TAG = add
	.text

	addi x1, x0, 5       

	add x31, x0, x0		#Test chargement d'une valeur nulle
	add x31, x0, x1 	#Test chargement d'une valeur maximal sur 20 bits
	add x31, x31, x31 	#Test chargement d'une valeur quelconque

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000005
	# 0000000A
	# pout_end