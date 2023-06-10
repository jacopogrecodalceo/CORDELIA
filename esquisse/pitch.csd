<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac  ;;;realtime audio out
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o sndwarp.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr = 48000 
ksmps = 32 
0dbfs  = 1 
nchnls = 2

instr 1

ktimewarp = 0
kresample init p5/440		;do not change pitch
ibeg = .45			;start at beginning
kwsize  = sr/20
iwsize = 4800			;window size in samples with
irandw = 400			;bandwidth of a random number generator
itimemode = 1			;ktimewarp is "time" pointer
ioverlap = p4

asig	sndwarp  .5, ktimewarp, kresample, 1, ibeg, iwsize, irandw, ioverlap, 2, itimemode
asig 	/= 2
    	outs asig, asig

endin
</CsInstruments>
<CsScore>
f 1 0 0 1 "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/mh.wav" 0 0 0	; audio file
f 2 0 1024 9 0.5 1 0		; half of a sine wave

i 1 0 15 2 220			;different overlaps
i 1 0 15 2 660			;different overlaps
i 1 0 15 2 880			;different overlaps

e

</CsScore>
</CsoundSynthesizer>