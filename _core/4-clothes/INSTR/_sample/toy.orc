gStoy_00_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/toy/toy_00.wav"
gitoy_00_1		 ftgen 0, 0, 0, 1, gStoy_00_file, 0, 0, 1
gitoy_00_2		 ftgen 0, 0, 0, 1, gStoy_00_file, 0, 0, 2
;-------
gStoy_01_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/toy/toy_01.wav"
gitoy_01_1		 ftgen 0, 0, 0, 1, gStoy_01_file, 0, 0, 1
gitoy_01_2		 ftgen 0, 0, 0, 1, gStoy_01_file, 0, 0, 2
;-------
gStoy_02_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/toy/toy_02.wav"
gitoy_02_1		 ftgen 0, 0, 0, 1, gStoy_02_file, 0, 0, 1
gitoy_02_2		 ftgen 0, 0, 0, 1, gStoy_02_file, 0, 0, 2
;-------
gStoy_03_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/toy/toy_03.wav"
gitoy_03_1		 ftgen 0, 0, 0, 1, gStoy_03_file, 0, 0, 1
gitoy_03_2		 ftgen 0, 0, 0, 1, gStoy_03_file, 0, 0, 2
;-------
gStoy_04_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/toy/toy_04.wav"
gitoy_04_1		 ftgen 0, 0, 0, 1, gStoy_04_file, 0, 0, 1
gitoy_04_2		 ftgen 0, 0, 0, 1, gStoy_04_file, 0, 0, 2
;-------
gStoy_05_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/toy/toy_05.wav"
gitoy_05_1		 ftgen 0, 0, 0, 1, gStoy_05_file, 0, 0, 1
gitoy_05_2		 ftgen 0, 0, 0, 1, gStoy_05_file, 0, 0, 2
;-------
gStoy_06_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/toy/toy_06.wav"
gitoy_06_1		 ftgen 0, 0, 0, 1, gStoy_06_file, 0, 0, 1
gitoy_06_2		 ftgen 0, 0, 0, 1, gStoy_06_file, 0, 0, 2
;-------
gStoy_07_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/toy/toy_07.wav"
gitoy_07_1		 ftgen 0, 0, 0, 1, gStoy_07_file, 0, 0, 1
gitoy_07_2		 ftgen 0, 0, 0, 1, gStoy_07_file, 0, 0, 2
;-------
gStoy_08_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/toy/toy_08.wav"
gitoy_08_1		 ftgen 0, 0, 0, 1, gStoy_08_file, 0, 0, 1
gitoy_08_2		 ftgen 0, 0, 0, 1, gStoy_08_file, 0, 0, 2
;-------
gitoy_sonvs[]			fillarray	gitoy_00_1, gitoy_00_2, gitoy_01_1, gitoy_01_2, gitoy_02_1, gitoy_02_2, gitoy_03_1, gitoy_03_2, gitoy_04_1, gitoy_04_2, gitoy_05_1, gitoy_05_2, gitoy_06_1, gitoy_06_2, gitoy_07_1, gitoy_07_2, gitoy_08_1, gitoy_08_2;-------
gktoy_time		init 16
gktoy_off		init .005
gktoy_dur		init 1
gktoy_sonvs		init 1
gitoy_len		init lenarray(gitoy_sonvs)/2

;------------------

	instr toy

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "toy"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gktoy_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gktoy_sonvs%(gitoy_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gitoy_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "toy"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gktoy_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gitoy_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gitoy_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "toy"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gktoy_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gktoy_sonvs%(gitoy_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gitoy_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	toy, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "toy"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktoy_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktoy_dur

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

	opcode	toy, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "toy"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktoy_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktoy_dur

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
