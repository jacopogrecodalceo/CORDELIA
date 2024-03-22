
	opcode	eva_midi, 0, Siiiii
Sinstr, iwhen, idur, iamp, ienv, icps xin

if	idur > giminnote && iamp > 0 && icps < 19500 then

	;GENERATE EVENT
	if	(icps != 0) then
		ich		init 1
		until ich > ginchnls do
			schedule	nstrnum(Sinstr), iwhen, idur, iamp, ienv, icps, ich
			ich += 1
		od
	endif

endif
	endop


