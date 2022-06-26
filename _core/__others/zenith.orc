;	instr 900, mouth
;	instr 950, clearer
;	instr 955, checker
;-----------------------------------------

#ifdef midi

	instr metrj_control

$if	eu(8, 16, 16, "heart") $then
	schedulek "metrj", 0, 25$ms
endif

	endin
	alwayson("metrj_control")


	instr metrj

	noteondur2	1, 48, 120, p3

	endin
#end

;-----------------------------------------

	instr 895

indx		init 0
until	indx == ginchnls do
	isend	init 900+((indx+1)/100)
	schedule isend, 0, -1, indx

	/*
	prints "\n\n\n!!!"
	print isend
	print indx
	prints "\n\n\n!!!"
	*/

	indx += 1
od
	turnoff

	endin
	schedule(895, 0, 1)
;-----------------------------------------
	instr 900; MOUTH

ich		init p4

		prints("👅---%f\n", p1)

aout		chnget gSmouth[ich]

;	DCBLOCK2
aout	dcblock2 aout

aout		*= gkgain

	outch gioffch+ich+1, aout

;	SEND AUDIO to OSC
kwhen		metro 5

	OSCsend kwhen, gShost, giport, sprintfk("/out%i", ich+1), "s", sprintfk("%f", k(aout))

;	CLEAR
	chnclear gSmouth[ich]

	endin
;-----------------------------------------
;	generate for each instrument a clear instrument
	instr 915

indx1	init 0
while	indx1 < ginstrslen do
		indx2	init 1
		;print indx1
		prints "%s | %i\n", gSinstrs[indx1], nstrnum(gSinstrs[indx1])
	until indx2 > ginchnls do
			isend	= 950 + (nstrnum(gSinstrs[indx1])/1000) + indx2/100000
			schedule isend, 0, -1, gSinstrs[indx1], indx2
			;print indx2
			indx2	+= 1
	od
		indx1	+= 1
od
	turnoff
	endin
	schedule(915, 0, 1)

	instr 950; CLEARER

Sinstr	strget	p4
ich		init p5

	;prints("---%s(%f) is digested\n", Sinstr, p1)
	
	chnclear sprintf("%s_%i", Sinstr, ich)

	endin

;-----------------------------------------
/*

	instr 955; CHECKER

ieach		= 2.5
ilen		lenarray gSinstrs

ihowmany	init 75

ktrig		init 1
ktrig		metro 1/ieach

kndx		init 0

kabstime	times
kmin		= int(kabstime/60)
ksec		= kabstime%60

if		ktrig == 1 then

		kndx	= 0

		until kndx == ilen do
			kactive	active gSinstrs[kndx]
			if (kactive > ihowmany) then
				printks("🧨 Watch out! %i instaces of %s\n", 0, kactive, gSinstrs[kndx])
			endif
			kndx	+= 1
		od

		printks("\n-------checking instances-------\n", 0)
		printks("--------- %.2d'  |  %.2d'' ---------\n", 0, kmin, ksec)

endif

	endin
	alwayson(955)

	instr 956

idiv 	init 1/96
kstart	init 1

if kstart == 1 then
	midiout 176, 1, 1, 2
endif

kstart = 0

;idiv 	init 1/96
;idiv	*= 64
kph	chnget	"heart"
kph	= (kph * 64 * 24) % 1

klast init -1
	
if (kph < klast) then
	midiout 176, 1, 1, 1
endif

klast = kph

	endin
	alwayson(956)
*/
