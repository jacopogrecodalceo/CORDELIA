;declade instr audio array
gaesq[]             init ginchnls



	instr esq

Sinstr      nstrstr p1
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

/*
BEGIN
*/

aout		vco2 iamp/4, icps

/*
END
*/

aout        *=linseg:a(0, .15, 1, p3-.15, 0)

if ich != 0 then
    gaesq[ich-1] = aout
else
    gaesq = aout
endif


	endin



    instr esq_route

ich         init p4

ain         = gaesq[ich]

aout		moogladder ain, 500, .85

gamouth[ich]     = aout

    endin

	indx init 0
	until indx == ginchnls do
		schedule nstrnum("esq_route")+(indx/1000), 0, -1, indx
		indx += 1
	od



