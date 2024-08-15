; N.B. Path without the last slash / !!!
gSesynth2_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-esynth2"
gkesynth2_jitter init 0

instr esynth2_jitter

gkesynth2_jitter jitter 1, gkbeatf/64, gkbeatf/32

	if active:k("esynth2") == 0 then
		if timeinstk() > 1 then
			turnoff
		endif
	endif

endin




$start_instr(esynth2)

	Sinstr_jitter sprintf "%s_jitter", Sinstr 
	if active:i(Sinstr_jitter) == 0 then
		schedule Sinstr_jitter, 0, -1
	endif

	ipitch_librosa init 179.61
	iratio = icps / ipitch_librosa

	; esynth2-001  to 21

	ijit i gkesynth2_jitter
	inum floor 1+abs((octcps(icps) + ijit) % 1)*31
	if inum < 10 then
		Snum sprintf "00%i", inum
	else
		Snum sprintf "0%i", inum
	endif

	Spath sprintf "%s/esynth2-%s.wav", gSesynth2_path, Snum
	;prints sprintf("%s\n", Spath )
	; MONOOOOOO
	ain diskin Spath, iratio, random:i(0, .005)


	; ADD A CODA (generally samps are short)
	ilen init filelen(Spath)/iratio
	
	acoda init 0
	if idur >= ilen then
/* 		kgrain_freq			init	8
		kgrain_pitch		init	iratio
		kgrain_size			init	16/ilen
		kgrain_pointrate	linseg	1, idur, 0
		igrain_fn			init	gihanning
		igrain_overlaps		init	32/ilen
		igrain_maxsize		init	ilen
		igrain_offset		init	0
		acoda				diskgrain Spath, 1, kgrain_freq, kgrain_pitch, kgrain_size, kgrain_pointrate, igrain_fn, igrain_overlaps, igrain_maxsize , igrain_offset
 */

		iolaps  	init 2
		igr_size 	init ilen/2
		igr_freq	init iolaps/igr_size
		ips     	init 1/iolaps

		istr 		init 1/idur;linseg 1/idur, idur, (1/64)/idur  ; timescale
		ipitch 		init iratio  ; pitchscale
		acoda		diskgrain Spath, 1, igr_freq*cosseg:k(1, idur, 2), ipitch*cosseg:k(1, idur, int(random:i(8, 13))/10), igr_size, -ips*istr, gihanning, iolaps
		;acoda		reverb agrain/2, idur-random:i(0, .005);, ilen*4 
		;acoda		valpass ain/2, idur-random:i(0, .005), ilen/100, idur
		acoda		*= linseg(0, ilen-ilen/4, .35, ilen/4, 1, ilen/4, .5, idur-ilen-(ilen/4)-ilen/4, .15)

	endif

	aout		= (ain + acoda) / 2

	aout moogladder2 aout*$dyn_var, limit(20$k-((1-$dyn_var)*19.5$k)+icps*idyn, 50, 20$k), random:i(0, 1/9)
	$dur_var(10)
$end_instr

