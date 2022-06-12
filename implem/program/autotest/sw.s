# TAG = sw
	.text

	lui  x31, 0x1        # 1000 | Charger l'adresse de base dans x31
	li   x30, 0x00500F93 # 1004 | Opération `addi x31, x0, 5` (deux instructions)
	sw   x30, 0x10(x31)  # 100C |
	add  x31, x0, x0     # 1010 |
	add  x31, x0, x0     # 1014 | Sécurité

	# max_cycle 50
	# pout_start
	# 00001000
	# 00000005
	# 00000000
	# pout_end