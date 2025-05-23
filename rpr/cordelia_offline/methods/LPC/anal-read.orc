iPOLE_ORD       init 24     ; npoles, number of poles for analysis. The default is 34, the maximum 50.
iHOPSIZE        init 250    ; hopsize -- hop size (in samples) between frames of analysis. This determines the number of frames per second (srate / hopsize) in the output control file. The analysis framesize is hopsize * 2 samples. The default is 200, the maximum 500.
iLOWEST_FREQ    init 20     ; lowest frequency (in Hz) of pitch tracking. -P0 means no pitch tracking 
iHIGHEST_FREQ   init 15000   ; maxcps, highest frequency (in Hz) of pitch tracking. The narrower the pitch range, the more accurate the pitch estimate. The defaults are -P70, -Q200.

indx init 0
iPOLE_FILTER    init 1      ;generate a pole filter file - WARNING, more dangerous
until indx == lenarray(gSfiles) do
    if iPOLE_FILTER == 0 then
        ires system_i 1, sprintf("/usr/local/bin/lpanal -s%i -p%i -h%i -P%i -Q%i \"%s\" \"%s.lpc\"", \
                        filesr(gSfiles[indx]), iPOLE_ORD, iHOPSIZE, iLOWEST_FREQ, iHIGHEST_FREQ, gSfiles[indx], gSfiles[indx])
    else
        ires system_i 1, sprintf("/usr/local/bin/lpanal -a -s%i -p%i -h%i -P%i -Q%i \"%s\" \"%s.lpc\"", \
                        filesr(gSfiles[indx]), iPOLE_ORD, iHOPSIZE, iLOWEST_FREQ, iHIGHEST_FREQ, gSfiles[indx], gSfiles[indx])
    endif
    indx += 1
od

gihanning       ftgen   0, 0, 8192, 20, 2
gisaw			ftgen	0, 0, 8192, 7, 1, 8192, -1
gisine			ftgen	0, 0, 8192, 10, 1

    instr 1

indx        init p4
ich         init indx + 1 
Slpcanal    sprintf "%s.lpc", gSfiles[indx]

idur        filelen gSfiles[indx]
p3          init idur
kread       linseg 0, idur, idur

krmsr, krmso, kerr, kcps lpread kread, Slpcanal

krmso       /= pow(2, 15)
aout        buzz krmso, kcps, int(sr/2/kcps), gisine

krmsr       /= pow(2, 14)
asig        rand krmsr

    outch ich, (aout*2)+asig

    endin

;---SCORE---
/* 
for i in range(1):
	code = [
		'i1',
		0,			# p2: when
		1,			# p3: dur
        ch          # p4
	]
	score.append(' '.join(map(str, code)))
*/