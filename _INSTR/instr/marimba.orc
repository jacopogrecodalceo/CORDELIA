; N.B. Path without the last slash / !!!
gSmarimba_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-marimba"

$start_instr(marimba)

	; IF RANGE DYN
		if idyn < ampdbfs(-17) then
			Sdyn init "L1"
		else
			Sdyn init "L2"
		endif

    inote = 69 + 12 * log2(icps / A4)

	; IF IN RANGE:
if inote <= 48 && inote > 0 then
        irootnote = 48
        Sbase_name init "Mar_C5.wav"
elseif inote <= 49 && inote > 48 then
        irootnote = 49
        Sbase_name init "Mar_C#5.wav"
elseif inote <= 50 && inote > 49 then
        irootnote = 50
        Sbase_name init "Mar_D5.wav"
elseif inote <= 51 && inote > 50 then
        irootnote = 51
        Sbase_name init "Mar_D#5.wav"
elseif inote <= 52 && inote > 51 then
        irootnote = 52
        Sbase_name init "Mar_E5.wav"
elseif inote <= 53 && inote > 52 then
        irootnote = 53
        Sbase_name init "Mar_F5.wav"
elseif inote <= 54 && inote > 53 then
        irootnote = 54
        Sbase_name init "Mar_F#5.wav"
elseif inote <= 55 && inote > 54 then
        irootnote = 55
        Sbase_name init "Mar_G5.wav"
elseif inote <= 56 && inote > 55 then
        irootnote = 56
        Sbase_name init "Mar_G#5.wav"
elseif inote <= 57 && inote > 56 then
        irootnote = 57
        Sbase_name init "Mar_A5.wav"
elseif inote <= 58 && inote > 57 then
        irootnote = 58
        Sbase_name init "Mar_A#5.wav"
elseif inote <= 59 && inote > 58 then
        irootnote = 59
        Sbase_name init "Mar_B5.wav"
elseif inote <= 60 && inote > 59 then
        irootnote = 60
        Sbase_name init "Mar_C6.wav"
elseif inote <= 61 && inote > 60 then
        irootnote = 61
        Sbase_name init "Mar_C#6.wav"
elseif inote <= 62 && inote > 61 then
        irootnote = 62
        Sbase_name init "Mar_D6.wav"
elseif inote <= 63 && inote > 62 then
        irootnote = 63
        Sbase_name init "Mar_D#6.wav"
elseif inote <= 64 && inote > 63 then
        irootnote = 64
        Sbase_name init "Mar_E6.wav"
elseif inote <= 65 && inote > 64 then
        irootnote = 65
        Sbase_name init "Mar_F6.wav"
elseif inote <= 66 && inote > 65 then
        irootnote = 66
        Sbase_name init "Mar_F#6.wav"
elseif inote <= 67 && inote > 66 then
        irootnote = 67
        Sbase_name init "Mar_G6.wav"
elseif inote <= 68 && inote > 67 then
        irootnote = 68
        Sbase_name init "Mar_G#6.wav"
elseif inote <= 69 && inote > 68 then
        irootnote = 69
        Sbase_name init "Mar_A6.wav"
elseif inote <= 70 && inote > 69 then
        irootnote = 70
        Sbase_name init "Mar_A#6.wav"
elseif inote <= 71 && inote > 70 then
        irootnote = 71
        Sbase_name init "Mar_B6.wav"
elseif inote <= 72 && inote > 71 then
        irootnote = 72
        Sbase_name init "Mar_C7.wav"
elseif inote <= 73 && inote > 72 then
        irootnote = 73
        Sbase_name init "Mar_C#7.wav"
elseif inote <= 74 && inote > 73 then
        irootnote = 74
        Sbase_name init "Mar_D7.wav"
elseif inote <= 75 && inote > 74 then
        irootnote = 75
        Sbase_name init "Mar_D#7.wav"
elseif inote <= 76 && inote > 75 then
        irootnote = 76
        Sbase_name init "Mar_E7.wav"
elseif inote <= 77 && inote > 76 then
        irootnote = 77
        Sbase_name init "Mar_F7.wav"
elseif inote <= 78 && inote > 77 then
        irootnote = 78
        Sbase_name init "Mar_F#7.wav"
elseif inote <= 79 && inote > 78 then
        irootnote = 79
        Sbase_name init "Mar_G7.wav"
elseif inote <= 80 && inote > 79 then
        irootnote = 80
        Sbase_name init "Mar_G#7.wav"
elseif inote <= 81 && inote > 80 then
        irootnote = 81
        Sbase_name init "Mar_A7.wav"
elseif inote <= 82 && inote > 81 then
        irootnote = 82
        Sbase_name init "Mar_A#7.wav"
elseif inote <= 83 && inote > 82 then
        irootnote = 83
        Sbase_name init "Mar_B7.wav"
elseif inote <= 84 && inote > 83 then
        irootnote = 84
        Sbase_name init "Mar_C8.wav"
elseif inote <= 85 && inote > 84 then
        irootnote = 85
        Sbase_name init "Mar_C#8.wav"
elseif inote <= 86 && inote > 85 then
        irootnote = 86
        Sbase_name init "Mar_D8.wav"
elseif inote <= 87 && inote > 86 then
        irootnote = 87
        Sbase_name init "Mar_D#8.wav"
elseif inote <= 88 && inote > 87 then
        irootnote = 88
        Sbase_name init "Mar_E8.wav"
elseif inote <= 89 && inote > 88 then
        irootnote = 89
        Sbase_name init "Mar_F8.wav"
elseif inote <= 90 && inote > 89 then
        irootnote = 90
        Sbase_name init "Mar_F#8.wav"
elseif inote <= 91 && inote > 90 then
        irootnote = 91
        Sbase_name init "Mar_G8.wav"
elseif inote <= 92 && inote > 91 then
        irootnote = 92
        Sbase_name init "Mar_G#8.wav"
elseif inote <= 93 && inote > 92 then
        irootnote = 93
        Sbase_name init "Mar_A8.wav"
elseif inote <= 94 && inote > 93 then
        irootnote = 94
        Sbase_name init "Mar_A#8.wav"
elseif inote <= 127 && inote > 94 then
        irootnote = 96
        Sbase_name init "Mar_B8.wav"
endif

	irootnote2cps = A4 * pow(2, (irootnote - 69) / 12)
	iratio = icps / irootnote2cps
	
	;/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-marimba/DK marimba_Natural_B3_L1_RR3.wav
	Spath sprintf "%s/%s", gSmarimba_path, Sbase_name

	aouts[] diskin Spath, iratio, .115

	aout = aouts[ich-1]
	idyn_base = .5
	idyn_scaled = idyn_base + idyn * (1 - idyn_base)
	aout moogladder2 aout*idyn_scaled, limit(15$k-((1-idyn)*7.5$k)+icps*idyn, 50, 15$k), random:i(0, 1/9)
	aout	*= 3

	$dur_var(10)
$end_instr
