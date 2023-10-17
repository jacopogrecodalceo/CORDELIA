; provide a way to approximate a value using control-rate inputs
	opcode approx, k, kk
	knum, kapprox xin

kfloor	= floor(knum * kapprox)
kres	= kfloor / kapprox
	
	xout kres
	endop


