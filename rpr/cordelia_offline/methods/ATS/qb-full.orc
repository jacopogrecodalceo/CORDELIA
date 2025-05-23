gioscildur		init 16384
gitri			ftgen	0, 0, gioscildur, 7, 0, gioscildur/4, 1, gioscildur/2, -1, gioscildur/4, 0
gihamming		ftgen   0, 0, gioscildur, 20, 1
gkqb_freq		init 3

	instr 1

; ============
; *** INIT ***
; ============
Satsfile	init p4
ich			init p5

; ============
; *** INFO ***
; ============
imax_p		ATSinfo	Satsfile, 3
gidur		ATSinfo	Satsfile, 7

inum		init imax_p
inum		limit inum, 1, imax_p

ipartial		init 1
until ipartial > inum do
	schedule	2, 0, 1, Satsfile, ich, ipartial
	ipartial	+= 1
od

	endin

	instr 2
; ============
; *** INIT ***
; ============
p3				init gidur
Satsfile		init p4
ich				init p5
ipartial		init p6

; ============
; *** READ ***
; ============
kread 			line 0, p3, gidur
kcps, kdyn		ATSread kread, Satsfile, ipartial

; ============
; *** CORE ***
; ============
ain1	oscil3 kdyn, kcps, gitri
ain2	oscil3 kdyn, kcps*(3/2), gitri
ain3	oscil3 kdyn, kcps*(9/8), gitri
ain4	oscil3 kdyn, kcps*(9/4), gitri

a1		= ain1; * oscil3:a(1, gkqb_freq, gihamming)
a2		= ain2; * oscil3:a(1, gkqb_freq/3, gihamming)
a3		= ain3; * oscil3:a(1, $M_PI, gihamming)
a4		= ain4; * cosseg:a(1, p3/6, 0)

apre		= a1 + (a2/2) + (a3/2) + a4 
apre		/= 4

; FXs
aph			phaser1 apre, gkqb_freq*2, 50, .75

adel		flanger apre, a(gkqb_freq)*4, .75

aout		= (apre/2) + aph + (adel*2)

aout		moogladder2 aout, 15000*(kdyn*2.75), random:i(.5, .75)
aout		balance2 aout, apre

; ============
; *** aOUT ***
; ============
	outch ich, aout
	
	endin

;---SCORE---
/* 
for i in range(1):
	code = [
		'i1',
		0,			# p2: when
		1,			# p3: dur
		ats_file,	# p4
		ch			# p5
	]
	score.append(' '.join(map(str, code)))
*/