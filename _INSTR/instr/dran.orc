/*
I was listening to autechre drane2
digging up
this instrument came up
simply oscil3 with a delay and exponential pitch
*/

	$start_instr(dran)
	$dur_var(10)

icps_start init icps
while icps_start < 90 do
	icps_start *= 2
od

icps_end init icps / 8
while icps_end < 10 do
	icps_end *= 2
od

apitch 	expseg icps_start, .008*idur, icps_end, .092*idur, icps_end-5
aosc		oscil3 1/2, apitch

aosc 		= aosc * envgen(idur_var, ienv)


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