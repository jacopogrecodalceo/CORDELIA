<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
0dbfs=1
nchnls=2
sr = 48000
ksmps = 1

girich	hc_gen 0, 8192, 0, \ 
		hc_segment(3/126, 1, hc_power_curve(0.18794)), \ 
		hc_segment(12/126, 0.0294, hc_diocles_curve(1.00163)), \ 
		hc_segment(9/126, 0.07087, hc_diocles_curve(1.16098)), \ 
		hc_segment(75/126, 0, hc_diocles_curve(1.22589))




girichr ftgen 0, 0, 8192, 2, 1

        opcode table_inv, 0, ii
itab, itabr xin

indx init 8192
until indx < 0 do
	ival	table indx, itab
			tablew ival, 8192-indx, itabr
	indx -= 1
od
		endop


table_inv girich, girichr

	instr 1

ktrig metro randomi:k(.25, 3, .5)				;produce 100 triggers per second

if ktrig == 1 then
	schedulek 2, 0, 4
endif

	endin

	instr 2

idur init p3

aout = oscili:a(1/4, random:i(300, 200))*table3:a(linseg:a(1, idur, 0)*.99, girich, 1)
outall aout

	endin


</CsInstruments>
<CsScore>
i 1 0 15
e
</CsScore>
</CsoundSynthesizer>
