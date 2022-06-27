;gixylo[]  fillarray 1, 3.932, 9.538, 16.688, 24.566, 31.147
;givibes[] fillarray 1, 3.997, 9.469, 15.566, 20.863, 29.440

gixylo		ftgen		0, 0, 6, -2, 1, 3.932, 9.538, 16.688, 24.566, 31.147
givibes		ftgen		0, 0, 6, -2, 1, 3.997, 9.469, 15.566, 20.863, 29.440

gixylomorf	ftgen		0, 0, 2, -2, gixylo, givibes
gixylodummy	ftgen		0, 0, 6, 10, 1

    instr xylo

Sinstr		init "xylo"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

ienvvar		init idur/5

      		ftmorf limit(idur, 0, 12)/2, gixylomorf, gixylodummy

aenv    envgen	(idur*(1/tab_i(0, gixylodummy)))-random:i(0, ienvvar), iftenv
a1      oscil3  iamp*aenv, icps*tab_i(0, gixylodummy), gisine

aenv    envgen	(idur*(1/tab_i(1, gixylodummy)))-random:i(0, ienvvar), iftenv
a2      oscil3  iamp*aenv, icps*tab_i(1, gixylodummy), gisine

ir3     init icps*tab_i(2, gixylodummy)
if      ir3<20$k then
    iamp		= p4/2

    aenv    envgen	(idur*(1/ir3))-random:i(0, ienvvar), iftenv
    a3      oscil3  iamp*aenv, icps*ir3, gisine
    imax    init ir3

    ir4     init icps*tab_i(3, gixylodummy)
    if      ir4<20$k then
        iamp		= p4/2

        aenv    envgen	(idur*(1/ir4))-random:i(0, ienvvar), iftenv
        a4      oscil3  iamp*aenv, icps*ir4, gisine
        imax    init ir4

        ir5     init icps*tab_i(4, gixylodummy)
        if      ir5<20$k then
            iamp		= p4/2

            aenv    envgen	(idur*(1/ir5))-random:i(0, ienvvar), iftenv
            a5      oscil3  iamp*aenv, icps*ir5, gisine
            imax    init ir5

            ir6     init icps*tab_i(5, gixylodummy)
            if      ir6<20$k then
                iamp		= p4/2

                aenv    envgen	(idur*(1/ir6))-random:i(0, ienvvar), iftenv
                a6      oscil3  iamp*aenv, icps*ir6, gisine
                imax    init ir6
            endif
        endif
    endif
endif

aout    sum     a1, a2, a3, a4, a5, a6

;aout	exciter aout, icps*tab_i(0, gixylodummy)/2, imax, random:i(.5, 1)*7, random:i(5.5, 9.5)

	$death

    endin
