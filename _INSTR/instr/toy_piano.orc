; N.B. Path without the last slash / !!!
gStoy_piano_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-toy_piano"

$start_instr(toy_piano)

	; NO SAMPLE FOR DYN
	inote = int(69 + 12 * log2(icps / A4))
	; IF IN RANGE:
		if  inote == 0 || inote == 12 || inote == 24 || inote == 36 || inote == 48 || inote == 60 || inote == 72 || inote == 84 || inote == 96 || inote == 108 || inote == 120 then
				irootnote = 48
				Snote_name init "3C"
		elseif inote == 1 || inote == 13 || inote == 25 || inote == 37 || inote == 49 || inote == 61 || inote == 73 || inote == 85 || inote == 97 || inote == 109 || inote == 121 then
				irootnote = 49
				Snote_name init "3C#"
		elseif inote == 2 || inote == 14 || inote == 26 || inote == 38 || inote == 50 || inote == 62 || inote == 74 || inote == 86 || inote == 98 || inote == 110 || inote == 122 then
				irootnote = 50
				Snote_name init "3D"
		elseif inote == 3 || inote == 15 || inote == 27 || inote == 39 || inote == 51 || inote == 63 || inote == 75 || inote == 87 || inote == 99 || inote == 111 || inote == 123 then
				irootnote = 51
				Snote_name init "3D#"
		elseif inote == 4 || inote == 16 || inote == 28 || inote == 40 || inote == 52 || inote == 64 || inote == 76 || inote == 88 || inote == 100 || inote == 112 || inote == 124 then
				irootnote = 52
				Snote_name init "3E"
		elseif inote == 5 || inote == 17 || inote == 29 || inote == 41 || inote == 53 || inote == 65 || inote == 77 || inote == 89 || inote == 101 || inote == 113 || inote == 125 then
				irootnote = 53
				Snote_name init "3F"
		elseif inote == 6 || inote == 18 || inote == 30 || inote == 42 || inote == 54 || inote == 66 || inote == 78 || inote == 90 || inote == 102 || inote == 114 || inote == 126 then
				irootnote = 54
				Snote_name init "3F#"
		elseif inote == 7 || inote == 19 || inote == 31 || inote == 43 || inote == 55 || inote == 67 || inote == 79 || inote == 91 || inote == 103 || inote == 115 || inote == 127 then
				irootnote = 55
				Snote_name init "3G"
		elseif inote == 8 || inote == 20 || inote == 32 || inote == 44 || inote == 56 || inote == 68 || inote == 80 || inote == 92 || inote == 104 || inote == 116 then
				irootnote = 56
				Snote_name init "3G#"
		elseif inote == 9 || inote == 21 || inote == 33 || inote == 45 || inote == 57 || inote == 69 || inote == 81 || inote == 93 || inote == 105 || inote == 117 then
				irootnote = 57
				Snote_name init "3A"
		elseif inote == 10 || inote == 22 || inote == 34 || inote == 46 || inote == 58 || inote == 70 || inote == 82 || inote == 94 || inote == 106 || inote == 118 then
				irootnote = 58
				Snote_name init "3A#"
		elseif inote == 11 || inote == 23 || inote == 35 || inote == 47 || inote == 59 || inote == 71 || inote == 83 || inote == 95 || inote == 107 || inote == 119 then
				irootnote = 59
				Snote_name init "3B"
		elseif inote == 0 || inote == 12 || inote == 24 || inote == 36 || inote == 48 || inote == 60 || inote == 72 || inote == 84 || inote == 96 || inote == 108 || inote == 120 then
				irootnote = 60
				Snote_name init "4C"
		elseif inote == 1 || inote == 13 || inote == 25 || inote == 37 || inote == 49 || inote == 61 || inote == 73 || inote == 85 || inote == 97 || inote == 109 || inote == 121 then
				irootnote = 61
				Snote_name init "4C#"
		elseif inote == 2 || inote == 14 || inote == 26 || inote == 38 || inote == 50 || inote == 62 || inote == 74 || inote == 86 || inote == 98 || inote == 110 || inote == 122 then
				irootnote = 62
				Snote_name init "4D"
		elseif inote == 3 || inote == 15 || inote == 27 || inote == 39 || inote == 51 || inote == 63 || inote == 75 || inote == 87 || inote == 99 || inote == 111 || inote == 123 then
				irootnote = 63
				Snote_name init "4D#"
		elseif inote == 4 || inote == 16 || inote == 28 || inote == 40 || inote == 52 || inote == 64 || inote == 76 || inote == 88 || inote == 100 || inote == 112 || inote == 124 then
				irootnote = 64
				Snote_name init "4E"
		elseif inote == 5 || inote == 17 || inote == 29 || inote == 41 || inote == 53 || inote == 65 || inote == 77 || inote == 89 || inote == 101 || inote == 113 || inote == 125 then
				irootnote = 65
				Snote_name init "4F"
		endif

	irootnote2cps = A4 * pow(2, (irootnote - 69) / 12)
	iratio = icps / irootnote2cps
	;/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-toy/Release_3A.wav
	;/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-toy/3A.wav
	Spath sprintf "%s/%s.wav", gStoy_piano_path, Snote_name

	; RELEASE
	;================================================================
	Spath_release sprintf "%s/Release_%s.wav", gStoy_piano_path, Snote_name
	schedule "toy_piano_release", 0, idur*2, Spath_release, idyn/4, ich
	;================================================================

	ains[] diskin Spath, iratio
	
	ifactor_dyn init 1
	$sample_instr_out
	aout = ain

	idyn_base = .35
	idyn_scaled = idyn_base + idyn * (1 - idyn_base)
	aout moogladder2 aout*idyn_scaled, limit(15$k-((1-idyn)*11.5$k)+icps*idyn, 50, 15$k), random:i(0, 1/9)
	$dur_var(10)
$end_instr


instr toy_piano_release
	Sinstr init "toy_piano"
	Spath init p4
	ilen filelen Spath
	if p3 > ilen then
			p3 init ilen
	endif
	idyn init p5
	ich init p6

	aenv cosseg idyn, p3-.005, idyn, .005, 0
	ains[] diskin Spath, 1

	ifactor_dyn init 1
	$sample_instr_out
	aout = ain*aenv

	$channel_mix
endin
