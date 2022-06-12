# TAG = or 
    .text

    lui  x31, 0xF0F00     # Des bits à 1 de temps en temps ..
	addi x31, x31, 0x00F  # ... bits de poids faible
	lui  x30, 0xFFFFF     # Chargement du masque
	or  x31, x31, x30     # OR
	addi x30, x0, 0       # Valeur zero
	or  x31, x31, x30     # Or avec zero

	# max_cycle 50
	# pout_start
	# F0F00000
	# F0F0000F
	# FFFFF00F
	# FFFFF00F
	# pout_end