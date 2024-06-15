;strijp with jitter

;START CORE

;division
PARAM_1 init ntof("4B")

;gen
PARAM_2 init i(gkbeats)/24

PARAM_3 init .5

PARAM_OUT cordelia_streson_p2 PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE
;START INPUT
kkk
;END INPUT

;START OPCODE


	opcode cordelia_streson_p2, a, akkk
	ain, kfreq, kport, kq xin

#define cordelia_streson_p2_q #limit(kq+jitter:k(kq/3, gkbeatf/16, gkbeatf), .05, .95)#

kfreq	portk kfreq, kport

aguid	wguide1 ain, 1/kfreq, kfreq/2, $cordelia_streson_p2_q

astr1	streson ain, kfreq, $cordelia_streson_p2_q
astr2	streson ain, kfreq*3/2, $cordelia_streson_p2_q

aout	= aguid + astr1 + astr2
aout	/= 3

aout	phaser1 aout, kfreq, 12, $cordelia_streson_p2_q
	
	xout aout
	endop
;END OPCODE