;START CORE

PARAM_1		init 0
PARAM_2		init gibeats/48
PARAM_3     init 1
PARAM_4     init .5

PARAM_OUT	cordelia_pitch_chebyshev PARAM_IN, PARAM_1, PARAM_2, PARAM_3, PARAM_4
;END CORE

;START INPUT
kkkk
;END INPUT

;START OPCODE

	opcode cordelia_pitch_chebyshev, a, akkkk
	ain, kdiv, kport, kratio, kwet xin

ilow		init 2
ihigh		init 15
itime		init i(gkbeats)
if itime <= 0 then
	itime = 1/2
endif

idbthresh	init 3 ; dB threshold
koct, kdyn 	pitch ain, itime, ilow, ihigh, idbthresh
kdyn		= kdyn/pow(2, 16)
if kdiv > 0 then
	kcycle		= chnget:k("heart") * divz(gkdiv, kdiv, 1)
	koct		samphold koct, changed2(int(kcycle))
endif
kcps        = cpsoct(koct)
koct2		vdel_k koct, gkbeats*kdiv, itime*2
kcps2        = cpsoct(koct2)

k1			init random(-1, 1)
k2			init random(-1, 1)
k3			init random(-1, 1)
k4			init random(-1, 1)
k5			init random(-1, 1)

aosc1		oscili 1, portk(kcps*kratio, kport)
acheby1		chebyshevpoly  aosc1, 0, k1, k2, k3, k4, k5

aosc2		oscili 1, portk(kcps2*kratio, kport)
acheby2		chebyshevpoly  aosc2, 0, k5, k4, k3, k2, k1

aosc		= (acheby1 + acheby2/2)*portk(kdyn, kport/(1+jitter:k(.5, gkbeatf/8, gkbeatf)))
;aosc		exciter aosc, kcps/2, kcps*9, 9, 3
;aosc	    dcblock2 aosc
;aosc        balance2 aosc, ain
aosc2		limit aosc, -.95, .95
aout		= ain*(1-kwet) + aosc*kwet

	xout aout
	endop


;END OPCODE
