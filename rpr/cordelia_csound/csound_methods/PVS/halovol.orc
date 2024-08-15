
ifft_size   init 4096
ioverlap    init ifft_size / 4

#define window_var #random:i(0, .05)#

indx init 0
until indx == lenarray(gSfiles) do
    ires system_i 1, sprintf("/usr/local/bin/pvanal -n %i -w %i -s %i \"%s\" \"%s.pvx\"", ifft_size, ioverlap, filesr(gSfiles[indx]), gSfiles[indx], gSfiles[indx])
    indx += 1
od

giblack     ftgen 0, 0, 8192, 20, 5
gihanning   ftgen 0, 0, 8192, 20, 2

    instr 1

indx        init p4
ich         init indx + 1 
Spvsanal    sprintf "%s.pvx", gSfiles[indx]

idur        filelen gSfiles[indx]
p3          init idur
kread       linseg 0, p3, idur

kpoint		init -1
kran		randomh 2, 3.5, 5
kmetro		metro kran
kpoint		samphold kread, kmetro

if changed2(kpoint) == 1 then
    schedulek 2, 0, 3.5+random:k(-.05, .05), kpoint, Spvsanal, ich
endif

    endin

    instr 2

ipoint		init p4
Spvsanal    init p5
ich         init p6

kratio		init 1

kpoint		linseg ipoint-$window_var, p3, ipoint+$window_var
aout		pvoc kpoint, kratio, Spvsanal

aenv        table3 phasor:a(1/p3), giblack, 1
aout		*= aenv
    outch	 	ich, aout / 2

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