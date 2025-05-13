/*
_fi is inspired by the work I did with lilypond and abjad.
The origin of the name has no special ideas.. Sorry me!
It focus on exploring only the part of the sample.
The original instrument is below.
*/

/*
	instr fifi

idur	init abs(p3)
idyn	init p4
ienv	init p5
icps 	init p6
ich		init p7

Spath init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm1.wav"
ilen filelen Spath
aouts[] 		diskin Spath, 1+((icps-20)/(20000-20)), (icps*1000+times:i()/1000) % ilen, 1
aout		 	= aouts[ich-1]*idyn*2
aout			*= linseg:a(0, .005, 1, idur/2, 1/8, (idur-.005)/2, 0)
aout			*=	giDYN
	outch ich, aout

	endin
*/

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

isonvs				i gk---NAME---_sonvs-1
isonvs				init isonvs%(gi---NAME---_len-1)
imod				init gi---NAME---_ch-1

index				init (isonvs*gi---NAME---_ch)+imod

itab_sonvs			init gi---NAME---_list[index]
itab_dur			init ftlen(itab_sonvs)/ftsr(itab_sonvs)

; JITTER
; mostly for stereo and multichannels
ijit_cps			random -.005, .005
ijit_phase			random -.005, .005

; this value is to normalise cps to 0. and 1.
; e.g.
; (440-20) / (20000-20) = 0.02102102102
; (4000-20) / (20000-20) = 0,1991991992

inorm_cps			init (icps-20+ijit_cps) / (20000-20+ijit_cps) / 100
inorm_phase			init ((icps + ijit_phase) / 1000) % 1

aphasor				phasor (1 / itab_dur) + inorm_cps, inorm_phase
aout				table3 aphasor, itab_sonvs, 1
aout				*= idyn

	$end_instr

