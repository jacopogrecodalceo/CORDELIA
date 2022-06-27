	instr insna

Sinstr		init "insna"
ich		init p4

aout		inch ginsna_ch

	$mix	

	endin

indx	init 0
until	indx == nchnls do
	schedule nstrnum("insna")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od


