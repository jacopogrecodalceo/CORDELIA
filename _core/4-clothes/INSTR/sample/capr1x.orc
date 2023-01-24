gScapr1x_00_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/capr1x/capr1x-00.wav"
gicapr1x_00_1		 ftgen 0, 0, 0, 1, gScapr1x_00_file, 0, 0, 1
gicapr1x_00_2		 ftgen 0, 0, 0, 1, gScapr1x_00_file, 0, 0, 2
;-------
gScapr1x_01_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/capr1x/capr1x-01.wav"
gicapr1x_01_1		 ftgen 0, 0, 0, 1, gScapr1x_01_file, 0, 0, 1
gicapr1x_01_2		 ftgen 0, 0, 0, 1, gScapr1x_01_file, 0, 0, 2
;-------
gScapr1x_02_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/capr1x/capr1x-02.wav"
gicapr1x_02_1		 ftgen 0, 0, 0, 1, gScapr1x_02_file, 0, 0, 1
gicapr1x_02_2		 ftgen 0, 0, 0, 1, gScapr1x_02_file, 0, 0, 2
;-------
gScapr1x_03_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/capr1x/capr1x-03.wav"
gicapr1x_03_1		 ftgen 0, 0, 0, 1, gScapr1x_03_file, 0, 0, 1
gicapr1x_03_2		 ftgen 0, 0, 0, 1, gScapr1x_03_file, 0, 0, 2
;-------
gScapr1x_04_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/capr1x/capr1x-04.wav"
gicapr1x_04_1		 ftgen 0, 0, 0, 1, gScapr1x_04_file, 0, 0, 1
gicapr1x_04_2		 ftgen 0, 0, 0, 1, gScapr1x_04_file, 0, 0, 2
;-------
gicapr1x_sonvs[]			fillarray	gicapr1x_00_1, gicapr1x_00_2, gicapr1x_01_1, gicapr1x_01_2, gicapr1x_02_1, gicapr1x_02_2, gicapr1x_03_1, gicapr1x_03_2, gicapr1x_04_1, gicapr1x_04_2;-------
gkcapr1x_time		init 16
gkcapr1x_off		init .005
gkcapr1x_dur		init 1
gkcapr1x_sonvs		init 1
gicapr1x_len		init lenarray(gicapr1x_sonvs)/2

;------------------

	instr capr1x

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "capr1x"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkcapr1x_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkcapr1x_sonvs%(gicapr1x_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gicapr1x_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "capr1x"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkcapr1x_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gicapr1x_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gicapr1x_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "capr1x"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkcapr1x_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkcapr1x_sonvs%(gicapr1x_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gicapr1x_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	capr1x, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "capr1x"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcapr1x_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcapr1x_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	capr1x, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "capr1x"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcapr1x_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcapr1x_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	
