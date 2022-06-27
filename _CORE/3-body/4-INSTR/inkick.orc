	instr inkick

Sinstr		init "inkick"
ich		init p4

aout		inch ginkick_ch

	$mix	

	endin

indx	init 0
until	indx == nchnls do
	schedule nstrnum("inkick")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od

