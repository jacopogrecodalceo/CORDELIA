
ipole_ord   init 24

indx init 0
until indx == lenarray(gSfiles) do
    ires system_i 1, sprintf("lpanal -p %i -s %i \"%s\" \"%s.lpc\"", ipole_ord, filesr(gSfiles[indx]), gSfiles[indx], gSfiles[indx])
    indx += 1
od

gihanning   ftgen   0, 0, 8192, 20, 2

gkcps init 0

    instr 1

isec_gate init 1/4

indx    init p4
ich     init indx + 1
idur    filelen gSfiles[indx]
p3      init idur

kread   linseg 0, idur, idur
krmsr, krmso, kerr, kcps    lpread kread, sprintf("%s.lpc", gSfiles[indx])

gkcps = kcps

kdyn = krmsr/1024

kgate init 1
kndx init 0
if kgate == 0 then
    kndx += ksmps
endif

if kndx > sr*isec_gate then
    kgate = 1
	kndx = 0
endif

imin_dur init 1
imax_dur init 7
#define dur_event #1#

irms    init -23

if kgate == 1 then
    schedulek 2, 0, $dur_event, ich, kdyn
    kgate = 0
endif

    endin

;cordelia, 0.0, .5, 0.0014349407283589244, 0, 38.58064651489258
;cordelia, start, dur, dyn, env, freq

    instr 2

itime times

Sinstr init "cordelia"
idur init p3
ich  init p4
idyn init p5
ienv init 0
icps i gkcps
icps init icps * 2

idone	system_i 1, sprintf("echo \'%s, %f, %f, %f, %i, %f\' >> %s.txt", Sinstr, itime, idur, idyn, ienv, icps, gScsound_score)
    schedule 3, 0, idur, ich, idyn, icps

    turnoff

    endin

    instr 3
ich init p4
kdyn init p5
icps init p6
;aout pluck kdyn, icps+jitter(1, .25, 1), icps, 0, 1
aout oscili kdyn*linseg(0, .005, 1, p3-.005, 0), icps
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