gSquar_01_file 	 init "../samples/quar/quar-01.wav"
giquar_01_1		 ftgen 0, 0, 0, 1, gSquar_01_file, 0, 0, 1
giquar_01_2		 ftgen 0, 0, 0, 1, gSquar_01_file, 0, 0, 2
;---
gSquar_02_file 	 init "../samples/quar/quar-02.wav"
giquar_02_1		 ftgen 0, 0, 0, 1, gSquar_02_file, 0, 0, 1
giquar_02_2		 ftgen 0, 0, 0, 1, gSquar_02_file, 0, 0, 2
;---
gSquar_03_file 	 init "../samples/quar/quar-03.wav"
giquar_03_1		 ftgen 0, 0, 0, 1, gSquar_03_file, 0, 0, 1
giquar_03_2		 ftgen 0, 0, 0, 1, gSquar_03_file, 0, 0, 2
;---
gSquar_04_file 	 init "../samples/quar/quar-04.wav"
giquar_04_1		 ftgen 0, 0, 0, 1, gSquar_04_file, 0, 0, 1
giquar_04_2		 ftgen 0, 0, 0, 1, gSquar_04_file, 0, 0, 2
;---
gSquar_05_file 	 init "../samples/quar/quar-05.wav"
giquar_05_1		 ftgen 0, 0, 0, 1, gSquar_05_file, 0, 0, 1
giquar_05_2		 ftgen 0, 0, 0, 1, gSquar_05_file, 0, 0, 2
;---
gSquar_06_file 	 init "../samples/quar/quar-06.wav"
giquar_06_1		 ftgen 0, 0, 0, 1, gSquar_06_file, 0, 0, 1
giquar_06_2		 ftgen 0, 0, 0, 1, gSquar_06_file, 0, 0, 2
;---
gSquar_07_file 	 init "../samples/quar/quar-07.wav"
giquar_07_1		 ftgen 0, 0, 0, 1, gSquar_07_file, 0, 0, 1
giquar_07_2		 ftgen 0, 0, 0, 1, gSquar_07_file, 0, 0, 2
;---
gSquar_08_file 	 init "../samples/quar/quar-08.wav"
giquar_08_1		 ftgen 0, 0, 0, 1, gSquar_08_file, 0, 0, 1
giquar_08_2		 ftgen 0, 0, 0, 1, gSquar_08_file, 0, 0, 2
;---
gSquar_09_file 	 init "../samples/quar/quar-09.wav"
giquar_09_1		 ftgen 0, 0, 0, 1, gSquar_09_file, 0, 0, 1
giquar_09_2		 ftgen 0, 0, 0, 1, gSquar_09_file, 0, 0, 2
;---
gSquar_10_file 	 init "../samples/quar/quar-10.wav"
giquar_10_1		 ftgen 0, 0, 0, 1, gSquar_10_file, 0, 0, 1
giquar_10_2		 ftgen 0, 0, 0, 1, gSquar_10_file, 0, 0, 2
;---
giquar_sonvs[]			fillarray	giquar_01_1, giquar_01_2, giquar_02_1, giquar_02_2, giquar_03_1, giquar_03_2, giquar_04_1, giquar_04_2, giquar_05_1, giquar_05_2, giquar_06_1, giquar_06_2, giquar_07_1, giquar_07_2, giquar_08_1, giquar_08_2, giquar_09_1, giquar_09_2, giquar_10_1, giquar_10_2
gkquar_time		init 16
gkquar_off		init .005
gkquar_dur		init 1
gkquar_sonvs		init 1
giquar_len		init lenarray(giquar_sonvs)/2

;------------------

	instr quar

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "quar"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkquar_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkquar_sonvs%(giquar_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init giquar_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "quar"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkquar_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(giquar_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init giquar_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "quar"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkquar_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkquar_sonvs%(giquar_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init giquar_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	quar, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "quar"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkquar_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkquar_dur

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

	opcode	quar, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "quar"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkquar_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkquar_dur

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
