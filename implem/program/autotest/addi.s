# TAG = addi
	.text

	addi x31, x0 ,0x4       #Test avec un immédiat quelconque
	addi x31, x31,0x6 		#Test avec sa valeur précédente
	addi x31, x0, -1 		#Test avec un immédiat de valeur maximal sur 12 bits
	addi x31, x0, 0x0  		#Test avec la valeur nulle

	# max_cycle 50
	# pout_start
	# 00000004
	# 0000000A
	# FFFFFFFF
	# 00000000
	# pout_end

