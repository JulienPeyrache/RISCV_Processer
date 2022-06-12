# TAG = bge
	.text

	add x31, x0, x0     # 1000
	addi x30, x0, -2    # 1004

# Loop de 0 à -3
loop1:
	addi x31, x31, -1   # 1008
	bge x31, x30, loop1 # 100c

# Loop de -3 à 4
	addi x30, x0, 4     # 1010
loop2:
	bge x31, x30, exit  # 1014
	addi x31, x31, 1    # 1018
	beq x0, x0, loop2   # 101c
exit:                   # 101c

	# max_cycle 300
	# pout_start
	# 00000000
	# FFFFFFFF
	# FFFFFFFE
	# FFFFFFFD
	# FFFFFFFE
	# FFFFFFFF
	# 00000000
	# 00000001
	# 00000002
	# 00000003
	# 00000004
	# pout_end