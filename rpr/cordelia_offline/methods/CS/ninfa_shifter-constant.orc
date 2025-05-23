giSPEED	init 1 ; [idur*ispeed]

; ============================================
; FNs
; ============================================
giFILE_nchnls	filenchnls gSfile
indx            init 0
ilimit			max giFILE_nchnls, nchnls
until indx == ilimit do
    ifn     = indx + 1
    ich     = (indx % (giFILE_nchnls <= nchnls ? giFILE_nchnls : nchnls)) + 1
    itab    ftgen ifn, 0, 0, 1, gSfile, 0, 0, ich
    prints  "FN NUMBER: %i with CHANNEL: %i\n", ifn, ich
    indx   += 1
od
giFILE_sr           ftsr 1
giFILE_samp         ftlen 1
giFILE_dur          init giFILE_samp / giFILE_sr


gifn_len	init 8192
gisine		ftgen	0, 0, gifn_len, 10, 1
gisquare	ftgen	0, 0, gifn_len, 7, 1, gifn_len/2, 1, 0, -1, gifn_len/2, -1
gitri		ftgen	0, 0, gifn_len, 7, 0, gifn_len/4, 1, gifn_len/2, -1, gifn_len/4, 0
gisaw		ftgen	0, 0, gifn_len, 7, 1, gifn_len, -1

gimorf		ftgen 	0, 0, gifn_len, 10, 1

	opcode morphing, i, kiiooo
	kndx, ift1, ift2, ift3, ift4, ift5 xin

ifno		init gisine

iftmorf1	abs	floor(ift1)
iftmorf2	abs	floor(ift2)
iftmorf3	abs	floor(ift3)
iftmorf4	abs	floor(ift4)
iftmorf5	abs	floor(ift5)

ifact		init .995

if	ift3==0 then
	ifno	ftgenonce 0, 0, 2, -2, iftmorf1, iftmorf2
		ftmorf kndx*ifact, ifno, gimorf
elseif	ift3>0&&ift4==0 then
	ifno	ftgenonce 0, 0, 3, -2, iftmorf1, iftmorf2, iftmorf3
		ftmorf kndx*(ifact+1), ifno, gimorf
elseif	ift4>0&&ift5==0 then
	ifno	ftgenonce 0, 0, 4, -2, iftmorf1, iftmorf2, iftmorf3, iftmorf4
		ftmorf kndx*(ifact+2), ifno, gimorf
elseif	ift5>0 then
	ifno	ftgenonce 0, 0, 5, -2, iftmorf1, iftmorf2, iftmorf3, iftmorf4, iftmorf5
		ftmorf kndx*(ifact+3), ifno, gimorf
endif

	xout gimorf
	endop

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
p3			init ilen_file*giSPEED
idur		init p3
; ============

; ============
; *** READ ***
; ============
atime		phasor 1/idur
ain			table3 atime, ifn, 1

; ============
; *** MORPH ***
; ============
kmorph_indx		linseg 0, p3, 1
imorph_ft1		init morphing(kmorph_indx, gisine, gisquare, gisine)
imorph_ft2		init morphing(kmorph_indx, gisaw, gitri, gisaw)

; ============
; *** TRSHIFT ***
; ============

ipv_size		init 4096
ipv_hop			init ipv_size/2
ipv_win			init 1 ; O: Hamming, 1: Hanning
ffr, fph		pvsifd	ain, ipv_size, ipv_hop, ipv_win

fsig			partials ffr, fph, .00125, 1, 5, ipv_size

kfreq, kamp		pvspitch ffr, .0125

f1				trshift fsig, kfreq*2;12+jitter(6, 1/p3, 2/p3)
f2				trshift fsig, kfreq/3;12+jitter(6, 1/p3, 2/p3)

kpitch			init 1
a1				tradsyn f1, 1, kpitch, ipv_size, imorph_ft1
a2				tradsyn f2, 1, kpitch, ipv_size, imorph_ft2

aout			sum a1, a2

		outch ich, aout / 2

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