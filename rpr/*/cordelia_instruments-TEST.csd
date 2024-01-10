<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac     ;;;realtime audio out
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o harmon3.wav -W ;;; for file output any platform
--sample-rate=48000
-3
--0dbfs=1
--ksmps=32
</CsOptions>
<CsInstruments>

gSfile init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/alina.wav"

#include "/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS/buzzy_fm2.orc"

</CsInstruments>
<CsScore>

i1 0 1 1
i1 0 1 2
e

</CsScore>
</CsoundSynthesizer>