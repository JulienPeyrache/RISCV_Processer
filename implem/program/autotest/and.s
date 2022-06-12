# TAG = and
	.text

	lui  x31, 0x55555     # On set un bit sur deux dans x31, poids fort ...
	addi x31, x31, 0x555  # ... bits de poids faible
	lui  x30, 0x00FFF     # Chargement du masque
	and  x31, x31, x30    # And
	addi x30, x0, 0       # Valeur zero
	and  x31, x31, x30    # And avec zero

	# max_cycle 50
	# pout_start
	# 55555000
	# 55555555
	# 00555000
	# 00000000
	# pout_end
