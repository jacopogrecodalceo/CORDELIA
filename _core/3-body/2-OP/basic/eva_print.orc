#define eva_Sk_kcps(kcps) #
			if	($kcps != 0) then
				kch		= 1
				until kch > ginchnls do
					schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
					;$gen_score($kcps)
					kch += 1
				od
			endif
#

	opcode	eva_print, 0, SkkkkOOOO
Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

if	kdur > giminnote && kamp > 0 then

	;LIMIT kdur TO gimax_note
	$eva_limit

	;AMPLITUDE DEPENDS ON HOW MANY NOTES
	$eva_amp

	;GENERATE EVENT
	$eva_Sk_kcps(kcps1)
	$eva_Sk_kcps(kcps2)
	$eva_Sk_kcps(kcps3)
	$eva_Sk_kcps(kcps4)
	$eva_Sk_kcps(kcps5)

	$eva_showmek

endif

		endop

