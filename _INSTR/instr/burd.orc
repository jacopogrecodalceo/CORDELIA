    instr burd

Sinstr      init "burd"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7
$dur_var(10)

icpsvar     init icps/100
iharm		init (ich%2)+1

a1		vco2 idyn*abs(lfo(1, (iharm*8)/random:i(55, 65))), (icps*iharm)+random:i(-icpsvar, icpsvar)
a2		vco2 idyn*abs(lfo(1, ((iharm+1)*8)/random:i(55, 65)))*.75, (icps*iharm)+random:i(-icpsvar, icpsvar)

apre    = a1 + a2

aout    moogladder2 apre, (20$k)*(idyn*2.75), random:i(.15, .25)
aout    balance2 aout, apre

    $END_INSTR

    endin
