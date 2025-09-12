;START CORE
PARAM_1    init 3
PARAM_2    init 3

PARAM_OUT cordelia_crispy PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE

    opcode cordelia_crispy, a, akk
    ain, kratio_l, kratio_h xin

idt                 init ksmps / sr

alow, ahigh, aband  svfilter  ain, ntof("2B"), .75
arms_low            follow alow, idt
krms_low            k arms_low
alpf		        K35_lpf ain, ntof("2B"), 5+krms_low, 1.25, 1+krms_low*kratio_l

arms_high           follow ahigh, idt
krms_high           k arms_high
ahpf		        K35_hpf ain, ntof("2B"), 5+krms_high*2, 1.125, 1+krms_high*kratio_h


k0		init -.75
k1		init .45
k2		init .125
k3		init -1/12
k4		init .645
k5		init -.245
k6		init .025
k7		init -.87535

;=======================================================================
;let's add a delay on the high
ahpf_delx			init 0
kfreq_samphold      = 1.5+krms_high*35

kdel_t		samphold gkbeats/3, metro(kfreq_samphold)
/* kdel_t			init 0
if kdel_t_temp > 1/12 then
	kdel_t = kdel_t_temp
endif */
kfeedback 	= .15 + oscil3(.75+jitter(.05, 1, 3), kfreq_samphold, giasquare)

ahpf_delx		vdelayx ahpf+ahpf_delx*(1-kfeedback), a(kdel_t), 5, 4096
;=======================================================================
        

acheby		chebyshevpoly  (alpf/kratio_l+ahpf/kratio_h+(ahpf_delx/(kratio_h*3)))/4, k0, k1, k2, k3, k4, k5, k6, k7
aout        = ain/(kratio_l+kratio_h)+acheby*linsegr(0, .95, 1, 1, 0)*(kratio_l+kratio_h)/8

    xout aout
    endop
;END OPCODE

