gSgamelf_00_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gamelf/gamelf_00.wav"
gigamelf_00_1		 ftgen 0, 0, 0, 1, gSgamelf_00_file, 0, 0, 1
gigamelf_00_2		 ftgen 0, 0, 0, 1, gSgamelf_00_file, 0, 0, 2
;-------
gSgamelf_01_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gamelf/gamelf_01.wav"
gigamelf_01_1		 ftgen 0, 0, 0, 1, gSgamelf_01_file, 0, 0, 1
gigamelf_01_2		 ftgen 0, 0, 0, 1, gSgamelf_01_file, 0, 0, 2
;-------
gSgamelf_02_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gamelf/gamelf_02.wav"
gigamelf_02_1		 ftgen 0, 0, 0, 1, gSgamelf_02_file, 0, 0, 1
gigamelf_02_2		 ftgen 0, 0, 0, 1, gSgamelf_02_file, 0, 0, 2
;-------
gSgamelf_03_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gamelf/gamelf_03.wav"
gigamelf_03_1		 ftgen 0, 0, 0, 1, gSgamelf_03_file, 0, 0, 1
gigamelf_03_2		 ftgen 0, 0, 0, 1, gSgamelf_03_file, 0, 0, 2
;-------
gSgamelf_04_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gamelf/gamelf_04.wav"
gigamelf_04_1		 ftgen 0, 0, 0, 1, gSgamelf_04_file, 0, 0, 1
gigamelf_04_2		 ftgen 0, 0, 0, 1, gSgamelf_04_file, 0, 0, 2
;-------
gSgamelf_05_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gamelf/gamelf_05.wav"
gigamelf_05_1		 ftgen 0, 0, 0, 1, gSgamelf_05_file, 0, 0, 1
gigamelf_05_2		 ftgen 0, 0, 0, 1, gSgamelf_05_file, 0, 0, 2
;-------
gSgamelf_06_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gamelf/gamelf_06.wav"
gigamelf_06_1		 ftgen 0, 0, 0, 1, gSgamelf_06_file, 0, 0, 1
gigamelf_06_2		 ftgen 0, 0, 0, 1, gSgamelf_06_file, 0, 0, 2
;-------
gSgamelf_07_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gamelf/gamelf_07.wav"
gigamelf_07_1		 ftgen 0, 0, 0, 1, gSgamelf_07_file, 0, 0, 1
gigamelf_07_2		 ftgen 0, 0, 0, 1, gSgamelf_07_file, 0, 0, 2
;-------
gSgamelf_08_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gamelf/gamelf_08.wav"
gigamelf_08_1		 ftgen 0, 0, 0, 1, gSgamelf_08_file, 0, 0, 1
gigamelf_08_2		 ftgen 0, 0, 0, 1, gSgamelf_08_file, 0, 0, 2
;-------
gSgamelf_09_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gamelf/gamelf_09.wav"
gigamelf_09_1		 ftgen 0, 0, 0, 1, gSgamelf_09_file, 0, 0, 1
gigamelf_09_2		 ftgen 0, 0, 0, 1, gSgamelf_09_file, 0, 0, 2
;-------
gSgamelf_10_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gamelf/gamelf_10.wav"
gigamelf_10_1		 ftgen 0, 0, 0, 1, gSgamelf_10_file, 0, 0, 1
gigamelf_10_2		 ftgen 0, 0, 0, 1, gSgamelf_10_file, 0, 0, 2
;-------
gSgamelf_11_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gamelf/gamelf_11.wav"
gigamelf_11_1		 ftgen 0, 0, 0, 1, gSgamelf_11_file, 0, 0, 1
gigamelf_11_2		 ftgen 0, 0, 0, 1, gSgamelf_11_file, 0, 0, 2
;-------
gSgamelf_12_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/gamelf/gamelf_12.wav"
gigamelf_12_1		 ftgen 0, 0, 0, 1, gSgamelf_12_file, 0, 0, 1
gigamelf_12_2		 ftgen 0, 0, 0, 1, gSgamelf_12_file, 0, 0, 2
;-------
gigamelf_sonvs[]			fillarray	gigamelf_00_1, gigamelf_00_2, gigamelf_01_1, gigamelf_01_2, gigamelf_02_1, gigamelf_02_2, gigamelf_03_1, gigamelf_03_2, gigamelf_04_1, gigamelf_04_2, gigamelf_05_1, gigamelf_05_2, gigamelf_06_1, gigamelf_06_2, gigamelf_07_1, gigamelf_07_2, gigamelf_08_1, gigamelf_08_2, gigamelf_09_1, gigamelf_09_2, gigamelf_10_1, gigamelf_10_2, gigamelf_11_1, gigamelf_11_2, gigamelf_12_1, gigamelf_12_2;-------
gkgamelf_time		init 16
gkgamelf_off		init .005
gkgamelf_dur		init 1
gkgamelf_sonvs		init 1
gigamelf_len		init lenarray(gigamelf_sonvs)/2

;------------------

	instr gamelf

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "gamelf"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkgamelf_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkgamelf_sonvs%(gigamelf_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gigamelf_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "gamelf"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkgamelf_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gigamelf_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gigamelf_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "gamelf"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkgamelf_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkgamelf_sonvs%(gigamelf_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gigamelf_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	gamelf, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gamelf"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgamelf_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgamelf_dur

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

	opcode	gamelf, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gamelf"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgamelf_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgamelf_dur

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
