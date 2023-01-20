;gixylo[]  fillarray 1, 3.932, 9.538, 16.688, 24.566, 31.147
;gixylo_vibes[] fillarray 1, 3.997, 9.469, 15.566, 20.863, 29.440

gixylo_ft           ftgen		0, 0, 6, -2, 1, 3.932, 9.538, 16.688, 24.566, 31.147
gixylo_vibes		ftgen		0, 0, 6, -2, 1, 3.997, 9.469, 15.566, 20.863, 29.440

gixylo_morf         ftgen		0, 0, 2, -2, gixylo_ft, gixylo_vibes
gixylo_dummy	    ftgen		0, 0, 6, 10, 1

    instr xylo

 	$params

ienvvar		init idur/5
ienv_max    init idur
ienv_min    init -.75        ;the minimum for the audible

ifreq_max   init 20$k

      		ftmorf limit(idur, 0, 12)/2, gixylo_morf, gixylo_dummy

;-------OSCIL01            
aenv1   envgen	limit((idur*(1/tab_i(0, gixylo_dummy)))-random:i(0, ienvvar), ienv_min, ienv_max), iftenv
a1      oscil3  iamp*aenv1, icps*tab_i(0, gixylo_dummy), gisine

;-------OSCIL02
aenv2   envgen	limit((idur*(1/tab_i(1, gixylo_dummy)))-random:i(0, ienvvar), ienv_min, ienv_max), iftenv
a2      oscil3  iamp*aenv2, icps*tab_i(1, gixylo_dummy), gisine


;-------OSCIL03
ir3     init icps*tab_i(2, gixylo_dummy)
if      ir3<ifreq_max then
    iamp		= p4/2

    aenv3   envgen	limit((idur*(1/ir3))-random:i(0, ienvvar), ienv_min, ienv_max), iftenv
    a3      oscil3  iamp*aenv3, ir3, gisine

;-------OSCIL04
    ir4     init icps*tab_i(3, gixylo_dummy)
    if      ir4<20$k then
        iamp		= p4/2

        aenv4   envgen	limit((idur*(1/ir4))-random:i(0, ienvvar), ienv_min, ienv_max), iftenv
        a4      oscil3  iamp*aenv4, ir4, gisine

;-------OSCIL05
        ir5     init icps*tab_i(4, gixylo_dummy)
        if      ir5<ifreq_max then
            iamp		= p4/2

            aenv5   envgen	limit((idur*(1/ir5))-random:i(0, ienvvar), ienv_min, ienv_max), iftenv
            a5      oscil3  iamp*aenv5, ir5, gisine

;-------OSCIL06
            ir6     init icps*tab_i(5, gixylo_dummy)
            if      ir6<ifreq_max then
                iamp		= p4/2

                aenv6   envgen	limit((idur*(1/ir6))-random:i(0, ienvvar), ienv_min, ienv_max), iftenv
                a6      oscil3  iamp*aenv6, ir6, gisine
            endif
        endif
    endif
endif

aout        =     a1 + a2 + a3 + a4 + a5 + a6

	        $death

            endin
