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


#ifdef hydraudiosync


		instr sender;	schedule tick	

	;kph	init 250
	kph	chnget "heart"
	kph	= (kph * 64) * 24
	kph	= kph % 1

	klast init -1
		
	if (kph < klast) then
	;if metro(25)==1 then
		schedulek "sendsamp", 0, 1
	endif

	klast	= kph

		mrtmsg 1

		endin
		schedule("sender", 0, -1)

		instr revive_control

	kph	chnget "heart"
	kph	= (kph * 4)
	kph	= kph % 1

	klast init -1
		
	if (kph < klast) then
	;if metro(25)==1 then
		schedulek "revive", 0, 1
	endif

	klast	= kph

		endin
		schedule("revive_control", 0, -1)

		instr revive

		mrtmsg 1
		turnoff

		endin


		instr sendsamp

	aout	init 1 
		;print 1
		outch 3, aout

		turnoff

		endin

		instr sendtempo

	kval	= gkpulse
	kval	= kval / 300

		outch 4, a(kval)

		endin
		alwayson("sendtempo")

#end


#ifdef midi

gis_midi init 1

prints "MIDISENDMODE"

	instr gotomidi

idur	= p3
iamp	= p4 * 127
icps	= p5

Sinstr	strget p6

ichn	= 1

indx	init 0

while 	indx < ginstrslen do

	ipos	strcmp Sinstr, gSinstrs[indx]

	if	ipos == 0 then
		itrack = indx
	endif

	indx += 1

od

inote	ftom icps, 2

	noteondur2	ichn, inote, iamp, idur

	endin


	instr midwrite

idur	init p3
iamp	init p4
ienv	init p5
icps	init p6
ich 	init p7
Sinstr	strget p8

inote	ftom icps

itime	times

; real score 
idone	system_i 1, sprintf("echo \'i\t\"%s\"\t%f\t%f\t%f\t%f\t\"%s\"\' >> %s", Sinstr, itime, idur, iamp, inote, sprintf("%i_%s", ich, Sinstr), "./*_i.sco")
 
; dummy score for midi
;idone	system_i 1, sprintf("echo \'i\t\"%s\"\t%f\t%f\t%f\t%f\t\"%s\"\' >> %s", "midwrite", itime, idur, iamp, inote, Sinstr, "./___.sco")

iamp	init iamp * 127

	noteondur2	1+ich, inote, limit(iamp, 25, 127), .125
	
	turnoff

	;midiout_i 244, 1+ich, 0, 96

	;midiout_i 144, 1+ich, inote, limit(iamp, 25, 127)
	
	endin


#end

#ifdef diskclavier

gis_midi init 1

prints "MIDISENDMODE"

	instr midwrite

idur	init p3
iamp	init p4*2
ienv	init p5
icps	init p6
ich 	init 0
Sinstr	strget p8

inote	ftom icps

if idur<10 then
	idur *= 100
	idur floor idur
	idur /= 100

elseif idur>=10 && idur<100 then
	idur *= 100
	idur floor idur
	idur /= 100

elseif idur>=100 && idur<1000 then
	idur *= 100
	idur floor idur
	idur /= 10000

endif


itime	times

if itime<10 then 
	itime *= 10
	itime floor itime
	itime /= 10

elseif itime>=10 && itime<100 then
	itime *= 10
	itime floor itime
	itime /= 10

elseif itime>=100 && itime<1000 then
	itime *= 10
	itime floor itime
	itime /= 10

endif

; real score 
idone	system_i 1, sprintf("echo \'i\t\"%s\"\t%f\t%f\t%f\t%f\t\"%s\"\' >> %s", Sinstr, itime, idur, iamp, inote, Sinstr, "./___.sco")
 
; dummy score for midi
;idone	system_i 1, sprintf("echo \'i\t\"%s\"\t%f\t%f\t%f\t%f\t\"%s\"\' >> %s", "midwrite", itime, idur, iamp, inote, Sinstr, "./___.sco")

iamp	init iamp * 127

	noteondur2	1+ich, inote, limit(iamp, 25, 127), idur/2

	endin


#end
