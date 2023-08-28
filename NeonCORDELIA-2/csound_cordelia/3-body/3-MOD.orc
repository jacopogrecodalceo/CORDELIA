

;===================================
;skl
;===================================

opcode cordelia_skl, a, akk
    ain, kfreq, kq xin

ifreq_var	init 5
aout	skf ain, portk(kfreq+jitter:k(ifreq_var, gkbeatf/8, gkbeatf), 5$ms), 1+(kq*3), 0
aout	balance2 aout, ain

    xout aout
    endop


;===================================
;rinij
;===================================

opcode cordelia_ringmod, a, akk
	ain, kdiv, ktab xin

kphase		= kdiv - floor(kdiv)
kndx		= ((chnget:k("heart")*kdiv*gkdiv)+kphase)%1
kring		tableikt kndx, ktab, 1, 0, 1

aout		= ain * a(kring)

	xout aout
	endop


;===================================
;moij
;===================================

opcode cordelia_moij, a, akk
    ain, kfreq, kq xin

kfreq_var   = (kfreq*11/10)-kfreq
aout	    moogladder2 ain, kfreq+jitter(1, gkbeatf/8, gkbeatf)*kfreq_var, kq
aout	    balance2 aout, ain

    xout aout
    endop


;===================================
;sklb
;===================================

gkcordelia_sklb_port init 5$ms
gkcordelia_sklb_freq init 3

    opcode cordelia_sklb, a, akk
    ain, kfreq, kq xin

ifreq_var	init 5

kfreq1  limit kfreq + jitter:k(ifreq_var, gkbeatf/8, gkbeatf), 20, 20$k
a1      skf ain, portk(kfreq1, gkcordelia_sklb_port), 1+(kq*3), 0

a0      init 0
kfreq2  limit gkcordelia_sklb_freq*kfreq + jitter:k(ifreq_var, gkbeatf/8, gkbeatf), 20, 20$k
a2      spf a0, a0, ain, portk(kfreq2, gkcordelia_sklb_port), 2-(kq*2)

aout    = a1 + a2

aout	balance2 aout, ain

    xout aout
    endop


;===================================
;revij
;===================================

opcode reverb_1, a, akkk
	ain, ktime, khigh_freq, kmix xin

arev	nreverb ain, ktime, 1-khigh_freq
aout	= ain*(1-kmix) + arev*kmix

	xout aout
	endop


;===================================
;tapij
;===================================

; Original research and code by Jon Downing  as in paper
; Real-time digital modeling of the Roland Space Echo by Jon Downing, Christian Terjesen (ECE 472 - Audio Signal Processing, May 2016)
;
; Reimplemented in Csound by Anton Kholomiov

; Error function approximation ~ 2% accuracy
opcode ErrorFunApprox, a, a
  aIn xin
  kCoeff init ( (3.1415926535 ^ 0.5) * log(2) )
  xout tanh(kCoeff * aIn)
endop

; Bandpass Chebyshev Type I filter
opcode bandpassCheby1, a, akkii
  aIn, kLowFreq, kHighFreq, iOrder, iRipple xin

  aHigh clfilt aIn,   kLowFreq,  1, iOrder, 1, iRipple
  aLow  clfilt aHigh, kHighFreq, 0, iOrder, 1, iRipple

  xout aLow
endop

