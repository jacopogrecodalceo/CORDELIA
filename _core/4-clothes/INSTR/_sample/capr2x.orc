gScapr2x_001_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/capr2x/capr2x-001.wav"
gicapr2x_001_1		 ftgen 0, 0, 0, 1, gScapr2x_001_file, 0, 0, 1
gicapr2x_001_2		 ftgen 0, 0, 0, 1, gScapr2x_001_file, 0, 0, 2
;-------
gScapr2x_002_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/capr2x/capr2x-002.wav"
gicapr2x_002_1		 ftgen 0, 0, 0, 1, gScapr2x_002_file, 0, 0, 1
gicapr2x_002_2		 ftgen 0, 0, 0, 1, gScapr2x_002_file, 0, 0, 2
;-------
gScapr2x_003_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/capr2x/capr2x-003.wav"
gicapr2x_003_1		 ftgen 0, 0, 0, 1, gScapr2x_003_file, 0, 0, 1
gicapr2x_003_2		 ftgen 0, 0, 0, 1, gScapr2x_003_file, 0, 0, 2
;-------
gScapr2x_004_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/capr2x/capr2x-004.wav"
gicapr2x_004_1		 ftgen 0, 0, 0, 1, gScapr2x_004_file, 0, 0, 1
gicapr2x_004_2		 ftgen 0, 0, 0, 1, gScapr2x_004_file, 0, 0, 2
;-------
gScapr2x_005_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/capr2x/capr2x-005.wav"
gicapr2x_005_1		 ftgen 0, 0, 0, 1, gScapr2x_005_file, 0, 0, 1
gicapr2x_005_2		 ftgen 0, 0, 0, 1, gScapr2x_005_file, 0, 0, 2
;-------
gScapr2x_006_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/capr2x/capr2x-006.wav"
gicapr2x_006_1		 ftgen 0, 0, 0, 1, gScapr2x_006_file, 0, 0, 1
gicapr2x_006_2		 ftgen 0, 0, 0, 1, gScapr2x_006_file, 0, 0, 2
;-------
gScapr2x_007_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/capr2x/capr2x-007.wav"
gicapr2x_007_1		 ftgen 0, 0, 0, 1, gScapr2x_007_file, 0, 0, 1
gicapr2x_007_2		 ftgen 0, 0, 0, 1, gScapr2x_007_file, 0, 0, 2
;-------
gScapr2x_008_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/capr2x/capr2x-008.wav"
gicapr2x_008_1		 ftgen 0, 0, 0, 1, gScapr2x_008_file, 0, 0, 1
gicapr2x_008_2		 ftgen 0, 0, 0, 1, gScapr2x_008_file, 0, 0, 2
;-------
gicapr2x_sonvs[]			fillarray	gicapr2x_001_1, gicapr2x_001_2, gicapr2x_002_1, gicapr2x_002_2, gicapr2x_003_1, gicapr2x_003_2, gicapr2x_004_1, gicapr2x_004_2, gicapr2x_005_1, gicapr2x_005_2, gicapr2x_006_1, gicapr2x_006_2, gicapr2x_007_1, gicapr2x_007_2, gicapr2x_008_1, gicapr2x_008_2;-------
gkcapr2x_time		init 16
gkcapr2x_off		init .005
gkcapr2x_dur		init 1
gkcapr2x_sonvs		init 1
gicapr2x_len		init lenarray(gicapr2x_sonvs)/2

;------------------

	instr capr2x

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "capr2x"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkcapr2x_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkcapr2x_sonvs%(gicapr2x_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gicapr2x_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "capr2x"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkcapr2x_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gicapr2x_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gicapr2x_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "capr2x"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkcapr2x_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkcapr2x_sonvs%(gicapr2x_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gicapr2x_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	capr2x, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "capr2x"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcapr2x_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcapr2x_dur

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

	opcode	capr2x, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "capr2x"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcapr2x_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcapr2x_dur

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
