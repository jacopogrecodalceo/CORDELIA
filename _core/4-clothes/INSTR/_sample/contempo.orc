gScontempo_file 		 init "/Users/j/Documents/PROJECTs/CORDELIA/samples/contempo.wav"
gicontempo_chs 		 init 2
;-------
gicontempo_1		 ftgen 0, 0, 0, 1, gScontempo_file, 0, 0, 1
gicontempo_2		 ftgen 0, 0, 0, 1, gScontempo_file, 0, 0, 2
;-------
gkcontempo_time		init 16
gkcontempo_off		init .005
gkcontempo_dur		init 1
;-------


;-------

	instr contempo

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "contempo"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkcontempo_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%gicontempo_chs
	aout	tablei aph, gicontempo_1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "contempo"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkcontempo_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%gicontempo_chs
	aout	tablei aph, gicontempo_1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "contempo"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkcontempo_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%gicontempo_chs
	aout	tablei aph, gicontempo_1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;-------

	opcode	contempo, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "contempo"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcontempo_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcontempo_dur

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

	opcode	contempo, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "contempo"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcontempo_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcontempo_dur

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
