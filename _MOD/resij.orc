;START CORE
PARAM_1    init 500
PARAM_2    init .5

PARAM_OUT cordelia_res PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE
    opcode cordelia_res, a, akk
    ain, kfreq, kq xin

ilen_array      init 96
iband_high      ntof "5B"

ktuning         = gktuning

kfreqs[]	init ilen_array
if changed2(ktuning) == 1 then
    klen_tuning		tablekt 0, gktuning
    kroot_tuning	tablekt 2, gktuning

    kndx		= 0
    kfreq_indx	= 0
    koct		= 1
    until kfreq_indx >= iband_high || kndx == ilen_array do
        if kndx % klen_tuning == 0 then
            koct += 1
        endif

        kfreqs[kndx]	= koct*kroot_tuning * tablekt:k(4+(kndx % klen_tuning), ktuning)
        kfreq_indx		= kfreqs[kndx]
        kndx += 1
    od
endif

kbws[]			= kfreqs / kq * 128
abands_as[] 	poly ilen_array, "butterbp", ain, kfreqs, kbws
aout 			sumarray abands_as; /pow(2, 12)

    xout aout
    endop
;END OPCODE

