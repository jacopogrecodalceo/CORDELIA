gkeuarm_onset init 11
gkeuarm_pulse init 32

	opcode	euarm_sched, 0, Siiiiiii
	Sinstr, idur, idyn, ienv, icps, ich, ionset, ipulse xin

ilen	init ipulse
iprev	init -1
ieu[]	init ilen
indx	init 0

irot	init 0

while indx < ipulse do
	ival		=	int((ionset / ipulse) * indx)
	indxrot		=	(indx + irot) % ipulse
	ieu[indxrot]	=	(ival == iprev ? 0 : 1)
	iprev		=	ival
	indx		+=	1
od

inum	init 0

schedule Sinstr, 0, idur, idyn, ienv, icps, ich, 1, ipulse

iharm init ionset

while inum < ilen do

	if ieu[inum] == 1 then
		
		if inum != 0 then
			schedule Sinstr, (idur/ionset)/inum, idur, idyn, ienv, icps+((icps/ipulse)*(ipulse-inum)), ich, iharm, ipulse
			iharm -= 1
		endif

	endif		
	inum += 1
od

	endop

	instr euarm

Sinstr		init "euarm_instr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

ionset		i gkeuarm_onset
ipulse		i gkeuarm_pulse

euarm_sched(Sinstr, idur, idyn, ienv, icps, ich, ionset, ipulse)
	endin

	

	instr euarm_instr

Sinstr		init "euarm"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

iharm		init p8
ipulse		init p9

ipanfreq	init icps/250

aout		oscil3 ($dyn_var/(ipulse/6))/(iharm/3), icps + randomi:k(-ipanfreq, ipanfreq, 1/idur), gitri

	$dur_var(10)
	$end_instr

	
