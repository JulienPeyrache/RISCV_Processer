# TAG = andi
	.text

	lui  x31, 0x55555     # On set un bit sur deux dans x31, poids fort ...
	addi x31, x31, 0x555  # ... bits de poids faible
	andi x31, x31, 0xFF   # And
	andi x31, x31, 0      # And avec zero

	# max_cycle 50
	# pout_start
	# 55555000
	# 55555555
	# 00000055
	# 00000000
	# pout_end