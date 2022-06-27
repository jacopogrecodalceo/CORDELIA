	opcode	getmech, 0, SOjPo
Sinstr, kch, ift, kgain, ich	xin

if	ich==ginchnls-1 goto next
		getmech Sinstr, kch, ift, kgain, ich+1

next:	

if ift == -1 then
	ift = girot
endif

imap		table ich, ift

kch		*= ginchnls

if	floor(kch)==imap-1 then
	;printsk "ch: %i map %i -- %f \n", ich+1, imap, floor(kch)

	kch	= kch%1
	ktab	table3 abs(kch/2), gisine, 1
else
	ktab	= 0
endif

ain		chnget sprintf("%s_%i", Sinstr, ich+1)
aout		= ain * ktab * 2
aout		*= kgain

		chnmix aout, gSmouth[ich]

	endop

