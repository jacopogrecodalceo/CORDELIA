gSvla_01_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vla/vla-01.wav"
givla_01_1		 ftgen 0, 0, 0, 1, gSvla_01_file, 0, 0, 1
givla_01_2		 ftgen 0, 0, 0, 1, gSvla_01_file, 0, 0, 2
;---
gSvla_02_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vla/vla-02.wav"
givla_02_1		 ftgen 0, 0, 0, 1, gSvla_02_file, 0, 0, 1
givla_02_2		 ftgen 0, 0, 0, 1, gSvla_02_file, 0, 0, 2
;---
gSvla_03_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vla/vla-03.wav"
givla_03_1		 ftgen 0, 0, 0, 1, gSvla_03_file, 0, 0, 1
givla_03_2		 ftgen 0, 0, 0, 1, gSvla_03_file, 0, 0, 2
;---
gSvla_04_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vla/vla-04.wav"
givla_04_1		 ftgen 0, 0, 0, 1, gSvla_04_file, 0, 0, 1
givla_04_2		 ftgen 0, 0, 0, 1, gSvla_04_file, 0, 0, 2
;---
gSvla_05_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vla/vla-05.wav"
givla_05_1		 ftgen 0, 0, 0, 1, gSvla_05_file, 0, 0, 1
givla_05_2		 ftgen 0, 0, 0, 1, gSvla_05_file, 0, 0, 2
;---
gSvla_06_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vla/vla-06.wav"
givla_06_1		 ftgen 0, 0, 0, 1, gSvla_06_file, 0, 0, 1
givla_06_2		 ftgen 0, 0, 0, 1, gSvla_06_file, 0, 0, 2
;---
gSvla_07_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//vla/vla-07.wav"
givla_07_1		 ftgen 0, 0, 0, 1, gSvla_07_file, 0, 0, 1
givla_07_2		 ftgen 0, 0, 0, 1, gSvla_07_file, 0, 0, 2
;---
givla_sonvs[]			fillarray	givla_01_1, givla_01_2, givla_02_1, givla_02_2, givla_03_1, givla_03_2, givla_04_1, givla_04_2, givla_05_1, givla_05_2, givla_06_1, givla_06_2, givla_07_1, givla_07_2
gkvla_time		init 16
gkvla_off		init .005
gkvla_dur		init 1
gkvla_sonvs		init 1
givla_len		init lenarray(givla_sonvs)/2

;------------------

	instr vla

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "vla"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkvla_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvla_sonvs%(givla_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givla_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "vla"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkvla_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(givla_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init givla_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "vla"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkvla_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvla_sonvs%(givla_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givla_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	vla, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "vla"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvla_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvla_dur

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

	opcode	vla, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "vla"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvla_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvla_dur

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
