
gi---NAME---_len		init lenarray(gi---NAME---_list)/gi---NAME---_ch
gi---NAME---_where		init 0

gk---NAME---_off		init .005
gk---NAME---_dur		init 1
gk---NAME---_sonvs		init 1

gk---NAME---_jit			init 0
gk---NAME---_ran			init 1

instr ---NAME---_jitter

	gk---NAME---_jit		samphold jitter:k(.005, gkbeatf/16, gkbeatf/32), changed2:k(int(chnget:k("heart") * 64))
	gk---NAME---_ran		samphold pow(int(random:k(1, 4)), int(random:k(1, 2))), changed2:k(int(chnget:k("heart") * 64))
	if active:k("---NAME---") == 0 then
		if timeinstk() > 1 then
			turnoff
		endif
	endif

endin


	instr ---NAME---

Sinstr		init "---NAME---"
idur		divz p3, i(gk---NAME---_dur), 1
idyn		init p4
ienv		init p5
icps		init p6 % i(gkdiv)
ich			init p7

if active:i("---NAME---_jitter") == 0 then
	schedule "---NAME---_jitter", 0, -1
endif

isonvs		i gk---NAME---_sonvs
isonvs		abs isonvs

if isonvs == 0 then
	isonvs random 0, gi---NAME---_len
	prints "I'll play a random sonvs\n"
endif

isonvs		init isonvs%(gi---NAME---_len-1)
index		init (isonvs*gi---NAME---_ch)+gi---NAME---_ch-1

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

aout_n		table3 aphasor, itab_sonvs, 1

;avar 		a portk(gk---NAME---_jit, random:i(.0015, .015)*cosseg(1, p3, 0))
aphasor_bb	= limit(gk---NAME---_jit+aphasor, 0, 1)%(1/gk---NAME---_ran)
aout_bb		table3 aphasor_bb, itab_sonvs, 1

aout_bb		*= table3:a((aphasor*gk---NAME---_ran)%1, gisotrap, 1)

ienvvar		init idur/25

if ienv < 1 then
	aout_n	*= cosseg:a(0, ienv, 1, idur-(ienv*2), 1, ienv, 0)
	aout_bb	*= cosseg:a(0, ienv, 1, idur-(ienv*2), 1, ienv, 0)
else
	aout_n	*= envgen(idur-random:i(0, ienvvar), ienv)
	aout_bb	*= envgen(idur-random:i(0, ienvvar), ienv)
endif

aout_n	*= $dyn_var
aout_bb	*= $dyn_var

aout = aout_n*(1-aphasor_bb) + aout_bb
	$channel_mix

;gi---NAME---_where init (i(gkbeatn)+1)/i(gkdiv)

	endin


