#define eva_kSk_kcps(kcps) #
if $kcps > 0 && $kcps < 20000 then

	if gieva_memories == 1 then
		kdone	system gkabstime, sprintfk("echo \'%s, %f, %f, %f, %i, %f\' >> %s-%s.txt", Sinstr, gkabstime, kdur, kamp, kenv, $kcps, gScsound_score, Sinstr)
	endif
	
	if kch == 0 then
		kch = 1
		until kch > ginchnls do
			schedulek Sinstr, 0, kdur, kamp, kenv, $kcps, kch
			kch += 1
		od
		kch = 0
	else
		kch_i = ((kch-1)%ginchnls)+1
		schedulek Sinstr, 0, kdur, kamp, kenv, $kcps, kch_i
	endif
endif
#

	opcode	eva, 0, kSkkkkOOOO
kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

/*
printk2 kch
printk2 kdur
printk2 kamp
printk2 kenv
printk2 kcps1
printk2 kcps2
printk2 kcps3
printk2 kcps4
printk2 kcps5
*/

if	kdur > giminnote && kamp > 0 then

	;LIMIT kdur TO gimax_note
	if kdur > gimaxnote then
		printsk "LOOK! YOU WANTED MORE THAN %is, ARE U SHURE?\n", gimaxnote
	endif

	kdur	limit	kdur, 0, gimaxnote

	;AMPLITUDE DEPENDS ON HOW MANY NOTES
	if	(kcps1 != 0 && kcps2 == 0 && kcps3 == 0 && kcps4 == 0 && kcps5 == 0) then
		$eva_kSk_kcps(kcps1)
	elseif	(kcps1 != 0 && kcps2 != 0 && kcps3 == 0 && kcps4 == 0 && kcps5 == 0) then
		kamp *= ampdb(-5)
		$eva_kSk_kcps(kcps1)
		$eva_kSk_kcps(kcps2)
	elseif	(kcps1 != 0 && kcps2 != 0 && kcps3 != 0 && kcps4 == 0 && kcps5 == 0) then
		kamp *= ampdb(-7)
		$eva_kSk_kcps(kcps1)
		$eva_kSk_kcps(kcps2)
		$eva_kSk_kcps(kcps3)
	elseif	(kcps1 != 0 && kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 == 0) then
		kamp *= ampdb(-9)
		$eva_kSk_kcps(kcps1)
		$eva_kSk_kcps(kcps2)
		$eva_kSk_kcps(kcps3)
		$eva_kSk_kcps(kcps4)
	elseif	(kcps1 != 0 && kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 != 0) then
		kamp *= ampdb(-11)
		$eva_kSk_kcps(kcps1)
		$eva_kSk_kcps(kcps2)
		$eva_kSk_kcps(kcps3)
		$eva_kSk_kcps(kcps4)
		$eva_kSk_kcps(kcps5)
	endif

	$eva_showmek

endif

	endop

