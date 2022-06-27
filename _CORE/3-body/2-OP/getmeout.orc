	opcode	getmeout, 0, SPo
Sinstr, kgain, ich	xin

if		ich==ginchnls-1 goto next
		getmeout Sinstr, kgain, ich+1

next:	

ain		chnget sprintf("%s_%i", Sinstr, ich+1)
aout		= ain

aout		*= kgain

		chnmix aout, gSmouth[ich]
	endop

	opcode	getmeout, 0, Sao
Sinstr, again, ich	xin

if		ich==ginchnls-1 goto next
		getmeout Sinstr, again, ich+1

next:	

ain		chnget sprintf("%s_%i", Sinstr, ich+1)
aout		= ain

aout		*= again

		chnmix aout, gSmouth[ich]
	endop

