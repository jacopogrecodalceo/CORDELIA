; ============
; Create as many GENs as channels
; ============
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

ispeed  init 1
isize   init 1024
iord    init ksmps

p3      init idur*ispeed

kport   = .05
kspeed  = 1/ispeed

kis_samphold_freq   init 1
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

kf0			init 0


; ============
; *** OSC1 ***
; ============
kcps1		= kf0
aosc1		oscili 1, portk(kcps1, kport/2)
aosc1		*= a(krms)

; ============
; *** OSC2 ***
; ============
kf1_temp	init 0
kcps2		init 0

if kcps1 != kf1_temp then
	kcps2 = kf1_temp
endif
kf1_temp = kf0

ka1_temp	init 0
kamp2		init 0

if krms != ka1_temp then
	kamp2 = ka1_temp
endif
ka1_temp = krms

aosc2		oscili 1, portk(kcps2, kport)
aosc2		*= a(kamp2)

; ============
; *** OSC3 ***
; ============
kf2_temp	init 0
kcps3		init 0

if kcps2 != kf2_temp then
	kcps3 = kf2_temp
endif
kf2_temp = kf0

ka2_temp	init 0
kamp3		init 0

if kamp2 != ka2_temp then
	kamp3 = ka2_temp
endif
ka2_temp = krms

aosc3		oscili 1, portk(kcps3, kport)
aosc3		*= a(kamp3)


aout		= (aosc1 + aosc2 + aosc3)

kread		+= ksmps*kspeed

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