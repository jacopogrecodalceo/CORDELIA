; N.B. Path without the last slash / !!!
gSpianto_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-manthey_klaviano"

$start_instr(pianto)

	if 			idyn < ampdbfs(-27) then
		Sdyn init "pp1"
	elseif		idyn < ampdbfs(-23) then
		Sdyn init "p2"
	elseif		idyn < ampdbfs(-15) then
		Sdyn init "p1"
	elseif		idyn < ampdbfs(-12) then
		Sdyn init "mf1"
	elseif		idyn < ampdbfs(-10) then
		Sdyn init "mf2"
	elseif		idyn < ampdbfs(-7) then
		Sdyn init "f1"
	else
		Sdyn init "f2"
	endif

    inote = 69 + 12 * log2(icps / A4)

    irange = 2.5    ; Define the range for nearest multiple of 5

    ; Find the nearest multiple of 5
    inear = round(inote / 5) * 5

    ; Check if iinput is within the range of the nearest multiple of 5
    if abs(inote - inear) <= irange then
        iresult = inear
    else
        ; If not, determine the closer multiple
        if inote < inear then
            iresult = inear - 5
        else
            iresult = inear + 5
        endif
    endif


    icps_note = A4 * pow(2, (iresult - 69) / 12)

    iratio = icps / icps_note

	; RELEASE
	;================================================================
	Spath_release sprintf "%s/%i_%s.wav", gSpianto_path, iresult, "r1"
	schedule "pianto_release", random:i(.125, .135), idur*2, Spath_release, idyn, ich
	;================================================================

	Spath sprintf "%s/%i_%s.wav", gSpianto_path, iresult, Sdyn
	aouts[] diskin Spath, iratio

	/*
	aoscil_1 oscili idyn, icps
	aoscil_2 oscili idyn*cosseg(0, p3/2, 1, p3/2, 0), icps*2
	aoscil_3 oscili idyn*cosseg(0, p3*3/2, 1, p3/3, 0), icps*3

	aout = aouts[ich-1]+aoscil_1+aoscil_2+aoscil_3;*aenv
	*/

	aout = aouts[ich-1]*$dyn_var

	$dur_var(10)
	$end_instr

instr pianto_release
	Sinstr init "pianto"
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
	aout = aouts[ich-1]*aenv
	$channel_mix
endin
