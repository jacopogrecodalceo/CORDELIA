;	LFOs
	opcode	lfa, k, kk
	kamp, kfreq	xin

kout	abs	lfo(kamp, kfreq/2)

	xout	kout	
		endop

	opcode	lfi, k, kk
	kamp, kfreq	xin

kout	int	lfo(kamp, kfreq)

	xout	kout	
		endop

	opcode	lfia, k, kk

	kamp, kfreq	xin

kout	int	abs(lfo(kamp, kfreq))

	xout	kout
	
		endop

	opcode	lfp, k, kkk
	kstart,	kamp, kfreq	xin

kout	lfo	kamp, kfreq
kout	+=	kstart

	xout	kout	
		endop

	opcode	lfpa, k, kkk
	kstart,	kamp, kfreq	xin

kout	int	lfo(kamp, kfreq)
kout	+=	kstart

	xout	kout	
		endop

	opcode	lfse, k, kkk
	kstart,	kend, kfreq	xin

kamp	=	kend + (kstart*-1)
khalf	=	kamp / 2
kst	=	kend - khalf

kout	=	kst	+ lfo(khalf, kfreq)

	xout	kout	
		endop

	opcode alo, k, kO
	kfreq, kphase xin

korgan	chnget	"heart"
kph	=	korgan * kfreq
kph	+=	kphase
kph	=	kph % 1

kout	tab	kph, giasine, 1

	xout kout
	endop

;	EU modulator
	opcode	peuh, k, kkkOO
	konset, kpulses, kdiv, krot, kport xin

Sorgan	= "heart"

kprev	init -1
keu[]	init 64
kndx	init 0

while kndx < kpulses do
	kval		=	int((konset / kpulses) * kndx)
	kndxrot		=	(kndx + krot) % kpulses
	keu[kndxrot]	=	(kval == kprev ? 0 : 1)
	kprev		=	kval
	kndx		+=	1
od

korgan	chnget	Sorgan
kph	=	(korgan * kdiv) % 1
kph	=	int(kph * kpulses)

	xout	portk(keu[kph], kport/1000)

	endop


	opcode	tempovar, k, kki
	kdiv, kper, itab xin

kphasor		= ((chnget:k("heart")*kdiv)%1)*16384
ktempovar	= tab(kphasor, itab)*kper

	xout ktempovar
	endop

;	TEMPOEXP
;	a 3-points function from segments of exponential curves
gitempoexp_int		init 64
gitempoexp_intramp	init 59
gitempoexp_intbetween	init 3
gitempoexp_inthold	init gitempoexp_int - gitempoexp_intramp - gitempoexp_intbetween
;-----------------------
gitempoexp_ramp		init gitempoexp_intramp / gitempoexp_int
gitempoexp_between	init gitempoexp_intbetween / gitempoexp_int
gitempoexp_hold		init gitempoexp_inthold / gitempoexp_int
gitempoexp_sus		init .115
;-----------------------
gitempoexp		ftgen	0, 0, gienvdur, 5, giexpzero, gienvdur*gitempoexp_ramp, gitempoexp_sus, gienvdur*gitempoexp_between, 1, gienvdur*gitempoexp_hold, 1
;-----------------------

	opcode timeh, k, k
	kdiv xin

kmaxtempo	max gkpulse, delayk(gkpulse, 1.5), delayk(gkpulse, 3.5), delayk(gkpulse, 5), delayk(gkpulse, 9), delayk(gkpulse, 15)
kfact		abs kmaxtempo*.85

kphasor		= ((chnget:k("heart")*kdiv)%1)*gienvdur
ktempovar	= tab(kphasor, gitempoexp)*kfact

	xout ktempovar
	endop




	opcode cunt, k, kik
	kstart, itime, kend xin

kndx	init -1
imax	init itime-1

if	kndx==imax then
	kndx = imax
else
	kndx	+= 1
endif

kres	= kstart + (((kend-kstart)/imax)*kndx)

	xout kres
	endop
	
	opcode cunti, k, kik
	kend, itime, kstart xin

kndx	init -1
imax	init itime-1

if	kndx==imax then
	kndx = imax
else
	kndx	+= 1
endif

kres	= kstart + (((kend-kstart)/imax)*kndx)

	xout kres
	endop
