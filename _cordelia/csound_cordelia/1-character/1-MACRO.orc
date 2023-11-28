;	HELPFULs
#define k		#*1000#
#define c		#*100#
#define d		#*10#

#define atk(atkms)			#+($atkms/1000)#

#define once(infill)		#once(fillarray($infill))#

; variation selected in each instrument [0 - 1]
gidyn_var init 1
#define	dyn_var #(idyn+random:i(-(idyn/10), idyn/10)*gidyn_var)#

; variation selected in each instrument [0 - 1]
gidur_var init 0
#define dur_var(dur_var_ratio) #idur_var init idur - (random:i(0, idur*(1 - 1/$dur_var_ratio))*gidur_var)#

;INSTRUMENT MACROs

#define params(instr_name) #
Sinstr		init "$instr_name"
idur		init abs(p3)
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7
#

#define cps_hi_limit(hi_freq) #
until icps < $hi_freq do
	icps	init icps/2
od
#

#define start_instr(start_instr_name) #
	instr $start_instr_name
	$params($start_instr_name)
#
#define env_gen #aout *= envgen(idur_var, ienv)#

#define channel_mix #chnmix aout, sprintf("%s_%i", Sinstr, ich)#

#define end_instr #
	$env_gen
	$channel_mix
	endin
#


;-----------------------------|
;-------------EVA-------------|
;-----------------------------|


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
#define pppp	#(ampdb(-31)*i(gkdyn))#

; deprecated
#define ms		#/1000#
#define s		#*1000#
#define if		#if (#
#define then	# == 1) then#
#define when(is_one)	#if ($is_one) == 1 then#
girpr_ck	init 95$ms
#define rpr_ck		#(linseg:k(0, girpr_ck, 1, p3-(girpr_ck*2), 1, girpr_ck, 0))#
#define rpr_courbe	#(cosseg:k(0, p3/2, 1, p3/2, 0))#
#define fill		#fillarray#

