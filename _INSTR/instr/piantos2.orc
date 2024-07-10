; N.B. Path without the last slash / !!!
gSpiantos2_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-manthey_klaviano"

$start_instr(piantos2)

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

	Spath sprintf "%s/%i_%s.wav", gSpiantos2_path, iresult, Sdyn

	; RELEASE
	;================================================================
	Spath_release sprintf "%s/%i_%s.wav", gSpiantos2_path, iresult, "r1"
	schedule "piantos2_release", random:i(.125, .135), idur*2, Spath_release, idyn, ich
	;================================================================

	aouts[] diskin Spath, iratio;*isr_correction

	indx init 1
	while indx < 7 do
		/* Sinstr		init "$instr_name"
		idur		init abs(p3)
		idyn		init p4
		ienv		init p5
		icps		init p6
		ich			init p7 */

		idur_oscil init idur * pow(2, indx - 1) / pow(2, 6)
		idyn_oscil init idyn / 2 / pow(2, indx - 1) / indx
		schedule "piantos2_oscil", idur_oscil+random:i(-.05, .05), idur*random:i(.95, 1.05), idyn_oscil, int(ienv)*(-1), icps*indx, ich
		;printf "ionset: %d, idur: %d, idyn: %d, ienv: %d, icps: %d, ich: %d\n", indx, idur*indx/2, idur*random:i(.5, 3/2), idyn/indx, ienv*(-1), icps*indx, ich
		indx += 1
	od

	aout = aouts[ich-1]*$dyn_var

	$dur_var(10)
	$end_instr

instr piantos2_oscil
$params(piantos2)
	p3 init p3+2
	aoscil oscili idyn, cosseg(icps, idur*10/11, icps, idur/11, icps*random:i(.995, .975))

	aoscil *= .75+lfo(.25, random:i(2.5, 3.5)*cosseg(1, idur, .65))*cosseg(0, idur, 1)

	$dur_var(10)
	aoscil *= envgen(idur_var, ienv)
	arev nreverb aoscil, 1, random:i(.35, .85)
	aout = aoscil + arev/3
	$channel_mix
$end_instr


instr piantos2_release
	Sinstr init "piantos2"
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