; Function to read from tape.
;
; tapeRead aIn, kDelay, kRandomSpread
;
; The function is used in the same manner as deltapi
; first init the delay buffer and the use tapeRead.
;
; aIn - input signal
; kDelay - delay time
; kRandomSpread - [0, Inf] - the random spread of reading from the tape
;    the higher the worser the quality of the tape.
opcode tapeRead, a, akk
  aIn, kDelay, kRandomSpread xin
  iTauUp = 1.07
  iTauDown = 1.89
  aPrevDelay init 0.06
  kOldDelay  init 0.06
  kLambda init 0.5

  kDelChange changed2 kDelay
  if (kDelChange == 1) then
    if (kOldDelay < kDelay) then
      kLambda = exp(-1/(iTauUp*sr))
    else
      kLambda = exp(-1/(iTauDown*sr))
    endif
  endif

  anoise noise kRandomSpread, 0
  anoise = 3*(7.5 - aPrevDelay*(10^-3))*(10^-7)*anoise
  anoiseMod butterlp anoise, 0.25  ; (0.5 / sr) * giNyquistFreq
  aActualDelay = (1 - kLambda) * kDelay + kLambda * aPrevDelay + anoiseMod
  aPrevDelay = aActualDelay
                                         ; measured
  aDelaySamps = aActualDelay * sr
  aReadSr = floor(aDelaySamps)          ; in samples
  aLastSr = aReadSr + 1                 ; in samples
  aReadIndex = aReadSr / sr             ; in seconds
  aLastIndex = aLastSr / sr             ; in seconds
  aFrac = aDelaySamps - aReadSr
  aFracScale = (1 - aFrac) * (1 + aFrac)

  aReadSample deltapi aReadIndex
  aLastSample deltapi aLastIndex

  aEcho ErrorFunApprox (aLastSample + aFracScale * (aReadSample - aLastSample))

  kOldDelay = kDelay
  xout aEcho
endop

; function to write to tape
;
; tapeWrite aIn, aOut, kFbGain
;
; It should be though of as delayw for magnetic tape.
;
; aIn - input signal
; aOut - output signal
; kFbGain - gain of feedback [0, 2]
opcode tapeWrite, 0, aak
  aIn, aOut, kFbGain xin
  iOrder    = 2
  iRippleDb = 6
  aProc bandpassCheby1 aOut * kFbGain, 95, 3000, iOrder, iRippleDb
  delayw aIn + aProc * kFbGain
endop

; Simple tape delay effect with tone-color.
;
; aIn - input signal
; kDelay - delay time
; kEchoGain - gain for the echo
; kFbGain - feedback gain
; kTone - color of the low-pass filter (frequency for the filter)
; kRandomSpread - radius of noisy reading from the tape [0.5, Inf] - relates to "tape age".
;   smaller - the better tape is
opcode TapeEcho1, a, akkkkk
  aIn, kDelay, kEchoGain, kFbGain, kTone, kRandomSpread xin

  aDummy delayr 16
  aEcho tapeRead aIn, kDelay, kRandomSpread
  aOut  = aIn + kEchoGain * aEcho

  aOut tone aOut, kTone
  tapeWrite aIn, aOut, kFbGain
  xout aOut
endop


opcode TapeEcho3, a, akkkkk
  aIn, kDelay, kEchoGain, kFbGain, kTone, kRandomSpread xin

  aDummy delayr 16
  aEcho1 tapeRead aIn, kDelay, kRandomSpread
  aEcho2 tapeRead aIn, (kDelay * 2), kRandomSpread
  aEcho3 tapeRead aIn, (kDelay * 4), kRandomSpread
  aOut  = aIn + kEchoGain * aEcho1 + 0.5 * kEchoGain * aEcho2 + 0.25 * kEchoGain * aEcho3

  aOut tone aOut, kTone
  tapeWrite aIn, aOut, kFbGain
  xout aOut
endop

opcode TapeEcho4, a, akkkkk
  aIn, kDelay, kEchoGain, kFbGain, kTone, kRandomSpread xin

  aDummy delayr 16
  aEcho1 tapeRead aIn, kDelay, kRandomSpread
  aEcho2 tapeRead aIn, (kDelay * 2), kRandomSpread
  aEcho3 tapeRead aIn, (kDelay * 4), kRandomSpread
  aEcho4 tapeRead aIn, (kDelay * 8), kRandomSpread
  aOut  = aIn + kEchoGain * aEcho1 + 0.5 * kEchoGain * aEcho2 + 0.25 * kEchoGain * aEcho3  + 0.2 * kEchoGain * aEcho4

  aOut tone aOut, kTone
  tapeWrite aIn, aOut, kFbGain
  xout aOut
endop


