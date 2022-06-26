;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin, Sout, kp1, kgain, ich

aplus init 0

if  kp1==-1 then
        kp1 = 1
endif

aplus	= ain + (aplus*.85)

aout    cross2 ain, chnget:a(sprintf("%s_%i", Sout, ich+1)), 4096, 8, gihan, kp1
aout    pdhalf aout/16, -.85
aout    pdhalf aout/16, -.95

aplus	= aout
