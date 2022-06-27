giflingjm_ft	init giasaw

giringj7_arr[]	genarray 1, ginchnls

gkringj6_port	init 0
gkringj5_port	init 0
gkringhj5_port	init 0

gisigm1		ftgen	0, 0, 257, 9, .5, 1, 270
gisigm2		ftgen	0, 0, 257, 9, .5, 1, 270, 1.5, .35, 90, 2.5, .215, 270, 3.5, .145, 90, 4.5, .115, 270;   1 PARAM OPCODEs

    opcode  abj, 0, SJPo
Sinstr, kp1, kgain, ich xin

if  ich==ginchnls-1 goto next
		abj Sinstr, kp1, kgain, ich+1

next:

;   INIT
if  kp1 ==-1 then
        kp1 = .5
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---OP1
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kp1, kgain, ich xin

kfreq	= kp1

afx	abs ain
afx	balance2 afx, ain

amod	abs lfo:a(1, kfreq/2)

afx	*= (1-amod)
ain	*= amod

aout	sum afx, ain


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  combj, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		combj Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

;krvt -- the reverberation time (defined as the time in seconds for a signal to decay to 1/1000, or 60dB down from its original amplitude).
;xlpt -- variable loop time in seconds, same as ilpt in comb. Loop time can be as large as imaxlpt.
;imaxlpt -- maximum loop time for klpt

imaxlpt	init 5

krvt	= ktime
klpt	= kfb*(imaxlpt/1000)

aout	vcomb ain, krvt/1000, klpt, imaxlpt


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  combj2, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		combj2 Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich

;krvt -- the reverberation time (defined as the time in seconds for a signal to decay to 1/1000, or 60dB down from its original amplitude).
;xlpt -- variable loop time in seconds, same as ilpt in comb. Loop time can be as large as imaxlpt.
;imaxlpt -- maximum loop time for klpt

imaxlpt	init 5

krvt	= ktime/1000
klpt	= kfb*(imaxlpt/1000)

aout	vcomb ain, krvt, klpt, imaxlpt
aout    flanger aout, a(ktime), kfb

	chnmix aout, gSmouth[ich]

    endop


;   2 STRINGS OPCODEs

    opcode  convj, 0, SSJPo
Sin, Sout, kp1, kgain, ich xin

if      ich==ginchnls-1 goto next
		convj Sin, Sout, kp1, kgain, ich+1

next:


