;START CORE
PARAM_1		init 8
PARAM_2		init .5

PARAM_OUT	jcut PARAM_IN, PARAM_1, 1, PARAM_2
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

opcode jcut, a, akkk
	asig, ksub, kchoice, kwet xin

	imaxdur init i(gkbeats)
	imaxdur init imaxdur*4
	if imaxdur < .5 then
		imaxdur = 4
	endif
	kstutter init 0
	ktrig init i(gkbeatn)
	ktrig = gkbeatn

	kkey, kdown sensekey
	if gkkeyboard_spacebar == 1 then 
		kstutter = (kstutter + 1 ) % 2
		kstutterspeed = int(random:k(1, 3))
	endif

	kchoice = kchoice % ksub
	kreach init 0

	if changed2(ktrig) == 1 then
		ksub_ch = changed2(ksub)
		kchoice_ch = changed2(kchoice)
		kstutter_ch = changed2(kstutter)
	endif
	
	ilen_smps = imaxdur * sr
	ibuf ftgentmp 0, 0, ilen_smps, -2, 0
	
	kstut_sub init 1
	kstut_rpos init 0
	if(kstutter_ch > 0) then 
		kstut_sub = ksub
		kstut_rpos = 0
	endif

	kstut_limit = int(ilen_smps / kstut_sub)
	ibuf_stutter ftgentmp 0, 0, ilen_smps, -2, 0

	kwrite_ptr init 0
	
	asig init 0

	kcnt = 0
	while kcnt < ksmps do 
		tablew(asig[kcnt], kwrite_ptr, ibuf)
		kwrite_ptr = (kwrite_ptr + 1) % ilen_smps
		kcnt += 1
	od

	kincr init 0
	kinit init 1
	if(kinit == 1  || kchoice_ch > 0 || ksub_ch > 0 ) then
		kplus = ilen_smps / ksub * kchoice
		kread_ptr = (kwrite_ptr + kplus) % ilen_smps
		kincr = 0
	endif
	kreach = 0

	kcnt = 0
	if(kstutter > 0) kgoto stutter

	kinit = 0
	while kcnt < ksmps do 
		aout[kcnt] = table(  (kread_ptr + kincr) % ilen_smps, ibuf)	
		kincr = (kincr + 1) % int(ilen_smps / ksub) 
		// Write for stutter
		tablew(aout[kcnt], kincr, ibuf_stutter)
		if(kincr == 0) then 
			kreach = 1
		endif
		kcnt += 1 
	od
	kgoto nostutter

	stutter:
	kcnt = 0
	while kcnt < ksmps do 
		aout[kcnt] = table(kstut_rpos, ibuf_stutter)
		kstut_rpos = (kstut_rpos + kstutterspeed) % int(ilen_smps / kstut_sub)
		kcnt += 1		
	od

	nostutter:

amain_out	= asig*(1-kwet) + aout*kwet

	xout amain_out
endop
;END OPCODE
