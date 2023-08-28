;START CORE

;division
PARAM_1 init ntof("4B")

;gen
PARAM_2 init .5

PARAM_OUT cor_streason PARAM_IN, PARAM_1, PARAM_2

;END CORE
;START INPUT
kk
;END INPUT

;START OPCODE


	opcode cor_streason, a, akk
	ain, kfreq, kq xin

kfreq += oscili:k(.5, gkbeatf/64)

aguid	wguide1 ain, 1/kfreq, kfreq/2, kq

astr1	streson ain, kfreq, kq
astr2	streson ain, kfreq*1.25, kq

aout	= aguid + astr1 + astr2
aout	/= 3

aout	phaser1 aout, kfreq, 12, kq
	
	xout aout
	endop
;END OPCODE