;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin (ain), Sout, kp1, kgain, ich

idepth  init 512
ires    init .75

if  kp1==-1 then
        kp1 = .5
endif

aflow    follow ain, (ksmps / sr) * 128
aflow    butterlp aflow, 35

avcf    moogvcf ain, aflow*idepth, ires
aenv    balance2 aflow, avcf

kenv    k aenv

idiv    init 32
kchange init (sr / idiv)+1

if kenv>kp1 && kchange > (sr / idiv) then

	kfreq		once fillarray(.5, 2) ;probability of freezing freqs: 1/4
	kamp		once fillarray(0, 1)	
	kchange = 0

	printks2 "envfrj--change %f\n", kfreq

endif

ifftsize       	init 4096
ioverlap	init ifftsize / 4
iwinsize	init ifftsize
iwinshape	init 0

aout   		chnget sprintf("%s_%i", Sout, ich+1)

fftin		pvsanal	aout, ifftsize, ioverlap, iwinsize, iwinshape ;fft-analysis of file
freeze		pvsfreeze fftin, portk(.95+kamp, gkbeats), kfreq ;freeze amps or freqs independently
aout		pvsynth	freeze ;resynthesize

aout   		balance2 aout, aenv

kchange		+= 1


