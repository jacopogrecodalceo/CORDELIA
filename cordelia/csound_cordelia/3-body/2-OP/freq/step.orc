opcode step, k, SikO	;classic step to use scales from Sroot using iscale output kdegree NB the last parameter is kshiftroot to shift root and scale easy NBB if step = 0 then rest

	Sroot, iscale, kdegree, kshiftroot xin 

iscaleroot ntom Sroot

kscaleroot = iscaleroot + kshiftroot

idegrees = ftlen(iscale)

ktrig	changed2 kdegree

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
	kpitch = kbase + (koct * 12) + ktab

	;schedulek   "sense_midi", 0, 1, kpitch
	kres	= cpsmidinn(kpitch)

else
	
	kres	= 0

endif

	xout kres

endop


	opcode stept, k, SikOO	;classic step to use scales from Sroot using iscale output kdegree NB the last parameter is kshiftroot to shift root and scale easy NBB if step = 0 then rest

	Sroot, iscale, kdegree, kshiftroot, ktuning xin 

iscaleroot ntom Sroot

kscaleroot = iscaleroot + kshiftroot

idegrees = ftlen(iscale)

ktrig	changed2 kdegree
kgo init 0
	
kgo = 1+(kgo%4)
kdegree -= 1

kbase = kscaleroot

koct = int(kdegree / idegrees)
kndx = kdegree % idegrees

if(kndx < 0) then
	koct -= 1
	kndx += idegrees
endif

ktab	table kndx, iscale

if ktuning == 0 then
	ktuning = gktuning
else
	ktuning = ktuning
endif

kres	= cpstun(kgo, int(kbase + (koct * 12) + ktab), ktuning)

kgo += 1


	xout kres

	endop






	opcode stepm, k, SikO	;classic step to use scales from Sroot using iscale output kdegree NB the last parameter is kshiftroot to shift root and scale easy NBB if step = 0 then rest

	Sroot, iscale, kdegree, kshiftroot xin 

iscaleroot ntom Sroot

kscaleroot = iscaleroot + kshiftroot

idegrees = ftlen(iscale)

ktrig	changed2 kdegree

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

	kres	= kbase + (koct * 12) + ktab

else
	
	kres	= 0

endif

	xout kres

	endop


	opcode step, k, iikO	;classic step to use scales from Sroot using iscale output kdegree NB the last parameter is kshiftroot to shift root and scale easy NBB if step = 0 then rest

	iscaleroot, iscale, kdegree, kshiftroot xin 

kscaleroot = iscaleroot + kshiftroot

idegrees = ftlen(iscale)

ktrig	changed2 kdegree

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



	opcode stept, k, SkOO	;classic step to use scales from Sroot using iscale output kdegree NB the last parameter is kshiftroot to shift root and scale easy NBB if step = 0 then rest

	Sroot, kdegree, kshiftroot, ktuning xin 

iscaleroot		ntom Sroot
kscaleroot		= iscaleroot + kshiftroot

ktrig			changed2 kdegree

if ktuning == 0 then
	ktuning = gktuning
else
	ktuning = ktuning
endif

kres	= cpstun(ktrig, int(kscaleroot + kdegree), ktuning)

	xout kres

	endop
