#TAG = auipc
    .text

    auipc x31, 0     # Test ajout d'une valeur nulle
	auipc x31, 0x11  # Ajout d'une valeur non nulle

	# max_cycle 50
	# pout_start
	# 00001004
	# 00012008
	# pout_end