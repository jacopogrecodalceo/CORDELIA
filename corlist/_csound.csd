<CsoundSynthesizer>
<CsOptions>
--port=10000
--udp-echo
-odac
--env:SSDIR+=../
--messagelevel=96
--m-amps=1
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 64
nchnls = 2
0dbfs  = 1

prints "I'm ready!\n"

    instr 1

;everything is transformed in ms

Sfile           init p4
istart          init p5/1000
iloop           init p6
igain           init p7

ifade_in         init p8/1000
ifade_in_mode    init p9
ifade_out        init p10/1000
ifade_out_mode   init p11

if ifade_in_mode == 0 then
    Sfade_in     init "COS"
elseif ifade_in_mode == 1 then
    Sfade_in     init "LIN"
elseif ifade_in_mode == 2 then
    Sfade_in     init "EXP"
endif

if ifade_out_mode == 0 then
    Sfade_out     init "COS"
elseif ifade_in_mode == 1 then
    Sfade_out     init "LIN"
elseif ifade_in_mode == 2 then
    Sfade_out     init "EXP"
endif

ilen            filelen Sfile   ;length of the file in seconds
idur            init ilen

                xtratim ifade_out
krel    		init 0
krel	    	release

if istart < idur*1000 then

    prints "\n---\n"
    prints "INSTR:\t\t%.003f\n", p1
    prints "FILE:\t\t%s\n", Sfile
    prints "LENGTH:\t\t%.02fs\n", idur
    prints "START AT:\t%ds\n", istart
    prints "LOOP:\t\t%s\n", iloop == 1 ? "ON" : "OFF"
    prints "FADE_IN:\t\t%s, %ims\n", Sfade_in, ifade_in*1000
    prints "FADE_OUT:\t%s, %ims\n", Sfade_out, ifade_out*1000
    prints "---\n"

    if iloop == 0 then

        ksec        init idur
        ksec_rel    init ifade_out
        if metro:k(1) == 1 then
            if krel == 0 then
                ksec -= 1
                printsk "%s", Sfile
            elseif krel == 1 then
                ksec_rel -= 1
                printsk "%s---RELEASING", Sfile
            endif
        endif

        p3  init idur-ifade_out
        if krel == 0 then
            printks2 ":	%ds left // ", ksec
            printks2 "%.02f%%\n", (ksec*100)/idur 

        elseif krel == 1 then
            ;ksec init ifade_out
            printks2 ":	%ds left // ", ksec_rel
            printks2 "%.02f%%\n", (ksec_rel*100)/ifade_out     
        endif        

    elseif iloop == 1 then

        ksec        init 0
        ksec_rel    init ifade_out
        if metro:k(1) == 1 then
            if krel == 0 then
                ksec += 1
                printsk "%s", Sfile
            elseif krel == 1 then
                ksec_rel -= 1
                printsk "%s---RELEASING", Sfile
            endif
        endif

        p3  init -1
        if krel == 0 then
            printks2 ":	in loop, %ds\n", ksec

        elseif krel == 1 then
            printks2 ":	%ds left // ", ksec_rel
            printks2 "%.02f%%\n", (ksec_rel*100)/ifade_out     
        endif   
    endif

    aout_file[]     diskin Sfile, 1, istart, iloop ;istart is in seconds
    ich_file        lenarray aout_file

    if ifade_in_mode == 0 then
        aout_file       *= cosseg(0, ifade_in, 1)
    elseif ifade_in_mode == 1 then
        aout_file       *= linseg(0, ifade_in, 1)
    elseif ifade_in_mode == 2 then
        aout_file       *= expseg(1, ifade_in, 2)-1
    endif

    if krel == 1 then

        if ifade_out_mode == 0 then
            aout_file       *= cosseg(1, ifade_out, 0)
        elseif ifade_out_mode == 1 then
            aout_file       *= linseg(1, ifade_out, 0)
        elseif ifade_in_mode == 2 then
            aout_file       *= expseg(2, ifade_out, 1)-1
        endif

        printks2 "\n---\n%.03f - RELEASE PHASE\n", p1
        printks2 "FADE_OUT:\t\t%.02fs\n---\n", ifade_out*1000

    endif

        out aout_file*igain

else

    prints "WARNING: starting point is greter than duration\n"
    turnoff2_i p1, 4, 0

endif

    endin

	instr MNEMOSINE

gSout	init p4
aouts[]	init nchnls
aouts	monitor

	fout gSout, -1, aouts

	endin

</CsInstruments>
<CsScore>
f 0 z
</CsScore>
</CsoundSynthesizer>
