
ipole_ord   init 24

indx init 0
until indx == lenarray(gSfiles) do
	ires system_i 1, sprintf("lpanal -p %i -s %i \"%s\" \"%s.lpc\"", ipole_ord, filesr(gSfiles[indx]), gSfiles[indx], gSfiles[indx])
	indx += 1
od

gihanning   ftgen   0, 0, 8192, 20, 2

	instr 1

; DEFAULTs VALUEs
indx        init p4
ich         init indx + 1 
Slpcanal    sprintf "%s.lpc", gSfiles[indx]
idur        filelen gSfiles[indx]
p3          init idur
kread       linseg 0, idur, idur

krmsr, krmso, kerr, kcps lpread kread, Slpcanal

ktrig metro 15
kdyn = krmsr/1024

if ktrig == 1 && kdyn > .0015 then
	schedulek int(random:k(2, 4)), 0, random:k(.25, 3.5), ich, kdyn, kcps*int(random:k(1, 4))
	schedulek int(random:k(2, 4)), random:k(0, .015), random:k(.25, 3.5), ich, kdyn, kcps*int(random:k(2, 4))
endif

	endin

	instr 2

ich     init p4
kdyn    init p5
icps    init p6
aout    pluck kdyn, icps+jitter(1, .25, 1), icps, 0, 1
;aout oscili kdyn*linseg(0, .005, 1, p3-.005, 0), icps*4

	outch ich, aout
	
	endin

	instr 3

ich     init p4
kdyn    init p5
icps    init p6
;aout    pluck kdyn, icps+jitter(1, .25, 1), icps, 0, 1
aout	oscili kdyn*linseg(0, .005, 1, p3-.005, 0), icps

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