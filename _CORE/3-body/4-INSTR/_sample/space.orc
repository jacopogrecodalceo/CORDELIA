gSspace_00_file 	 init "../samples/space/space-00.wav"
gispace_00_1		 ftgen 0, 0, 0, 1, gSspace_00_file, 0, 0, 1
gispace_00_2		 ftgen 0, 0, 0, 1, gSspace_00_file, 0, 0, 2
;---
gSspace_01_file 	 init "../samples/space/space-01.wav"
gispace_01_1		 ftgen 0, 0, 0, 1, gSspace_01_file, 0, 0, 1
gispace_01_2		 ftgen 0, 0, 0, 1, gSspace_01_file, 0, 0, 2
;---
gSspace_02_file 	 init "../samples/space/space-02.wav"
gispace_02_1		 ftgen 0, 0, 0, 1, gSspace_02_file, 0, 0, 1
gispace_02_2		 ftgen 0, 0, 0, 1, gSspace_02_file, 0, 0, 2
;---
gSspace_03_file 	 init "../samples/space/space-03.wav"
gispace_03_1		 ftgen 0, 0, 0, 1, gSspace_03_file, 0, 0, 1
gispace_03_2		 ftgen 0, 0, 0, 1, gSspace_03_file, 0, 0, 2
;---
gSspace_04_file 	 init "../samples/space/space-04.wav"
gispace_04_1		 ftgen 0, 0, 0, 1, gSspace_04_file, 0, 0, 1
gispace_04_2		 ftgen 0, 0, 0, 1, gSspace_04_file, 0, 0, 2
;---
gSspace_05_file 	 init "../samples/space/space-05.wav"
gispace_05_1		 ftgen 0, 0, 0, 1, gSspace_05_file, 0, 0, 1
gispace_05_2		 ftgen 0, 0, 0, 1, gSspace_05_file, 0, 0, 2
;---
gSspace_06_file 	 init "../samples/space/space-06.wav"
gispace_06_1		 ftgen 0, 0, 0, 1, gSspace_06_file, 0, 0, 1
gispace_06_2		 ftgen 0, 0, 0, 1, gSspace_06_file, 0, 0, 2
;---
gSspace_07_file 	 init "../samples/space/space-07.wav"
gispace_07_1		 ftgen 0, 0, 0, 1, gSspace_07_file, 0, 0, 1
gispace_07_2		 ftgen 0, 0, 0, 1, gSspace_07_file, 0, 0, 2
;---
gSspace_08_file 	 init "../samples/space/space-08.wav"
gispace_08_1		 ftgen 0, 0, 0, 1, gSspace_08_file, 0, 0, 1
gispace_08_2		 ftgen 0, 0, 0, 1, gSspace_08_file, 0, 0, 2
;---
gSspace_09_file 	 init "../samples/space/space-09.wav"
gispace_09_1		 ftgen 0, 0, 0, 1, gSspace_09_file, 0, 0, 1
gispace_09_2		 ftgen 0, 0, 0, 1, gSspace_09_file, 0, 0, 2
;---
gSspace_10_file 	 init "../samples/space/space-10.wav"
gispace_10_1		 ftgen 0, 0, 0, 1, gSspace_10_file, 0, 0, 1
gispace_10_2		 ftgen 0, 0, 0, 1, gSspace_10_file, 0, 0, 2
;---
gSspace_11_file 	 init "../samples/space/space-11.wav"
gispace_11_1		 ftgen 0, 0, 0, 1, gSspace_11_file, 0, 0, 1
gispace_11_2		 ftgen 0, 0, 0, 1, gSspace_11_file, 0, 0, 2
;---
gSspace_12_file 	 init "../samples/space/space-12.wav"
gispace_12_1		 ftgen 0, 0, 0, 1, gSspace_12_file, 0, 0, 1
gispace_12_2		 ftgen 0, 0, 0, 1, gSspace_12_file, 0, 0, 2
;---
gSspace_13_file 	 init "../samples/space/space-13.wav"
gispace_13_1		 ftgen 0, 0, 0, 1, gSspace_13_file, 0, 0, 1
gispace_13_2		 ftgen 0, 0, 0, 1, gSspace_13_file, 0, 0, 2
;---
gSspace_14_file 	 init "../samples/space/space-14.wav"
gispace_14_1		 ftgen 0, 0, 0, 1, gSspace_14_file, 0, 0, 1
gispace_14_2		 ftgen 0, 0, 0, 1, gSspace_14_file, 0, 0, 2
;---
gSspace_15_file 	 init "../samples/space/space-15.wav"
gispace_15_1		 ftgen 0, 0, 0, 1, gSspace_15_file, 0, 0, 1
gispace_15_2		 ftgen 0, 0, 0, 1, gSspace_15_file, 0, 0, 2
;---
gispace_sonvs[]			fillarray	gispace_00_1, gispace_00_2, gispace_01_1, gispace_01_2, gispace_02_1, gispace_02_2, gispace_03_1, gispace_03_2, gispace_04_1, gispace_04_2, gispace_05_1, gispace_05_2, gispace_06_1, gispace_06_2, gispace_07_1, gispace_07_2, gispace_08_1, gispace_08_2, gispace_09_1, gispace_09_2, gispace_10_1, gispace_10_2, gispace_11_1, gispace_11_2, gispace_12_1, gispace_12_2, gispace_13_1, gispace_13_2, gispace_14_1, gispace_14_2, gispace_15_1, gispace_15_2
gkspace_time		init 16
gkspace_off		init .005
gkspace_dur		init 1
gkspace_sonvs		init 1
gispace_len		init lenarray(gispace_sonvs)/2

;------------------

	instr space

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "space"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkspace_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkspace_sonvs%(gispace_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gispace_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "space"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkspace_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gispace_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gispace_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "space"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkspace_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkspace_sonvs%(gispace_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gispace_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	space, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "space"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkspace_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkspace_dur

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

	opcode	space, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "space"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkspace_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkspace_dur

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
