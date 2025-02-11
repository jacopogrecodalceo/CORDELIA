; 11/02/25
; jacoueminus greed d'alceo
; pulsar synthesis in its simplest basis

giplums_formant_count init 3

	instr plums
$params(plums_instr)
indx init 0
while indx < giplums_formant_count do
	iformant_freq init icps * (indx+1)
	schedule Sinstr, 0, idur, idyn / giplums_formant_count, ienv, icps, ich, iformant_freq
	indx += 1
od
	turnoff
	endin

	instr plums_instr
$params(plums)
iformant_freq init p8

icps_lfo init icps
while (icps_lfo / 2) <= 1 do
	icps_lfo /= 2
od
alfo			lfo 1, icps_lfo
; Sine cycles (number of oscillations in the pulsaret)
asine_cycles	randomh 1, 3, icps_lfo
;ksine_cycles	= klfo/3

apulsaret_phase		phasor icps
apulsaret_phase		= apulsaret_phase * iformant_freq / icps ; Scale phase

awindow     		table3 phasor(random:i(1, 4+idyn*12)/idur), gihanning, 1

; Pulsaret signal (sine wave with windowing)
apulsaret 	oscil3 awindow, apulsaret_phase * asine_cycles, gisine ; Sine wave pulsaret

aout 		= apulsaret * min(apulsaret_phase, a(1))

; Amplitude modulation
aout *= (.5+alfo/2)

;aout	moogladder2 aout, limit(icps+(icps*96*idyn), 20, 20$k), random:i(.35, .65)
aout *= 8

;aPITCH		PITCH_shifter			ain, klfo_rate

;aFREQ		FREQ_shifter			ain, klfo_rate

; Accumulate the output
;aout += sum(aPITCH, aFREQ)
aout *= idyn



	$dur_var(10)
	$end_instr
