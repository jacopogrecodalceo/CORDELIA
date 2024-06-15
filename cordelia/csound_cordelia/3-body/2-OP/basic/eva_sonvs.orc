
	opcode	eva_sonvs, 0, kSkkkk
kch, Sinstr, kdur, kamp, kenv, kcps xin

/*
printk2 kch
printk2 kdur
printk2 kamp
printk2 kenv
printk2 kcps1
printk2 kcps2
printk2 kcps3
printk2 kcps4
printk2 kcps5
*/

if kch != 0 then
	kch = ((kch+ginchnls)%ginchnls)+1
endif

if	kdur > giminnote && kamp > 0 then

	;LIMIT kdur TO gimax_note
	if kdur > gimaxnote then
		printsk "LOOK! YOU WANTED MORE THAN %is, ARE U SHURE?\n", gimaxnote
	endif

	kdur	limit	kdur, 0, gimaxnote

	;GENERATE EVENT
	if kch == 0 then
		kch = 1
		until kch > ginchnls do
			schedulek Sinstr, 0, kdur, kamp, kenv, kcps, kch
			kch += 1
		od
		kch = 0
	else
		schedulek Sinstr, 0, kdur, kamp, kenv, kcps, kch
	endif

endif

	endop

