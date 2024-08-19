giedo12					ftgen 0, 0, 0, -2, 12, 2/1, A4, 69, 1, 1.0594630943592953, 1.122462048309373, 1.189207115002721, 1.2599210498948732, 1.3348398541700344, 1.4142135623730951, 1.4983070768766815, 1.5874010519681994, 1.681792830507429, 1.7817974362806785, 1.8877486253633868, 2/1

gkswing	init 0

gktuning init giedo12
gktuning_len init tab_i(0, i(gktuning))
gScsound_score init ""

gSmouth[]		init ginchnls

indx		init 0
until	indx == ginchnls do
	gSmouth[indx]		sprintf	"mouth_%i", indx+1
	indx	+= 1
od

gkabstime	init 0 
gkdiv		init 64 ;max division of main tempo for heart and lungs

;	HEART
;	tempo for heart
gkpulse 	init 120
gkbeatf		init i(gkpulse) / 60
gkbeats		init 1 / (i(gkpulse) / 60)

	instr heart

if gkpulse <= 0 then
	gkpulse = gizero
endif

gkbeatf		= gkpulse / 60				;frequency for a quarter note in Hz
gkbeats		= 1 / (gkpulse / 60)		;time of a quarter note in sec
gkbeatms	= gkbeats*1000

kph		init 0
kph		phasor (gkpulse / gkdiv) / 60

aph		init 0
aph		phasor (gkpulse / gkdiv) / 60

gkbeatn		init 0				;number of beats from the beginning of session
klast_n		init -1

if (((kph*gkdiv)%1) < klast_n) then
	gkbeatn += 1
endif

klast_n	= ((kph*gkdiv)%1)

gkbeatc	init 0				;number of beats from the beginning of session
klast_c	init -1

if kph < klast_c then
	gkbeatc += 1
endif

klast_c	= kph

kswing = (kph*gkdiv)%1
if gkswing > 0 && kswing > .5 then
	kph = (.5 + (kph - .5) * (1 - gkswing/gkdiv))%1
	aph = (.5 + (aph - .5) * (1 - gkswing/gkdiv))%1
endif

	chnset	kph, "heart"
	chnset	aph, "heart_a"


gkabstime	times

if changed2(gktuning) == 1 then
	schedulek "tuning_info", 0, 1
endif

schedule "heartbeat_print", 0, 0

	endin
;	schedule("heart", .5, -1)
;	alwayson("heart")

	instr tuning_info
gktuning_len	tab 0, i(gktuning)
	turnoff
	endin

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

	turnoff

	endin


