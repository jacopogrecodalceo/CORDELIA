	opcode	metrout, 0, SiiP
Sinstr, iout1, iout2, kgain xin

ain		chnget sprintf("%s_%i", Sinstr, 1)
aout		= ain * portk(kgain, 5$ms)

		outch iout1, aout, iout2, aout

		endop
