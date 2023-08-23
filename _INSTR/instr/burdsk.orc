    $start_instr(burdsk)
    $dur_var(10)

icpsvar     init icps/100
iharm		init (ich%2)+1

a1		vco2 idyn*abs(lfo(1, (iharm*8)/random:i(55, 65))), (icps*iharm)+random:i(-icpsvar, icpsvar)
a2		vco2 idyn*abs(lfo(1, ((iharm+1)*8)/random:i(55, 65)))*.75, (icps*iharm)+random:i(-icpsvar, icpsvar)

apre    = a1 + a2

aout    skf apre, (20$k)*(idyn*2.75), 2+jitter:k(.5, 1/idur, 3/idur)
aout    balance2 aout, apre

    $end_instr
