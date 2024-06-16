; N.B. Path without the last slash / !!!
gSmusic_box_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-music_box"
gimusic_box_index init 0

gimusic_max_num_for_recharge init 48
gimusic_max_num_for_comingback init 0

instr music_box
	$params(music_box_instrument)

	irecharge_active active "music_box_recharge", 0, 1

	if irecharge_active == 0 then
		if gimusic_box_index > gimusic_max_num_for_recharge then
			schedule "music_box_recharge", 0, 1, idyn, ich
			turnoff2_i nstrnum("music_box_noise"), 0, 1
		else
			schedule Sinstr, 0, idur, idyn, ienv, icps, ich
		endif
	endif

	gimusic_max_num_for_comingback random gimusic_max_num_for_recharge+nchnls, gimusic_max_num_for_recharge+nchnls*4

	turnoff

endin

instr music_box_instrument
	$params(music_box)

	inoise_active active "music_box_noise"
	if inoise_active == 0  && gimusic_box_index < gimusic_max_num_for_recharge then
		schedule "music_box_noise", 0, idur*8, ich
	endif

	; NO SAMPLE FOR DYN
	inote = int(69 + 12 * log2(icps / A4))
	; IF IN RANGE:
		if inote <= 53 && inote > 0 then
				irootnote = 49
				Snote_name init "C#3"
		elseif inote <= 55 && inote > 53 then
				irootnote = 54
				Snote_name init "F#3"
		elseif inote <= 60 && inote > 55 then
				irootnote = 56
				Snote_name init "G#3"
		elseif inote <= 63 && inote > 60 then
				irootnote = 61
				Snote_name init "C#4"
		elseif inote <= 64 && inote > 63 then
				irootnote = 64
				Snote_name init "E4"
		elseif inote <= 65 && inote > 64 then
				irootnote = 65
				Snote_name init "F4"
		elseif inote <= 66 && inote > 65 then
				irootnote = 66
				Snote_name init "F#4"
		elseif inote <= 67 && inote > 66 then
				irootnote = 67
				Snote_name init "G4"
		elseif inote <= 69 && inote > 67 then
				irootnote = 68
				Snote_name init "G#4"
		elseif inote <= 127 && inote > 69 then
				irootnote = 72
				Snote_name init "C5"
		endif

	irootnote2cps = A4 * pow(2, (irootnote - 69) / 12)
	iratio = icps / irootnote2cps
	;/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-music_box/Breitler_Musicbox_E4.wav
	Spath sprintf "%s/Breitler_Musicbox_%s.wav", gSmusic_box_path, Snote_name

	aouts[] diskin Spath, iratio
	
	aout = aouts[ich-1]
	idyn_base = .35
	idyn_scaled = idyn_base + idyn * (1 - idyn_base)
	aout moogladder2 aout*idyn_scaled, limit(15$k-((1-idyn)*7.5$k)+icps*idyn, 50, 15$k), random:i(0, 1/9)
	gimusic_box_index += 1

	$dur_var(10)
$end_instr

instr music_box_recharge
	Sinstr init "music_box"
	idyn init p4
	ich init p5

	Spath sprintf "%s/Breitler_Wind_Spring_%i.wav", gSmusic_box_path, int(random:i(1, 7))
	ilen filelen Spath
	p3 init ilen/2

	itime_rel init ilen/2
				xtratim itime_rel
	krel        init 0
	krel        release

	if krel == 0 then
		kenv cosseg 0, .05, 1
	else
		kenv cosseg 1, itime_rel-.05, 1, .05, 0
	endif

	aouts[] diskin Spath, 1+random:i(-.05, .05)

	idyn_base = .75
	idyn_scaled = idyn_base + idyn * (1 - idyn_base)

	aout = kenv*aouts[ich-1]*idyn_scaled

	gimusic_box_index += 1

	if gimusic_box_index > gimusic_max_num_for_comingback then
		gimusic_box_index init 0
		turnoff
	endif

	$channel_mix
endin

instr music_box_noise
	Sinstr init "music_box"
	ich init p4
	iloop init 1
	Spath sprintf "%s/Breitler_Mechanical_Noise.wav", gSmusic_box_path

	itime_rel init .05
				xtratim itime_rel
	krel        init 0
	krel        release

	if krel == 0 then
		kenv cosseg 0, .05, 1
	else
		kenv cosseg 1, itime_rel, 0
	endif

	aouts[] diskin Spath, 1+random:i(-.05, .05), random:i(0, .125), iloop
	aout = kenv*aouts[ich-1]/16
	$channel_mix
endin
