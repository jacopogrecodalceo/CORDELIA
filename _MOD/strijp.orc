;START CORE

;division
PARAM_1 init ntof("4B")

;gen
PARAM_2 init i(gkbeats)/24

PARAM_3 init .5

PARAM_OUT cordelia_streson_p PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE
;START INPUT
kkk
;END INPUT

;START OPCODE


	opcode cordelia_streson_p, a, akkk
	ain, kfreq, kport, kq xin

kfreq	portk kfreq, kport

aguid	wguide1 ain, 1/kfreq, kfreq/2, kq

astr1	streson ain, kfreq, kq
astr2	streson ain, kfreq*1.25, kq

aout	= aguid + astr1 + astr2
aout	/= 3

aout	phaser1 aout, kfreq, 12, kq
	
	xout aout
	endop
;END OPCODE