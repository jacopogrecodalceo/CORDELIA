ginmic2		init 1

	instr inmic2

Sinstr		init "inmic2"
ich		init p4

aout		inch ginmic2

	$CHNMIX	

	

indx	init 0
until	indx == nchnls do
	schedule nstrnum("inmic2")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od

