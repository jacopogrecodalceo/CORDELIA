	opcode	getallout, 0, Po
kgain, indx xin

if	indx==((ginstrslen*ginchnls)-1) goto next
	getallout kgain, indx+1

next:	

inum	init indx%ginstrslen
ich	init indx%ginchnls

;prints sprintf("%s_%i\n", gSinstrs[inum], ich+1)

ain		chnget sprintf("%s_%i", gSinstrs[inum], ich+1)
aout		= ain * portk(kgain, 5$ms)

		chnmix aout, gSmouth[ich]
	endop

