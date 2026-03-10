;START CORE
PARAM_1    init 35
PARAM_2    init 0

PARAM_OUT cordelia_notch PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE

;===================
gkcordelia_notch_ord 		        init 45
gicordelia_notch_delayx_window 		init 1024
;===================

    opcode cordelia_notch, a, akk
    ain, kratio, k_ xin

/*
icps (optional, default=0) -- estimated initial frequency of the signal. If 0, icps = (imincps+imaxcps) / 2. The default is 0.
imedi (optional, default=1) -- size of median filter applied to the output kcps. The size of the filter will be imedi*2+1. If 0, no median filtering will be applied. The default is 1.
idowns (optional, default=1) -- downsampling factor for asig. Must be an integer. A factor of idowns > 1 results in faster performance, but may result in worse pitch detection. Useful range is 1 - 4. The default is 1.
iexcps (optional, default=0) -- how frequently pitch analysis is executed, expressed in Hz. If 0, iexcps is set to imincps. This is usually reasonable, but experimentation with other values may lead to better results. Default is 0.
irmsmedi (optional, default=0) -- size of median filter applied to the output krms. The size of the filter will be irmsmedi*2+1. If 0, no median filtering will be applied. The default is 0.
*/
kcps, krms pitchamdf ain, 35, 3500;, 0, imedi, idowns;, iexcps, irmsmedi

kfreq_samphold = 1.5+krms*kratio

;kfeedback 	init .95
kfeedback 	= .15 + oscil3:k(.75+jitter:k(.05, 1, 3), kfreq_samphold/2, giasquare)
anotch		phaser1 ain, samphold:k(kcps, metro:k(kfreq_samphold)), gkcordelia_notch_ord, kfeedback
anotch		= (ain / 12 - anotch) / 2

adelx			init 0
kdel_t_temp		= 1/samphold:k(kcps, metro:k(kfreq_samphold))*16
kdel_t			init 0
if kdel_t_temp > 1/12 then
	kdel_t = kdel_t_temp
endif

while kdel_t > 1.5 do
	kdel_t /= 2
od

adelx		vdelayx anotch+adelx*(1-kfeedback), a(kdel_t), 1.5, gicordelia_notch_delayx_window

asum		sum anotch, adelx / 8

aout		buthp asum, 20

    xout aout
    endop

;END OPCODE

