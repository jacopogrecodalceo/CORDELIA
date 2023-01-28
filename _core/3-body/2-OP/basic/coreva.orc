;-------------------------------------------------
;-------------------------------------------------
;-------------------------------------------------

;-------EVA Sk-------|THE STANDARD 5-PARAMs EVA
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

	opcode	eva, 0, SkkkkOOOO
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

;-------------------------------------------------
;-------------------------------------------------
;-------------------------------------------------

;-------EVA kSk-------|EVA WITH SPACE CONTROL
#define eva_kSk_kcps(kcps) #
				if	($kcps != 0) then
					if (kch	== 0) then
						;SEND INSTR ON ALL THE SPEAKERs
						kch = 1
						until kch > ginchnls do
							schedulek	Sinstr, 0+random:k(0, kdecimal), kdur, kamp, kenv, $kcps, kch
							;$gen_score($kcps)
							kch += 1
						od
					else
						;CHOOSE THE SPEAKER TO GO
						schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
						;$gen_score($kcps)
					endif
				endif
#

	opcode	eva, 0, kSkkkkOOOO
kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

	$eva_ch

if	kdur > giminnote && kamp > 0 then

	;LIMIT kdur TO gimax_note
	$eva_limit

	;AMPLITUDE DEPENDS ON HOW MANY NOTES
	$eva_amp

	;GENERATE EVENT
	$eva_kSk_kcps(kcps1)
	$eva_kSk_kcps(kcps2)
	$eva_kSk_kcps(kcps3)
	$eva_kSk_kcps(kcps4)
	$eva_kSk_kcps(kcps5)

	$eva_showmek

endif

	endop

;-------------------------------------------------
;-------------------------------------------------
;-------------------------------------------------

;-------EVA SS-------|EVA WITH DOUBLE STRING
#define eva_SS_kcps(kcps) #
			if	($kcps != 0) then
				kch		= 1
				until kch > ginchnls do
					schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
					;$gen_score($kcps)
					kch += 1
				od
			endif
#

gkeva_SS_change init 0

	opcode	eva, 0, SSkkkkOOOO
Sinstr1, Sinstr2, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

if	gkeva_SS_change == 0 then
	Sinstr	strcpyk Sinstr1
	gkeva_SS_change = 1
else
	Sinstr	strcpyk Sinstr2
	gkeva_SS_change = 0
endif

if	kdur > giminnote && kamp > 0 then

	;LIMIT kdur TO gimax_note
	$eva_limit

	;AMPLITUDE DEPENDS ON HOW MANY NOTES
	$eva_amp

	;GENERATE EVENT
	$eva_SS_kcps(kcps1)
	$eva_SS_kcps(kcps2)
	$eva_SS_kcps(kcps3)
	$eva_SS_kcps(kcps4)
	$eva_SS_kcps(kcps5)

	$eva_showmek

endif

		endop
