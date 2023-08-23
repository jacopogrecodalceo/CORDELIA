    $start_instr(burdt)
    $dur_var(10)

kndx		    = abs(jitter(1, gibeatf/16, gibeatf))

ituning		    i gktuning
ilen		    tab_i 0, ituning
ioff		    init 4
itun_len	    init ilen - ioff

ktun_dec		tab (kndx*(itun_len+1))+ioff, ituning
kcps            = icps*ktun_dec

a1              vco2 $dyn_var, kcps
a2              vco2 $dyn_var, kcps

apre            = (a1 + a2)/4

isk_freq        limit 11.5$k*($dyn_var*2.75), 20, 20$k
ksk_q           = 2+jitter:k(.5, 1/idur, 3/idur)

aout            skf apre, isk_freq, ksk_q
aout            balance2 aout, apre

    $end_instr
