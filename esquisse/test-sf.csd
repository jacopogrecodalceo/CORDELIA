<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
0dbfs=1
nchnls=2

sr = 48000

ksmps = 32




	instr piano_load

		ipiano   sfload "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/soundfonts/piano.sf2"
		sfpassign 0, ipiano
		turnoff

	endin
	schedule "piano_load", 0, 1

			instr piano
					$params
		
		aout	    sfplay3m 1, ftom:i(A4), $ampvar/4096, icps, 0, 1
		ienvvar		init idur/10
		
					$death

			endin


</CsInstruments>
<CsScore>
i 1 0 25
</CsScore>
</CsoundSynthesizer>
