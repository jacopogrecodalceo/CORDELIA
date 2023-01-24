gain1	init 0

	instr in1

Sinstr		init "in1"
aout		inch 1

gain1		= aout

	endin
	alwayson("in1")

