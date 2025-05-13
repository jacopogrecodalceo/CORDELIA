;START CORE
/*
a variation of decimator, i'm not very proud of it..
*/
PARAM_1    init 16

PARAM_OUT cordelia_monster PARAM_IN, PARAM_1
;END CORE

;START INPUT
k
;END INPUT

;START OPCODE
	opcode cordelia_monster, a, ak	;UDO Sample rate / Bit depth reducer

	setksmps   1

	ain, kbit xin

kbits		=        2^kbit                ;bit depth (1 to 16)
kin			downsamp ain                   ;convert to kr

;kin			abs kin ; cut low dynamic
kin			tan kin
kin			= 1 / (1 + sin(-kin))

kin			= (kin+0dbfs)           ;add DC to avoid (-)
kin			= kin*(kbits/(0dbfs*2)) ;scale signal level
kin			= ceil(kin)     ;quantise
;kin			= cos(kin * $M_PI)

aout		upsamp   kin                   ;convert to sr
aout		=        aout*(2/kbits)-0dbfs  ;rescale and remove DC
			xout    aout / 12

	endop
;END OPCODE
