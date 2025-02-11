
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



	opcode	eva_midi_ch, 0, Siiiiii
Sinstr, iwhen, idur, iamp, ienv, icps, ich xin

if	idur > giminnote && iamp > 0 && icps < 19500 then

	;GENERATE EVENT
	if	(icps != 0) then
		if ich == 0 then
			ilocal_ch		init 1
			until ilocal_ch > ginchnls do
				schedule	nstrnum(Sinstr), iwhen, idur, iamp, ienv, icps, ilocal_ch
				ilocal_ch += 1
			od
		else
			schedule	nstrnum(Sinstr), iwhen, idur, iamp, ienv, icps, ((ich - 1) % ginchnls) + 1
		endif
	endif

endif
	endop


