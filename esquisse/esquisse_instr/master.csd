<CsoundSynthesizer>
<CsOptions>
-3
-m0
-D
--port=10000
--udp-echo
--messagelevel=96
--m-amps=1
--env:SSDIR+=../
-+rtaudio=CoreAudio
--sample-rate=48000
--ksmps=64
--nchnls=2
</CsOptions>
<CsInstruments>

;here to be replaced
sr		    =	48000
ksmps		=	64
nchnls		=	2
0dbfs		=	1

ginchnls		init nchnls

;---

gkheart     init 0

gkheart_beat    init 4
gkheart_val     init 4

gkpulse     init 120

gkbeatn     init 0
gkbeatf     init 0
gkbeats     init 0
gkbeatms    init 0

    instr heart

gkbeatf		= gkpulse / 60
gkbeats		= 1 / (gkpulse / 60)
gkbeatms	= gkbeats*1000

gkheart     phasor (gkpulse / gkheart_div) / 60

klast	init -1
if (((gkheart*gkheart_div)%1) < klast) then
	gkbeatn += 1
endif

klast	= ((gkheart*gkheart_div)%1)

    endin

;---

gamouth[]		init ginchnls

    instr 900

ich     init p4
aout	= gamouth[ich]
    
    outch ich+1, aout

    endin

indx init 0
until indx == ginchnls do
    schedule 900+(indx/1000), 0, -1, indx
    indx += 1
od


</CsInstruments>
<CsScore>
f 0 z
</CsScore>
</CsoundSynthesizer>
