/*
e.g. 
📩orp is verified.
................................................................
giorp_ch init 2
gSorp_file_1 init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/orp.wav"
giorp_1 ftgen 0, 0, 0, 1, gSorp_file_1, 0, 0, 1
giorp_2 ftgen 0, 0, 0, 1, gSorp_file_1, 0, 0, 2
giorp_list[] fillarray giorp_1, giorp_2

giorp_len		init lenarray(giorp_list)/giorp_ch
giorp_where		init 0

gkorp_off		init .005
gkorp_dur		init 1
gkorp_sonvs		init 1
*/


; how many files are there
gi---NAME---_len			init lenarray(gi---NAME---_list)/gi---NAME---_ch
gi---NAME---_where		init 0

gk---NAME---_off			init .005
gk---NAME---_dur			init 1
gk---NAME---_sonvs		init 1

	instr ---NAME---

Sinstr		init "---NAME---"
idur			abs p3
idyn			init p4
ienv			init p5
icps			init p6
ich			init p7


; isonvs_input_ft is the gen chosen if it's a samples directory case
isonvs_input_ft		i gk---NAME---_sonvs
isonvs_input_ft		abs isonvs_input_ft

if isonvs_input_ft == 0 then
	isonvs_input_ft random 0, gi---NAME---_len
	prints "I'll play a random sonvs\n"
endif

isonvs_input_ft		init isonvs_input_ft%(gi---NAME---_len-1)
isonvs_input_ft_indx	init (isonvs_input_ft*gi---NAME---_ch)+(gi---NAME---_ch-1)
isonvs_ft				init gi---NAME---_list[isonvs_input_ft_indx]
isonvs_ft_dur			init ftlen(isonvs_ft)/sr
isonvs_phase			init (icps%A4)/A4

aread						phasor 1/isonvs_ft_dur, isonvs_phase
aout						table3 aread, isonvs_ft, 1

ienvvar					init idur/25

if ienv < 1 then
	aout	*= cosseg:a(0, ienv, 1, idur-(ienv*2), 1, ienv, 0)
else
	aout	*= envgen(idur-random:i(0, ienvvar), ienv)
endif

aout	*= $dyn_var

	$channel_mix
	endin

