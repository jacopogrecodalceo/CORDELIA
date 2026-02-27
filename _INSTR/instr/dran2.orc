/*
it's dran, but with a vco2
*/

	$start_instr(dran2)
	$dur_var(10)

icps_start init icps
while icps_start < 90 do
	icps_start *= 2
od

icps_end init icps / 8
while icps_end < 10 do
	icps_end *= 2
od

kpitch 			expseg icps_start, .008*idur, icps_end, .092*idur, icps_end-5
aosc				vco2 1/12, kpitch

kfreq				init icps / 2
while kfreq > 20 do
	kfreq /= 2
od

while kfreq < 3 do
	kfreq *= 2
od

ktrig				init 0
iphase			init 0
kfreq_seg		loopxseg kfreq, ktrig, iphase, .05, .65, 1, .0125, .005, .95, .0015, .95

aosc_lpf			diode_ladder aosc, limit(kfreq_seg*icps*4, 35, 17500), 11+jitter(1, 1, 1/8)

aosc_hpf			K35_hpf aosc/powoftwo(2), limit(icps+kfreq_seg*icps*4, 35, 13500), 10;+jitter(1, 1, 1/8)
aosc_hpf			buthp aosc_hpf/powoftwo(2), 20

aosc				sum aosc/3, aosc_lpf, aosc_hpf/powoftwo(2)

/* kenv_int			loopxseg kfreq, 0, 1/4, .05, .75, 1, .0125, .005, .95, .0015, .95
aosc				*= kenv_int
 */
aosc 				*= envgen(idur_var, ienv) 

idel_start		random .45, .55
idel_end 		random .00075, .00035
itime				init idur/3

; Delay time envelope (exponential decay)
adel_time		expseg idur*idel_start, itime, idur*idel_end, idur - itime, idur*idel_end+.0001

; Feedback amount (high for long tail)
kfb				cosseg 0.88, itime * .5, 0.92, itime * .5, 0.85, idur - itime, 0.75

; Delay line with feedback
adel_out			init 0
adel_in			= aosc + (adel_out * kfb)
adel_in			*= linseg:a(0, .005, 1)
adel_out			vdelayx adel_in*idyn, adel_time, 1, 512
adel_out			tanh adel_out * random:i(1.15, 1.25)

aout				buthp adel_out, 30

	$channel_mix
	endin

