	opcode	getmeout, 0, SPo
Sinstr, kgain, ich	xin

if		ich==ginchnls-1 goto next
		getmeout Sinstr, kgain, ich+1

next:	

ain		chnget sprintf("%s_%i", Sinstr, ich+1)
aout		= ain

		xtratim gixtratim
krel		init 0
krel		release
igain		i 1

if krel == 1 then
	kgain	*= cosseg(igain, gixtratim-gixtratim_rel, igain, gixtratim_rel, 0)
	;kgain lineto kgain, 0
endif

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

		xtratim gixtratim
krel		init 0
krel		release
igain		i 1

if krel == 1 then
	again *= cosseg(igain, gixtratim-gixtratim_rel, igain, gixtratim_rel, 0)
endif


aout		*= again

		chnmix aout, gSmouth[ich]
	endop


