;START CORE

PARAM_1		init 0
PARAM_2		init gibeats/48
PARAM_3     init .5

PARAM_OUT	cordelia_pitch_chebyshev_vco PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

	opcode cordelia_pitch_chebyshev_vco, a, akkk
	ain, kdiv, kport, kmix xin

ilow		init 2
ihigh		init 15
itime		init i(gkbeats)
if itime <= 0 then
	itime = 1/2
endif
itime		init itime / 2

idbthresh	init 9 ; dB threshold
koct, kdyn 	pitch ain, itime, ilow, ihigh, idbthresh
kdyn		= kdyn/pow(2, 16)
kcps        = cpsoct(koct)
if kdiv > 0 then
	kcycle		= chnget:k("heart") * divz(gkdiv, kdiv, 1)
	koct		samphold koct, changed2(int(kcycle))
	koct2		vdel_k koct, gkbeats*kdiv, itime*2
endif

k1			jitter 1, gkbeatf/24, gkbeatf/8
k2			jitter 1, gkbeatf/24, gkbeatf/8
k3			jitter 1, gkbeatf/24, gkbeatf/8
k4			jitter 1, gkbeatf/24, gkbeatf/8
k5			jitter 1, gkbeatf/24, gkbeatf/8

aosc1		vco2 1, portk(kcps, kport)
acheby1		chebyshevpoly  aosc1, 0, k1, k2, k3, k4, k5

aosc2		vco2 1, portk(kcps, kport)
acheby2		chebyshevpoly  aosc2, 0, k5, k4, k3, k2, k1

aosc		= (acheby1 + acheby2/2)*portk(kdyn, kport/(1+jitter:k(.5, gkbeatf/8, gkbeatf)))

aout		= ain*(1-kmix) + aosc*kmix

	xout aout
	endop


;END OPCODE
