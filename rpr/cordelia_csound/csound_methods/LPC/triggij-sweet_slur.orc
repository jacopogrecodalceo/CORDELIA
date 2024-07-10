
gSlpanal_path   init "/usr/local/bin/lpanal"
giTHRESHOLD		init -24
giPOLE_ORDER	init 24

indx init 0
until indx == lenarray(gSfiles) do
	ires system_i 1, sprintf("%s -p %i -s %i \"%s\" \"%s.lpc\"", gSlpanal_path, giPOLE_ORDER, filesr(gSfiles[indx]), gSfiles[indx], gSfiles[indx])
	indx += 1
od

instr 1

	indx        init p4
	ich         init indx + 1 
	Slpcanal    sprintf "%s.lpc", gSfiles[indx]

	idur        filelen gSfiles[indx]
	p3          init idur
	kread       linseg 0, idur, idur
	krmsr, krmso, kerr, kcps lpread kread, Slpcanal

	kdyn = krmsr/1024

	if kdyn > ampdbfs(giTHRESHOLD) then
		schedulek 2 + ich/10, 0, -random:k(2, 5), kdyn, kcps, ich
	endif

endin

instr 2

	idur	abs p3
	kdyn	init p4
	kcps	init p5
	ich		init p6

	itie	tival
	iport	init idur/24
	until iport < idur do
		iport /= 2
	od

	iatk	init .005

	iphase init -1
	ktime init 0

	tigoto SKIP_INIT
		; if it is tied note skip this
		iphase init 0
		icps_last init icps
		idyn_last init idyn

	SKIP_INIT:
	if itie == 0 then
		;prints "TIED: INITIAL NOTE\n"
		aenv	cosseg 0, iatk, idyn
		kcps	init icps
		kvib	cosseg 0, idur, 1

	elseif itie == 1 then
		;prints "TIED: MIDDLE NOTE\n"
		aenv	cosseg idyn_last, iport, idyn
		kcps	cosseg icps_last, iport, icps
		kvib	= oscili(1, portk(cosseg:k(0, idur/2, 1)*kcps/250, iport*2, icps_last/250), gisine, iphase)
		icps_last init icps
		idyn_last init idyn
	endif

	ktime timeinsts
	if ktime > idur then
		turnoff2 p1, 4, 1
	endif

	irel_time init idur/6

		xtratim irel_time
	krel release
	if krel == 1 then
		icps_rel init icps_last/2
		while icps_rel > 20 do
			icps_rel /= 2
		od

		aenv	cosseg idyn_last, irel_time, 0
		kcps	cosseg icps_last, irel_time, icps_rel
		kvib	cosseg 1, irel_time, 0
	endif

	aosc	oscili .75+kvib*.25, jitter:k(kcps/100, 1/6, 1/3)+kcps*2+kvib*kcps/500, gitri, iphase

	avco	vco2 .85+kvib*.15, kcps+kvib*kcps/500, itie
	avco	zdf_ladder avco, limit(kcps*2+jitter:k(1, 1/idur, .5/idur)*kcps, 20, 20$k), 7.25+jitter:k(5, 1/idur, .5/idur), itie

	aout	= (aosc + avco) / 2

	aout *= aenv

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