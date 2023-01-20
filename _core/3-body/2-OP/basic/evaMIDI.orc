	opcode	evaMIDI, 0, Siiiii
Sinstr, iwhen, idur, iamp, ienv, icps xin

if	idur > giminnote && iamp > 0 then

	;	generate event
	ich		= 1
	until ich > ginchnls do
		schedule	Sinstr, iwhen, idur, iamp, ienv, icps, ich
		ich += 1
	od

endif

	endop

	opcode	evaMIDIk, 0, Skkkkk
Sinstr, kwhen, kdur, kamp, kenv, kcps xin

if	kdur > giminnote && kamp > 0 then

	;	generate event
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, kwhen, kdur, kamp, kenv, kcps, kch
		kch += 1
	od

endif

	endop


	opcode	evaMIDImode, 0, Siiiiiii
Sinstr, iwhen, idur, iamp, ienv, icps, imode, imodp1 xin

if	idur > giminnote && iamp > 0 then

	;	generate event
	ich		= 1
	until ich > ginchnls do
		schedule	Sinstr, iwhen, idur, iamp, ienv, icps, ich, imode, imodp1
		ich += 1
	od

endif

	endop