;   INPUT
ain		chnget sprintf("%s_%i", Sin, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin, Sout, kp1, kgain, ich

if  kp1==-1 then
        kp1 = 1
endif

aout    cross2 ain, chnget:a(sprintf("%s_%i", Sout, ich+1)), 4096, 8, gihan, kp1



		chnmix aout, gSmouth[ich]

    endop


;   2 STRINGS OPCODEs

    opcode  convj2, 0, SSJPo
Sin, Sout, kp1, kgain, ich xin

if      ich==ginchnls-1 goto next
		convj2 Sin, Sout, kp1, kgain, ich+1

next:


;   INPUT
ain		chnget sprintf("%s_%i", Sin, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin, Sout, kp1, kgain, ich

if  kp1==-1 then
        kp1 = 1
endif

aout    cross2 ain, chnget:a(sprintf("%s_%i", Sout, ich+1)), 4096, 8, gihan, kp1
aout    pdhalf aout/16, -.85
aout    pdhalf aout/16, -.95


		chnmix aout, gSmouth[ich]

    endop


;   2 STRINGS OPCODEs

    opcode  convj3, 0, SSJPo
Sin, Sout, kp1, kgain, ich xin

if      ich==ginchnls-1 goto next
		convj3 Sin, Sout, kp1, kgain, ich+1

next:


;   INPUT
ain		chnget sprintf("%s_%i", Sin, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin, Sout, kp1, kgain, ich

aplus init 0

if  kp1==-1 then
        kp1 = 1
endif

aplus	= ain + (aplus*.85)

aout    cross2 ain, chnget:a(sprintf("%s_%i", Sout, ich+1)), 4096, 8, gihan, kp1
aout    pdhalf aout/16, -.85
aout    pdhalf aout/16, -.95

aplus	= aout


		chnmix aout, gSmouth[ich]

    endop


;   1 PARAM OPCODEs

    opcode  distj1, 0, SJPo
Sinstr, kp1, kgain, ich xin

if  ich==ginchnls-1 goto next
		distj1 Sinstr, kp1, kgain, ich+1

next:

;   INIT
if  kp1 ==-1 then
        kp1 = .5
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---OP1
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kp1, kgain, ich xin

ift     init gisigm1
kdist	= kp1

aout    distort ain, kdist, ift;[, ihp, istor]
aout	balance2 aout, ain


	chnmix aout, gSmouth[ich]

    endop


;   1 PARAM OPCODEs

    opcode  distj2, 0, SJPo
Sinstr, kp1, kgain, ich xin

if  ich==ginchnls-1 goto next
		distj2 Sinstr, kp1, kgain, ich+1

next:

;   INIT
if  kp1 ==-1 then
        kp1 = .5
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---OP1
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kp1, kgain, ich xin

ift     init gisigm2
kdist	= kp1

aout    distort ain, kdist, ift;[, ihp, istor]
aout	balance2 aout, ain


	chnmix aout, gSmouth[ich]

    endop


;   2 STRINGS OPCODEs

    opcode  envfrj, 0, SSJPo
Sin, Sout, kp1, kgain, ich xin

if      ich==ginchnls-1 goto next
		envfrj Sin, Sout, kp1, kgain, ich+1

next:


;   INPUT
ain		chnget sprintf("%s_%i", Sin, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin (ain), Sout, kp1, kgain, ich

idepth  init 512
ires    init .75

if  kp1==-1 then
        kp1 = .5
endif

aflow    follow ain, (ksmps / sr) * 128
aflow    butterlp aflow, 35

avcf    moogvcf ain, aflow*idepth, ires
aenv    balance2 aflow, avcf

kenv    k aenv

idiv    init 32
kchange init (sr / idiv)+1

if kenv>kp1 && kchange > (sr / idiv) then

	kfreq		once fillarray(.5, 2) ;probability of freezing freqs: 1/4
	kamp		once fillarray(0, 1)	
	kchange = 0

	printks2 "envfrj--change %f\n", kfreq

endif

ifftsize       	init 4096
ioverlap	init ifftsize / 4
iwinsize	init ifftsize
iwinshape	init 0

aout   		chnget sprintf("%s_%i", Sout, ich+1)

fftin		pvsanal	aout, ifftsize, ioverlap, iwinsize, iwinshape ;fft-analysis of file
freeze		pvsfreeze fftin, portk(.95+kamp, gkbeats), kfreq ;freeze amps or freqs independently
aout		pvsynth	freeze ;resynthesize

aout   		balance2 aout, aenv

kchange		+= 1




		chnmix aout, gSmouth[ich]

    endop


;   2 STRINGS OPCODEs

    opcode  envj, 0, SSJPo
Sin, Sout, kp1, kgain, ich xin

if      ich==ginchnls-1 goto next
		envj Sin, Sout, kp1, kgain, ich+1

next:


;   INPUT
ain		chnget sprintf("%s_%i", Sin, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin (ain), Sout, kp1, kgain, ich

idepth  init 512
ires    init .75

if  kp1==-1 then
        kp1 = .5
endif

aflow    follow ain, (ksmps / sr) * 128
aflow    butterlp aflow, 35

avcf    moogvcf ain, aflow*idepth, ires
aenv    balance2 aflow, avcf

;aout    oscili 1, kfreq, gitri
aout    chnget sprintf("%s_%i", Sout, ich+1)
aout    balance2 aout, aenv


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingj, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingj Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    = ktime

aout	flanger ain, a(kdel)/1000, kfb


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingj2, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingj2 Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

imaxfb		init .995
kdel        = ktime

a1		flanger ain, a(kdel)/1000, kfb%imaxfb

kdel	*= 2
kfb		*= 2
a2		flanger a1, a(kdel)/1000, kfb%imaxfb

kdel	*= 3
kfb		*= 3
a3		flanger a2, a(kdel)/1000, kfb%imaxfb

aout		= a3


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingj3, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingj3 Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

imaxfb	init .995
kdel        = ktime

a1		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)

kdel	*= 2
kfb		*= 2
a2		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)

kdel	*= 3
kfb		*= 3
a3		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)

aout		sum a1, a2, a3


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingj4, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingj4 Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

imaxfb		init .995
kdel        = ktime

a1		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)
kdel		*= 2
a2		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)
kdel		*= 3
a3		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)
aout		sum a1, a2, a3


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingjagm, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingjagm Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    = ktime
adel	= a(kdel)/1000

