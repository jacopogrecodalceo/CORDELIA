/*
the original cordelia wow, i think i missed that millisecond delay was
second.. so this way it's kind of difficult - tried to make different in wow
*/

;START CORE
PARAM_1     init 1
PARAM_2     init 1

PARAM_OUT cordelia_wow2 PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE

	opcode cordelia_wow2, a, akk
	ain, kfactor, kwet xin

imax_del	init 15

; subtle wow/flutter LFO
idepth1		init 3.5					
irate1 		init 1/10
amod1 		oscili idepth1+jitter(1, 1/8, 1/32), irate1

idepth2		init 1.5					
irate2 		init 1/7
amod2 		oscili idepth2+jitter(.5, 1/8, 1/32), irate2

amod 		= amod1 + amod2

awow vdelay ain*kwet, .015 + amod*a(kfactor), imax_del

aout		= ain*(1-kwet)+ awow

	xout aout
	endop

;END OPCODE

