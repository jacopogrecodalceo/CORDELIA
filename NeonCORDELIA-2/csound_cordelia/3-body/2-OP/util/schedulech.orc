opcode	schedulech, 0, Siiiiioooo
Sinstr, ist, idur, iamp, ienv, icps1, icps2, icps3, icps4, icps5 xin

if	idur > giminnote && iamp > 0 then

		idur	limit	idur, gizero, gimaxnote	;limit idur from gizero to 120

		;	amp depends on how many notes
		if	(icps2 != 0 && icps3 == 0 && icps4 == 0 && icps5 == 0) then
		iamp /= 2
		elseif	(icps2 != 0 && icps3 != 0 && icps4 == 0 && icps5 == 0) then
		iamp /= 3
		elseif	(icps2 != 0 && icps3 != 0 && icps4 != 0 && icps5 == 0) then
		iamp /= 4
		elseif	(icps2 != 0 && icps3 != 0 && icps4 != 0 && icps5 != 0) then
		iamp /= 5
		endif

		;	generate event
		if	(icps1 != 0) then
			
			ich		= 1
			until ich > nchnls do
				schedule	Sinstr, ist, idur, iamp, ienv, icps1, ich
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, idur, iamp, ienv, icps1, ich, gScorename)
					#end
				ich += 1
			od
					#ifdef	midisend
						schedule "gotomidi", ist, idur, iamp, icps1, Sinstr
					#end

		endif

		if	(icps2 != 0) then

			ich		= 1
			until ich > nchnls do
				schedule	Sinstr, ist, idur, iamp, ienv, icps2, ich
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, idur, iamp, ienv, icps2, ich, gScorename)
					#end
				ich += 1
			od
					#ifdef	midisend
						schedule "gotomidi", ist, idur, iamp, icps2, Sinstr
					#end

		endif

		if	(icps3 != 0) then

			ich		= 1
			until ich > nchnls do
				schedule	Sinstr, ist, idur, iamp, ienv, icps3, ich
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, idur, iamp, ienv, icps3, ich, gScorename)
					#end
				ich += 1
			od
					#ifdef	midisend
						schedule "gotomidi", ist, idur, iamp, icps3, Sinstr
					#end

		endif

		if	(icps4 != 0) then

			ich		= 1
			until ich > nchnls do
				schedule	Sinstr, ist, idur, iamp, ienv, icps4, ich
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, idur, iamp, ienv, icps4, ich, gScorename)
					#end
				ich += 1
			od
					#ifdef	midisend
						schedule "gotomidi", ist, idur, iamp, icps4, Sinstr
					#end

		endif

		if	(icps5 != 0) then

			ich		= 1
			until ich > nchnls do
				schedule	Sinstr, ist, idur, iamp, ienv, icps5, ich
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, idur, iamp, ienv, icps5, ich, gScorename)
					#end
				ich += 1
			od
					#ifdef	midisend
						schedule "gotomidi", ist, idur, iamp, icps5, Sinstr
					#end

		endif

	$showme

endif

	endop
