	opcode fc, k, SiSJ	;classic step to use scales from Sroot using iscale output kdegree NB the last parameter is kshiftroot to shift root and scale easy NBB if step = 0 then rest

	Sroot, igen, Sdest, kdiv xin 

if kdiv == -1 then
	kdiv = gkdiv
endif

ifreq	ntof Sroot
idest	ntof Sdest

korgan	chnget "heart"
kph	= (korgan * kdiv) % 1

kcurve	tablei kph, igen, 1

kres	= ifreq + (kcurve * idest)

	xout kres

	endop

