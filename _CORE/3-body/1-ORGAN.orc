gSmouth[]		init ginchnls

indx		init 0
until	indx == ginchnls do
	gSmouth[indx]	sprintf	"mouth_%i", indx+1
	indx	+= 1
od
	printarray gSmouth

gkdiv	init 64 ;max division of main tempo for heart and lungs


;	HEART
;	tempo for heart
gkpulse		init 120 ;tempo for heart in BPM

	instr heart

if gkpulse <= 0 then
	gkpulse = gizero
endif

gkbeatf		= gkpulse / 60				;frequency for a quarter note in Hz
gkbeats		= 1 / (gkpulse / 60)		;time of a quarter note in sec
gkbeatms	= gkbeats*1000

kph		init 0
kph		phasor (gkpulse / gkdiv) / 60

gkbeatn	init 0				;number of beats from the beginning of session
klast	init -1

if (((kph*gkdiv)%1) < klast) then
	gkbeatn += 1
endif

klast	= ((kph*gkdiv)%1)

	chnset	kph, "heart"

	endin
;	schedule("heart", .5, -1)
	alwayson("heart")



gkheartbeat_print_fact init 1

	instr heartbeat_print_control

if	gkpulse < 40 then
	gkheartbeat_print_fact = 16 
elseif	gkpulse > 40 && gkpulse < 160 then
	gkheartbeat_print_fact = 8
else
	gkheartbeat_print_fact = 4
endif

kph	chnget "heart"	
kph	= (kph * gkheartbeat_print_fact)
kph	= kph % 1

klast init -1

schedule "heartbeat_print", .125, 1

if (kph < klast) then
	schedulek "heartbeat_print", 0, 1
endif

klast	= kph

	endin
	alwayson("heartbeat_print_control")

	instr heartbeat_print

gipulse		i gkpulse
gibeats		i gkbeats 
gibeatms	i gkbeatms 
gibeatf		i gkbeatf

prints("\n--------- i'm 🔥beating --------\n")
prints " 💛 %.02fbpm: %.02fs // %.02fHz 💛 \n", gipulse, gibeats, gibeatf

;---ABSOLUTE TIME AND WARN IF INSTRS ARE TOO MANY

indx		init 0
ilen		lenarray gSinstrs
ihowmany	init 75

imin		init int(times:i()/60)
isec		init times:i()%60

until indx == ilen do
	iactive	active gSinstrs[indx]
	if (iactive > ihowmany) then
		prints("🧨 Watch out! %i instaces of %s\n", iactive, gSinstrs[indx])
	endif
	indx	+= 1
od

prints("--------- %.2d'  |  %.2d'' ---------\n", imin, isec)
ifact	i gkheartbeat_print_fact
prints	"---------      %i♩      ---------\n", ifact

	turnoff

	endin
