# TAG = sub
	.text

	addi x31, x0, 0     # Chargement d'une valeur nulle
	addi x30, x0, 0x123 # Chargement valeur positive
	sub  x31, x31, x30  # Soustraction (résultat négatif)
	addi x30, x0, -1000 # Chargement valeur négative
	sub  x31, x31, x30  # Soustraction (résultat positif)

	# max_cycle 50
	# pout_start
	# 00000000
	# FFFFFEDD
	# 000002C5
	# pout_end