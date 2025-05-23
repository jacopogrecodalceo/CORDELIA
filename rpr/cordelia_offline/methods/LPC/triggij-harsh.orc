
ipole_ord   init 24

indx init 0
until indx == lenarray(gSfiles) do
    ires system_i 1, sprintf("/usr/local/bin/lpanal -p %i -s %i \"%s\" \"%s.lpc\"", ipole_ord, filesr(gSfiles[indx]), gSfiles[indx], gSfiles[indx])
    indx += 1
od

gihanning   ftgen   0, 0, 8192, 20, 2

    instr 1

indx init p4
ich init indx + 1 
Slpcanal sprintf "%s.lpc", gSfiles[indx]

idur filelen gSfiles[indx]
p3  init idur
kread  linseg 0, idur, idur
krmsr, krmso, kerr, kcps lpread kread, Slpcanal

ktrig metro 15
;kdyn = krmso/8192
kdyn = krmsr/1024

idur_note init 5
if ktrig == 1 && kdyn > .005 then
    schedulek 2, 0, idur_note, ich, kdyn, kcps
endif

    endin

    instr 2
ich init p4
kdyn init p5
icps init p6
aout pluck kdyn, icps+jitter(1, .25, 1), icps, 0, 1
;aout oscili kdyn*linseg(0, .005, 1, p3-.005, 0), icps*4
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