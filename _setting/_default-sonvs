
gi---NAME---_len		init lenarray(gi---NAME---_list)/gi---NAME---_ch
gi---NAME---_where		init 0

gk---NAME---_off		init .005
gk---NAME---_dur		init 1
gk---NAME---_sonvs		init 1

	instr ---NAME---

Sinstr		init "---NAME---"
idur		divz p3, i(gk---NAME---_dur), 1
idyn		init p4
ienv		init p5
icps		init p6 % i(gkdiv)
ich			init p7

isonvs		i gk---NAME---_sonvs
isonvs		abs isonvs

if isonvs == 0 then
	isonvs random 0, gi---NAME---_len
	prints "I'll play a random sonvs\n"
endif

isonvs		init isonvs%(gi---NAME---_len-1)
imod		init gi---NAME---_ch-1

index		init (isonvs*gi---NAME---_ch)+imod

itab_sonvs	init gi---NAME---_list[index]
itab_dur	init ftlen(itab_sonvs)/sr

if icps < 1 then

	if icps == 0 then
		icps = .8
	endif
	
	ifreq		init 1/itab_dur
	aphasor		phasor ifreq
	aphasor		= (aphasor+(i(gkbeatn)/dec_to_int(icps)))%1

else

	idiv		init icps%i(gkdiv)
	ioff		i gk---NAME---_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	acycle		= (chnget:a("heart_a") * divz(gkdiv, idiv, 1))+ioff
	aphasor		= acycle % 1

endif

aout		table3 aphasor, itab_sonvs, 1

ienvvar		init idur/25

if ienv < 1 then
	aout	*= cosseg:a(0, ienv, 1, idur-(ienv*2), 1, ienv, 0)
else
	aout	*= envgen(idur-random:i(0, ienvvar), ienv)
endif

aout	*= $dyn_var

	$channel_mix

;gi---NAME---_where init (i(gkbeatn)+1)/i(gkdiv)

	endin

