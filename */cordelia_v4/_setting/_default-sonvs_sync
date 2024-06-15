
gi---NAME---_len		init lenarray(gi---NAME---_list)/gi---NAME---_ch
gi---NAME---_where		init 0

gk---NAME---_off		init .005
gk---NAME---_freq		init 1
gk---NAME---_sonvs		init 1

	$start_instr(---NAME---)
/*
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7
*/
			$dur_var(10)

isonvs		i gk---NAME---_sonvs-1
isonvs		init isonvs%(gi---NAME---_len-1)
imod		init gi---NAME---_ch-1

index		init (isonvs*gi---NAME---_ch)+imod

itab_sonvs	init gi---NAME---_list[index]

;ilen		init ftlen(itab_sonvs)/ftsr(itab_sonvs)

kfreq = (gkbeatf*gk---NAME---_freq)-((gkbeatf*3/2)*envgen(idur_var, ienv))

if icps > 20 && icps > 0 then
	kresample			init icps / ---PITCH--- 
else
	kresample			init 1
endif

imax_overlaps 		init 4

;itimescale			init ilen / idur
;ips     			init 1 / imax_overlaps

aout				syncgrain $dyn_var, kfreq, kresample, idur/i(gkbeatf), idur, itab_sonvs, ienv, imax_overlaps
aout				*= 3.5

	$end_instr
