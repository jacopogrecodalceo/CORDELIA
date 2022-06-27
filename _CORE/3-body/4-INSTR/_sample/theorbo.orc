gStheorbo_05_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//theorbo/theorbo-05.wav"
githeorbo_05_1		 ftgen 0, 0, 0, 1, gStheorbo_05_file, 0, 0, 1
githeorbo_05_2		 ftgen 0, 0, 0, 1, gStheorbo_05_file, 0, 0, 2
;---
gStheorbo_06_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//theorbo/theorbo-06.wav"
githeorbo_06_1		 ftgen 0, 0, 0, 1, gStheorbo_06_file, 0, 0, 1
githeorbo_06_2		 ftgen 0, 0, 0, 1, gStheorbo_06_file, 0, 0, 2
;---
gStheorbo_07_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//theorbo/theorbo-07.wav"
githeorbo_07_1		 ftgen 0, 0, 0, 1, gStheorbo_07_file, 0, 0, 1
githeorbo_07_2		 ftgen 0, 0, 0, 1, gStheorbo_07_file, 0, 0, 2
;---
gStheorbo_08_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//theorbo/theorbo-08.wav"
githeorbo_08_1		 ftgen 0, 0, 0, 1, gStheorbo_08_file, 0, 0, 1
githeorbo_08_2		 ftgen 0, 0, 0, 1, gStheorbo_08_file, 0, 0, 2
;---
gStheorbo_09_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//theorbo/theorbo-09.wav"
githeorbo_09_1		 ftgen 0, 0, 0, 1, gStheorbo_09_file, 0, 0, 1
githeorbo_09_2		 ftgen 0, 0, 0, 1, gStheorbo_09_file, 0, 0, 2
;---
githeorbo_sonvs[]			fillarray	githeorbo_05_1, githeorbo_05_2, githeorbo_06_1, githeorbo_06_2, githeorbo_07_1, githeorbo_07_2, githeorbo_08_1, githeorbo_08_2, githeorbo_09_1, githeorbo_09_2
gktheorbo_time		init 16
gktheorbo_off		init .005
gktheorbo_dur		init 1
gktheorbo_sonvs		init 1
githeorbo_len		init lenarray(githeorbo_sonvs)/2

;------------------

	instr theorbo

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "theorbo"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gktheorbo_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gktheorbo_sonvs%(githeorbo_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init githeorbo_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "theorbo"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gktheorbo_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(githeorbo_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init githeorbo_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "theorbo"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gktheorbo_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gktheorbo_sonvs%(githeorbo_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init githeorbo_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	theorbo, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "theorbo"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktheorbo_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktheorbo_dur

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

	opcode	theorbo, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "theorbo"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktheorbo_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktheorbo_dur

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
