	instr killer
inum	init p4
	turnoff2 inum, 1, 1
	endin

	opcode kill, 0, i
	inum xin
	schedule "killer", 0, 1, inum
	endop

	opcode start, 0, i
	inum xin
	kill inum
	schedule inum, gizero, -1
	endop

