# TAG = xori 
    .text

    lui  x31, 0xDEADB     # On va compléter les bits de poids faible
	xori x31, x31, 0xEF   # et voila (trou à cause du sign extension)
	xori  x31, x31, 0xEF  # On peut effacer ça maintenant
	xori  x31, x31, -1    # Inversion de bits

	# max_cycle 50
	# pout_start
	# DEADB000
	# DEADB0EF
	# DEADB000
	# 21524FFF
	# pout_end