opcode tapeReadBatch, a, akkii
  aIn, kDelay, kRandomSpread, iSize, iStart xin

  if iStart <= iSize then
    acall tapeReadBatch aIn, kDelay, kRandomSpread, iSize, iStart + 1
  else
    acall = 0
  endif

  iScale = iStart
  aEcho tapeRead aIn, kDelay * iScale, kRandomSpread
  xout acall + aEcho / iScale
endop

opcode TapeEchoN, a, akkkkki
  aIn, kDelay, kEchoGain, kFbGain, kTone, kRandomSpread, iSize xin
  aDummy delayr (16 * iSize)
  aEcho tapeReadBatch aIn, kDelay, kRandomSpread, iSize, 1
  aOut = aIn + kEchoGain * aEcho
  tapeWrite aIn, aOut, kFbGain
  xout aOut
endop


opcode  cordelia_tapij, a, akkk
ain, ktime, kfb, kmix xin

kdel  = ktime
kvar	jitter .25, gkbeatf/8, gkbeatf

adel	TapeEchoN ain, kdel, kfb, .95, 0, .75 + kvar, 10
aout	= ain*(1-kmix) + adel*kmix

  xout aout

    endop


;===================================
;cutij
;===================================

/*
	Args:  
	* asig : input signal
	* imaxdur : size of buffer in seconds
	* ksub : slicing subdivision
	* kchoice : which subdivision to use (not obvious it is useful)
	* kstutter : 1 for stutter, 0 for normal
	* kstutterspeed : speedy gonzales

*/

opcode jcut, a, akk
	asig, ksub, kchoice xin

	imaxdur init i(gkbeats)*4
	kstutter init 0
	ktrig init i(gkbeatn)
	ktrig = gkbeatn

	kkey, kdown sensekey
	if gkkeyboard_spacebar == 1 then 
		kstutter = (kstutter + 1 ) % 2
		kstutterspeed = int(random:k(1, 3))
	endif

	kchoice = kchoice % ksub
	kreach init 0

	if changed2(ktrig) == 1 then
		ksub_ch = changed2(ksub)
		kchoice_ch = changed2(kchoice)
		kstutter_ch = changed2(kstutter)
	endif
	
	ilen_smps = imaxdur * sr
	ibuf ftgentmp 0, 0, ilen_smps, -2, 0
	
	kstut_sub init 1
	kstut_rpos init 0
	if(kstutter_ch > 0) then 
		kstut_sub = ksub
		kstut_rpos = 0
	endif

	kstut_limit = int(ilen_smps / kstut_sub)
	ibuf_stutter ftgentmp 0, 0, ilen_smps, -2, 0

	kwrite_ptr init 0
	
	asig init 0

	kcnt = 0
	while kcnt < ksmps do 
		tablew(asig[kcnt], kwrite_ptr, ibuf)
		kwrite_ptr = (kwrite_ptr + 1) % ilen_smps
		kcnt += 1
	od

	kincr init 0
	kinit init 1
	if(kinit == 1  || kchoice_ch > 0 || ksub_ch > 0 ) then
		kplus = ilen_smps / ksub * kchoice
		kread_ptr = (kwrite_ptr + kplus) % ilen_smps
		kincr = 0
	endif
	kreach = 0

	kcnt = 0
	if(kstutter > 0) kgoto stutter

	kinit = 0
	while kcnt < ksmps do 
		aout[kcnt] = table(  (kread_ptr + kincr) % ilen_smps, ibuf)	
		kincr = (kincr + 1) % int(ilen_smps / ksub) 
		// Write for stutter
		tablew(aout[kcnt], kincr, ibuf_stutter)
		if(kincr == 0) then 
			kreach = 1
		endif

		
		kcnt += 1 
	od
	kgoto nostutter

	stutter:
	kcnt = 0
	while kcnt < ksmps do 
		aout[kcnt] = table(kstut_rpos, ibuf_stutter)
		kstut_rpos = (kstut_rpos + kstutterspeed) % int(ilen_smps / kstut_sub)
		kcnt += 1		
	od

	nostutter:
	
	xout aout
endop
