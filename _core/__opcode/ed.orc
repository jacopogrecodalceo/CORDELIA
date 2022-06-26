;	ed_kcps
#define ed_kcps(kcps) #

kch1	= kch
kch2	= (kch1%ginchnls)+1

if	($kcps != 0) then
	
	if (kch	== 0) then
		until kch > ginchnls do
			schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch
			kch += 1
		od
	else 
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch1
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch2

	endif

	if gis_midi==1 then
		schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, kch, Sinstr
	endif

endif

#
	opcode	ed, 0, kSkkkkOOOO
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
	
	$ed_kcps(kcps1)	
	$ed_kcps(kcps2)	
	$ed_kcps(kcps3)	
	$ed_kcps(kcps4)	
	$ed_kcps(kcps5)	
	
	$showmek

endif

	endop

;	ed_ikcps
#define ed_ikcps(kcps) #

kch1	= kch
kch2	= (kch1%ginchnls)+1

if	($kcps != 0) then
	
	if (kch	== 0) then
		until kch > ginchnls do
			schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch
			kch += 1
		od
	else 
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch1
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch2

	endif

	if gis_midi==1 then
		schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, itrack, Sinstr
	endif

endif

#
	opcode	ed, 0, ikSkkkkOOOO
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
	
	$ed_ikcps(kcps1)	
	$ed_ikcps(kcps2)	
	$ed_ikcps(kcps3)	
	$ed_ikcps(kcps4)	
	$ed_ikcps(kcps5)	
	
	$showmek

endif

	endop
