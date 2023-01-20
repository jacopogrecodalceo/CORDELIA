gSbee01_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/bee/bee01.wav"
gibee01_1		 ftgen 0, 0, 0, 1, gSbee01_file, 0, 0, 1
gibee01_2		 ftgen 0, 0, 0, 1, gSbee01_file, 0, 0, 2
;-------
gSbee02_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/bee/bee02.wav"
gibee02_1		 ftgen 0, 0, 0, 1, gSbee02_file, 0, 0, 1
gibee02_2		 ftgen 0, 0, 0, 1, gSbee02_file, 0, 0, 2
;-------
gSbee02_complete_file 	 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/bee/bee02_complete.wav"
gibee02_complete_1		 ftgen 0, 0, 0, 1, gSbee02_complete_file, 0, 0, 1
gibee02_complete_2		 ftgen 0, 0, 0, 1, gSbee02_complete_file, 0, 0, 2
;-------
gibee_sonvs[]			fillarray	gibee01_1, gibee01_2, gibee02_1, gibee02_2, gibee02_complete_1, gibee02_complete_2;-------
gkbee_time		init 16
gkbee_off		init .005
gkbee_dur		init 1
gkbee_sonvs		init 1
gibee_len		init lenarray(gibee_sonvs)/2

;------------------

	instr bee

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "bee"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkbee_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkbee_sonvs%(gibee_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gibee_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "bee"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkbee_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gibee_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gibee_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "bee"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkbee_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkbee_sonvs%(gibee_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gibee_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	bee, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "bee"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkbee_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkbee_dur

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

	opcode	bee, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "bee"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkbee_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkbee_dur

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
