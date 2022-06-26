;	eva_karr
#define eva_karr(kcps) #

kch1	= kcharr[0]
kch2	= kcharr[1]

if	($kcps != 0) then
	
	if (kch1 == 0) then
		until kch1 > ginchnls do
			schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch1
			kch1 += 1
		od
	else 
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch1
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch2

	endif

	if gis_midi==1 then
		schedulek	"midwrite", 0, kdur, kamp, kenv, $kcps, kch1, Sinstr
	endif

endif

#

	opcode	eva, 0, k[]SkkkkOOOO
kcharr[], Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

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
	
	$eva_karr(kcps1)	
	$eva_karr(kcps2)	
	$eva_karr(kcps3)	
	$eva_karr(kcps4)	
	$eva_karr(kcps5)	
	
	$showmek

endif

	endop

