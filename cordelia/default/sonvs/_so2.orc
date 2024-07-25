
gi---NAME---_len		init lenarray(gi---NAME---_list)/gi---NAME---_ch
gi---NAME---_where		init 0

gk---NAME---_off		init .005
gk---NAME---_dur		init 1
gk---NAME---_sonvs		init 1

	$start_instr(---NAME---)

isonvs		i gk---NAME---_sonvs-1
isonvs		init isonvs%(gi---NAME---_len-1)
imod		init gi---NAME---_ch-1

index		init (isonvs*gi---NAME---_ch)+imod

itab_sonvs	init gi---NAME---_list[index]

iratio = icps / ---PITCH---

ifreq init 1/(ftlen(itab_sonvs)/sr)*iratio

andx	oscil3 1, ifreq/2, giatri
;andx	phasor ifreq
aout	table3  andx, itab_sonvs, 1, 0, 1
aout 	*= $dyn_var
;aout loscil3 $dyn_var, ifreq, itab_sonvs
	$dur_var(10)
	$end_instr

