	opcode fc3, k, SiSP
	Sroot, igen, Sdest, kdiv xin 

ifreq	ntof Sroot
idest	ntof Sdest

korgan	chnget "heart"
kph	= (korgan * kdiv) % 1
kcurve	table3 kph, igen, 1

if ifreq < idest then

	kres	= ifreq + (kcurve * idest)

else

	kres	= idest + (abs(1-kcurve) * ifreq)

endif

	xout kres

	endop

	opcode fck3, k, SiSP
	Sroot, igen, Sdest, kdiv xin 

kfreq	ntof Sroot
kdest	ntof Sdest

korgan	chnget "heart"
kph	= (korgan * kdiv) % 1
kcurve	table3 kph, igen, 1

if kfreq < kdest then

	kres	= kfreq + (kcurve * kdest)

else

	kres	= kdest + (abs(1-kcurve) * kfreq)

endif

	xout kres

	endop

	opcode fc3, k, kikP
	kbase, igen, kdest, kdiv xin 

korgan	chnget "heart"
kph	= (korgan * kdiv) % 1
kcurve	table3 kph, igen, 1

if kbase < kdest then

	kres	= kbase + (kcurve * kdest)

else

	kres	= kdest + (abs(1-kcurve) * kbase)

endif

	xout kres

	endop

