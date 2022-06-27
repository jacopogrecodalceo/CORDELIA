gSfalga_01_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//falga/falga-01.wav"
gifalga_01_1		 ftgen 0, 0, 0, 1, gSfalga_01_file, 0, 0, 1
gifalga_01_2		 ftgen 0, 0, 0, 1, gSfalga_01_file, 0, 0, 2
;---
gSfalga_02_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//falga/falga-02.wav"
gifalga_02_1		 ftgen 0, 0, 0, 1, gSfalga_02_file, 0, 0, 1
gifalga_02_2		 ftgen 0, 0, 0, 1, gSfalga_02_file, 0, 0, 2
;---
gSfalga_03_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//falga/falga-03.wav"
gifalga_03_1		 ftgen 0, 0, 0, 1, gSfalga_03_file, 0, 0, 1
gifalga_03_2		 ftgen 0, 0, 0, 1, gSfalga_03_file, 0, 0, 2
;---
gSfalga_04_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//falga/falga-04.wav"
gifalga_04_1		 ftgen 0, 0, 0, 1, gSfalga_04_file, 0, 0, 1
gifalga_04_2		 ftgen 0, 0, 0, 1, gSfalga_04_file, 0, 0, 2
;---
gSfalga_05_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//falga/falga-05.wav"
gifalga_05_1		 ftgen 0, 0, 0, 1, gSfalga_05_file, 0, 0, 1
gifalga_05_2		 ftgen 0, 0, 0, 1, gSfalga_05_file, 0, 0, 2
;---
gifalga_sonvs[]			fillarray	gifalga_01_1, gifalga_01_2, gifalga_02_1, gifalga_02_2, gifalga_03_1, gifalga_03_2, gifalga_04_1, gifalga_04_2, gifalga_05_1, gifalga_05_2
gkfalga_time		init 16
gkfalga_off		init .005
gkfalga_dur		init 1
gkfalga_sonvs		init 1
gifalga_len		init lenarray(gifalga_sonvs)/2

;------------------

	instr falga

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "falga"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkfalga_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkfalga_sonvs%(gifalga_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gifalga_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "falga"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkfalga_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gifalga_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gifalga_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "falga"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkfalga_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkfalga_sonvs%(gifalga_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gifalga_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	falga, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "falga"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkfalga_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkfalga_dur

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

	opcode	falga, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "falga"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkfalga_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkfalga_dur

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
