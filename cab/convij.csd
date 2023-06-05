<Cabbage>
form caption("Untitled") size(400, 300), guiMode("queue") pluginId("def1")

rslider bounds(296, 162, 100, 100), channel("mix"), range(0, 1, 0, 1, .01), text("mix"), trackerColour("lime"), outlineColour(0, 0, 0, 50), textColour("white")
rslider bounds(196, 62, 100, 100), channel("chan"), range(0, 1, 0, 1, .01), text("chan"), trackerColour("lime"), outlineColour(0, 0, 0, 50), textColour("white")

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 64
nchnls_i = 4
nchnls = 2
0dbfs = 1

gihanning			ftgen   0, 0, 8192, 20, 2

gkmix cabbageGetValue "mix"
gkchan cabbageGetValue "chan"

    instr 1
    
a1 inch 1
a2 inch 2

a3 inch 3
a4 inch 4

aout1    cross2 a1, a3, 4096, 2, gihanning, gkmix
aout2    cross2 a2, a4, 4096, 2, gihanning, gkmix

aout1	balance2 aout1+(a3*gkchan), a1
aout2	balance2 aout2+(a4*gkchan), a2

    outs aout1, aout2

    endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7]
</CsScore>
</CsoundSynthesizer>
