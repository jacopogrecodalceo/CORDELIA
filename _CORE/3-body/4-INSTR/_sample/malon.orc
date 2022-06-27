gSmalon_00_file 	 init "../samples/malon/malon_00.wav"
gimalon_00_1		 ftgen 0, 0, 0, 1, gSmalon_00_file, 0, 0, 1
gimalon_00_2		 ftgen 0, 0, 0, 1, gSmalon_00_file, 0, 0, 2
;---
gSmalon_01_file 	 init "../samples/malon/malon_01.wav"
gimalon_01_1		 ftgen 0, 0, 0, 1, gSmalon_01_file, 0, 0, 1
gimalon_01_2		 ftgen 0, 0, 0, 1, gSmalon_01_file, 0, 0, 2
;---
gSmalon_02_file 	 init "../samples/malon/malon_02.wav"
gimalon_02_1		 ftgen 0, 0, 0, 1, gSmalon_02_file, 0, 0, 1
gimalon_02_2		 ftgen 0, 0, 0, 1, gSmalon_02_file, 0, 0, 2
;---
gSmalon_03_file 	 init "../samples/malon/malon_03.wav"
gimalon_03_1		 ftgen 0, 0, 0, 1, gSmalon_03_file, 0, 0, 1
gimalon_03_2		 ftgen 0, 0, 0, 1, gSmalon_03_file, 0, 0, 2
;---
gSmalon_04_file 	 init "../samples/malon/malon_04.wav"
gimalon_04_1		 ftgen 0, 0, 0, 1, gSmalon_04_file, 0, 0, 1
gimalon_04_2		 ftgen 0, 0, 0, 1, gSmalon_04_file, 0, 0, 2
;---
gSmalon_05_file 	 init "../samples/malon/malon_05.wav"
gimalon_05_1		 ftgen 0, 0, 0, 1, gSmalon_05_file, 0, 0, 1
gimalon_05_2		 ftgen 0, 0, 0, 1, gSmalon_05_file, 0, 0, 2
;---
gSmalon_06_file 	 init "../samples/malon/malon_06.wav"
gimalon_06_1		 ftgen 0, 0, 0, 1, gSmalon_06_file, 0, 0, 1
gimalon_06_2		 ftgen 0, 0, 0, 1, gSmalon_06_file, 0, 0, 2
;---
gSmalon_07_file 	 init "../samples/malon/malon_07.wav"
gimalon_07_1		 ftgen 0, 0, 0, 1, gSmalon_07_file, 0, 0, 1
gimalon_07_2		 ftgen 0, 0, 0, 1, gSmalon_07_file, 0, 0, 2
;---
gSmalon_08_file 	 init "../samples/malon/malon_08.wav"
gimalon_08_1		 ftgen 0, 0, 0, 1, gSmalon_08_file, 0, 0, 1
gimalon_08_2		 ftgen 0, 0, 0, 1, gSmalon_08_file, 0, 0, 2
;---
gSmalon_09_file 	 init "../samples/malon/malon_09.wav"
gimalon_09_1		 ftgen 0, 0, 0, 1, gSmalon_09_file, 0, 0, 1
gimalon_09_2		 ftgen 0, 0, 0, 1, gSmalon_09_file, 0, 0, 2
;---
gimalon_sonvs[]			fillarray	gimalon_00_1, gimalon_00_2, gimalon_01_1, gimalon_01_2, gimalon_02_1, gimalon_02_2, gimalon_03_1, gimalon_03_2, gimalon_04_1, gimalon_04_2, gimalon_05_1, gimalon_05_2, gimalon_06_1, gimalon_06_2, gimalon_07_1, gimalon_07_2, gimalon_08_1, gimalon_08_2, gimalon_09_1, gimalon_09_2
gkmalon_time		init 16
gkmalon_off		init .005
gkmalon_dur		init 1
gkmalon_sonvs		init 1
gimalon_len		init lenarray(gimalon_sonvs)/2

;------------------

	instr malon

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "malon"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkmalon_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkmalon_sonvs%(gimalon_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gimalon_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "malon"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkmalon_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gimalon_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gimalon_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "malon"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkmalon_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkmalon_sonvs%(gimalon_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gimalon_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	malon, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "malon"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmalon_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmalon_dur

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

	opcode	malon, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "malon"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmalon_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmalon_dur

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
