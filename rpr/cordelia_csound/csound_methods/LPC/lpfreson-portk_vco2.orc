
giFRESON_RATIO		    init 1
giFREQ_RATIO            init 2
giPORT                  init .005
giSPEED                 init 1          ; [idur*ispeed]

; ============================================
; LPANAL FILEs
; ============================================
iPOLE_ORD       init 48				; npoles, number of poles for analysis. The default is 34, the maximum 50.
iHOPSIZE        init 256			; hopsize -- hop size (in samples) between frames of analysis. This determines the number of frames per second (srate / hopsize) in the output control file. The analysis framesize is hopsize * 2 samples. The default is 200, the maximum 500.
iLOWEST_FREQ    init ntof("0B")		; lowest frequency (in Hz) of pitch tracking. -P0 means no pitch tracking 
iHIGHEST_FREQ   init ntof("4B")		; maxcps, highest frequency (in Hz) of pitch tracking. The narrower the pitch range, the more accurate the pitch estimate. The defaults are -P70, -Q200.
gSlpanal_path   init "/usr/local/bin/lpanal"

indx init 0
iPOLE_FILTER init 0			; generate a pole filter file - WARNING, more dangerous
until indx == lenarray(gSfiles) do
    if iPOLE_FILTER == 0 then
        ires system_i 1, sprintf("%s -s%i -p%i -h%i -P%i -Q%i \"%s\" \"%s.lpc\"", \
                        gSlpanal_path, filesr(gSfiles[indx]), iPOLE_ORD, iHOPSIZE, iLOWEST_FREQ, iHIGHEST_FREQ, gSfiles[indx], gSfiles[indx])
    else
        ires system_i 1, sprintf("%s -a -s%i -p%i -h%i -P%i -Q%i \"%s\" \"%s.lpc\"", \
                        gSlpanal_path, filesr(gSfiles[indx]), iPOLE_ORD, iHOPSIZE, iLOWEST_FREQ, iHIGHEST_FREQ, gSfiles[indx], gSfiles[indx])
    endif
    indx += 1
od

; ============================================
; FNs
; ============================================
giFILE_nchnls	lenarray gSfiles
indx            init 0
ilimit			max giFILE_nchnls, nchnls
until indx == ilimit do
    ifn     init indx + 1
    ich     init 1
    itab    ftgen ifn, 0, 0, 1, gSfiles[indx % giFILE_nchnls], 0, 0, ich
    prints  "FN NUMBER: %i with CHANNEL: %i\n", ifn, ich
    indx   += 1
od
giFILE_sr           ftsr 1
giFILE_samp         ftlen 1
giFILE_dur          init giFILE_samp / giFILE_sr


    instr 1

; ============================================
; INIT
; ============================================
indx        init p4 
ich         init p4 + 1
ifn         init p4 + 1

Sfile		init gSfiles[indx]
Slpcanal    sprintf "%s.lpc", Sfile

p3			init giFILE_dur*giSPEED
idur		init p3

; ============================================
; READ
; ============================================
kread       				linseg 0, idur, 1
aref                        table a(kread)*giFILE_samp, ifn
krmsr, krmso, kerr, kcps 	lpread kread*giFILE_dur, Slpcanal

; ============================================
; MODIFY VARs
; ============================================
kdyn		= krmsr / pow(2, 24)
kcps        *= giFREQ_RATIO

; ============================================
; CORE
; ============================================

kcps_temp    	 init 0
kcps_last   	 init 0

if kcps != kcps_temp then
	kcps_last = kcps_temp
endif
kcps_temp = kcps

avco1      	vco2 kdyn, portk(kcps, giPORT), 2, .5, 0, 1/4
avco2      	vco2 kdyn, portk(kcps_last*2, giPORT), 12, .5, 0, 1/4

avco		sum avco1, avco2*3

asum		lpfreson avco, giFRESON_RATIO
asum		balance2 asum, aref/2

ahp	        K35_hpf asum, 9500+jitter:k(3500, 1/idur, 3/idur), 4.5+jitter:k(1.5, 1/idur, 3/idur), 1, 1.5+jitter:k(.5, 1/idur, 3/idur)

; ============================================
; DEL
; ============================================
ideltime	init idur
until ideltime < 1/64 do
	ideltime /= 3
od
kfb			= k(1-follow2(asum, .005, .125))*(.5+jitter:k(.45, 1/idur, 3/idur))
adel		flanger ahp, ideltime+a(jitter:k(ideltime/32, 1/idur, 3/idur)), kfb

; ============================================
; OUT
; ============================================
aout		sum asum, adel
aout        butterhp aout, 20

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
