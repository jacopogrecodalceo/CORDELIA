;CORE

;division
PARAM_1 init ntof("4B")

;gen
PARAM_2 init i(gkbeats)/24

PARAM_3 init .5

PARAM_OUT string_filter PARAM_IN, portk(PARAM_1, PARAM_2), PARAM_3

;OPCODE


	opcode string_filter, a, akk
	ain, kfreq, kq xin

aguid	wguide1 ain, 1/kfreq, kfreq/2, kq

astr1	streson ain, kfreq, kq
astr2	streson ain, kfreq*1.25, kq

aout	= aguid + astr1 + astr2
aout	/= 3

aout	phaser1 aout, kfreq, 12, kq
	
	xout aout
	endop
