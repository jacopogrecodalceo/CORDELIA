<CsoundSynthesizer>
<CsOptions>
-odac
-r=48000
--ksmps=16
--0dbfs=1
--nchnls=2
</CsOptions>
<CsInstruments>

    instr 1

k1 init 0

ilisten 	OSCinit   9999
krec		OSClisten	ilisten, "/hand0/palm:ty", "i", k1

klast		init 0
kflag		init 1
if k1 > 50 && kflag == 1 then
	schedulek 10, 0, 5, k1+100
	kflag = 0
endif

if kflag == 0 then
	klast += 1
	if klast >= int(sr/50) then
		kflag = 1
		klast = 0
	endif
endif

    endin
	alwayson(1)

gitri			ftgen	0, 0, 8192, 7, 0, 8192/4, 1, 8192/2, -1, 8192/4, 0 


	instr 10

idur		init abs(p3)
idyn		init .15
icps		init p4

ipanfreq	random -.25, .25

ifn		init gitri

ichoose[]	fillarray 1, 3
imeth		init ichoose[int(random(0, lenarray(ichoose)))]

ap		pluck .25, icps + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

;		RESONANCE

ap_res1		pluck .25, (icps*4) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth
ap_res2		pluck .25, (icps*6) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth
ap_res3		pluck .25, (icps*7) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

ap_resum	= ap_res1 + ap_res2 + ap_res3

ao_res1		oscil3 .25, icps, gitri
ao_res2		oscil3 .25, icps*3, gitri
ao_res3		oscil3 .25, icps*5, gitri
ao_res4		oscil3 .25, icps+(icps*21/9), gitri

ao_resum	= ao_res1 + ao_res2 + (ao_res3/4) + (ao_res4/6)

;		REVERB

irvt		init idur/2
arev		reverb (ap_resum/4)+(ao_resum/8), irvt

ivib[]		fillarray .5, 1, 2, 3
ivibt		init ivib[int(random(0, lenarray(ivib)))]

arev		*= 1-(oscil:k(1, .5*cosseg(0, idur*.95, 1, idur*.05, 1)))

aout		= ap + arev	
aout		dcblock2 aout
	outall aout*cosseg(0, .005, 1, p3-.005, 0)
	endin

</CsInstruments>
<CsScore>
f0 z
</CsScore>
</CsoundSynthesizer>
