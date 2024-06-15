giplumk_detune		ftgen 0, 0, 8, -21, 6, .025 ; table of detuning values for each string in a 12 string guitar configuration
gkplumk_damp init .15

	$start_instr(plumk)

idamp			limit i(gkplumk_damp), 1/64, 1-(1/32)
ipluck_pos		limit idyn, 1/64, 1

kmvt1			abs jspline(1, gibeatf/64, gibeatf/32) ; a bit of random pick-up movement animates the tone of the guitar    
kmvt2			abs jspline(1, gibeatf/64, gibeatf/32)
kmvt3			abs jspline(1, gibeatf/64, gibeatf/32)

idtn			table floor(random:i(0, 6)), giplumk_detune ; detuning value. used in 12 string guitar only.

a1			wgpluck2 ipluck_pos, idyn/2, icps, kmvt1, idamp

icps2		init icps*(2+idtn)
until icps2 < 15$k do
	icps2 init icps2/2
od
a2			wgpluck2 ipluck_pos, idyn/2, icps2, kmvt2, idamp

icps3		init icps*(6+idtn)
until icps3 < 15$k do
	icps3 init icps3/2
od
a3			wgpluck2 ipluck_pos/4, idyn*2, icps3, kmvt3, idamp
;a2			delay a2, rnd:i(.0125)                ; slight delay to second string
asig			= a1 + a2*cosseg:a(0, idur, 1) + a3*cosseg:a(0, idur, 1)

;aenv        linsegr    0, 0008, 1, idur-1008, 0, 05, 0    ; amplitude envelope. Attack removes excessive 'click'. Decays to nothing across note duration (p3). Short release stage prevents click if a note is interrupted.

/* FILTERING TO IMPROVE THE SOUND */
af1			resonz asig, 200, 200 
af2			resonz asig, 550, 550
af3			resonz asig, 2100, 2100
asig			sum af1, af2*5, af3
aout			= asig/96
/* ------------------------------ */

	$dur_var(10)
	$end_instr
