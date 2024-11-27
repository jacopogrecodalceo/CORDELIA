;START CORE
PARAM_1    init 16
PARAM_2    init sr

PARAM_OUT cordelia_mega_dist PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE
	opcode cordelia_mega_dist, a, akk	;UDO Sample rate / Bit depth reducer
	ain, kbit, ksrate xin

acheby		chebyshevpoly  ain, random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1)
apoly		polynomial acheby, floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2))
aout		= apoly
			xout     a0ut

	endop
;END OPCODE
