<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac  --limiter=0.95   ;;;realtime audio out & limit loud pops
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o lpreson-2.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr      = 48000
ksmps   = 16
nchnls  = 2
0dbfs   = 1

; by Menno Knevel - 2021
;works with or without -a option when analyzing "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/amen.wav" from the manual
;both options sound a little different
ires  system_i 1,{{ lpanal -P25 -Q15000 -s48000 -v1 -p12 /Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/algo.wav /Users/j/Documents/PROJECTs/CORDELIA/esquisse/lpc/anal2.lpc }}  ; pole filter file

instr 1

ilen   filelen "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/algo.wav"	;length of soundfile 1
prints "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/amen.wav = %f seconds\\n",ilen

ktime  phasor 1/ilen
krmsr, krmso, kerr, kcps lpread ktime, "/Users/j/Documents/PROJECTs/CORDELIA/esquisse/lpc/anal2.lpc"

asig, a2   diskin2	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm2.wav", 1     ; use pitch deifferences from the flute

aout        lpfreson asig, 1.3
ares        balance2 aout, asig
ares        dcblock2 ares

            outs ares, ares

endin
</CsInstruments>
<CsScore>
s 
i 1 0 32

e
</CsScore>
</CsoundSynthesizer>