gkeuarm2_onset init 11
gkeuarm2_pulse init 32

	opcode	euarm2_sched, 0, Siiiiiii
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

schedule Sinstr, 0, idur, idyn, ienv, icps, ich, 1, ionset

iharm init ionset

while inum < ilen do

	if ieu[inum] == 1 then
		
		if inum != 0 then
			schedule Sinstr, (idur/ionset)/inum, idur, idyn, ienv, icps+(((icps*2)/ipulse)*(ipulse-inum)), ich, iharm, ionset
			iharm -= 1
		endif

	endif		
	inum += 1
od

	endop

	instr euarm2

Sinstr		init "euarm2_instr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

ionset		i gkeuarm2_onset
ipulse		i gkeuarm2_pulse

euarm2_sched(Sinstr, idur, idyn, ienv, icps, ich, ionset, ipulse)
	endin
	

	instr euarm2_instr

Sinstr		init "euarm2"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

iharm		init p8
ionset		init p9

ipanfreq	init icps/250

aout		oscil3 ($dyn_var/(ionset/6))/(iharm/3), icps + randomi:k(-ipanfreq, ipanfreq, 1/idur), gitri

$dur_var(10)

	$end_instr

	
