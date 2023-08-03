<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac 

;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o lpreson-2.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr      = 48000
ksmps   = 32
nchnls  = 2
0dbfs   = 1

gSanal_file             init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/fragment.wav"
gSexcitated_file        init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm2.wav"

gSlpc_file              init "/Users/j/Documents/PROJECTs/CORDELIA/esquisse/lpc/anal3.lpc"

ires                       system_i 1, sprintf("lpanal -a -P25 -Q15000 -s48000 -v1 -p32 -h500 \"%s\" \"%s\"", gSanal_file, gSlpc_file)

    instr 1

ilen        filelen gSanal_file
p3          init ilen

ktime       linseg 0, ilen, ilen
ktime       = abs(jitter(1, 1/ilen, 4/ilen))*ilen

krmsr, krmso, kerr, kcps lpread ktime, gSlpc_file
;asig        fractalnoise krmsr*10e-4, .95
asig, a2        diskin gSexcitated_file, 1, 0, 1
aout            lpreson asig

aosc            oscili krmsr*10e-4, portk(kcps*2, .005)
ares            balance2 aout, asig

        outall ares+aosc

    endin  

</CsInstruments>
<CsScore>
i 1 0 1
e
</CsScore>
</CsoundSynthesizer>