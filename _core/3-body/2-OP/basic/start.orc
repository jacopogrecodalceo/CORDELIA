	instr killstr
Sinstr init p4 
if (nstrnum(Sinstr) > 0) then
	turnoff2(Sinstr, 0, 1)
endif
	turnoff
	endin

	instr killint
inum	init p4
if (inum > 0) then
	turnoff2_i(inum, 0, 1)
endif
	turnoff
	endin


	opcode kill, 0, So
Sinstr, idel xin

schedule("killstr", 0+idel, .05, Sinstr)

	endop

	opcode killk, 0, SO
Sinstr, kdel xin

schedulek("killstr", 0+kdel, .05, Sinstr)

	endop



	opcode kill, 0, io
inum, idel xin

schedule("killint", 0+idel, .05, inum)

	endop



	opcode start, 0, So
Sinstr, idel xin

if idel == 0 then
	ireminder init 0
else
	ifact		i gkbeats
	ireminder i gkbeatr
endif

idel init (idel*ifact*giadjust)-ireminder

if (nstrnum(Sinstr) > 0) then
	kill(Sinstr, idel)
	schedule(Sinstr, gizero+idel, -1)
endif

	endop

	opcode start, 0, io
inum, idel xin

if idel == 0 then
	ireminder init 0
else
	ifact		i gkbeats
	ireminder i gkbeatr
endif

idel init (idel*ifact*giadjust)-ireminder

if (inum > 0) then
	kill(inum, idel)
	schedule(inum, gizero+idel, -1)
endif
	endop

	opcode start_nver, 0, So
Sinstr, idel xin

kndx	init 0

if idel == 0 then
	if (nstrnum(Sinstr) > 0) then
		kill(Sinstr)
		schedule(Sinstr, gizero, -1)
	endif
else
	if changed2:k(gkbeatn) == 1 then
		kndx += 1
		printk2 kndx
		if kndx == idel then
			if (nstrnum(Sinstr) > 0) then
				killk(Sinstr)
				schedulek(Sinstr, gizero, -1)
				turnoff
			endif
		endif
	endif
endif

	endop
