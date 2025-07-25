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
		irootnote int inote
	endif

	irootnote2cps = A4 * pow(2, (irootnote - 69) / 12)
	iratio = icps / irootnote2cps
	print irootnote2cps
	print iratio
	print icps
	print irootnote
	;Felt Piano m A6 RR1.wav
	;Felt Piano Release D5.wav
	Spath sprintf "%s/%i.wav", Sharps_path, irootnote

	; RELEASE
	;================================================================
	Spath_release sprintf "%s/Releases/%i.wav", Sharps_path, irootnote
	schedule "harps_release", 0, idur, Spath_release, 1, ich
	;================================================================

	ains[] diskin Spath, iratio
	ifactor_dyn init 12
	$sample_instr_out
	aout = ain

	;aout moogladder2 aout*idyn_scaled, limit(15$k-((1-idyn)*7.5$k)+icps*idyn, 50, 15$k), random:i(0, 1/9)

	$dur_var(10)
$end_instr

instr harps_release

	Sinstr 	init "harps"
	Spath init p4
	ilen filelen Spath
	if p3 > ilen then
		p3 init ilen
	endif
	idur init p3
	idyn init p5
	ich init p6
	aenv cosseg 0, .05, 1, idur-.05*2, 1, .05, 0
	ains[] diskin Spath, 1;, iskiptime/1000
	ifactor_dyn init 1
	$sample_instr_out
	aout = ain
	$channel_mix
	
endin
