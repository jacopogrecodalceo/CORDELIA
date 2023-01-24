gSalghef_00_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/alghef/alghef-00.wav"
gialghef_00_1		 ftgen 0, 0, 0, 1, gSalghef_00_file, 0, 0, 1
gialghef_00_2		 ftgen 0, 0, 0, 1, gSalghef_00_file, 0, 0, 2
;-------
gSalghef_01_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/alghef/alghef-01.wav"
gialghef_01_1		 ftgen 0, 0, 0, 1, gSalghef_01_file, 0, 0, 1
gialghef_01_2		 ftgen 0, 0, 0, 1, gSalghef_01_file, 0, 0, 2
;-------
gSalghef_02_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/alghef/alghef-02.wav"
gialghef_02_1		 ftgen 0, 0, 0, 1, gSalghef_02_file, 0, 0, 1
gialghef_02_2		 ftgen 0, 0, 0, 1, gSalghef_02_file, 0, 0, 2
;-------
gSalghef_03_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/alghef/alghef-03.wav"
gialghef_03_1		 ftgen 0, 0, 0, 1, gSalghef_03_file, 0, 0, 1
gialghef_03_2		 ftgen 0, 0, 0, 1, gSalghef_03_file, 0, 0, 2
;-------
gSalghef_04_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/alghef/alghef-04.wav"
gialghef_04_1		 ftgen 0, 0, 0, 1, gSalghef_04_file, 0, 0, 1
gialghef_04_2		 ftgen 0, 0, 0, 1, gSalghef_04_file, 0, 0, 2
;-------
gSalghef_05_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/alghef/alghef-05.wav"
gialghef_05_1		 ftgen 0, 0, 0, 1, gSalghef_05_file, 0, 0, 1
gialghef_05_2		 ftgen 0, 0, 0, 1, gSalghef_05_file, 0, 0, 2
;-------
gSalghef_06_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/alghef/alghef-06.wav"
gialghef_06_1		 ftgen 0, 0, 0, 1, gSalghef_06_file, 0, 0, 1
gialghef_06_2		 ftgen 0, 0, 0, 1, gSalghef_06_file, 0, 0, 2
;-------
gSalghef_07_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/alghef/alghef-07.wav"
gialghef_07_1		 ftgen 0, 0, 0, 1, gSalghef_07_file, 0, 0, 1
gialghef_07_2		 ftgen 0, 0, 0, 1, gSalghef_07_file, 0, 0, 2
;-------
gSalghef_08_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/alghef/alghef-08.wav"
gialghef_08_1		 ftgen 0, 0, 0, 1, gSalghef_08_file, 0, 0, 1
gialghef_08_2		 ftgen 0, 0, 0, 1, gSalghef_08_file, 0, 0, 2
;-------
gSalghef_09_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/alghef/alghef-09.wav"
gialghef_09_1		 ftgen 0, 0, 0, 1, gSalghef_09_file, 0, 0, 1
gialghef_09_2		 ftgen 0, 0, 0, 1, gSalghef_09_file, 0, 0, 2
;-------
gSalghef_10_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/alghef/alghef-10.wav"
gialghef_10_1		 ftgen 0, 0, 0, 1, gSalghef_10_file, 0, 0, 1
gialghef_10_2		 ftgen 0, 0, 0, 1, gSalghef_10_file, 0, 0, 2
;-------
gSalghef_11_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/alghef/alghef-11.wav"
gialghef_11_1		 ftgen 0, 0, 0, 1, gSalghef_11_file, 0, 0, 1
gialghef_11_2		 ftgen 0, 0, 0, 1, gSalghef_11_file, 0, 0, 2
;-------
gialghef_sonvs[]			fillarray	gialghef_00_1, gialghef_00_2, gialghef_01_1, gialghef_01_2, gialghef_02_1, gialghef_02_2, gialghef_03_1, gialghef_03_2, gialghef_04_1, gialghef_04_2, gialghef_05_1, gialghef_05_2, gialghef_06_1, gialghef_06_2, gialghef_07_1, gialghef_07_2, gialghef_08_1, gialghef_08_2, gialghef_09_1, gialghef_09_2, gialghef_10_1, gialghef_10_2, gialghef_11_1, gialghef_11_2;-------
gkalghef_time		init 16
gkalghef_off		init .005
gkalghef_dur		init 1
gkalghef_sonvs		init 1
gialghef_len		init lenarray(gialghef_sonvs)/2

;------------------

	instr alghef

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "alghef"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkalghef_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkalghef_sonvs%(gialghef_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gialghef_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "alghef"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkalghef_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gialghef_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gialghef_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "alghef"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkalghef_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkalghef_sonvs%(gialghef_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gialghef_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	alghef, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "alghef"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkalghef_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkalghef_dur

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

	opcode	alghef, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "alghef"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkalghef_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkalghef_dur

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
