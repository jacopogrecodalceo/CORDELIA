;	evad_kcps
#define evad_kcps(kcps) #

kch1	= kch
kch2	= (kch1%ginchnls)+1

if	($kcps != 0) then
	
	if (kch	== 0) then
		until kch > ginchnls do
			schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
			kch += 1
		od
	else 
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch1
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch2

	endif

	if gis_midi==1 then
		schedulek	"midwrite", 0, kdur, kamp, kenv, $kcps, kch, Sinstr
	endif

endif

#
	opcode	evad, 0, kSkkkkOOOO
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
	
	$evad_kcps(kcps1)	
	$evad_kcps(kcps2)	
	$evad_kcps(kcps3)	
	$evad_kcps(kcps4)	
	$evad_kcps(kcps5)	
	
	$showmek

endif

	endop

;	evad_ikcps
#define evad_ikcps(kcps) #

kch1	= kch
kch2	= (kch1%ginchnls)+1

if	($kcps != 0) then
	
	if (kch	== 0) then
		until kch > ginchnls do
			schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
			kch += 1
		od
	else 
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch1
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch2

	endif

	if gis_midi==1 then
		schedulek	"midwrite", 0, kdur, kamp, kenv, $kcps, itrack, Sinstr
	endif

endif

#
	opcode	evad_i, 0, ikSkkkkOOOO
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
	
	$evad_ikcps(kcps1)	
	$evad_ikcps(kcps2)	
	$evad_ikcps(kcps3)	
	$evad_ikcps(kcps4)	
	$evad_ikcps(kcps5)	
	
	$showmek

endif

	endop
