gSgameld_00_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gameld/gameld_00.wav"
gigameld_00_1		 ftgen 0, 0, 0, 1, gSgameld_00_file, 0, 0, 1
gigameld_00_2		 ftgen 0, 0, 0, 1, gSgameld_00_file, 0, 0, 2
;-------
gSgameld_01_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gameld/gameld_01.wav"
gigameld_01_1		 ftgen 0, 0, 0, 1, gSgameld_01_file, 0, 0, 1
gigameld_01_2		 ftgen 0, 0, 0, 1, gSgameld_01_file, 0, 0, 2
;-------
gSgameld_02_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gameld/gameld_02.wav"
gigameld_02_1		 ftgen 0, 0, 0, 1, gSgameld_02_file, 0, 0, 1
gigameld_02_2		 ftgen 0, 0, 0, 1, gSgameld_02_file, 0, 0, 2
;-------
gSgameld_03_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gameld/gameld_03.wav"
gigameld_03_1		 ftgen 0, 0, 0, 1, gSgameld_03_file, 0, 0, 1
gigameld_03_2		 ftgen 0, 0, 0, 1, gSgameld_03_file, 0, 0, 2
;-------
gSgameld_04_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gameld/gameld_04.wav"
gigameld_04_1		 ftgen 0, 0, 0, 1, gSgameld_04_file, 0, 0, 1
gigameld_04_2		 ftgen 0, 0, 0, 1, gSgameld_04_file, 0, 0, 2
;-------
gSgameld_05_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gameld/gameld_05.wav"
gigameld_05_1		 ftgen 0, 0, 0, 1, gSgameld_05_file, 0, 0, 1
gigameld_05_2		 ftgen 0, 0, 0, 1, gSgameld_05_file, 0, 0, 2
;-------
gSgameld_06_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gameld/gameld_06.wav"
gigameld_06_1		 ftgen 0, 0, 0, 1, gSgameld_06_file, 0, 0, 1
gigameld_06_2		 ftgen 0, 0, 0, 1, gSgameld_06_file, 0, 0, 2
;-------
gSgameld_07_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gameld/gameld_07.wav"
gigameld_07_1		 ftgen 0, 0, 0, 1, gSgameld_07_file, 0, 0, 1
gigameld_07_2		 ftgen 0, 0, 0, 1, gSgameld_07_file, 0, 0, 2
;-------
gSgameld_08_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gameld/gameld_08.wav"
gigameld_08_1		 ftgen 0, 0, 0, 1, gSgameld_08_file, 0, 0, 1
gigameld_08_2		 ftgen 0, 0, 0, 1, gSgameld_08_file, 0, 0, 2
;-------
gSgameld_09_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gameld/gameld_09.wav"
gigameld_09_1		 ftgen 0, 0, 0, 1, gSgameld_09_file, 0, 0, 1
gigameld_09_2		 ftgen 0, 0, 0, 1, gSgameld_09_file, 0, 0, 2
;-------
gSgameld_10_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gameld/gameld_10.wav"
gigameld_10_1		 ftgen 0, 0, 0, 1, gSgameld_10_file, 0, 0, 1
gigameld_10_2		 ftgen 0, 0, 0, 1, gSgameld_10_file, 0, 0, 2
;-------
gSgameld_11_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gameld/gameld_11.wav"
gigameld_11_1		 ftgen 0, 0, 0, 1, gSgameld_11_file, 0, 0, 1
gigameld_11_2		 ftgen 0, 0, 0, 1, gSgameld_11_file, 0, 0, 2
;-------
gSgameld_12_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gameld/gameld_12.wav"
gigameld_12_1		 ftgen 0, 0, 0, 1, gSgameld_12_file, 0, 0, 1
gigameld_12_2		 ftgen 0, 0, 0, 1, gSgameld_12_file, 0, 0, 2
;-------
gigameld_sonvs[]			fillarray	gigameld_00_1, gigameld_00_2, gigameld_01_1, gigameld_01_2, gigameld_02_1, gigameld_02_2, gigameld_03_1, gigameld_03_2, gigameld_04_1, gigameld_04_2, gigameld_05_1, gigameld_05_2, gigameld_06_1, gigameld_06_2, gigameld_07_1, gigameld_07_2, gigameld_08_1, gigameld_08_2, gigameld_09_1, gigameld_09_2, gigameld_10_1, gigameld_10_2, gigameld_11_1, gigameld_11_2, gigameld_12_1, gigameld_12_2;-------
gkgameld_time		init 16
gkgameld_off		init .005
gkgameld_dur		init 1
gkgameld_sonvs		init 1
gigameld_len		init lenarray(gigameld_sonvs)/2

;------------------

	instr gameld

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "gameld"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkgameld_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkgameld_sonvs%(gigameld_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gigameld_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "gameld"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkgameld_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gigameld_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gigameld_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "gameld"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkgameld_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkgameld_sonvs%(gigameld_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gigameld_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	gameld, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gameld"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgameld_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgameld_dur

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

	opcode	gameld, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gameld"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgameld_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgameld_dur

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
