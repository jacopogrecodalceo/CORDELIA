<CsoundSynthesizer>
<CsOptions>
-o elle.wav
</CsOptions>
<CsInstruments>
0dbfs=1
nchnls=2

ksmps = 32


opcode vocoder_channel, a, aakiiiii				;MODE UDO 
	aMod,aCar,ksteepness,ibase,ibw,iincr,icount,inum  xin	;NAME INPUT VARIABLES
	icf	=	cpsmidinn(ibase+(icount*iincr))		;DERIVE FREQUENCY FOR *THIS* BANDPASS FILTER BASED ON BASE FREQUENCY AND FILTER NUMBER (icount)
	icount	=	icount + 1				;INCREMENT COUNTER IN PREPARTION FOR NEXT FILTER
	
	if	icf>15000 goto SKIP				;IF FILTER FREQUENCY EXCEEDS A SENSIBLE LIMIT SKIP THE CREATION OF THIS FILTER AND END RECURSION
	
	aModF	butbp	aMod,icf,ibw*icf			;BANDPASS FILTER MODULATOR
	
	if ksteepness=2 then					;IF 24DB PER OCT MODE IS CHOSEN...
	  aModF	butbp	aModF,icf,ibw*icf			;...BANDPASS FILTER AGAIN TO SHARPEN CUTOFF SLOPES
	endif							;END OF THIS CONDITIONAL BRANCH
	aEnv 	follow2	aModF, 0.05, 0.05			;FOLLOW THE ENVELOPE OF THE FILTERED AUDIO
	aCarF	butbp	aCar,icf,ibw*icf			;BANDPASS FILTER CARRIER
	if ksteepness=2 then					;IF 24 DB PER OCT IS CHOSEN...
	  aCarF	butbp	aCarF,icf,ibw*icf			;...BANDPASS FILTER AGAIN TO SHARPEN CUTOFF SLOPES
	endif							;END OF THIS CONDITIONAL BRANCH
	amix	init	0					;INITIALISE MIX VARIABLE CONTAINING ALL SUBSEQUENT BANDS
	
	if	icount < inum	then					;IF MORE FILTERS STILL NEED TO BE CREATED...
		amix	vocoder_channel	aMod,aCar,ksteepness,ibase,ibw,iincr,icount,inum	;...CALL UDO AGAIN WITH INCREMENTED COUNTER
	endif								;END OF THIS CONDITIONAL BRANCH
	SKIP:							;LABEL
		xout	amix + (aCarF*aEnv)			;MIX LOCAL BAND WITH SUBSEQUENT BANDS GENERATED VIA RECURSION
endop								;END OF UDO

	instr 1
Svoice  = "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm2.wav"
p3 = filelen(Svoice)

aMod, a2 diskin Svoice, 1, 0, 1
acar, a2 diskin "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/etag.wav", 1, 1, 1

ain vocoder_channel aMod, acar, 2, 12, 50, 1, 2, 2

	outall ain*8+aMod*cosseg(.25, p3, 0)+acar*cosseg(0, p3, 1/6)

	endin


</CsInstruments>
<CsScore>
i 1 0 1
</CsScore>
</CsoundSynthesizer>
