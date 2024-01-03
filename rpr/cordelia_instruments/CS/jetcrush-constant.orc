; ============
; *** INIT ***
; ============ 
ich     filenchnls gSfile
indx    init 0
until indx == ich do
    inum init indx + 1
    itab ftgen inum, 0, 0, 1, gSfile, 0, 0, inum
    indx += 1
od

; ============
; *** UDO ***
; ============ 

	opcode cordelia_decimator, a, akk

	setksmps   1

	ain, kbit, ksrate xin

kbits		=        2^kbit                ;bit depth (1 to 16)
kfold		=        (sr/ksrate)           ;sample rate
kin			downsamp ain                   ;convert to kr
kin			=        (kin+0dbfs)           ;add DC to avoid (-)
kin			=        kin*(kbits/(0dbfs*2)) ;scale signal level
kin			=        int(kin)              ;quantise
aout		upsamp   kin                   ;convert to sr
aout		=        aout*(2/kbits)-0dbfs  ;rescale and remove DC
a0ut		fold     aout, kfold           ;resample
			xout     a0ut

	endop

; ============
; *** INSTR ***
; ============ 

        instr 1

; ============
; *** INIT ***
; ============ 
ich     init p4
idur    init ftlen(ich)/sr
p3      init idur

; ============
; *** READ ***
; ============ 
andx    phasor 1/p3
ain     table3 andx, ich, 1

; ============
; *** BIT ***
; ============ 
kbit    = 8+jitter(7, .25/idur, 4/idur)
ksr     = sr/(1+abs(jitter(8, .25/idur, 4/idur)))
aout    cordelia_decimator ain, kbit, ksr

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
		ch			# p4
	]
	score.append(' '.join(map(str, code)))
*/