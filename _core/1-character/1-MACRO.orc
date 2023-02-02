;	HELPFULs
#define k		#*1000#
#define c		#*100#
#define d		#*10#

#define ms		#/1000#
#define s		#*1000#

#define if		#if (#
#define then	# == 1) then#

#define atk(atkms)			#+($atkms/1000)#
#define when(is_one)	#if ($is_one) == 1 then#

#define fill		#fillarray#

#define once(infill)		#once(fillarray($infill))#

#define	ampvar		#(iamp+random:i(-(iamp/10), iamp/10))#

girpr_ck	init 95$ms
#define rpr_ck		#(linseg:k(0, girpr_ck, 1, p3-(girpr_ck*2), 1, girpr_ck, 0))#
#define rpr_courbe	#(cosseg:k(0, p3/2, 1, p3/2, 0))#

;	ENVELOPEs
#define env1		#a1*=envgen(idur-random:i(0, ienvvar), iftenv)#
#define env2		#a2*=envgen(idur-random:i(0, ienvvar), iftenv)#

#define env			#aout*=envgen(idur-random:i(0, ienvvar), iftenv)#
#define mix			#chnmix aout, sprintf("%s_%i", Sinstr, ich)#

;-----------------------------|
;-------------EVA-------------|
;-----------------------------|

;MANAGE CHANNELs
#define eva_ch #
			;GET THE DECIMAL PART OF A NUMBER TO GET DELAY
			;e.g. 0.25 will produce a random delay between 0 and .25s on all speakers
			kdecimal = kch % 1

			kch	floor kch
			kch	-= 1

			if kch == -1 then
				kch = 0
			else
				kch = ((kch+ginchnls)%ginchnls)+1
			endif
#

;LIMIT kdur TO gimax_note
#define eva_limit #
			if kdur > gimaxnote then
				printsk "LOOK! YOU WANTED MORE THAN %is, ARE U SHURE?\n", gimaxnote
			endif

			kdur	limit	kdur, 0, gimaxnote
#

;AMPLITUDE DEPENDS ON HOW MANY NOTES
#define eva_amp #
			if	(kcps2 != 0 && kcps3 == 0 && kcps4 == 0 && kcps5 == 0) then
				kamp /= 2
			elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 == 0 && kcps5 == 0) then
				kamp /= 3
			elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 == 0) then
				kamp /= 4
			elseif	(kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 != 0) then
				kamp /= 5
			endif
#

;PRINT INFOs IN THE CONSOLE
#define eva_showmek #
			if	(kcps1 != 0 && kcps2 == 0 && kcps3 == 0 && kcps4 == 0 && kcps5 == 0) then
				printsk "%s, %.1fs, %.3f, %.2fHz\n", Sinstr, kdur, kamp, kcps1
			elseif	(kcps1 != 0 && kcps2 != 0 && kcps3 == 0 && kcps4 == 0 && kcps5 == 0) then
				printsk "%s, %.1fs, %.3f, %.2fHz, %.2fHz\n", Sinstr, kdur, kamp, kcps1, kcps2
			elseif	(kcps1 != 0 && kcps2 != 0 && kcps3 != 0 && kcps4 == 0 && kcps5 == 0) then
				printsk "%s, %.1fs, %.3f, %.2fHz, %.2fHz, %.2fHz\n", Sinstr, kdur, kamp, kcps1, kcps2, kcps3
			elseif	(kcps1 != 0 && kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 == 0) then
				printsk "%s, %.1fs, %.3f, %.2fHz, %.2fHz, %.2fHz, %.2fHz\n", Sinstr, kdur, kamp, kcps1, kcps2, kcps3, kcps4
			elseif	(kcps1 != 0 && kcps2 != 0 && kcps3 != 0 && kcps4 != 0 && kcps5 != 0) then
				printsk "%s, %.1fs, %.3f, %.2fHz, %.2fHz, %.2fHz, %.2fHz, %.2fHz\n", Sinstr, kdur, kamp, kcps1, kcps2, kcps3, kcps4, kcps5
			endif
#

;GENERATE A SCORE
#define gen_score(kcps) #
			kdone system kch, \
				sprintfk("echo \'i \t \"%s\" \t %f \t %f \t %f \t %f \t %f \t %i\' >> %s", \
				Sinstr, 						gkabstime, kdur, kamp, kenv, $kcps, kch, \
				gScorename)
#

;------------------------------|
;-------INSTRUMENT MACRO-------|
;------------------------------|

#define params #
				Sinstr		nstrstr p1
				idur		init p3
				iamp		init p4
				iftenv		init p5
				icps		init p6
				ich			init p7
#

#define showme		#
					if		(icps1 != 0 && icps2 == 0 && icps3 == 0 && icps4 == 0 && icps5 == 0) then
						prints "%s, %.1fs, %.3f, %.2fHz\n", Sinstr, idur, iamp, icps1
					elseif	(icps1 != 0 && icps2 != 0 && icps3 == 0 && icps4 == 0 && icps5 == 0) then
						prints "%s, %.1fs, %.3f, %.2fHz, %.2fHz\n", Sinstr, idur, iamp, icps1, icps2
					elseif	(icps1 != 0 && icps2 != 0 && icps3 != 0 && icps4 == 0 && icps5 == 0) then
						prints "%s, %.1fs, %.3f, %.2fHz, %.2fHz, %.2fHz\n", Sinstr, idur, iamp, icps1, icps2, icps3
					elseif	(icps1 != 0 && icps2 != 0 && icps3 != 0 && icps4 != 0 && icps5 == 0) then
						prints "%s, %.1fs, %.3f, %.2fHz, %.2fHz, %.2fHz, %.2fHz\n", Sinstr, idur, iamp, icps1, icps2, icps3, icps4
					elseif	(icps1 != 0 && icps2 != 0 && icps3 != 0 && icps4 != 0 && icps5 != 0) then
						prints "%s, %.1fs, %.3f, %.2fHz, %.2fHz, %.2fHz, %.2fHz, %.2fHz\n", Sinstr, idur, iamp, icps1, icps2, icps3, icps4, icps5
					endif
					#



#define END_INSTR		#
					$env
					$mix
					#



;------------------------------|
;-----------DYNAMICs-----------|
;------------------------------|

#define fff		#(ampdb(-3)*i(gkdyn))#
#define ff		#(ampdb(-6)*i(gkdyn))#
#define f		#(ampdb(-9)*i(gkdyn))#
#define mf		#(ampdb(-11)*i(gkdyn))#
#define mp		#(ampdb(-14)*i(gkdyn))#
#define p		#(ampdb(-19)*i(gkdyn))#
#define pp		#(ampdb(-23)*i(gkdyn))#
#define ppp		#(ampdb(-27)*i(gkdyn))#
#define pppp		#(ampdb(-31)*i(gkdyn))#

