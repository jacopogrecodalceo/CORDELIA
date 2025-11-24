; very simple concatenative synth

gi---NAME---_len		init lenarray(gi---NAME---_list)/gi---NAME---_ch
gk---NAME---_sonvs		init 1

	instr ---NAME---

Sinstr		init "---NAME---"
idur		init p3;, i(gk---NAME---_dur), 1
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

isonvs		i gk---NAME---_sonvs
isonvs		abs isonvs

isonvs		init isonvs%(gi---NAME---_len-1)
imod		init gi---NAME---_ch-1

index		init (isonvs*gi---NAME---_ch)+imod

itab_sonvs	init gi---NAME---_list[index]
itab_dur	init ftlen(itab_sonvs)/ftsr(itab_sonvs)

ifreq		init 1/itab_dur
aphasor		phasor ifreq

aout		table3 (aphasor+icps)%1, itab_sonvs, 1

ienvvar		init idur/25

if ienv < 1 then
	aout	*= cosseg:a(0, ienv, 1, idur-(ienv*2), 1, ienv, 0)
else
	aout	*= envgen(idur-random:i(0, ienvvar), ienv)
endif

aout	*= $dyn_var

	$channel_mix

	endin

