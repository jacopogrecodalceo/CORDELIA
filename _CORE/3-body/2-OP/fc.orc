	opcode fc, k, SiSP
	Sroot, igen, Sdest, kdiv xin 

ifreq	ntof Sroot
idest	ntof Sdest

korgan	chnget "heart"
kph	= (korgan * kdiv) % 1
kcurve	tablei kph, igen, 1

if ifreq < idest then

	kres	= ifreq + (kcurve * idest)

else

	kres	= idest + (abs(1-kcurve) * ifreq)

endif

	xout kres

	endop

	opcode fc, k, kikP
	kbase, igen, kdest, kdiv xin 

korgan	chnget "heart"
kph	= (korgan * kdiv) % 1
kcurve	tablei kph, igen, 1

if kbase < kdest then

	kres	= kbase + (kcurve * kdest)

else

	kres	= kdest + (abs(1-kcurve) * kbase)

endif

	xout kres

	endop

