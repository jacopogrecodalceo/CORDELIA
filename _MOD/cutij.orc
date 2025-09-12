;START CORE
PARAM_1		init 8
PARAM_2		init .5

PARAM_OUT	johanner_cut PARAM_IN, PARAM_1, 1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT


;START OPCODE

/*
	Args:  
	* asig : input signal
	* imaxdur : size of buffer in seconds
	* ksub : slicing subdivision
	* kchoice : which subdivision to use (not obvious it is useful)
	* kstutter : 1 for stutter, 0 for normal
	* kstutterspeed : speedy gonzales

*/

opcode johanner_cut, a, akkk
    ; Inputs: audio signal, number of slices, selected slice, wet mix
    asig, ksub, kchoice, kwet xin

    ;------------------------------------------------------------
    ; INITIAL SETUP
    ;------------------------------------------------------------

    imaxdur init 1
    imaxdur = imaxdur * 4
    if imaxdur < 0.5 then
        imaxdur = 4
    endif

    ; Trigger for change detection
    ktrig metro 5
    kstutter init 0
    kstutterspeed init int(random(1, 3))

    ; Ensure selected slice is within bounds
    kchoice = kchoice % ksub

    ; Change detection flags
    ksub_ch init 0
    kchoice_ch init 0
    kstutter_ch init 0

    if changed2(ktrig) == 1 then
        ksub_ch = changed2(ksub)
        kchoice_ch = changed2(kchoice)
        kstutter_ch = changed2(kstutter)
    endif

    ;------------------------------------------------------------
    ; BUFFER INITIALIZATION
    ;------------------------------------------------------------

    ilen_smps = imaxdur * sr
    ibuf ftgentmp 0, 0, ilen_smps, -2, 0
    ibuf_stutter ftgentmp 0, 0, ilen_smps, -2, 0

    ; For stutter
    kstut_sub init 1
    kstut_rpos init 0
    if kstutter_ch > 0 then
        kstut_sub = ksub
        kstut_rpos = 0
    endif
    kstut_limit = int(ilen_smps / kstut_sub)

    ;------------------------------------------------------------
    ; WRITE INPUT AUDIO TO MAIN BUFFER
    ;------------------------------------------------------------

    kwrite_ptr init 0
    kcnt = 0
    while kcnt < ksmps do
        tablew(asig[kcnt], kwrite_ptr, ibuf)
        kwrite_ptr = (kwrite_ptr + 1) % ilen_smps
        kcnt += 1
    od

    ;------------------------------------------------------------
    ; READ FROM SLICE OR STUTTER BUFFER
    ;------------------------------------------------------------

    kincr init 0
    kinit init 1
    kreach init 0
	konset init 0
    if kinit == 1 || kchoice_ch > 0 || ksub_ch > 0 then
        kplus = ilen_smps / ksub * kchoice
        kread_ptr = (kwrite_ptr + kplus) % ilen_smps
        kincr = 0
    endif

    kinit = 0

    ; STUTTER BRANCH
    if kstutter > 0 kgoto stutter

    ;------------------------------------------------------------
    ; NORMAL SLICE READING
    ;------------------------------------------------------------

    kcnt = 0
    while kcnt < ksmps do
        aout[kcnt] = table((kread_ptr + kincr + konset) % ilen_smps, ibuf)
        kincr = (kincr + 1) % int(ilen_smps / ksub)
        tablew(aout[kcnt], kincr, ibuf_stutter)
        if kincr == 0 then
            kreach = 1
			konset += random(0, 8)
			if konset >= 128 then
				konset = 0
			endif
			printk2 konset
        endif
        kcnt += 1
    od

    kgoto mix

    ;------------------------------------------------------------
    ; STUTTER READING
    ;------------------------------------------------------------

stutter:
    kcnt = 0

    while kcnt < ksmps do
        aout[kcnt] = table(kstut_rpos, ibuf_stutter)
        kstut_rpos = (kstut_rpos + kstutterspeed) % kstut_limit
        kcnt += 1
    od

    ;------------------------------------------------------------
    ; MIX INPUT AND PROCESSED SIGNAL
    ;------------------------------------------------------------

mix:
    amix = asig * (1 - kwet) + aout * kwet
    xout amix

endop
;END OPCODE
