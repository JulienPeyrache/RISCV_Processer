# TAG = story_load
	.text

	lui  x31, 0xDEADB
	addi x31, x31, 0x00F
	lui  x30, 0x1
	sw   x31, 0x4(x30)
	add  x31, x0, x0
	lw   x31, 0x4(x30)

	# max_cycle 50
	# pout_start
	# DEADB000
	# DEADB00F
	# 00000000
	# DEADB00F
	# pout_end