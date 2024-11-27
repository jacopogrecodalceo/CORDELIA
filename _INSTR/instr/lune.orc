	instr lune
	$params(lune_instr)

indx init 1
until indx > ginchnls do
	schedule Sinstr, 0, idur, idyn, ienv, icps, ich
	schedule Sinstr, 0, idur, idyn, ienv, icps/9, ich
	schedule Sinstr, 0, idur, idyn, ienv, icps/24, ich
	indx += 1
od
	turnoff
	endin

	instr lune_instr
	$params(lune)

atri		oscil3 1, icps, gitri
asaw		oscil3 1, icps, gisaw

across		linseg 0, idur/2, 1, idur/2, 0

aosc		= atri*(1-across) + asaw*across

;apoly		polynomial aosc, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1
apoly		polynomial aosc, floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2))

apoly		butterhp apoly, 35
apoly		balance2 apoly, aosc

;acheby		chebyshevpoly  adel, 0, .25, 0, .025, .015, .5, .005, .75
acheby		chebyshevpoly  apoly, random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1)
acheby		balance2 acheby, aosc

aharm		oscil3 idyn, icps*int(randomh:k(64, 128, icps)), gisquare

isize       init 4096
kperiod		init isize
iord        init 4         ; also the number of coefficients computed, typical lp orders may range from about 30 to 100 coefficients, but larger values can also be used.
iflag       init 1          ; compute flag, non-zero values switch on linear prediction analysis replacing filter coefficients, zero switch it off, keeping current filter coefficients.

avoc        lpcfilter acheby, aharm, iflag, kperiod, isize, iord

aout		balance2 avoc, aosc
aout		*= idyn
aout		*= (1-across*.5)
aout		/= 16
aout		butterhp aout, 19.5

	$dur_var(10)
	$end_instr