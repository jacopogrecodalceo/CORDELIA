<CsoundSynthesizer>
<CsOptions>
-3
-m0
-D
--messagelevel=96
--m-amps=1
--env:SSDIR+=../
--sample-rate=48000
--ksmps=64
--nchnls=2
--port=10000
-odac
--udp-echo
</CsOptions>
<CsInstruments>

    instr 1

if metro:k(.25) == 1 then
    turnoff2 nstrnum("score"), 0, 0
    schedulek nstrnum("score"), 0, -1
endif

print 1
    endin
    alwayson(1)

    instr score

print 1

    endin




</CsInstruments>
</CsoundSynthesizer>