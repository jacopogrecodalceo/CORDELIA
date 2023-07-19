instr 300
gkpulse = 110;*pump(4, fillarray(.5, 1, .25, 2))
        endin
turnoff2_i 300, (ksmps / sr) * 1, 1
schedule 300, (ksmps / sr) * 1 * 3, -1

	instr 302
gkspace_3 = 0
        endin
turnoff2_i 302, (ksmps / sr) * 3, 1
schedule 302, (ksmps / sr) * 3 * 3, -1

        instr 303
gSname_3 = "ixland"
        endin
turnoff2_i 303, (ksmps / sr) * 4, 1
schedule 303, (ksmps / sr) * 4 * 3, -1

        instr 304
gkdur_3 = (gkbeats*4)*$once(1, .5)
        endin
turnoff2_i 304, (ksmps / sr) * 5, 1
schedule 304, (ksmps / sr) * 5 * 3, -1

        instr 305
gkdyn_3 = accent(4, $f)
        endin
turnoff2_i 305, (ksmps / sr) * 6, 1
schedule 305, (ksmps / sr) * 6 * 3, -1

        instr 306
gkenv_3 = giasine
        endin
turnoff2_i 306, (ksmps / sr) * 7, 1
schedule 306, (ksmps / sr) * 7 * 3, -1

        instr 307
gkfreq_3_1 = cpstun_render(ntom("4E")+int(tablekt:k((chnget:k("heart") * 2) % 1, $once(giasine, giatri), 1)*8), gktuning)
        endin
turnoff2_i 307, (ksmps / sr) * 8, 1
schedule 307, (ksmps / sr) * 8 * 3, -1

        instr 308
gkfreq_3_2 = cpstun_render(ntom("4A")+int(tablekt:k((chnget:k("heart") * 4) % 1, $once(giasine, giatri), 1)*8), gktuning)
        endin
turnoff2_i 308, (ksmps / sr) * 9, 1
schedule 308, (ksmps / sr) * 9 * 3, -1

        instr 309
gkfreq_3_3 = 0
        endin
turnoff2_i 309, (ksmps / sr) * 10, 1
schedule 309, (ksmps / sr) * 10 * 3, -1

        instr 310
gkfreq_3_4 = 0
        endin
turnoff2_i 310, (ksmps / sr) * 11, 1
schedule 310, (ksmps / sr) * 11 * 3, -1

        instr 311
gkfreq_3_5 = 0
        endin
turnoff2_i 311, (ksmps / sr) * 12, 1
schedule 311, (ksmps / sr) * 12 * 3, -1

        instr 312

if eu(7, 8, 8) == 1 then
        eva(gkspace_3, gSname_3,
        gkdur_3,
        gkdyn_3,
        gkenv_3,
        gkfreq_3_1, 
        gkfreq_3_2, 
        gkfreq_3_3, 
        gkfreq_3_4, 
        gkfreq_3_5)
endif
        endin
turnoff2_i 312, (ksmps / sr) * 13, 1
schedule 312, (ksmps / sr) * 13 * 3, -1

        instr 313
gkroute_4_1_p1 = 1
        endin
turnoff2_i 313, (ksmps / sr) * 14, 1
schedule 313, (ksmps / sr) * 14 * 3, -1

        instr 314
getmeout("ixland", gkroute_4_1_p1)
        endin
turnoff2_i 314, (ksmps / sr) * 15, 1
schedule 314, (ksmps / sr) * 15 * 3, -1
