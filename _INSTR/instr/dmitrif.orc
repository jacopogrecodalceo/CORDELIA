	instr dmitrif_control

gkdmitrif_time randomi gkbeatms, gkbeatms/4, gkbeatf/32

	

	instr dmitrif

Sinstr		init "dmitrif"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

anoi		fractalnoise cosseg(idyn, idur, 0), cosseg(0, idur, 2)

asub		resonx anoi, icps, icps/random:i(25, 10)

avco		vco2 cosseg(0, idur, idyn), icps*3/2, 10

asub		balance asub, anoi

apre		= asub + avco/5

iq			init 5

alow, ahigh, aband	svfilter  apre, cosseg(icps*4, idur, icps), iq

ivibfilter1	random 5, 7
ivibfilter2	init ivibfilter1/2

kviblow		cosseg ivibfilter1, idur, ivibfilter1*random:i(.95, 1.05)
kvibhigh	cosseg ivibfilter2, idur, ivibfilter2*random:i(.95, 1.05)

kvibhigh	= kvibhigh * expseg(1, idur/3, 1, idur/3, 2, idur/3, 2)
kviblow		= kviblow * expseg(1, idur/3, 1, idur/3, 2, idur/3, 2)

alow		*= .5 + lfo(.5, kviblow)

ahigh		*= .5 + lfo(.5, kvibhigh)

asum		= alow + ahigh + flanger(aband, expseg:a(giexpzero, idur, random:i(.065, .025)), random:i(.65, .85))

itime		i gkdmitrif_time/10
ist			init itime/4
iend		init ist+random(-itime/100, itime/100)

adel		cosseg ist, idur, iend*16

adel		samphold adel, metro(3/idur)

af1			flanger asum, adel+random(-itime/100, itime/100), .995
af1			*= oscil(1, (idyn*8)+random(-itime/100, itime/100), gisotrap)
af2			flanger af1, adel+random(-itime/100, itime/100), .995
af2			*= oscil(1, (idyn*8)+random(-itime/100, itime/100), gisotrap)
af3			flanger af2, adel+random(-itime/100, itime/100), .995
af3			*= oscil(1, (idyn*8)+random(-itime/100, itime/100), gisotrap)

aout		balance2 af3, asum

;		ENVELOPE
$dur_var(10)

		$end_instr

	
