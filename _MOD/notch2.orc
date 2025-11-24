;START CORE
PARAM_1    init 35
PARAM_2    init 0

PARAM_OUT cordelia_notch PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE

    opcode cordelia_notch, a, akk
    ain, kratio, k_ xin

kcps, krms pitchamdf ain, 35, 2500

kfreq_samphold = 1.5+krms*kratio

;===================
kord 		init 45
;===================
;kfeedback 	init .95
kfeedback 	= .15 + oscil3(.75+jitter(.05, 1, 3), kfreq_samphold/2, giasquare)
anotch		phaser1 ain, samphold:k(kcps, metro(kfreq_samphold)), kord, kfeedback
anotch		= (ain / 12 - anotch) / 2

adelx			init 0
kdel_t_temp		= 1/samphold:k(kcps, metro(kfreq_samphold))*16
kdel_t			init 0
if kdel_t_temp > 1/12 then
	kdel_t = kdel_t_temp
endif

while kdel_t > 5 do
	kdel_t /= 2
od

adelx		vdelayx anotch+adelx*(1-kfeedback), a(kdel_t), 5, 4096

asum		sum anotch, adelx / 8

aout		butterhp asum, 20

    xout aout
    endop
;END OPCODE

