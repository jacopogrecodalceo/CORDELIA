	opcode	hardduckmeout, 0, SSkk
Sin, Sout, katt, krel xin

Sin1	sprintf	"%s-1", Sin
Sin2	sprintf	"%s-2", Sin

Sout1	sprintf	"%s-1", Sout
Sout2	sprintf	"%s-2", Sout

;	routing
aout1	chnget Sout1
aout2	chnget Sout2

ain1	chnget Sin1
ain2	chnget Sin2

;	instrument
a1	compress ain1, aout1, -60, 0, 48, 9.5, katt, krel, 0
a2	compress ain2, aout2, -60, 0, 48, 9.5, katt, krel, 0

	chnmix dcblock2(a1), "mouth-1"
	chnmix dcblock2(a2), "mouth-2"

		endop

	opcode	softduckmeout, 0, SSkk
Sin, Sout, katt, krel xin

Sin1	sprintf	"%s-1", Sin
Sin2	sprintf	"%s-2", Sin

Sout1	sprintf	"%s-1", Sout
Sout2	sprintf	"%s-2", Sout

;	routing
aout1	chnget Sout1
aout2	chnget Sout2

ain1	chnget Sin1
ain2	chnget Sin2

;	instrument
a1	compress ain1, aout1, -60, 0, 48, 3.5, katt, krel, 0
a2	compress ain2, aout2, -60, 0, 48, 3.5, katt, krel, 0

	chnmix dcblock2(a1), "mouth-1"
	chnmix dcblock2(a2), "mouth-2"

		endop

	opcode	followmeout, 0, SSkkP
Sin, Sout, katt, krel, kgain xin

Sin1	sprintf	"%s-1", Sin
Sin2	sprintf	"%s-2", Sin

Sout1	sprintf	"%s-1", Sout
Sout2	sprintf	"%s-2", Sout

;	routing
ain1	chnget Sin1
ain2	chnget Sin2

aout1	chnget Sout1
aout2	chnget Sout2

;	instrument
af1	follow2 aout1, katt + randomi:k(-katt/2, katt, .05), krel + randomi:k(-krel/2, krel, .05)
af2	follow2 aout2, katt + randomi:k(-katt/2, katt, .05), krel + randomi:k(-krel/2, krel, .05)

a1	= ain1 * af1
a2	= ain2 * af2

a1	*= a(kgain)
a2	*= a(kgain)

	chnmix a1, "mouth-1"
	chnmix a2, "mouth-2"

		endop

	opcode	followdrum, 0, SP
	Sin, kgain xin

Sin1	sprintf	"%s-1", Sin
Sin2	sprintf	"%s-2", Sin

Sout	= "drum"

Sout1	sprintf	"%s-1", Sout
Sout2	sprintf	"%s-2", Sout

;	routing
ain1	chnget Sin1
ain2	chnget Sin2

aout1	chnget Sout1
aout2	chnget Sout2

katt	= .005
krel	= .5

;	instrument
af1	follow2 aout1, katt + randomi:k(-katt/2, katt, .05), krel + randomi:k(-krel/2, krel, .05)
af2	follow2 aout2, katt + randomi:k(-katt/2, katt, .05), krel + randomi:k(-krel/2, krel, .05)

a1	= ain1 * af1
a2	= ain2 * af2

a1	*= a(kgain)
a2	*= a(kgain)

	chnmix a1, "mouth-1"
	chnmix a2, "mouth-2"

		endop
