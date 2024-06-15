	opcode	one, k, 0

kres	init 0

if	kres==1 then
	xout kres
	printk2 kres
endif

kres	+= 1

	endop