aout	flanger ain, adel, kfb, 15

aout	*= kgain


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingjm, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingjm Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    = ktime

aoutf	flanger ain, a(kdel)/1000, kfb

kfreq	= 1/(ktime/1000)
kfreq	limit kfreq, gizero, gkbeatf*4

aoutm	moogladder2 aoutf, 25+oscili:a(7.5$k*kfb, kfreq, giflingjm_ft), limit(.995-kfb, 0, .995)
aoutm	flanger aoutm, a(kdel)/500, kfb

aout	sum aoutf, balance2(aoutm, aoutf)
aout	/= 2




	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingjs, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingjs Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    	= ktime
kdel		+= randomi:k(0, kdel/4, .25/kdel)

aout		flanger ain, a(kdel)/1000, kfb


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingjs2, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingjs2 Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    	= ktime
kdel		+= randomi:k(0, kdel/4, .25/kdel)

aout		flanger ain, a(kdel)/1000/(ich+1), kfb


	chnmix aout, gSmouth[ich]

    endop


;   FREQ DOMAIN OPCODEs

    opcode  foj, 0, SJJPo
Sinstr, kfreq, kq, kgain, ich xin

if      ich==ginchnls-1 goto next
                foj Sinstr, kfreq, kq, kgain, ich+1

next:

;       INIT
if      kfreq==-1 then
                kfreq = ntof("3B")
endif

if  kq==-1 then
        kq = .65
endif

;       LIMIT
kfreq   limit kfreq, 10, 21$k
kq      limit kq, 0, .95

;       INPUT
ain     chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

;xris -- impulse response attack time (secs).
;xdec -- impulse response decay time (secs).

kfreq_var	init 5

kris	= kq
kdec	= 1-kq

kdec	limit kdec, 0, kris*2

aout	fofilter ain, kfreq+randomi:k(-kfreq_var, kfreq_var, .05), kris/1000, kdec/1000


        chnmix aout, gSmouth[ich]

    endop


;   FREQ DOMAIN OPCODEs

    opcode  foj2, 0, SJJPo
Sinstr, kfreq, kq, kgain, ich xin

if      ich==ginchnls-1 goto next
                foj2 Sinstr, kfreq, kq, kgain, ich+1

next:

;       INIT
if      kfreq==-1 then
                kfreq = ntof("3B")
endif

if  kq==-1 then
        kq = .65
endif

;       LIMIT
kfreq   limit kfreq, 10, 21$k
kq      limit kq, 0, .95

;       INPUT
ain     chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

;xris -- impulse response attack time (secs).
;xdec -- impulse response decay time (secs).

ifreq_var	init 5

kris	= kq
kdec	= 1-kq

kdec	limit kdec, 0, kris*2

aout	fofilter ain, kfreq+randomi:k(-ifreq_var, ifreq_var, .05), kris/1000, kdec/1000
aout	fofilter aout, kfreq+randomi:k(-ifreq_var, ifreq_var, .05)*2, kris/500, kdec/500


        chnmix aout, gSmouth[ich]

    endop


;   2 STRINGS OPCODEs

    opcode  folj, 0, SSJPo
Sin, Sout, kp1, kgain, ich xin

if      ich==ginchnls-1 goto next
		folj Sin, Sout, kp1, kgain, ich+1

next:


