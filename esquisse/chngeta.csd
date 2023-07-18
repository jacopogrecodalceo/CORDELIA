<CsoundSynthesizer>
<CsOptions>
-odac -3
</CsOptions>
<CsInstruments>

sr		= 48000
ksmps 	= 128
0dbfs 	= 1

gSfile1 init "/Users/j/Desktop/envol_guest/cordelia/hegoak/_hegoak-2-render/_main/hegoak-2-_main.wav"
gSfile2 init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/bois.wav"

ichn1 filenchnls gSfile1
ichn2 filenchnls gSfile2

gaouts1[] init ichn1
gaouts2[] init ichn2

nchnls	= ichn1

gidur		filelen gSfile1
gihanning	ftgen   0, 0, 8192, 20, 2



	instr 1 

p3			init gidur
gaouts1		diskin	  gSfile1, 1

	endin



	instr 2

p3			init gidur
gaouts2		diskin	  gSfile2, 1, 0, 1

	endin

indx init 0
until indx > nchnls do
	schedule 3, 0, 1, indx
	indx += 1
od



	instr 3

p3			init gidur
ich			init p4+1
			print ich

ain			= gaouts1[ich-1]
adest 		= gaouts2[ich-1]

aout    cross2 ain, adest, 8192, 2, gihanning, 1
aout	balance2 aout, ain

	outch ich, aout + (ain*abs(lfo(1, 100/p3)))

	endin

</CsInstruments>
<CsScore>
i 1 0 1
i 2 0 1
</CsScore>
</CsoundSynthesizer>