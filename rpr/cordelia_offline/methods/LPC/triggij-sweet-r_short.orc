
iPOLE_ORD       init 24     ;max 50
iHOPSIZE        init 200    ;max 500
iLOWEST_FREQ    init 70
iHIGHEST_FREQ   init 200
;-p     npoles, number of poles for analysis. The default is 34, the maximum 50.
;-h     hopsize -- hop size (in samples) between frames of analysis. This determines the number of frames per second (srate / hopsize) in the output control file. The analysis framesize is hopsize * 2 samples. The default is 200, the maximum 500.
;-Q     maxcps, highest frequency (in Hz) of pitch tracking. The narrower the pitch range, the more accurate the pitch estimate. The defaults are -P70, -Q200.

indx init 0
until indx == lenarray(gSfiles) do
    ires system_i 1, sprintf("/usr/local/bin/lpanal -s%i -p%i -h%i -P%i -Q%i \"%s\" \"%s.lpc\"", \
                            filesr(gSfiles[indx]), iPOLE_ORD, iHOPSIZE, iLOWEST_FREQ, iHIGHEST_FREQ, gSfiles[indx], gSfiles[indx])
    indx += 1
od

gihanning   ftgen 0, 0, 8192, 20, 2

    instr 1

indx        init p4
ich         init indx + 1 
Slpcanal    sprintf "%s.lpc", gSfiles[indx]

idur        filelen gSfiles[indx]
p3          init idur
kread       linseg 0, idur, idur

krmsr, krmso, kerr, kcps lpread kread, Slpcanal

ithreshold  ampdb -24
kdyn        = krmsr/1024

if kdyn > ithreshold then
    kdur    = random:k(.125, .5)
    kcps    = kcps*pow(2, int(random:k(2, 4)))
    schedulek 2, 0, kdur, ich, kdyn, kcps
endif

    endin

    instr 2
ich init p4
kdyn init p5
kcps init p6
;aout pluck kdyn, kcps+jitter(1, .25, 1)*4, kcps*4, 0, 1
aout oscili kdyn*linseg:a(0, .005, 1, p3-.005, 0), kcps
    outch ich, aout
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