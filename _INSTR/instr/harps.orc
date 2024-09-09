; N.B. Path without the last slash / !!!
gSharps_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-harps"

gSharps_quality init "nasat"

$start_instr(harps)

	Sharps_path sprintf "%s/%s", gSharps_path, gSharps_quality

    inote = 69 + 12 * log2(icps / A4)

	if inote < 28 then
		irootnote init 28
	elseif inote > 88 then
		irootnote init 88
	else
		irootnote init inote
	endif

	irootnote2cps = A4 * pow(2, (irootnote - 69) / 12)
	iratio = icps / irootnote2cps
	;Felt Piano m A6 RR1.wav
	;Felt Piano Release D5.wav
	Spath sprintf "%s/%i.wav", Sharps_path, irootnote

	; RELEASE
	;================================================================
	Spath_release sprintf "%s/Releases/%i.wav", Sharps_path, irootnote
	schedule "harps_release", 0, idur, Spath_release, 1, ich
	;================================================================

	aouts[] diskin Spath, iratio

	aout = aouts[ich-1]*idyn

	;aout moogladder2 aout*idyn_scaled, limit(15$k-((1-idyn)*7.5$k)+icps*idyn, 50, 15$k), random:i(0, 1/9)

	$dur_var(10)
$end_instr

instr harps_release
	Sinstr init "harps"
	Spath init p4
	ilen filelen Spath
	if p3 > ilen then
		p3 init ilen
	endif
	idur init p3
	idyn init p5
	ich init p6
	aenv cosseg idyn, p3-.005, idyn, .005, 0
	aouts[] diskin Spath, 1
	aout = aouts[ich-1]*aenv*3
	$channel_mix
endin
