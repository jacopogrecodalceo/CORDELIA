	opcode	goe, k, iii	;cosine interpolation between i1 in i2[itime] to i3
	i1, it, i2 xin

if	i1==0 then
		i1 = giexpzero
endif

kout	expseg i1, it, i2

printks "➤➤➤ ➤➤➤ ➤➤➤ ➤➤➤ ➤➤➤ ➤➤➤ i'm at %f to %f)\n", 1, kout, i2

if (kout >= i2) then
	printf "Done, from %f to %f))\n", i1, i2
	kout = i2
endif

	xout kout
	endop

	opcode	golin, k, iii
i1, it, i2 xin

prints("🔜Lin(%f, %f, %f)\n", i1, it, i2)

kout	linseg i1, it, i2

if (kout == i2) then
	printf("🔚Lin(%f, %f, %f))\n", 1, i1, it, i2)
endif

xout kout
		endop

	opcode	go, k, iii	;cosine interpolation between i1 in i2[itime] to i3
	i1, it, i2 xin

kout	cosseg i1, it, i2

printks "➤➤➤ ➤➤➤ ➤➤➤ ➤➤➤ ➤➤➤ ➤➤➤ i'm at %f to %f)\n", 1, kout, i2

if (kout >= i2) then
	printf "Done, from %0.12f to %0.12f))\n", i1, i2
	kout = i2
endif

	xout kout
	endop

	opcode	goi, k, iii
	i2, it, i1 xin

prints("I'm going from %f to %f)\n", i1, i2)

kout	cosseg i1, it, i2

if (kout == i2) then
	printf("Done, from %f to %f))\n", 1, i1, i2)
endif

xout kout
		endop

	opcode	comeforme, k, i
	it xin

prints("I am coming\n")

kout	cosseg 0, it, 1

if (kout == 1) then
	printf("I came\n", 1)
endif

	xout kout
		endop

	opcode	fadeaway, k, i
	it xin

prints("I leave\n")

kout	cosseg 1, it, 0

if (kout == 0) then
	printf("Goodbye\n", 1)
endif

	xout kout
		endop
