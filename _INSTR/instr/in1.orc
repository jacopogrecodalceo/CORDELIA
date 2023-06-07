
	instr in1

Sinstr		init "in1"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

aout	inch 1

	chnmix aout, sprintf("%s_%i", Sinstr, ich)

	endin
	
indx	init 1
until	indx > ginchnls do
	schedule  nstrnum("in1")+((indx+1)/1000), 0, -1, 0, 0, 0, indx
	indx += 1
od
