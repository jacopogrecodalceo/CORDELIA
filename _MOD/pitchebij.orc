;START CORE

PARAM_1		init 0
PARAM_2		init gibeats/48
PARAM_3     init .5

PARAM_OUT	cordelia_pitch_chebyshev PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

	opcode cordelia_pitch_chebyshev, a, akkk
	ain, kdiv, kport, kmix xin

ilow		init 2
ihigh		init 15
itime		init i(gkbeats)
if itime <= 0 then
	itime = 1/2
endif

idbthresh	init 3 ; dB threshold
koct, kamp 	pitch ain, itime, ilow, ihigh, idbthresh
kamp		= kamp/pow(2, 16)
aamp		a kamp
kcps        = cpsoct(koct)
if kdiv > 0 then
	kcycle		= chnget:k("heart") * divz(gkdiv, kdiv, 1)
	koct		samphold koct, changed2(int(kcycle))
	koct2		vdel_k koct, gkbeats*kdiv, itime*2
endif

k1			init random:i(-1, 1)
k2			init random:i(-1, 1)
k3			init random:i(-1, 1)
k4			init random:i(-1, 1)
k5			init random:i(-1, 1)

aosc1		oscili aamp, portk(kcps, kport)
acheby1		chebyshevpoly  aosc1, 0, k1, k2, k3, k4, k5

aosc2		oscili aamp, portk(kcps, kport)
acheby2		chebyshevpoly  aosc2, 0, k5, k4, k3, k2, k1

aosc		= ((acheby1 + acheby2/2)*aamp)
;aosc		exciter aosc, kcps/2, kcps*9, 9, 3
;aosc	    dcblock2 aosc
;aosc        balance2 aosc, ain
aosc2		limit aosc, -.95, .95
aout		= ain*(1-kmix) + aosc*kmix

	xout aout
	endop


;END OPCODE
