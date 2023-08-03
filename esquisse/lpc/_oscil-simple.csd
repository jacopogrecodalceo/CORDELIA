<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac  --limiter=1   ;;;realtime audio out & limit loud pops
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o lpreson-2.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 2
nchnls = 2
0dbfs  = 1

; by Menno Knevel - 2021
;works with or without -a option when analyzing "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/armagain.wav" from the manual
;both options sound a little different
ires  system_i 1,{{ lpanal -p 24 -s 48000 "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm2.wav" /Users/j/Documents/PROJECTs/CORDELIA/esquisse/lpc/anal1.lpc }}  ; pole filter file
gihanning   ftgen   0, 0, 8192, 20, 2

gifile ftgen 0, 0, 0, 1, "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm2.wav", 0, 0, 1

    instr 1

ilen filelen "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm2.wav"
p3 init ilen

kread  linseg 0, ilen, ilen

krmsr, krmso, kerr, kcps lpread kread, "/Users/j/Documents/PROJECTs/CORDELIA/esquisse/lpc/anal1.lpc"
;kcfs[], krmsr, kerr, kcps lpcanal kread, 1, gifile, isize, iord, gihanning

ktrig metro 15
;kdyn = krmso/8192
kdyn = krmsr/1024

idur init 5
if ktrig == 1 && kdyn > .005 then
    schedulek 2, 0, idur, kdyn, kcps
endif


a1, a2 diskin "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm2.wav"
    outall a1*.25

    endin

    instr 2

;aout pluck p4, p5+jitter(1, .25, 1)*4, p5*4, 0, 1
aout oscili linseg(0, .005, p4, p3-.005, 0), p5*4
    outall aout

    endin

</CsInstruments>
<CsScore>
f1 0 4096 10 1


i 1 0 1
e
</CsScore>
</CsoundSynthesizer>
