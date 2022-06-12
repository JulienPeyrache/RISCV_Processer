# TAG = add
	.text

	lui  x31, 0        # Chargement d'une valeur nulle
	lui  x30, 0xfffff  # Chargement valeur max
	add  x31, x31, x30 # Addition
	lui  x30, 0x12345  # Chargement d'une valeur quelconque
	addi x31, x0,  0x1 # Chargement valeur 1
	add  x31, x31, x30 # Addition

	# max_cycle 50
	# pout_start
	# 00000000
	# FFFFF000
	# 00000001
	# 12345001
	# pout_end