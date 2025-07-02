; ============
; Create as many GENs as channels
; ============
ich			filenchnls gSfile
indx		init 1
until indx > ich do
	itab ftgen indx, 0, 0, 1, gSfile, 0, 0, indx
	print indx
	indx += 1
od

gifn_len	init 8192
giasquare		ftgen	0, 0, gifn_len, 7, 1, gifn_len/2, 1, 0, 0, gifn_len/2 

		instr 1
; ============
; *** INIT ***
; ============
ifn			init p4
ich			init p4
ilen_file	init ftlen(ifn)/ftsr(ifn)

; ============
; *** VARs ***
; ============
ispeed 		init 1 ; [idur*ispeed]
kport		= 0
; ============
p3			init ilen_file*ispeed
idur		init p3
; ============

; ============
; *** READ ***
; ============
atime		phasor 1/idur
ain			table3 atime, ifn, 1

kcps, krms pitchamdf ain, 35, 2500

kfreq_samphold = 1.5+krms*35

;===================
kord 		init 425
;===================
;kfeedback 	init .95
kfeedback 	= .15 + oscil3(.75+jitter(.05, 1, 3), kfreq_samphold/2, giasquare)
anotch		phaser1 ain, samphold:k(kcps, metro(kfreq_samphold)), kord, kfeedback
anotch		= (ain / 12 - anotch) / 2

adelx			init 0
kdel_t_temp		= 1/samphold:k(kcps, metro(kfreq_samphold))*16
kdel_t			init 0
if kdel_t_temp > 1/12 then
	kdel_t = kdel_t_temp
endif

while kdel_t > 5 do
	kdel_t /= 2
od

adelx		vdelayx anotch+adelx*(1-kfeedback), a(kdel_t), 5, 4096

asum		sum anotch, adelx / 8

aout		butterhp asum, 20

		outch ich, aout

		endin


;---SCORE---
/* 
for i in range(1):
	code = [
		'i1',
		0,			# p2: when
		1,			# p3: dur
		ch			# p4
	]
	score.append(' '.join(map(str, code)))
*/
