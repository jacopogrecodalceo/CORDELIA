;	eva iSk
#define eva_iSk_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", 0, kdur, kamp, kenv, $kcps, itrack, Sinstr
	endif

endif

#
	opcode	eva_i, 0, iSkkkkOOOO
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
		$eva_iSk_kcps(kcps1)
		$eva_iSk_kcps(kcps2)
		$eva_iSk_kcps(kcps3)
		$eva_iSk_kcps(kcps4)
		$eva_iSk_kcps(kcps5)

	$showmek

endif

		endop

;	eva ikSk
#define eva_ikSk_kcps(kcps) #

if	($kcps != 0) then
	
	if (kch	== 0) then
		kch = 1
		until kch > ginchnls do
			schedulek	Sinstr, 0+random:k(0, kmodulo), kdur, kamp, kenv, $kcps, kch
			kch += 1
		od

		if gis_midi==1 then
			schedulek	"midwrite", 0, kdur, kamp, kenv, $kcps, itrack, Sinstr
		endif

	else 
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
		
		if gis_midi==1 then
			schedulek	"midwrite", 0, kdur, kamp, kenv, $kcps, itrack, Sinstr
		endif


	endif

endif

#
	opcode	eva_i, 0, ikSkkkkOOOO
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
	$eva_ikSk_kcps(kcps1)
	$eva_ikSk_kcps(kcps2)
	$eva_ikSk_kcps(kcps3)
	$eva_ikSk_kcps(kcps4)
	$eva_ikSk_kcps(kcps5)

	$showmek

endif

	endop

