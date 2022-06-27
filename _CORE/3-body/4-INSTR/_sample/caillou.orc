gScaillou_001_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//caillou/caillou-001.wav"
gicaillou_001_1		 ftgen 0, 0, 0, 1, gScaillou_001_file, 0, 0, 1
gicaillou_001_2		 ftgen 0, 0, 0, 1, gScaillou_001_file, 0, 0, 2
;---
gScaillou_002_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//caillou/caillou-002.wav"
gicaillou_002_1		 ftgen 0, 0, 0, 1, gScaillou_002_file, 0, 0, 1
gicaillou_002_2		 ftgen 0, 0, 0, 1, gScaillou_002_file, 0, 0, 2
;---
gScaillou_003_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//caillou/caillou-003.wav"
gicaillou_003_1		 ftgen 0, 0, 0, 1, gScaillou_003_file, 0, 0, 1
gicaillou_003_2		 ftgen 0, 0, 0, 1, gScaillou_003_file, 0, 0, 2
;---
gScaillou_004_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//caillou/caillou-004.wav"
gicaillou_004_1		 ftgen 0, 0, 0, 1, gScaillou_004_file, 0, 0, 1
gicaillou_004_2		 ftgen 0, 0, 0, 1, gScaillou_004_file, 0, 0, 2
;---
gScaillou_005_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//caillou/caillou-005.wav"
gicaillou_005_1		 ftgen 0, 0, 0, 1, gScaillou_005_file, 0, 0, 1
gicaillou_005_2		 ftgen 0, 0, 0, 1, gScaillou_005_file, 0, 0, 2
;---
gScaillou_006_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//caillou/caillou-006.wav"
gicaillou_006_1		 ftgen 0, 0, 0, 1, gScaillou_006_file, 0, 0, 1
gicaillou_006_2		 ftgen 0, 0, 0, 1, gScaillou_006_file, 0, 0, 2
;---
gScaillou_007_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples//caillou/caillou-007.wav"
gicaillou_007_1		 ftgen 0, 0, 0, 1, gScaillou_007_file, 0, 0, 1
gicaillou_007_2		 ftgen 0, 0, 0, 1, gScaillou_007_file, 0, 0, 2
;---
gicaillou_sonvs[]			fillarray	gicaillou_001_1, gicaillou_001_2, gicaillou_002_1, gicaillou_002_2, gicaillou_003_1, gicaillou_003_2, gicaillou_004_1, gicaillou_004_2, gicaillou_005_1, gicaillou_005_2, gicaillou_006_1, gicaillou_006_2, gicaillou_007_1, gicaillou_007_2
gkcaillou_time		init 16
gkcaillou_off		init .005
gkcaillou_dur		init 1
gkcaillou_sonvs		init 1
gicaillou_len		init lenarray(gicaillou_sonvs)/2

;------------------

	instr caillou

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "caillou"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkcaillou_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkcaillou_sonvs%(gicaillou_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gicaillou_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "caillou"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkcaillou_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gicaillou_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gicaillou_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "caillou"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkcaillou_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkcaillou_sonvs%(gicaillou_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gicaillou_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	caillou, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "caillou"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcaillou_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcaillou_dur

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

	opcode	caillou, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "caillou"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcaillou_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcaillou_dur

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
