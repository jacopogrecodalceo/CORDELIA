; N.B. Path without the last slash / !!!
gSjoscil4_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-joscil4"

$start_instr(joscil4)

    inote 				init 69 + 12 * log2(icps / A4)

	if inote > 0 && inote <= 12 then
		irootnote init 9
	elseif inote > 12 && inote <= 18 then
		irootnote init 15
	elseif inote > 18 && inote <= 24 then
		irootnote init 21
	elseif inote > 24 && inote <= 30 then
		irootnote init 27
	elseif inote > 30 && inote <= 36 then
		irootnote init 33
	elseif inote > 36 && inote <= 42 then
		irootnote init 39
	elseif inote > 42 && inote <= 48 then
		irootnote init 45
	elseif inote > 48 && inote <= 54 then
		irootnote init 51
	elseif inote > 54 && inote <= 60 then
		irootnote init 57
	elseif inote > 60 && inote <= 66 then
		irootnote init 63
	elseif inote > 66 && inote <= 72 then
		irootnote init 69
	elseif inote > 72 && inote <= 78 then
		irootnote init 75
	elseif inote > 78 && inote <= 84 then
		irootnote init 81
	elseif inote > 84 && inote <= 90 then
		irootnote init 87
	elseif inote > 90 && inote <= 96 then
		irootnote init 93
	elseif inote > 96 && inote <= 102 then
		irootnote init 99
	elseif inote > 102 && inote <= 108 then
		irootnote init 105
	elseif inote > 108 && inote <= 114 then
		irootnote init 111
	elseif inote > 114 && inote <= 120 then
		irootnote init 117
	elseif inote > 120 then
		irootnote init 123
	endif

	irootnote2cps		init A4 * pow(2, (irootnote - 69) / 12)
	iratio				init icps / irootnote2cps

	; joscil4-1  to 21
	Spath sprintf "%s/joscil4-%i.wav", gSjoscil4_path, irootnote

	ains[] diskin Spath, iratio

	ifactor_dyn init 1
	$sample_instr_out
	
	; ADD A CODA (generally samps are short)
	ilen init filelen(Spath)/iratio
	acoda init 0
	if idur >= ilen then

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

