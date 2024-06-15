	opcode fch, k, kikP
	kbase, igen, kdest, kdiv xin 

korgan	chnget "heart"
kph	= (korgan * kdiv) % 1
kcurve	tablei kph, igen, 1

if kbase < kdest then

	kout	= kbase + (kcurve * kdest)

else

	kout	= kdest + (abs(1-kcurve) * kbase)

endif

klast init -1
kph2 = (kph*kdiv) % 1

if kph2<klast then

	kres = kout

endif

klast	= kph2	

	xout kres

	endop

