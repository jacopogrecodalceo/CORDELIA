	opcode subscale, k, Skk ;subdivide octave from Sroot in ksub step and output kdegree 

	Sroot, ksub, kdegree xin 

kscaleroot mtof ntom(Sroot)

kmin	= kscaleroot / ksub

kfreq	= (kmin * kdegree) + kscaleroot

	xout	kfreq

	endop



	opcode step, k, SikO	;classic step to use scales from Sroot using iscale output kdegree NB the last parameter is kshiftroot to shift root and scale easy NBB if step = 0 then rest

	Sroot, iscale, kdegree, kshiftroot xin 

iscaleroot ntom Sroot

kscaleroot = iscaleroot + kshiftroot

idegrees = ftlen(iscale)

ktrig	changed kdegree

if	(kdegree != 0) then

	kdegree -= 1

	kbase = kscaleroot

	koct = int(kdegree / idegrees)
	kndx = kdegree % idegrees

	if(kndx < 0) then
		koct -= 1
		kndx += idegrees
	endif

	ktab	table kndx, iscale

	kres	= cpsmidinn(kbase + (koct * 12) + ktab)

else
	
	kres	= 0

endif

	xout kres

	endop


	opcode step, k, iikO	;classic step to use scales from Sroot using iscale output kdegree NB the last parameter is kshiftroot to shift root and scale easy NBB if step = 0 then rest

	iscaleroot, iscale, kdegree, kshiftroot xin 

kscaleroot = iscaleroot + kshiftroot

idegrees = ftlen(iscale)

ktrig	changed kdegree

if	(kdegree != 0) then

	kdegree -= 1

	kbase = kscaleroot

	koct = int(kdegree / idegrees)
	kndx = kdegree % idegrees

	if(kndx < 0) then
		koct -= 1
		kndx += idegrees
	endif

	ktab	table kndx, iscale

	kres	= cpsmidinn(kbase + (koct * 12) + ktab)

else
	
	kres	= 0

endif

	xout kres

	endop

	opcode triad, k, SikO	;for each note make a triad 
	Sroot, iscale, kdegree, kshiftroot xin 

iscaleroot ntom Sroot

kscaleroot = iscaleroot + kshiftroot

idegrees = ftlen(iscale)

ktrig	changed kdegree

kwhile	= 0
	
while kwhile < 3 do
	kdegree -= 1

	kbase = kscaleroot

	koct = int(kdegree / idegrees)
	kndx = kdegree % idegrees

	if(kndx < 0) then
		koct -= 1
		kndx += idegrees
	endif

	printk2 kwhile*kndx
	printk2 kndx

	ktab	table kndx+kwhile, iscale

	kres	= cpsmidinn(kbase + (koct * 12) + ktab)

	kwhile += 1
	xout kres
od

	endop


	opcode chromatic, k, Sk ;opcode to easy use chromatic tempered scale

	Sroot, kdegree xin 

iscaleroot ntom Sroot

idegrees = 12

kbase = iscaleroot

koct = int(kdegree / idegrees)
kndx = kdegree % idegrees

if(kndx < 0) then
	koct -= 1
	kndx += idegrees
endif

	xout cpsmidinn(kbase + (koct * 12) + kndx)
	
	endop

