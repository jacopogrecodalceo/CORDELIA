<CsoundSynthesizer>
<CsOptions>

;--midioutfile="midi.mid" -odac
-b2
-B2048
-Ma
-odac
</CsOptions>
<CsInstruments>

0dbfs=1
nchnls=2
sr = 48000
ksmps = 2

giedo12					ftgen 0, 0, 0, -2, 12, 3/1, A4, 69, 1, 1.0594630943592953, 1.122462048309373, 1.189207115002721, 1.2599210498948732, 1.3348398541700344, 1.4142135623730951, 1.4983070768766815, 1.5874010519681994, 1.681792830507429, 1.7817974362806785, 1.8877486253633868, 2/1


	instr 1

icps	cpstmid giedo12
midinoteoncps p4, p5				;puts MIDI key translated to cycles per second into p4, and MIDI velocity into p5

kvel = p5/1024					;scale midi velocity to 0-1
kenv madsr 0.005, 0.8, 0.8, 0.5			;amplitude envelope multiplied by
asig pluck kenv*kvel, icps, icps, 2, 1		;velocity value			
     outs  asig, asig
	endin


</CsInstruments>
<CsScore>
f0 z
f 2 0 4096 10 1	

</CsScore>
</CsoundSynthesizer>
