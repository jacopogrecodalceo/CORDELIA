;CORE

PARAM_OUT	bij PARAM_IN, PARAM_1, PARAM_2
	
;OPCODE

	opcode  bij, a, akk
	ain, ktime, kfb xin

kdel    = ktime

ibpm		i gkpulse
ibps		init ibpm/60
isubdiv		init 8 ;4, 8, 12 ..
ibarlength	init 4
iphrasebars	init 1
inumrepeats	init 9

istutterspeed	init 1
istutterchance	init 1
ienvchoice	init 1

aout        bbcutm ain, ibps, isubdiv, ibarlength, iphrasebars, inumrepeats, istutterspeed, istutterchance, ienvchoice

	xout aout
    	endop


