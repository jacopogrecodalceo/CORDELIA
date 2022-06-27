;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin, Sout, kp1, kgain, ich

if  kp1==-1 then
        kp1 = 1
endif

aout    cross2 ain, chnget:a(sprintf("%s_%i", Sout, ich+1)), 4096, 8, gihan, kp1

