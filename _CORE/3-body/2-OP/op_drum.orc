;-------DRUMs
	opcode	givemekick, 0, kkkSikk
	konset, kpulses, kdiv, Sorgan, isamp, kvar, kamp xin

if	(isamp > 0 && isamp <= 9) then
	Szero	= "00"
elseif	(isamp > 9 && isamp <= 99) then
	Szero	= "0"
elseif	(isamp > 99) then
	Szero	= ""
endif

Sfile	sprintf "kick/%s%s%d.wav", "XF_Kick_A_", Szero, isamp

if(eu(konset, kpulses, kdiv, Sorgan) == 1) then
	schedulek("drum", 0, .05, Sfile, random:k(-kvar, kvar), kamp, 1)
endif

		endop

	opcode	kali, 0, kkkSkkk
konset, kpulses, kdiv, Sorgan, ksamp, kvar, kamp xin

Sfile	sprintfk "kali/note_%d.wav", ksamp

if(eu(konset, kpulses, kdiv, Sorgan) == 1) then
	schedulek("Kali", 0, .05, Sfile, random:k(-kvar, kvar), kamp, 1)
endif
		endop

gkdnb	init 0

	opcode	givemednb, 0, kkS
	ktempo, kamp, Sorgan xin

ivar	= .05

Sohh	= "HH/open/XF_HatAna48.wav"
if (givemearray(ktempo, fillarray(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), Sorgan)) == 1 then
	schedulek("drum", 0, .05, Sohh, random:k(-ivar, ivar), kamp+random:k(-$pp, $pp), 1)
endif

kschh	init 0

Schh	sprintfk "HH/closed/real/dnb/%i.wav", kschh

if (givemearray(ktempo, fillarray(0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), Sorgan)) == 1 then
	schedulek("drum", 0, .05, Schh, random:k(-ivar, ivar), (kamp-$mf)+random:k(-$mp, $mp), 1)
	kschh = (kschh + 1) % 2
endif

;	SNARE

Ssnare = "snares/Classic/XF_SnrClassic09.wav"

ksnare[]	fillarray	0, 0, 0, 0, 
			1, 0, 0, 0,
			0, 0, 0, 0,
			1, 0, 0, 0

if (givemearray(ktempo, ksnare, Sorgan) == 1) then
	schedulek("drum", 0, .05, Ssnare, random:k(-ivar, ivar), kamp, 1)
endif

;	KICK
Skick	= "kick/XF_Kick_A_009.wav"

kkick[]	init 8

kkick0[]	fillarray 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0
kkick1[]	fillarray 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0
kkick2[]	fillarray 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0
kkick3[]	fillarray 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1

krnd	int 	random(0, 3)

if 	(gkdnb == 0) then
	kkick = kkick0
elseif	(gkdnb == 1) then
	kkick = kkick0
elseif	(gkdnb == 2) then
	kkick = kkick0

elseif	(gkdnb == 3 && krnd == 0) then
	kkick = kkick1
elseif	(gkdnb == 3 && krnd == 1) then
	kkick = kkick2
elseif	(gkdnb == 3 && krnd == 2) then
	kkick = kkick3
endif

if (givemearray(ktempo, kkick, Sorgan) == 1) then
	schedulek("drum", 0, .05, Skick, random:k(-ivar, ivar), kamp, 1)
endif

kph	chnget	Sorgan
kph	= (kph * ktempo) % 1

klast init -1

if (kph < klast) then
	gkdnb = (gkdnb + 1) % 4
endif

klast = kph

		endop
