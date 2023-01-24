
;	CLASSIC
;	a 3-points function from linear segments
giclassic_atk		init sr * 5$ms
giclassic_dur		init gienvdur - giclassic_atk
giclassic_int		init 9
giclassic_intdec	init 4
giclassic_dec		init giclassic_intdec / giclassic_int
giclassic_sus		init .15
giclassic_intrel	init giclassic_int-giclassic_intdec
giclassic_rel		init giclassic_intrel / giclassic_int
;-----------------------
giclassic		ftgen	0, 0, gienvdur, 7, 0, giclassic_atk, 1, giclassic_dur*giclassic_dec, giclassic_sus, giclassic_dur*giclassic_rel, 0
;-----------------------
	opcode morpheus, i, kiiooo
	kndx, ift1, ift2, ift3, ift4, ift5 xin

ifno		init giclassic

iftmorf1	abs	floor(ift1)
iftmorf2	abs	floor(ift2)
iftmorf3	abs	floor(ift3)
iftmorf4	abs	floor(ift4)
iftmorf5	abs	floor(ift5)

ifact		init .995

if	ift3==0 then
	ifno	ftgenonce 0, 0, 2, -2, iftmorf1, iftmorf2
		ftmorf kndx*ifact, ifno, gimorf
elseif	ift3>0&&ift4==0 then
	ifno	ftgenonce 0, 0, 3, -2, iftmorf1, iftmorf2, iftmorf3
		ftmorf kndx*(ifact+1), ifno, gimorf
elseif	ift4>0&&ift5==0 then
	ifno	ftgenonce 0, 0, 4, -2, iftmorf1, iftmorf2, iftmorf3, iftmorf4
		ftmorf kndx*(ifact+2), ifno, gimorf
elseif	ift5>0 then
	ifno	ftgenonce 0, 0, 5, -2, iftmorf1, iftmorf2, iftmorf3, iftmorf4, iftmorf5
		ftmorf kndx*(ifact+3), ifno, gimorf
endif

	xout gimorf
	endop

	opcode morpheusyn, i, kiiooo
	kndx, ift1, ift2, ift3, ift4, ift5 xin

ifno		init giclassic

iftmorf1	abs	floor(ift1)
iftmorf2	abs	floor(ift2)
iftmorf3	abs	floor(ift3)
iftmorf4	abs	floor(ift4)
iftmorf5	abs	floor(ift5)

ifact		init .995

if	ift3==0 then
	ifno	ftgenonce 0, 0, 2, -2, iftmorf1, iftmorf2
		ftmorf kndx*ifact, ifno, gimorfsyn
elseif	ift3>0&&ift4==0 then
	ifno	ftgenonce 0, 0, 3, -2, iftmorf1, iftmorf2, iftmorf3
		ftmorf kndx*(ifact+1), ifno, gimorfsyn
elseif	ift4>0&&ift5==0 then
	ifno	ftgenonce 0, 0, 4, -2, iftmorf1, iftmorf2, iftmorf3, iftmorf4
		ftmorf kndx*(ifact+2), ifno, gimorfsyn
elseif	ift5>0 then
	ifno	ftgenonce 0, 0, 5, -2, iftmorf1, iftmorf2, iftmorf3, iftmorf4, iftmorf5
		ftmorf kndx*(ifact+3), ifno, gimorfsyn
endif

	xout gimorf
	endop
