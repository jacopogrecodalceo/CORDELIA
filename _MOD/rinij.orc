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

kexists ftexists ktab
if kexists != 1 then
	ktab = giasine
	printks "WARNING ***RINIJ*** PARAM_2 IS TAB\n", 1/2
endif

kphase		= kdiv - floor(kdiv)
andx		= ((chnget:a("heart_a")*kdiv*gkdiv)+kphase)%1

kwarp	init 0; if greater than 1, use sin (x / kwarp) / x function for sinc interpolation, instead of the default sin (x) / x. This is useful to avoid aliasing when transposing up (kwarp should be set to the transpose factor in this case, e.g. 2.0 for one octave), however it makes rendering up to twice as slow. Also, iwsize should be at least kwarp * 8. This feature is experimental, and may be optimized both in terms of speed and quality in new versions.
iwsize	init 4*16; This parameter controls the type of interpolation to be used:
imode	init 1
ioff	init 0
iwrap	init 1 ;wraparound index flag. The default value is 0.

aring		tablexkt andx, ktab, kwarp, iwsize, imode, ioff , iwrap

aout		= ain * aring

	xout aout
	endop
;END OPCODE
