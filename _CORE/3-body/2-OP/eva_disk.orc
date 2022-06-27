;	eva Sk

#define eva_disk_Sk_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, 0+.405, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", 0, 1, kamp, kenv, $kcps, kch, Sinstr
	endif

endif

#

	opcode	eva_disk, 0, SkkkkOOOO
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
		$eva_disk_Sk_kcps(kcps1)
		$eva_disk_Sk_kcps(kcps2)
		$eva_disk_Sk_kcps(kcps3)
		$eva_disk_Sk_kcps(kcps4)
		$eva_disk_Sk_kcps(kcps5)

	$showmek

endif

		endop


;	eva Sk

#define eva_disk1_Sk_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, 0+.405, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", 0, 1, kamp, kenv, $kcps*2, kch, Sinstr
	endif

endif

#

	opcode	eva_disk1, 0, SkkkkOOOO
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
		$eva_disk1_Sk_kcps(kcps1)
		$eva_disk1_Sk_kcps(kcps2)
		$eva_disk1_Sk_kcps(kcps3)
		$eva_disk1_Sk_kcps(kcps4)
		$eva_disk1_Sk_kcps(kcps5)

	$showmek

endif

		endop

