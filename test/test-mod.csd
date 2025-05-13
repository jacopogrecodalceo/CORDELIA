<CsoundSynthesizer>
<CsOptions>
-odac
--sample-rate=48000
--nchnls=2
--ksmps=16
--0dbfs=1
--m-amps=1
--m-range=1
--m-warnings=0
--m-dB=1
--m-colours=1
--m-benchmarks=0
</CsOptions>

<CsInstruments>

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

	instr 1

ain, a_ diskin2 "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm2.wav", 1, 0, 1
aout cordelia_monster ain, 2
outall aout

	endin



</CsInstruments>
<CsScore>
i 1 0 32
</CsScore>
</CsoundSynthesizer>
