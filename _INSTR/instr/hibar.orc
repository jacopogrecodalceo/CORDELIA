	$start_instr(hibar)

until icps < 1 do
	icps /= 2
od

; ============
; METALLIC NOISE
; ============
kbcL init 3 ; Boundary condition at left end of bar (1 is clamped, 2 pivoting and 3 free).
kbcR init 1 ; Boundary condition at right end of bar (1 is clamped, 2 pivoting and 3 free).

iK init 3 ; dimensionless stiffness parameter. If this parameter is negative then the initialisation is skipped and the previous state of the bar is continued.
ib init icps/100 ; high-frequency loss parameter (keep this small).

kscan init .25 ; Speed of scanning the output location.

iT30 init 9; 30 db decay time in seconds.

ipos random .895, .95; position along the bar that the strike occurs.
ivel init idyn$k; normalized strike velocity.
iwid init .35; spatial width of strike.

anoi barmodel kbcL, kbcR, iK, ib, kscan, iT30, ipos, ivel, iwid

; ============
; RESONANT BANDPASS
; ============
kfreq init 13.5$k
kq init .5
kdrive init .85
a_, a_, aout, a_ svn anoi, kfreq, kq, kdrive

; ============
; DISTORTION
; ============

aout chebyshevpoly aout, 0, icps, 0, icps, 0, icps, 0, icps;$hibar_jit, $hibar_jit, $hibar_jit, $hibar_jit, $hibar_jit, $hibar_jit

; ============
; ENVELOPE
; ============
	$dur_var(10)
	$env_gen

; ============
; HIGHPASS
; ============
kfreq = cosseg(11.5, idur, 1.5)$k
kq limit .5+idyn, .5, 1
kdrive init .75
aout, a_, a_, a_ svn aout, kfreq, kq, kdrive
aout *= 2048
	$channel_mix
	endin
