	opcode	e_init, 0, SikkkkOOOO
Sinstr, ist, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

if	kdur > giminnote && kamp > 0 then

		kdur	limit	kdur, gizero, gimaxnote	;limit kdur from gizero to 120

		;	amp depends on how many notes
		if	(kcps2 != 0 && kcps3 == 0 && kcps4 == 0 && kcps5 == 0) then
		kamp /= 2
		elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 == 0 && kcps5 == 0) then
		kamp /= 3
		elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 == 0) then
		kamp /= 4
		elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 != 0) then
		kamp /= 5
		endif

		;	generate event
		if	(kcps1 != 0) then
			
			kch		= 1
			until kch > ginchnls do
				schedulek	Sinstr, ist, kdur, kamp, kenv, kcps1, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", ist, kdur, kamp, kcps1, Sinstr
					#end

		endif

		if	(kcps2 != 0) then

			kch		= 1
			until kch > ginchnls do
				schedulek	Sinstr, ist, kdur, kamp, kenv, kcps2, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps2, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", ist, kdur, kamp, kcps2, Sinstr
					#end

		endif

		if	(kcps3 != 0) then

			kch		= 1
			until kch > ginchnls do
				schedulek	Sinstr, ist, kdur, kamp, kenv, kcps3, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps3, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", ist, kdur, kamp, kcps3, Sinstr
					#end

		endif

		if	(kcps4 != 0) then

			kch		= 1
			until kch > ginchnls do
				schedulek	Sinstr, ist, kdur, kamp, kenv, kcps4, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps4, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", ist, kdur, kamp, kcps4, Sinstr
					#end

		endif

		if	(kcps5 != 0) then

			kch		= 1
			until kch > ginchnls do
				schedulek	Sinstr, ist, kdur, kamp, kenv, kcps5, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps5, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", ist, kdur, kamp, kcps5, Sinstr
					#end

		endif

	$showmek

endif

	endop
