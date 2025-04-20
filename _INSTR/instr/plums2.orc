; 11/02/25
; jacoueminus greed d'alceo
; pulsar synthesis in its simplest basis

giplums2_formant_count init 3

	instr plums2
$params(plums2_instr)
indx init 0
while indx < giplums2_formant_count do
	iformant_freq init icps * (indx+1)
	schedule Sinstr, 0, idur, idyn / giplums2_formant_count, ienv, icps, ich, iformant_freq
	indx += 1
od
	turnoff
	endin

	instr plums2_instr
$params(plums2)
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

apulsaret = apulsaret * min(apulsaret_phase, a(1))

; Amplitude modulation
apulsaret *= (.5+alfo/2)

areal, aimag 		hilbert apulsaret

; Quadrature oscillator.
asin oscil3 1, iformant_freq, gisine
acos oscil3 1, iformant_freq, gisine, .25

; Use a trigonometric identity. 
; See the references for further details.
amod1 = areal * acos
amod2 = aimag * asin

; Both sum and difference frequencies can be 
; output at once.
; aupshift corresponds to the sum frequencies.
aupshift = (amod1 - amod2) / 4
; adownshift corresponds to the difference frequencies. 
adownshift = (amod1 + amod2) / 4

aout sum aupshift, adownshift

;aout	moogladder2 aout, limit(icps+(icps*96*idyn), 20, 20$k), random:i(.35, .65)
aout *= 8

;aPITCH		PITCH_shifter			ain, klfo_rate

;aFREQ		FREQ_shifter			ain, klfo_rate

; Accumulate the output
;aout += sum(aPITCH, aFREQ)
aout *= idyn



	$dur_var(10)
	$end_instr
