
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

ktimewarp			= 0
kresample			init icps / ---PITCH---		;do not change pitch
ibeg				init .45		;start at beginning
kwsize 				= sr / 10
iwsize				init sr / 10			;window size in samples with
irandw				init iwsize * (1/4)				;bandwidth of a random number generator
itimemode			init 1					;ktimewarp is "time" pointer
ioverlap			init 8

aout	sndwarp  .5, ktimewarp, kresample, itab_sonvs, ibeg, iwsize, irandw, ioverlap, giasine, itimemode

aout				*= $dyn_var

	$dur_var(10)
	$end_instr
