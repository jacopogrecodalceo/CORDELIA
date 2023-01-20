gSbd10_file 		 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/bd10.wav"
gibd10_chs 		 init 1
;-------
gibd10_1		 ftgen 0, 0, 0, 1, gSbd10_file, 0, 0, 1
;-------
gkbd10_time		init 16
gkbd10_off		init .005
gkbd10_dur		init 1
;-------


;-------

	instr bd10

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "bd10"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkbd10_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%gibd10_chs
	aout	tablei aph, gibd10_1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "bd10"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkbd10_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%gibd10_chs
	aout	tablei aph, gibd10_1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "bd10"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkbd10_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%gibd10_chs
	aout	tablei aph, gibd10_1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;-------

	opcode	bd10, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "bd10"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkbd10_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkbd10_dur

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

	opcode	bd10, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "bd10"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkbd10_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkbd10_dur

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
