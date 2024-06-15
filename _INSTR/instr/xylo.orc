;gixylo[]  fillarray 1, 3.932, 9.538, 16.688, 24.566, 31.147
;gixylo_vibes[] fillarray 1, 3.997, 9.469, 15.566, 20.863, 29.440

gixylo_ft           ftgen		0, 0, 6, -2, 1, 3.932, 9.538, 16.688, 24.566, 31.147
gixylo_vibes		ftgen		0, 0, 6, -2, 1, 3.997, 9.469, 15.566, 20.863, 29.440

gixylo_morf         ftgen		0, 0, 2, -2, gixylo_ft, gixylo_vibes
gixylo_dummy	    ftgen		0, 0, 6, 10, 1

    $start_instr(xylo)
    $dur_var(5)
ienv_max    init idur
ienv_min    init -.75        ;the minimum for the audible
ienvvar     init .05
ifreq_max   init 20$k

      		ftmorf limit(idur, 0, 12)/2, gixylo_morf, gixylo_dummy

;-------OSCIL01            
aenv1   envgen	limit((idur*(1/tab_i(0, gixylo_dummy)))-random:i(0, ienvvar), ienv_min, ienv_max), ienv
a1      oscil3  idyn*aenv1, icps*tab_i(0, gixylo_dummy), gisine

;-------OSCIL02
aenv2   envgen	limit((idur*(1/tab_i(1, gixylo_dummy)))-random:i(0, ienvvar), ienv_min, ienv_max), ienv
a2      oscil3  idyn*aenv2, icps*tab_i(1, gixylo_dummy), gisine


;-------OSCIL03
ir3     init icps*tab_i(2, gixylo_dummy)
if      ir3<ifreq_max then
    idyn		= p4/2

    aenv3   envgen	limit((idur*(1/ir3))-random:i(0, ienvvar), ienv_min, ienv_max), ienv
    a3      oscil3  idyn*aenv3, ir3, gisine

;-------OSCIL04
    ir4     init icps*tab_i(3, gixylo_dummy)
    if      ir4<20$k then
        idyn		= p4/2

        aenv4   envgen	limit((idur*(1/ir4))-random:i(0, ienvvar), ienv_min, ienv_max), ienv
        a4      oscil3  idyn*aenv4, ir4, gisine

;-------OSCIL05
        ir5     init icps*tab_i(4, gixylo_dummy)
        if      ir5<ifreq_max then
            idyn		= p4/2

            aenv5   envgen	limit((idur*(1/ir5))-random:i(0, ienvvar), ienv_min, ienv_max), ienv
            a5      oscil3  idyn*aenv5, ir5, gisine

;-------OSCIL06
            ir6     init icps*tab_i(5, gixylo_dummy)
            if      ir6<ifreq_max then
                idyn		= p4/2

                aenv6   envgen	limit((idur*(1/ir6))-random:i(0, ienvvar), ienv_min, ienv_max), ienv
                a6      oscil3  idyn*aenv6, ir6, gisine
            endif
        endif
    endif
endif

aout        =     a1 + a2 + a3 + a4 + a5 + a6

	$end_instr
