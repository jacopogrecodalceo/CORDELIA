;	eva Sk
#define eva_Sk_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", 0, 1, kamp, kenv, $kcps, kch, Sinstr
	endif

endif

#
	opcode	eva, 0, SkkkkOOOO
Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

if	kdur > giminnote && kamp > 0 then

		kdur	limit	kdur, gizero, gimaxnote	;limit kdur from gizero to 120

		;	amp depends on how many notes
		if	(kcps2 != 0 && kcps3 == 0 && kcps4 == 0 && kcps5 == 0) then
		kamp /= 2
		elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 == 0 && kcps5 == 0) then
		kamp /= 3
		elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 == 0) then
		kamp /= 4
		elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 != 0) then
		kamp /= 5
		endif

		;	generate event
		$eva_Sk_kcps(kcps1)
		$eva_Sk_kcps(kcps2)
		$eva_Sk_kcps(kcps3)
		$eva_Sk_kcps(kcps4)
		$eva_Sk_kcps(kcps5)

	$showmek

endif

		endop

;	eva kSk
#define eva_kSk_kcps(kcps) #

if	($kcps != 0) then
	
	if (kch	== 0) then
		kch = 1
		until kch > ginchnls do
			schedulek	Sinstr, 0+random:k(0, kmodulo), kdur, kamp, kenv, $kcps, kch
			kch += 1
		od

		if gis_midi==1 then
			schedulek	"midwrite", 0, 1, kamp, kenv, $kcps, kch, Sinstr
		endif

	else 
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
		
		if gis_midi==1 then
			schedulek	"midwrite", 0, 1, kamp, kenv, $kcps, kch, Sinstr
		endif


	endif

endif

#
	opcode	eva, 0, kSkkkkOOOO
kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

	$ch_limit

if	kdur > giminnote && kamp > 0 then

	kdur	limit	kdur, gizero, gimaxnote	;limit kdur from gizero to 120

	;	amp depends on how many notes
	if	(kcps2 != 0 && kcps3 == 0 && kcps4 == 0 && kcps5 == 0) then
	kamp /= 2
	elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 == 0 && kcps5 == 0) then
	kamp /= 3
	elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 == 0) then
	kamp /= 4
	elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 != 0) then
	kamp /= 5
	endif

	;	generate event
	$eva_kSk_kcps(kcps1)
	$eva_kSk_kcps(kcps2)
	$eva_kSk_kcps(kcps3)
	$eva_kSk_kcps(kcps4)
	$eva_kSk_kcps(kcps5)

	$showmek

endif

	endop


;	eva SS
#define eva_SS_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", 0, 1, kamp, kenv, $kcps, kch, Sinstr
	endif

endif

#
	opcode	eva, 0, SSkkkkOOOO
Sinstr1, Sinstr2, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

kchange		init 0

if	kchange == 0 then
	Sinstr	strcpyk Sinstr1
	kchange = 1
else
	Sinstr	strcpyk Sinstr2
	kchange = 0
endif


if	kdur > giminnote && kamp > 0 then

		kdur	limit	kdur, gizero, gimaxnote	;limit kdur from gizero to 120

		;	amp depends on how many notes
		if	(kcps2 != 0 && kcps3 == 0 && kcps4 == 0 && kcps5 == 0) then
		kamp /= 2
		elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 == 0 && kcps5 == 0) then
		kamp /= 3
		elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 == 0) then
		kamp /= 4
		elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 != 0) then
		kamp /= 5
		endif

		;	generate event
		$eva_SS_kcps(kcps1)
		$eva_SS_kcps(kcps2)
		$eva_SS_kcps(kcps3)
		$eva_SS_kcps(kcps4)
		$eva_SS_kcps(kcps5)

	$showmek

endif

		endop

;	ieva Sk
#define ieva_Sk_kcps(icps) #

if	($icps != 0) then	
	ich		= 1
	until ich > ginchnls do
		schedule	Sinstr, 0, idur, i(kamp), i(kenv), $icps, ich
		ich += 1
	od
endif

#
	opcode	ieva, 0, SkkkkOOOO
Sinstr, idur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

if	idur > giminnote && kamp > 0 then

		;	amp depends on how many notes
		if	(kcps2 != 0 && kcps3 == 0 && kcps4 == 0 && kcps5 == 0) then
		kamp /= 2
		elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 == 0 && kcps5 == 0) then
		kamp /= 3
		elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 == 0) then
		kamp /= 4
		elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 != 0) then
		kamp /= 5
		endif

		;	generate event
		$ieva_Sk_kcps(i(kcps1))
		$ieva_Sk_kcps(i(kcps2))
		$ieva_Sk_kcps(i(kcps3))
		$ieva_Sk_kcps(i(kcps4))
		$ieva_Sk_kcps(i(kcps5))


endif

		endop

