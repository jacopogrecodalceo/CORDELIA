<CsoundSynthesizer>
<CsOptions>
-3
-m0
-D
--messagelevel=96
--m-amps=1
--env:SSDIR+=../
-+rtaudio=CoreAudio
--sample-rate=48000
--ksmps=64
--nchnls=2
</CsOptions>
<CsInstruments>

;here to be replaced
sr		    =	48000
ksmps		=	64
nchnls		=	2
0dbfs		=	1

ginchnls            init nchnls

gSinstrs[]          fillarray "esq"

gamouth[]			init ginchnls
indx	init 0
until	indx == ginchnls do
	gSmouth[indx]			sprintf	"mouth_%i", indx + 1
    schedule 900, 0, -1, indx
	indx	+= 1
od

    instr 900

Sinstr      init "mouth"
ich         init p4

ain         chnget sprintf("%s_%i", Sinstr, ich+1)
aout        = ain
            outch ich+1, aout
            chnclear gSmouth[ich]

    endin

indx	init 0
until	indx == ginchnls do
    schedule 910, 0, -1, indx
	indx	+= 1
od
    instr 910

ich         init p4
            chnclear sprintf("esq_%i", ich+1)

    endin






gSesq[]			init ginchnls
indx	init 0
until	indx == ginchnls do
	prints "creating esq_%d..\n", indx
	gSesq[indx]			sprintf	"esq_%i", indx+1
	indx	+= 1
od

	instr esq

Sinstr      nstrstr p1
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

/*
BEGIN
*/

ipanfreq	random -.25, .25
ifn			init 0
imeth		init 6
iharm		init (ich%2)+1
aout		pluck iamp, (icps*iharm) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth
ienvvar		init idur/10

/*
END
*/
    aout*=linseg:a(0, 1, 1, p3-1, 0)
    chnmix aout, sprintf("%s_%i", Sinstr, ich)

	endin


	opcode	getmeout, a, aa
ain, again	xin

aout        = ain * again

    xout aout

	endop
    schedule "esq", 1, 5, .95, 1, 300, 1
    schedule "esq", 2, 5, .95, 1, 700, 2
    event_i "e", 0, 10


    instr esq_route

Sinstr		init "esq"
ich         init p4

ain         chnget sprintf("%s_%i", Sinstr, ich+1)
aout        getmeout ain, a(1)
            
            ;outch aout, ich+1
		    
            chnmix aout, gSmouth[ich]
	        ;chnclear sprintf("%s_%i", Sinstr, ich+1)

    endin
    schedule "esq_route", 0, -1, 0
    schedule "esq_route", 0, -1, 1






</CsInstruments>
<CsScore>
f 0 z
</CsScore>
</CsoundSynthesizer>