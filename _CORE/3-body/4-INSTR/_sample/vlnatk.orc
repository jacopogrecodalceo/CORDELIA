gSvlnatk_00_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vlnatk/vlnatk-00.wav"
givlnatk_00_1		 ftgen 0, 0, 0, 1, gSvlnatk_00_file, 0, 0, 1
givlnatk_00_2		 ftgen 0, 0, 0, 1, gSvlnatk_00_file, 0, 0, 2
;---
gSvlnatk_01_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vlnatk/vlnatk-01.wav"
givlnatk_01_1		 ftgen 0, 0, 0, 1, gSvlnatk_01_file, 0, 0, 1
givlnatk_01_2		 ftgen 0, 0, 0, 1, gSvlnatk_01_file, 0, 0, 2
;---
gSvlnatk_02_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vlnatk/vlnatk-02.wav"
givlnatk_02_1		 ftgen 0, 0, 0, 1, gSvlnatk_02_file, 0, 0, 1
givlnatk_02_2		 ftgen 0, 0, 0, 1, gSvlnatk_02_file, 0, 0, 2
;---
gSvlnatk_03_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vlnatk/vlnatk-03.wav"
givlnatk_03_1		 ftgen 0, 0, 0, 1, gSvlnatk_03_file, 0, 0, 1
givlnatk_03_2		 ftgen 0, 0, 0, 1, gSvlnatk_03_file, 0, 0, 2
;---
gSvlnatk_04_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vlnatk/vlnatk-04.wav"
givlnatk_04_1		 ftgen 0, 0, 0, 1, gSvlnatk_04_file, 0, 0, 1
givlnatk_04_2		 ftgen 0, 0, 0, 1, gSvlnatk_04_file, 0, 0, 2
;---
gSvlnatk_05_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vlnatk/vlnatk-05.wav"
givlnatk_05_1		 ftgen 0, 0, 0, 1, gSvlnatk_05_file, 0, 0, 1
givlnatk_05_2		 ftgen 0, 0, 0, 1, gSvlnatk_05_file, 0, 0, 2
;---
gSvlnatk_06_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vlnatk/vlnatk-06.wav"
givlnatk_06_1		 ftgen 0, 0, 0, 1, gSvlnatk_06_file, 0, 0, 1
givlnatk_06_2		 ftgen 0, 0, 0, 1, gSvlnatk_06_file, 0, 0, 2
;---
givlnatk_sonvs[]			fillarray	givlnatk_00_1, givlnatk_00_2, givlnatk_01_1, givlnatk_01_2, givlnatk_02_1, givlnatk_02_2, givlnatk_03_1, givlnatk_03_2, givlnatk_04_1, givlnatk_04_2, givlnatk_05_1, givlnatk_05_2, givlnatk_06_1, givlnatk_06_2
gkvlnatk_time		init 16
gkvlnatk_off		init .005
gkvlnatk_dur		init 1
gkvlnatk_sonvs		init 1
givlnatk_len		init lenarray(givlnatk_sonvs)/2

;------------------

	instr vlnatk

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "vlnatk"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkvlnatk_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvlnatk_sonvs%(givlnatk_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givlnatk_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "vlnatk"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkvlnatk_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(givlnatk_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init givlnatk_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "vlnatk"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkvlnatk_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvlnatk_sonvs%(givlnatk_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givlnatk_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	vlnatk, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "vlnatk"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvlnatk_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvlnatk_dur

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

	opcode	vlnatk, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "vlnatk"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvlnatk_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvlnatk_dur

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
