;	instruments management
instr KillImpl
  Sinstr = p4 
  if (nstrnum(Sinstr) > 0) then
    turnoff2(Sinstr, 0, 0)
  endif
  turnoff
endin

/* Turns off running instances of named instruments.  Useful when livecoding
  audio and control signal process instruments. May not be effective if for
  temporal recursion instruments as they may be non-running but scheduled in the
  event system. In those situations, try using clear_instr to overwrite the
  instrument definition. */
	opcode kill, 0, S

Sinstr xin
schedule("KillImpl", 0, .05, Sinstr)

	endop
/** Starts running a named instrument for indefinite time using p2=0 and p3=-1. 
  Will first turnoff any instances of existing named instrument first.  Useful
  when livecoding always-on audio and control signal process instruments. */
	opcode start, 0, S

Sinstr xin

if (nstrnum(Sinstr) > 0) then
	kill(Sinstr)
	schedule(Sinstr, ksmps / sr, -1)
endif

	endop

/** Given a random chance value between 0 and 1, calculates a random value and
returns 1 if value is less than chance value. For example, giving a value of 0.7,
it can read as "70 percent of time, return 1; else 0" */
	opcode	choose, i, i

iamount xin
ival = 0

if(random(0,1) < limit:i(iamount, 0, 1)) then
	ival = 1 
endif
	xout ival

	endop

	opcode	givemearray, k, kk[]S
	kdiv, karray[], Sorgan xin

klen	lenarray karray

kph	chnget	Sorgan
kph	=	int(kph * (klen * kdiv) % klen)

ktrig	changed	kph

if (karray[kph] == 1 && ktrig == 1) then
	kout = 1	
else
	kout = 0
endif

	xout	kout
		endop


	opcode	Lau, 0, Skk
Sfilcod, kfactor, kamp xin

kph	chnget	"heart"
kph	= (kph * kfactor) % 1

kdur	= (1 / (gkpulse / (60 * 64))) / kfactor

ichnls = filenchnls(Sfilcod)

if (ichnls == 1) then
	if1	ftgen 0, 0, 0, 1, Sfilcod, 0, 0, 1
	if2	ftgen 0, 0, 0, 1, Sfilcod, 0, 0, 1

elseif (ichnls == 2) then
	if1	ftgen 0, 0, 0, 1, Sfilcod, 0, 0, 1
	if2	ftgen 0, 0, 0, 1, Sfilcod, 0, 0, 2

endif

ktrig	init 1
klast	init -1

if (kph < klast) then
	schedulek("Laurence", 0, kdur, Sfilcod, kfactor, kamp, if1, if2)
endif

klast	= kph

		endop

	opcode	jump, k, k
	kfreq xin

kout	abs	lfo(1, kfreq, 3)
kout	portk	kout, .005

	xout kout
		endop



;	SCALE

gispace[] init 32

	opcode F2M, i, io
iFq, iRnd xin
iNotNum = 12 * (log(iFq/220)/log(2)) + 57
iNotNum = (iRnd == 1 ? round(iNotNum) : iNotNum)
xout iNotNum
	endop

	opcode F2M, k, kO
kFq, kRnd xin
kNotNum = 12 * (log(kFq/220)/log(2)) + 57
kNotNum = (kRnd == 1 ? round(kNotNum) : kNotNum)
xout kNotNum
	endop

opcode rotarray, i[], i[]p
 iInArr[], iPos xin
 iLen lenarray iInArr
 iOutArr[] init iLen
 iPos = (iPos < 0) ? iLen-(abs(iPos%iLen)) : iPos
 indx = 0
 while indx < iLen do
  iOutArr[indx] = iInArr[(iPos+indx)%iLen]
  indx += 1
 od
 xout iOutArr
endop

opcode rotarray, k[], k[]P
 kInArr[], kPos xin
 iLen lenarray kInArr
 kOutArr[] init iLen
 kPos = (kPos < 0) ? iLen-(abs(kPos%iLen)) : kPos
 kndx = 0
 while kndx < iLen do
  kOutArr[kndx] = kInArr[(kPos+kndx)%iLen]
  kndx += 1
 od
 xout kOutArr
endop
