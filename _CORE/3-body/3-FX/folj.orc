;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin, Sout, kp1, kgain, ich

if  kp1==-1 then
        kp1 = 0
endif

kp1	/= 1000

aenv    follow2 chnget:a(sprintf("%s_%i", Sout, ich+1)), 5$ms, 25$ms+kp1
aout	balance2 ain, aenv
