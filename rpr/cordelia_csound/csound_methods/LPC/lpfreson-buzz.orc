
giRATIO		init 1
giSPEED     init 1          ; [idur*ispeed]

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
; FUNCTIONs
; ============================================
    instr 1

; ============================================
; INIT
; ============================================
indx        init p4
ich         init indx + 1

Sfile		init gSfiles[indx]
ilen_sec	filelen Sfile
Slpcanal    sprintf "%s.lpc", Sfile

p3			init ilen_sec*giSPEED
idur		init p3

; ============================================
; READ
; ============================================
kread       				linseg 0, idur, ilen_sec
krmsr, krmso, kerr, kcps 	lpread kread, Slpcanal

; ============================================
; CORE
; ============================================
kdyn		= krmsr / 8192
kn_harm 	divz sr / 2, kcps, 0

; aref is mono because files are created mono before removing them
aref		diskin gSfiles[indx], giRATIO
abuzz      	buzz kdyn / 512, kcps, int(kn_harm), -1
asum		lpfreson abuzz, giRATIO
asum		balance2 asum, aref

ahp	K35_hpf asum, 9500+jitter:k(3500, 1/idur, 3/idur), 4.5+jitter:k(1.5, 1/idur, 3/idur), 1, 1.5+jitter:k(.5, 1/idur, 3/idur)

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
