;START CORE

;space
PARAM_1 init 1

PARAM_OUT plate_rev PARAM_IN, PARAM_1

;END CORE
;START INPUT
k
;END INPUT

;START OPCODE

giplate_rev_tabexcite	ftgen 0, 0, 0, -2, .35, .3875, .392575, .325, .85715, .78545
giplate_rev_tabouts		ftgen 0, 0, 0, -2, .25, .675, 1.50975, .25, .75, .51545

	opcode plate_rev, a, ak
	ain, kmix xin

itime	init i(gkbeats)*8 

arev	platerev giplate_rev_tabexcite, giplate_rev_tabouts, 0, .095, .75, itime, .0015, ain
aout	= ain*(1-kmix) + arev*kmix

	xout aout
	endop
;END OPCODE

