# TAG = lui
	.text

	lui x31, 0       
	lui x31, 0xfffff 
	lui x31, 0x12345 

	# max_cycle 50
	# pout_start
	# 00000000
	# FFFFF000
	# 12345000
	# pout_end
