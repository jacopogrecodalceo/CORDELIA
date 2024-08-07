ich     filenchnls gSfile
indx    init 0
until indx == ich do
    inum init indx + 1
    itab ftgen inum, 0, 0, 1, gSfile, 0, 0, inum
    indx += 1
od

gihanning   ftgen   0, 0, 8192, 20, 2

        instr 1

ich     init p4
idur    init ftlen(ich)/sr

ispeed  init 8
isize   init 8192
iord    init ksmps

iamp	init 1/ispeed

p3      init idur*ispeed

kport   = .05
kspeed  = 1/ispeed

kis_samphold_freq   init 0
kfreq_samphold       = 8

kread   init 0

kcfs[], krms, kerr, kf0 lpcanal kread, 1, ich, isize, iord, gihanning

if kis_samphold_freq == 1 then
    ;kflag init 1
    ;kflag_var jitter 1, 1/12, 1/3
    kflag       metro kfreq_samphold
    kf0         samphold kf0, kflag
endif

ibandwidth ntof "5B"

if (kf0 > ibandwidth * 8) then
    kf0 /= 64
elseif (kf0 > ibandwidth * 4) then
    kf0 /= 32
elseif (kf0 > ibandwidth * 2) then
    kf0 /= 16
elseif (kf0 > ibandwidth) then
    kf0 /= 8
; Add more conditions as needed
; elseif (kf0 > ibandwidth * 16) then
;     kf0 /= 32
; elseif (kf0 > ibandwidth * 32) then
;     kf0 /= 64
; ...
endif

kf0         init 0
kf_temp     init 0
kf0_last    init 0

if kf0 != kf_temp then
    kf0_last = kf_temp
endif
kf_temp = kf0

kn_harm             = sr/(kf0*4)

amain       fractalnoise iamp, 1
aout        allpole amain*krms*kerr, kcfs

kread      += ksmps*kspeed  

if kread > ftlen(ich) then
    kread = 0
endif 

        outch ich, aout

        endin

;---SCORE---
/* 
for i in range(1):
	code = [
		'i1',
		0,			# p2: when
		1,			# p3: dur
		ch			# p4
	]
	score.append(' '.join(map(str, code)))
*/
