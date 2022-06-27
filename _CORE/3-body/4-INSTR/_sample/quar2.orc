gSquar2_01_file 	 init "../samples/quar2/quar2-01.wav"
giquar2_01_1		 ftgen 0, 0, 0, 1, gSquar2_01_file, 0, 0, 1
giquar2_01_2		 ftgen 0, 0, 0, 1, gSquar2_01_file, 0, 0, 2
;---
gSquar2_02_file 	 init "../samples/quar2/quar2-02.wav"
giquar2_02_1		 ftgen 0, 0, 0, 1, gSquar2_02_file, 0, 0, 1
giquar2_02_2		 ftgen 0, 0, 0, 1, gSquar2_02_file, 0, 0, 2
;---
gSquar2_05_file 	 init "../samples/quar2/quar2-05.wav"
giquar2_05_1		 ftgen 0, 0, 0, 1, gSquar2_05_file, 0, 0, 1
giquar2_05_2		 ftgen 0, 0, 0, 1, gSquar2_05_file, 0, 0, 2
;---
giquar2_sonvs[]			fillarray	giquar2_01_1, giquar2_01_2, giquar2_02_1, giquar2_02_2, giquar2_05_1, giquar2_05_2
gkquar2_time		init 16
gkquar2_off		init .005
gkquar2_dur		init 1
gkquar2_sonvs		init 1
giquar2_len		init lenarray(giquar2_sonvs)/2

;------------------

	instr quar2

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "quar2"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkquar2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkquar2_sonvs%(giquar2_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init giquar2_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "quar2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkquar2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(giquar2_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init giquar2_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "quar2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkquar2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkquar2_sonvs%(giquar2_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init giquar2_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	quar2, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "quar2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkquar2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkquar2_dur

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

	opcode	quar2, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "quar2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkquar2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkquar2_dur

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
