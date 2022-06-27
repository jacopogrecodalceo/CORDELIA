;	e Sk
#define e_Sk_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, kch, Sinstr
	endif

endif

#
	opcode	e, 0, SkkkkOOOO
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
		$e_Sk_kcps(kcps1)
		$e_Sk_kcps(kcps2)
		$e_Sk_kcps(kcps3)
		$e_Sk_kcps(kcps4)
		$e_Sk_kcps(kcps5)

	$showmek

endif

		endop

;	e kSk
#define e_kSk_kcps(kcps) #

if	($kcps != 0) then
	
	if (kch	== 0) then
		kch = 1
		until kch > ginchnls do
			schedulek	Sinstr, gkzero+random:k(0, kmodulo), kdur, kamp, kenv, $kcps, kch
			kch += 1
		od

		if gis_midi==1 then
			schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, kch, Sinstr
		endif

	else 
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch
		
		if gis_midi==1 then
			schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, kch, Sinstr
		endif


	endif

endif

#
	opcode	e, 0, kSkkkkOOOO
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
	$e_kSk_kcps(kcps1)
	$e_kSk_kcps(kcps2)
	$e_kSk_kcps(kcps3)
	$e_kSk_kcps(kcps4)
	$e_kSk_kcps(kcps5)

	$showmek

endif

	endop

;	e iSk
#define e_iSk_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, itrack, Sinstr
	endif

endif

#
	opcode	e, 0, iSkkkkOOOO
itrack, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

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
		$e_iSk_kcps(kcps1)
		$e_iSk_kcps(kcps2)
		$e_iSk_kcps(kcps3)
		$e_iSk_kcps(kcps4)
		$e_iSk_kcps(kcps5)

	$showmek

endif

		endop

;	e ikSk
#define e_ikSk_kcps(kcps) #

if	($kcps != 0) then
	
	if (kch	== 0) then
		kch = 1
		until kch > ginchnls do
			schedulek	Sinstr, gkzero+random:k(0, kmodulo), kdur, kamp, kenv, $kcps, kch
			kch += 1
		od

		if gis_midi==1 then
			schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, itrack, Sinstr
		endif

	else 
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch
		
		if gis_midi==1 then
			schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, itrack, Sinstr
		endif


	endif

endif

#
	opcode	e, 0, ikSkkkkOOOO
itrack, kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

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
	$e_ikSk_kcps(kcps1)
	$e_ikSk_kcps(kcps2)
	$e_ikSk_kcps(kcps3)
	$e_ikSk_kcps(kcps4)
	$e_ikSk_kcps(kcps5)

	$showmek

endif

	endop