;   INPUT
ain		chnget sprintf("%s_%i", Sin, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin, Sout, kp1, kgain, ich

if  kp1==-1 then
        kp1 = 0
endif

kp1	/= 1000

aenv    follow2 chnget:a(sprintf("%s_%i", Sout, ich+1)), 5$ms, 25$ms+kp1
aout	balance2 ain, aenv


		chnmix aout, gSmouth[ich]

    endop


;   ANALYSIS DOMAIN OPCODEs

    opcode  frj, 0, SJJjjPo
Sinstr, kpitch, kfb, iwin, ift, kgain, ich xin

if		ich==ginchnls-1 goto next
		frj Sinstr, kpitch, kfb, iwin, ift, kgain, ich+1

next:

;   INIT
if  kpitch==-1 then
        kpitch = 1
endif

if  kfb==-1 then
        kfb = .65
endif

if  iwin==-1 then
        iwin init 11
endif

if  ift==-1 then
        ift init gisine
endif

;   LIMIT
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .95
#end

iwin    limit iwin, 0, 13
iwin    = 2^iwin

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain             *= kgain

;---INSTRUMENT---
;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

kdel        = gkbeats/12

if	kfb!=0 then
	aout	flanger ain, a(kdel)/1000, kfb
else
	aout = ain
endif

ifftsize       	init iwin
ioverlap	init ifftsize / 4
iwinsize	init ifftsize

kamp		= kpitch
kamp		limit kamp, 0, 1
kfreq		= kpitch

fftin		pvsanal	ain, ifftsize, ioverlap, iwinsize, 0
freeze		pvsfreeze fftin, kamp, .5+kfreq ;freeze amps or freqs independently
aout		pvsynth	freeze ;resynthesize

aout 		*= kamp	


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  haasj, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		haasj Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

aout    init 0
kdel	= ktime

aout		vdelay3	ain + (aout*a(kfb)), a(kdel*ich), 5$k


	chnmix aout, gSmouth[ich]

    endop


;   FREQ DOMAIN OPCODEs

    opcode  k35h, 0, SJJPo
Sinstr, kfreq, kq, kgain, ich xin

if      ich==ginchnls-1 goto next
                k35h Sinstr, kfreq, kq, kgain, ich+1

next:

;       INIT
if      kfreq==-1 then
                kfreq = ntof("3B")
endif

if  kq==-1 then
        kq = .65
endif

;       LIMIT
kfreq   limit kfreq, 10, 21$k
kq      limit kq, 0, .95

;       INPUT
ain     chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

;knlp (optional, default=0) -- Non-linear processing method. 0 = no processing, 1 = non-linear processing. Method 1 uses tanh(ksaturation * input). Enabling NLP may increase the overall output of filter above unity and should be compensated for outside of the filter.
;ksaturation (optional, default=1) -- saturation amount to use for non-linear processing. Values > 1 increase the steepness of the NLP curve.

ifreq_var	init 5
inlp        init 1

ksaturn     = kq*1.5

aout	K35_hpf ain, kfreq+randomi:k(-ifreq_var, ifreq_var, .05), kq*10, inlp, ksaturn
aout	balance2 aout, ain


        chnmix aout, gSmouth[ich]

    endop


;   ANALYSIS DOMAIN OPCODEs

    opcode  lofj, 0, SJJjjPo
Sinstr, kpitch, kfb, iwin, ift, kgain, ich xin

if		ich==ginchnls-1 goto next
		lofj Sinstr, kpitch, kfb, iwin, ift, kgain, ich+1

next:

;   INIT
if  kpitch==-1 then
        kpitch = 1
endif

if  kfb==-1 then
        kfb = .65
endif

if  iwin==-1 then
        iwin init 11
endif

if  ift==-1 then
        ift init gisine
endif

;   LIMIT
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .95
#end

iwin    limit iwin, 0, 13
iwin    = 2^iwin

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain             *= kgain

;---INSTRUMENT---
;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

fs1, fsi2	pvsifd		ain, iwin, iwin/4, 1			;ifd analysis
fst		partials	fs1, fsi2, 0.035, 1, 3, 500		;partial tracking
fscl		trshift		fst, kpitch						;frequency shift
aout		tradsyn		fscl, 1, 1, 500, ift			;resynthesis

if kfb > 0 then
	aout	flanger aout, a(gkbeats/12), kfb
endif


		chnmix aout, gSmouth[ich]

    endop


;   FREQ DOMAIN OPCODEs

    opcode  moogj, 0, SJJPo
Sinstr, kfreq, kq, kgain, ich xin

if      ich==ginchnls-1 goto next
                moogj Sinstr, kfreq, kq, kgain, ich+1

next:

;       INIT
if      kfreq==-1 then
                kfreq = ntof("3B")
endif

if  kq==-1 then
        kq = .65
endif

;       LIMIT
kfreq   limit kfreq, 10, 21$k
kq      limit kq, 0, .95

;       INPUT
ain     chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

ifreq_var	init 5

aout	moogladder2 ain, kfreq+randomi:k(-ifreq_var, ifreq_var, .05), kq
aout	balance2 aout, ain


        chnmix aout, gSmouth[ich]

    endop


;   ANALYSIS DOMAIN OPCODEs

    opcode  pitchj, 0, SJJjjPo
Sinstr, kpitch, kfb, iwin, ift, kgain, ich xin

if		ich==ginchnls-1 goto next
		pitchj Sinstr, kpitch, kfb, iwin, ift, kgain, ich+1

next:

;   INIT
if  kpitch==-1 then
        kpitch = 1
endif

if  kfb==-1 then
        kfb = .65
endif

if  iwin==-1 then
        iwin init 11
endif

if  ift==-1 then
        ift init gisine
endif

;   LIMIT
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .95
#end

iwin    limit iwin, 0, 13
iwin    = 2^iwin

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain             *= kgain

;---INSTRUMENT---
;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

kdel        = gkbeats/12

if	kfb!=0 then
	aout	flanger ain, a(kdel)/1000, kfb
else
	aout = ain
endif

fs1, fsi2	pvsifd		aout, iwin, iwin/8, 1			;ifd analysis
fst		partials	fs1, fsi2, 0.035, 1, 3, 256		;partial tracking
aout		resyn		fst, 1, kpitch, 256, ift		;resynthesis (up a 5th)


		chnmix aout, gSmouth[ich]

    endop


;   ANALYSIS DOMAIN OPCODEs

    opcode  pitchj2, 0, SJJjjPo
Sinstr, kpitch, kfb, iwin, ift, kgain, ich xin

if		ich==ginchnls-1 goto next
		pitchj2 Sinstr, kpitch, kfb, iwin, ift, kgain, ich+1

next:

;   INIT
if  kpitch==-1 then
        kpitch = 1
endif

if  kfb==-1 then
        kfb = .65
endif

if  iwin==-1 then
        iwin init 11
endif

if  ift==-1 then
        ift init gisine
endif

;   LIMIT
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .95
#end

iwin    limit iwin, 0, 13
iwin    = 2^iwin

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain             *= kgain

;---INSTRUMENT---
;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

kdel		= gkbeatms/12

aout		vdelay3 ain + (a(kdel)*kfb), a(kdel)/1000, 5000

fs1, fsi2	pvsifd		aout, iwin, iwin/8, 1			; ifd analysis
fst			partials	fs1, fsi2, 0.035, 1, 3, 512		; partial tracking
aout		resyn		fst, 1, kpitch, 512, ift		; resynthesis (up a 5th)


		chnmix aout, gSmouth[ich]

    endop


;   ANALYSIS DOMAIN OPCODEs

    opcode  pitchjdc, 0, SJJjjPo
Sinstr, kpitch, kfb, iwin, ift, kgain, ich xin

if		ich==ginchnls-1 goto next
		pitchjdc Sinstr, kpitch, kfb, iwin, ift, kgain, ich+1

next:

;   INIT
if  kpitch==-1 then
        kpitch = 1
endif

if  kfb==-1 then
        kfb = .65
endif

if  iwin==-1 then
        iwin init 11
endif

if  ift==-1 then
        ift init gisine
endif

;   LIMIT
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .95
#end

iwin    limit iwin, 0, 13
iwin    = 2^iwin

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain             *= kgain

;---INSTRUMENT---
;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

kdel        = gkbeats/12

if	kfb!=0 then
	aout	flanger ain, a(kdel)/1000, kfb
else
	aout = ain
endif

fs1, fsi2	pvsifd		aout, iwin, iwin/8, 1			;ifd analysis
fst		partials	fs1, fsi2, 0.035, 1, 3, 256		;partial tracking
aout		resyn		fst, 1, kpitch, 256, ift		;resynthesis (up a 5th)

aout		dcblock2 aout


		chnmix aout, gSmouth[ich]

    endop


;   1 PARAM OPCODEs

    opcode  powerranger, 0, SJPo
Sinstr, kp1, kgain, ich xin

if  ich==ginchnls-1 goto next
		powerranger Sinstr, kp1, kgain, ich+1

next:

;   INIT
if  kp1 ==-1 then
        kp1 = .5
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---OP1
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kp1, kgain, ich xin

kshape	= kp1

aout	powershape ain, kshape
aout	balance2 aout, ain


	chnmix aout, gSmouth[ich]

    endop


;   ANALYSIS DOMAIN OPCODEs

    opcode  resj, 0, SJJjjPo
Sinstr, kpitch, kfb, iwin, ift, kgain, ich xin

if		ich==ginchnls-1 goto next
		resj Sinstr, kpitch, kfb, iwin, ift, kgain, ich+1

next:

;   INIT
if  kpitch==-1 then
        kpitch = 1
endif

if  kfb==-1 then
        kfb = .65
endif

if  iwin==-1 then
        iwin init 11
endif

if  ift==-1 then
        ift init gisine
endif

;   LIMIT
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .95
#end

iwin    limit iwin, 0, 13
iwin    = 2^iwin

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain             *= kgain

;---INSTRUMENT---
;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

fs1, fsi2	pvsifd		ain, iwin, iwin/4, 1			;ifd analysis
fst			partials	fs1, fsi2, 0.035, 1, 3, 500		;partial tracking
aout		resyn		fst, 1, kpitch, 500, ift		;resynthesis (up a 5th)


		chnmix aout, gSmouth[ich]

    endop


;   FREQ DOMAIN OPCODEs

    opcode  rezj, 0, SJJPo
Sinstr, kfreq, kq, kgain, ich xin

if      ich==ginchnls-1 goto next
                rezj Sinstr, kfreq, kq, kgain, ich+1

next:

;       INIT
if      kfreq==-1 then
                kfreq = ntof("3B")
endif

if  kq==-1 then
        kq = .65
endif

;       LIMIT
kfreq   limit kfreq, 10, 21$k
kq      limit kq, 0, .95

;       INPUT
ain     chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

ifreq_var	init 5

aout	rezzy ain, kfreq+randomi:k(-ifreq_var, ifreq_var, .05), kq*100
aout	balance2 aout, ain


        chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringhj, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringhj Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = giasine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

;		OUT
aout	= ain * tablei:a(andx, ift, 1)


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringhj2, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringhj2 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = giasine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

;	INSTRUMENT
aout	= ain * tablei:a(andx, ift, 1)

;	DELAY
adel    a gkbeats/12 ; it must be in second
aout	flanger aout, adel, kfb


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringhj3, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringhj3 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = giasine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

;	INSTRUMENT
ar_out	= ain * tablei:a(andx, ift, 1)

;	DELAY
adel    a gkbeats/12 ; it must be in second
af_out	flanger ar_out, adel, kfb

aout	sum ar_out, af_out


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringhj4, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringhj4 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = giasine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

ar_out	= ain * tablei:a(andx, ift, 1)

;	DELAY
af_out	flanger ar_out, a(gkbeats/kdiv), kfb

aout	sum ar_out, af_out


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringhj5, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringhj5 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = giasine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

;	INSTRUMENT
ar_out	= ain * tablei:a(andx, ift, 1)

;	DELAY
if gkringhj5_port==0 then
	adel	a gkbeats/kdiv
else
	adel	a portk(gkbeats/kdiv, gkringhj5_port)
endif

af_out	flanger ar_out, adel, kfb

aout	= af_out * tablei:a(andx, ift, 1)


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringhjs, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringhjs Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = giasine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime/pow(2, int(ich/2))
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

;		OUT
aout	= ain * tablei:a(andx, ift, 1)


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringj, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringj Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = giasine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime

aout	= ain * oscili:a(1, kfreq, ift)


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringj2, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringj2 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = giasine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms			= (1/ktime)*(gkbeats/12)

aout	= ain * oscili:a(1, kfreq, ift)

;	DELAY
aout	flanger aout, a(kms), kfb


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringj3, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringj3 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = giasine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms		= (1/ktime)*(gkbeats/12)

ar_out	= ain * oscili:a(1, kfreq, ift)

;	DELAY
af_out	flanger ar_out, a(kms), kfb

igain	init 2

aout	sum ar_out/igain, af_out/igain


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringj5, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringj5 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = giasine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms			= (1/ktime)*(gkbeats/12)

ar_out	= ain * oscili:a(1, kfreq, ift)

if gkringj5_port==0 then
	adel	a kms
else
	adel	a portk(kms, gkringj5_port)
endif

;	DELAY
af_out	flanger ar_out, adel, kfb

aout	= af_out * oscili:a(1, kfreq, ift)


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringj6, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringj6 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = giasine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms			= (1/ktime)*(gkbeats/12)

ar_out	= ain * oscili:a(1, kfreq, ift)

if gkringj6_port==0 then
	adel	a kms
else
	adel	a portk(kms, gkringj6_port)
endif

adel	*= ich

;	DELAY
af_out	flanger ar_out, adel, kfb

aout	= af_out * oscili:a(1, kfreq, ift)


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringj7, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringj7 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = giasine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms			= (1/ktime)*(gkbeats/12)

kndx	= ((chnget:k("heart")*gkdiv/ginchnls))%1
kndx	= (int(kndx*ginchnls)+ich)%ginchnls

;	INSTRUMENT
ar_out	= ain * oscili:a(1, kfreq*giringj7_arr[kndx], ift)

;	DELAY
af_out	flanger ar_out, a(kms), kfb

aout	sum ar_out, af_out


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  shj, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		shj Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

afb     init 0
kdel	= ktime
imaxdel init 5000

;		pre-DELAY
;		vdelay3 works with ms
ad		vdelay3 ain, a(kdel), imaxdel
ad		balance2 ad, ain

afb	 	= ad + (afb * kfb) 

;		REVERB
;		reverb works with s
aout		nreverb ad, kdel$ms, kfb

;		ANAL
kratio		=	kfb*randomi:k(2.25, 2.35, .25)	

ideltime 	=	imaxdel/2

ifftsize 	=	2048
ioverlap 	=	ifftsize / 4 
iwinsize 	=	ifftsize 
iwinshape 	=	1; von-Hann window 

fftin		pvsanal	ad, ifftsize, ioverlap, iwinsize, iwinshape 
fftscale 	pvscale	fftin, kratio, 0, 1 
atrans	 	pvsynth	fftscale 

;		FB
afb 	=	vdelay3(atrans, a(kdel), imaxdel)


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  shjnot, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		shjnot Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

afb     init 0
kdel	= ktime
imaxdel init 5000

;		pre-DELAY
;		vdelay3 works with ms
ad		vdelay3 ain, a(kdel), imaxdel
aout		balance2 ad, ain

afb	 	= aout + (afb * kfb) 


;		ANAL
kratio		=	kfb*randomi:k(2.25, 2.35, .25)	

ideltime 	=	imaxdel/2

ifftsize 	=	1024
ioverlap 	=	ifftsize / 4 
iwinsize 	=	ifftsize 
iwinshape 	=	1; von-Hann window 

fftin		pvsanal	ad, ifftsize, ioverlap, iwinsize, iwinshape 
fftscale 	pvscale	fftin, kratio, 0, 1 
atrans	 	pvsynth	fftscale 

;		FB
afb 	=	vdelay3(atrans, a(kdel), imaxdel)


	chnmix aout, gSmouth[ich]

    endop


;   FREQ DOMAIN OPCODEs

    opcode  stringj, 0, SJJPo
Sinstr, kfreq, kq, kgain, ich xin

if      ich==ginchnls-1 goto next
                stringj Sinstr, kfreq, kq, kgain, ich+1

next:

;       INIT
if      kfreq==-1 then
                kfreq = ntof("3B")
endif

if  kq==-1 then
        kq = .65
endif

;       LIMIT
kfreq   limit kfreq, 10, 21$k
kq      limit kq, 0, .95

;       INPUT
ain     chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

aguid	wguide1 ain, 1/kfreq, kfreq/2, kq

astr1	streson ain, kfreq, kq
astr2	streson ain, kfreq*1.25, kq

aout	sum aguid, astr1, astr2

aout	phaser1 aout, kfreq, 12, kq


        chnmix aout, gSmouth[ich]

    endop


