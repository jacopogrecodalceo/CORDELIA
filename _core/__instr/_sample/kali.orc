gSnote_1_file 	 init "../samples/opcode/kali/note_1.wav"
ginote_1_1		 ftgen 0, 0, 0, 1, gSnote_1_file, 0, 0, 1
ginote_1_2		 ftgen 0, 0, 0, 1, gSnote_1_file, 0, 0, 2
;---
gSnote_10_file 	 init "../samples/opcode/kali/note_10.wav"
ginote_10_1		 ftgen 0, 0, 0, 1, gSnote_10_file, 0, 0, 1
ginote_10_2		 ftgen 0, 0, 0, 1, gSnote_10_file, 0, 0, 2
;---
gSnote_11_file 	 init "../samples/opcode/kali/note_11.wav"
ginote_11_1		 ftgen 0, 0, 0, 1, gSnote_11_file, 0, 0, 1
ginote_11_2		 ftgen 0, 0, 0, 1, gSnote_11_file, 0, 0, 2
;---
gSnote_2_file 	 init "../samples/opcode/kali/note_2.wav"
ginote_2_1		 ftgen 0, 0, 0, 1, gSnote_2_file, 0, 0, 1
ginote_2_2		 ftgen 0, 0, 0, 1, gSnote_2_file, 0, 0, 2
;---
gSnote_3_file 	 init "../samples/opcode/kali/note_3.wav"
ginote_3_1		 ftgen 0, 0, 0, 1, gSnote_3_file, 0, 0, 1
ginote_3_2		 ftgen 0, 0, 0, 1, gSnote_3_file, 0, 0, 2
;---
gSnote_4_file 	 init "../samples/opcode/kali/note_4.wav"
ginote_4_1		 ftgen 0, 0, 0, 1, gSnote_4_file, 0, 0, 1
ginote_4_2		 ftgen 0, 0, 0, 1, gSnote_4_file, 0, 0, 2
;---
gSnote_5_file 	 init "../samples/opcode/kali/note_5.wav"
ginote_5_1		 ftgen 0, 0, 0, 1, gSnote_5_file, 0, 0, 1
ginote_5_2		 ftgen 0, 0, 0, 1, gSnote_5_file, 0, 0, 2
;---
gSnote_6_file 	 init "../samples/opcode/kali/note_6.wav"
ginote_6_1		 ftgen 0, 0, 0, 1, gSnote_6_file, 0, 0, 1
ginote_6_2		 ftgen 0, 0, 0, 1, gSnote_6_file, 0, 0, 2
;---
gSnote_7_file 	 init "../samples/opcode/kali/note_7.wav"
ginote_7_1		 ftgen 0, 0, 0, 1, gSnote_7_file, 0, 0, 1
ginote_7_2		 ftgen 0, 0, 0, 1, gSnote_7_file, 0, 0, 2
;---
gSnote_8_file 	 init "../samples/opcode/kali/note_8.wav"
ginote_8_1		 ftgen 0, 0, 0, 1, gSnote_8_file, 0, 0, 1
ginote_8_2		 ftgen 0, 0, 0, 1, gSnote_8_file, 0, 0, 2
;---
gSnote_9_file 	 init "../samples/opcode/kali/note_9.wav"
ginote_9_1		 ftgen 0, 0, 0, 1, gSnote_9_file, 0, 0, 1
ginote_9_2		 ftgen 0, 0, 0, 1, gSnote_9_file, 0, 0, 2
;---
gikali_sonvs[]			fillarray	ginote_1_1, ginote_1_2, ginote_10_1, ginote_10_2, ginote_11_1, ginote_11_2, ginote_2_1, ginote_2_2, ginote_3_1, ginote_3_2, ginote_4_1, ginote_4_2, ginote_5_1, ginote_5_2, ginote_6_1, ginote_6_2, ginote_7_1, ginote_7_2, ginote_8_1, ginote_8_2, ginote_9_1, ginote_9_2
gkkali_time		init 16
gkkali_off		init .005
gkkali_dur		init 1
gkkali_sonvs		init 1
gikali_len		init lenarray(gikali_sonvs)/2

;------------------

	instr kali

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "kali"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkkali_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkkali_sonvs%(gikali_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gikali_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "kali"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkkali_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gikali_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gikali_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "kali"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkkali_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkkali_sonvs%(gikali_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gikali_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	kali, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "kali"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkkali_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkkali_dur

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

	opcode	kali, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "kali"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkkali_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkkali_dur

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
