;START CORE

;division
PARAM_1 init 4

;gen
PARAM_2 init giasine

PARAM_OUT cordelia_ringmod PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE
	opcode cordelia_ringmod, a, akk
	ain, kdiv, ktab xin

kphase		= kdiv - floor(kdiv)
kndx		= ((chnget:k("heart")*kdiv*gkdiv)+kphase)%1
kring		tableikt kndx, ktab, 1, 0, 1

aout		= ain * a(kring)

	xout aout
	endop
;END OPCODE
