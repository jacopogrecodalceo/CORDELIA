;START CORE
PARAM_1    init 16
PARAM_2    init sr

PARAM_OUT cordelia_decimator PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE
	opcode cordelia_decimator, a, akk	;UDO Sample rate / Bit depth reducer

	setksmps   1

	ain, kbit, ksrate xin

kbits		=        2^kbit                ;bit depth (1 to 16)
kfold		=        (sr/ksrate)           ;sample rate
kin			downsamp ain                   ;convert to kr
kin			=        (kin+0dbfs)           ;add DC to avoid (-)
kin			=        kin*(kbits/(0dbfs*2)) ;scale signal level
kin			=        int(kin)              ;quantise
aout		upsamp   kin                   ;convert to sr
aout		=        aout*(2/kbits)-0dbfs  ;rescale and remove DC
a0ut		fold     aout, kfold           ;resample
			xout     a0ut

	endop
;END OPCODE
