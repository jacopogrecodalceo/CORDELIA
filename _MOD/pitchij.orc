;START CORE

PARAM_1		init 0
PARAM_2		init gibeats/48
PARAM_3     init .5

PARAM_OUT	cordelia_pitch PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

	opcode cordelia_pitch, a, akkk
	ain, kdiv, kport, kwet xin

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

if kdiv > 0 then
	kcycle			= chnget:k("heart") * divz(gkdiv, kdiv, 1)
	koct			samphold koct, changed2(int(kcycle))
	koct2			vdel_k koct, gkbeats*kdiv, gibeats*2
	aosc2			oscili 1, portk(cpsoct(koct2)/2, kport/(1+jitter:k(.5, gkbeatf/8, gkbeatf))), gitri
endif

aosc1		oscili 1, portk(cpsoct(koct)/2, kport/(1+jitter:k(.5, gkbeatf/8, gkbeatf))), gitri
aosc		= (aosc1 + aosc2/2)*portk(kdyn, kport/(1+jitter:k(.5, gkbeatf/8, gkbeatf)))*4

aout		= ain*(1-kwet) + aosc*kwet

	xout aout
	endop

;END OPCODE
