;START CORE
PARAM_1		init i(gkbeats)
PARAM_2		init .5
PARAM_3		init .5

PARAM_OUT	cordelia_tapij PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

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


;END OPCODE
