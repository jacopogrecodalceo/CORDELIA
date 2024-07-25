; N.B. Path without the last slash / !!!
gSglock_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-glock"

$start_instr(glock)

	; IF RANGE DYN
		if idyn < ampdbfs(-17) then
			Sdyn init "L1"
		else
			Sdyn init "L2"
		endif

    inote = 69 + 12 * log2(icps / A4)

	; IF IN RANGE:
		if inote <= 55 && inote > 0 then
				irootnote = 53
				Snote_name init "F3"
		elseif inote <= 58 && inote > 55 then
				irootnote = 56
				Snote_name init "G#3"
		elseif inote <= 61 && inote > 58 then
				irootnote = 59
				Snote_name init "B3"
		elseif inote <= 64 && inote > 61 then
				irootnote = 62
				Snote_name init "D4"
		elseif inote <= 67 && inote > 64 then
				irootnote = 65
				Snote_name init "F4"
		elseif inote <= 70 && inote > 67 then
				irootnote = 68
				Snote_name init "G#4"
		elseif inote <= 73 && inote > 70 then
				irootnote = 71
				Snote_name init "B4"
		elseif inote <= 76 && inote > 73 then
				irootnote = 74
				Snote_name init "D5"
		elseif inote <= 127 && inote > 76 then
				irootnote = 80
				Snote_name init "G#5"
		endif


	irootnote2cps = A4 * pow(2, (irootnote - 69) / 12)
	iratio = icps / irootnote2cps
	;/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-glock/DK Glock_Natural_B3_L1_RR3.wav
	Spath sprintf "%s/DK Glock_Natural_%s_%s_RR%i.wav", gSglock_path, Snote_name, Sdyn, int(random:i(1, 5))

	aouts[] diskin Spath, iratio, .115

	aout = aouts[ich-1]
	idyn_base = .5
	idyn_scaled = idyn_base + idyn * (1 - idyn_base)
	aout moogladder2 aout*idyn_scaled, limit(15$k-((1-idyn)*7.5$k)+icps*idyn, 50, 15$k), random:i(0, 1/9)
	aout	*= 3

	$dur_var(10)
$end_instr
