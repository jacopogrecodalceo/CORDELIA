
gi---NAME---_len		init lenarray(gi---NAME---_list)/gi---NAME---_ch
gi---NAME---_where		init 0

gk---NAME---_off		init .005
gk---NAME---_dur		init 1
gk---NAME---_sonvs		init 1



gi---NAME---_index		init 0;-1/ginchnls


; if you wan tto use a table precostructed
gi---NAME---_index_check_len	init 6
gi---NAME---_index_check		ftgenonce 0, 0, gi---NAME---_index_check_len, -2, 		3, 4, 1, 8, 4

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

index_instr 		floor gi---NAME---_index

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
	; pre constructed table
	;icheck abs floor(tab_i(index_instr%gi---NAME---_index_check_len, gi---NAME---_index_check) * (1+tab_i((index_instr%8)/8, itab_sonvs, 1)))

	; with gktuning
	;giancient_greek_ptolemy_diatonic_ditoniaion ftgen 0, 0, 0, -2, 7, 2/1, A4, 69, 1, 256/243, 32/27, 4/3, 3/2, 128/81, 16/9, 2/1
	icheck_fn init i(gktuning)
	icheck_len tab_i 0, icheck_fn
	icheck abs floor(icheck_len*log2(tab_i(4+(index_instr%(icheck_len-4)), icheck_fn)) * (1+tab_i((index_instr%8)/8, itab_sonvs, 1)))
	print icheck
	print index_instr
	print tab_i(4+(index_instr%(icheck_len-4)), icheck_fn)
	
	
	if index_instr % icheck == 0 then
		ivar init index_instr % 4
		ivar /= 4 + random:i(-1/96, 1/96)
	else
		ivar init 1
	endif
	isize init 4
	ifn_var ftgenonce 0, 0, isize, -2, 1, 1, 1, ivar
	kvar tab int(linseg:k(0, idur, 4)), ifn_var
 
	acycle		= (chnget:a("heart_a") * divz(gkdiv, idiv*kvar, 1)+ioff)
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
	gi---NAME---_index += 1/ginchnls
;gi---NAME---_where init (i(gkbeatn)+1)/i(gkdiv)

	endin

