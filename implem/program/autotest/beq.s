# TAG = beq
	.text

	addi x1, x0, 5       #Test chargement d'une valeur nulle
	addi x2, x0, 2
	addi x3, x0, 2
	beq x1, x2, no
	addi x31, x0, 1
	beq x2, x3, yes

no:
	addi x31, x0, 0
yes:
	addi x31, x0, 2
	# max_cycle 50
	# pout_start
	# 00000001
	# 00000002
	# pout_end
