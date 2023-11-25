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

opcode jcut, a, akk
	asig, ksub, kchoice xin

	imaxdur init 2*4
	kstutter init 0
	ktrig metro 1
	kstutterspeed = 1

	kchoice = kchoice % ksub
	kreach init 0

	if changed2(ktrig) == 1 then
		ksub_ch = changed2(ksub)
		kchoice_ch = changed2(kchoice)
		kstutter_ch = changed2(kstutter)
	endif
	
	ilen_smps = imaxdur * sr
	ibuf ftgentmp 0, 0, ilen_smps, -2, 0
	
	kstut_sub init 1
	kstut_rpos init 0
	if(kstutter_ch > 0) then 
		kstut_sub = ksub
		kstut_rpos = 0
	endif

	kstut_limit = int(ilen_smps / kstut_sub)
	ibuf_stutter ftgentmp 0, 0, ilen_smps, -2, 0

	kwrite_ptr init 0
	
	asig init 0

	kcnt = 0
	while kcnt < ksmps do 
		tablew(asig[kcnt], kwrite_ptr, ibuf)
		kwrite_ptr = (kwrite_ptr + 1) % ilen_smps
		kcnt += 1
	od

	kincr init 0
	kinit init 1
	if(kinit == 1  || kchoice_ch > 0 || ksub_ch > 0 ) then
		kplus = ilen_smps / ksub * kchoice
		kread_ptr = (kwrite_ptr + kplus) % ilen_smps
		kincr = 0
	endif
	kreach = 0

	kcnt = 0
	if(kstutter > 0) kgoto stutter

	kinit = 0
	while kcnt < ksmps do 
		aout[kcnt] = table(  (kread_ptr + kincr) % ilen_smps, ibuf)	
		kincr = (kincr + 1) % int(ilen_smps / ksub) 
		// Write for stutter
		tablew(aout[kcnt], kincr, ibuf_stutter)
		if(kincr == 0) then 
			kreach = 1
		endif

		
		kcnt += 1 
	od
	kgoto nostutter

	stutter:
	kcnt = 0
	while kcnt < ksmps do 
		aout[kcnt] = table(kstut_rpos, ibuf_stutter)
		kstut_rpos = (kstut_rpos + kstutterspeed) % int(ilen_smps / kstut_sub)
		kcnt += 1		
	od

	nostutter:
	
	xout aout
endop


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
aout jcut aout, 32, 1
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
