# TAG = ori 
    .text

    lui  x31, 0xDEADB  # On va compléter les bits de poids faible
	ori x31, x31, 0xEF # et voila (ok il y a un trou mais c'est à cause du signe extension)
	ori x31, x31, -1   # On peut effacer ça maintenant

	# max_cycle 50
	# pout_start
	# DEADB000
	# DEADB0EF
	# FFFFFFFF
	# pout_end