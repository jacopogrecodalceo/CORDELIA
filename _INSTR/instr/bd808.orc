gibd808 ftgen 25, 0, 16, -2,	30000,			/* amplitude scale	     */
		0.0215,			/* delay		     */
		0.08,			/* release time		     */
		0,	1,	0,	/* X, Y, Z coordinates	     */
		32,			/* base freq. (MIDI note)    */
		4,			/* start freq. / base frq.   */
		0.007,			/* frq. envelope half-time   */
		0.25,			/* start phase (0..1)	     */
		3000,			/* lowpass filter frequency  */
		0.25			/* decay half-time	     */


	$start_instr(bd808)

ilnth	=  idur
ifn		=  gibd808		; table number

iscl	table  0, ifn	; amp. scale
idel	table  1, ifn	; delay
irel	table  2, ifn	; release time
iX		table  3, ifn	; X
iY		table  4, ifn	; Y
iZ		table  5, ifn	; Z
ibsfrq	table  6, ifn	; base frequency (MIDI note)
ifrqs	table  7, ifn	; start frequency / base frq
ifrqt	table  8, ifn	; frequency envelope half-time
iphs	table  9, ifn	; start phase (0..1)
ilpfrq	table 10, ifn	; lowpass filter frequency
idect	table 11, ifn	; decay half-time

ixtim	=  .25 + idel + irel		; expand note length
p3		=  p3 + ixtim
; note amplitude
idyn	=  $dyn_var

kcps	port 1, ifrqt, ifrqs
kcps	=  icps * kcps

a1	oscili 1, kcps, gisine, iphs
a1	butterlp a1, ilpfrq

aenv	expon 1, idect, 0.5
aenv2	linseg 1, ilnth, 1, irel, 0, 1, 0

aout	delay a1 * idyn * aenv * (aenv2 * aenv2), idel

	$dur_var(5)
	$end_instr
