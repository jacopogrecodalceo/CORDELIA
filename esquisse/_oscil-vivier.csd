<CsoundSynthesizer>
<CsOptions>
-odac
-r=48000
--ksmps=16
--nchnls=2
--0dbfs=1
</CsOptions>
<CsInstruments>

/*
The A of the soprano, 440Hz, and the G of the second horn and cellos, 196 Hz, when “ring-modulated”, produce the combination tone of 636 Hz (a+b). . . .
Then the process continues: the new pitch is itself ring-modulated against the original G: 636 Hz plus 196 Hz gives the combination tone of 832 Hz (a+2b).
This new note is in turn ring-modulated against the G: 832 Hz plus 196 Hz gives 1028 Hz (a+3b). 
 And so the process continues, with two more, still higher, combination tones. (Gilmore 2007, 8; 2014, 166–67)
*/

gisaw ftgen	0, 0, 8192, 7, 1, 8192, -1				; sawtooth wave, downward slope

	instr 1

iatk	init p3/8
aout	oscili .015, p4, gisaw
if p5 > 0 then
	aout	*= oscili:a(1, p5)
endif
aout	= aout * cosseg:a(0, iatk, 1, p3-(iatk*2), 1, iatk, 0)
af		moogladder2 aout, p4, .95
aout	balance2 af, aout
	outall aout

	endin


</CsInstruments>
<CsScore>
i1		0		3		440		0
i1		0		3		196		0
i1		+		3		440		196
i1		+		3		[440+196]		0

</CsScore>
</CsoundSynthesizer>
