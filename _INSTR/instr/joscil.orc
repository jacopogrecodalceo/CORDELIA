; N.B. Path without the last slash / !!!
gSjoscil_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-joscil"

$start_instr(joscil)

    inote = 69 + 12 * log2(icps / A4)

	irootnote2cps = A4 * pow(2, (inote - 69) / 12)
	iratio = icps / irootnote2cps

	; joscil-01  to 21

	if inote < 10 then
		Snote sprintf "0%i", inote
	else
		Snote sprintf "%i", inote
	endif

	Spath sprintf "%s/joscil-%s.wav", gSjoscil_path, Snote
	;prints sprintf("%s\n", Spath )

	ains[] diskin Spath, iratio, random:i(0, .005)

	ifactor_dyn init 1
	$sample_instr_out
	
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

		iolaps  	init 8
		igr_size 	init ilen/4
		igr_freq	init iolaps/igr_size
		ips     	init 1/iolaps

		istr 		init 1/idur ;linseg 1/idur, idur, (1/64)/idur  ; timescale
		ipitch 		init iratio  ; pitchscale

		a1, a2		diskgrain Spath, 1, igr_freq*(1+oscili:k(1, gkbeatf*4)), ipitch, igr_size, -ips*istr, gihanning, iolaps

		if ich % 2 == 0 then
			acoda = a1
		else
			acoda = a2
		endif
		;acoda		reverb agrain/2, idur-random:i(0, .005);, ilen*4 
		;acoda		valpass ain/2, idur-random:i(0, .005), ilen/100, idur
		acoda		*= linseg(0, ilen-ilen/4, .35, ilen/4, 1, ilen/4, .5, idur-ilen-(ilen/4)-ilen/4, .15)

	endif

	aout		= ain + acoda

	aout moogladder2 aout*$dyn_var, limit(20$k-((1-$dyn_var)*19.5$k)+icps*idyn, 50, 20$k), random:i(0, 1/9)
	$dur_var(10)
$end_instr

