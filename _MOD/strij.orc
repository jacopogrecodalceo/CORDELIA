;START CORE

;division
PARAM_1 init ntof("4B")

;gen
PARAM_2 init .5

PARAM_OUT cordelia_streson PARAM_IN, PARAM_1, PARAM_2

;END CORE
;START INPUT
kk
;END INPUT

;START OPCODE

gicordelia_streson_limit init .95
gicordelia_streson_thr init .75
gicordelia_streson_range init gicordelia_streson_limit - gicordelia_streson_thr

	opcode cordelia_streson, a, akk
	ain, kfreq, kq xin

; light, shallow compensation on resonance
; or it can explode..
kq      limit kq, 0, gicordelia_streson_limit
kratio  = max(kq - gicordelia_streson_thr, 0) / gicordelia_streson_range
kdyn    = 1 - (kratio * gicordelia_streson_range)

kfreq += oscili:k(.5, gkbeatf/64)

aguid	wguide1 ain, 1/kfreq, kfreq/2, kq

astr1	streson ain, kfreq, kq
astr2	streson ain, kfreq*1.25, kq

aout	= aguid + astr1 + astr2
aout	/= 3

aout	phaser1 aout*kdyn, kfreq, 12, kq
aout	butterhp aout, 20
	xout aout
	endop
;END OPCODE