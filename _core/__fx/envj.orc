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

;aout    oscili 1, kfreq, gitri
aout    chnget sprintf("%s_%i", Sout, ich+1)
aout    balance2 aout, aenv
