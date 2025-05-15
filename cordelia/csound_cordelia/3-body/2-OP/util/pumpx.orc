	opcode	pumpx, k, kk[] ; in heart output kvals[] every kdiv
	kdiv, kvals[] xin

kdiv		init i(kdiv)
klen		lenarray kvals

kph			chnget	"heart"

kflag		init 0
kvar		init 0
kthresh 	init 2 / 3

if (kph <= kthresh) && (kflag == 0) then
	kvar = 0
	kflag = 1
endif

if (kph > kthresh) && (kflag == 1) then
	kvar		floor random(-kdiv/7, kdiv/7)
	kthresh 	random 2 / 3, 1
	printks2 "PUMPx CHANGED STATUS: %i\n", kvar
	kflag = 0
endif

kdiv		+= kvar

kph 		*= kdiv
kout		= kvals[int((kph % 1) * klen)]

	xout kout

	endop
	