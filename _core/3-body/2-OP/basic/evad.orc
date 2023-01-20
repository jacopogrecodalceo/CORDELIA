;-------------------------------------------------
;-------------------------------------------------
;-------------------------------------------------

;-------EVAD kS-------|EVA WITH DOUBLE SPEAKERS
#define evad_kS_kcps(kcps) #
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
			endif
#
	opcode	evad, 0, kSkkkkOOOO
kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

	$eva_ch

if	kdur > giminnote && kamp > 0 then

	;LIMIT kdur TO gimax_note
	$eva_limit

	;AMPLITUDE DEPENDS ON HOW MANY NOTES
	$eva_amp

	;GENERATE EVENT
	$evad_kS_kcps(kcps1)	
	$evad_kS_kcps(kcps2)	
	$evad_kS_kcps(kcps3)	
	$evad_kS_kcps(kcps4)	
	$evad_kS_kcps(kcps5)	
	
	$eva_showmek

endif

	endop
