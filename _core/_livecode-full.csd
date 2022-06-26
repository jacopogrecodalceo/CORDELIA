;	HELPFULs
#define k		#*1000#
#define c		#*100#
#define d		#*10#

#define ms		#/1000#
#define s		#*1000#

#define if		#if (#
#define then	# == 1) then#

;	GLOBAL VARIABLEs
gizero		= ksmps / sr	;i variable better than write zero? because it's between samples
gkzero		= ksmps / sr	;k variable better than write zero? because it's between samples

giexpzero	= .00015		;a zero value for expseg

gkgain		init 1			;master gain for "mouth" instrument

gkabstime	init 0

gksamp_mod	init 24

giminnote	init 50$ms
gimaxnote	init 125;s
;	2 types of envelopes : envelope (0, 1), oscil(-1, 1)
gienvdur	init 8192		;duration for all envelopes gen envelope tables
gioscildur	init 16384		;duration for all envelopes gen envelope tables

gkdyn		init 1

gkclearchns[]	init 128

gis_midi	init 0

gkrpr1		init 0
gkrpr2		init 0
gkrpr3		init 0
gkrpr4		init 0

gkrpr_arr1		init 16
gkrpr_arr2		init 16
gkrpr_arr3		init 16
gkrpr_arr4		init 16

;	MACROs
;	DYNAMICs
#define fff		#(ampdb(-3)*i(gkdyn))#
#define ff		#(ampdb(-6)*i(gkdyn))#
#define f		#(ampdb(-9)*i(gkdyn))#
#define mf		#(ampdb(-11)*i(gkdyn))#
#define mp		#(ampdb(-14)*i(gkdyn))#
#define p		#(ampdb(-19)*i(gkdyn))#
#define pp		#(ampdb(-23)*i(gkdyn))#
#define ppp		#(ampdb(-27)*i(gkdyn))#
#define pppp		#(ampdb(-31)*i(gkdyn))#

#define atk(atkms)			#+($atkms/1000)#
#define when(is_one)	#if ($is_one) == 1 then#

#define fill		#fillarray#

#define once(infill)		#once(fillarray($infill))#

#define	ampvar		#(iamp+random:i(-(iamp/10), iamp/10))#

#define ch_limit	#

kmodulo	= kch % 1

kch	floor kch
kch	-= 1

if kch == -1 then
	kch = 0
else
	kch		= ((kch+ginchnls)%ginchnls)+1
endif

#

girpr_ck	init 95$ms
#define rpr_ck		#(linseg:k(0, girpr_ck, 1, p3-(girpr_ck*2), 1, girpr_ck, 0))#
#define rpr_courbe	#(cosseg:k(0, p3/2, 1, p3/2, 0))#

;	ENVELOPEs
#define env1		#a1*=envgen(idur-random:i(0, ienvvar), iftenv)#
#define env2		#a2*=envgen(idur-random:i(0, ienvvar), iftenv)#

#define env			#aout*=envgen(idur-random:i(0, ienvvar), iftenv)#
#define mix			#chnmix aout, sprintf("%s_%i", Sinstr, ich)#

#define printing	#
					\#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
					\#end

					\#ifdef	midisend
						schedulek "gotomidi", 0, kdur, kamp, kcps1, Sinstr
					\#end
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

#define showmek		#
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

#define death		#
					$env
					$mix
					#

;-----------------------------------------

	instr	abstime

gkabstime	times
	
	endin
	alwayson("abstime")


;	generate date of the score
itim		date
Stim		dates     itim
Syear		strsub    Stim, 22, 24
Smonth		strsub    Stim, 4, 7
Sday		strsub    Stim, 8, 10
iday		strtod    Sday
Shor		strsub    Stim, 11, 13
Smin		strsub    Stim, 14, 16
Ssec		strsub    Stim, 17, 19
Sfilename	sprintf   "%s%s%02d_%s_%s_%s.orc", Syear, Smonth, iday, Shor,Smin, Ssec
gScorename	sprintf    "../_score/%s", Sfilename

;	OSC
gShost		init "localhost"
giport		init 10005



;--- ||| --- ||| ---

gSinstrs[]			fillarray	"aaron", "alghed", "alghef", "algo", "algo2", "alone", "alonefr", "amen", "amor", "arm1", "arm2", "armagain", "bass", "bebois", "beboo", "bebor", "becapr", "bee", "begad", "begaf", "beme", "between", "betweenmore", "bleu", "bois", "bois2", "break", "burd", "caillou", "caiu", "calin", "calinin", "capr1x", "capr2x", "capriccio1", "capriccio2", "careless", "careless2", "cascade", "cascadexp", "chime", "chiseq", "click", "coeur", "contempo", "curij", "curij2", "dance", "dismatter", "distmar", "dmitri", "dmitrif", "drum", "drumhigh", "etag", "euarm", "euarm2", "fairest", "fairest2", "falga", "fim", "flij", "flou", "fragment", "fuji", "gameld", "gamelf", "gesto1", "gesto2", "gesto3", "gesto4", "grind", "grind2", "grind3", "grr", "hh", "inkick", "insna", "ipercluster", "iveheard", "ixland", "junis", "kali", "madcow", "maij", "maij2", "malon", "mario1", "mario2", "meer", "meli", "meli2", "mhon", "mhon2", "mhon2q", "mhonq", "mirrors", "ninfa", "noij", "noinput", "noneknows", "noriff", "november", "ocean", "ohoh", "orphans", "orphans2", "orphans3", "pert", "pharm", "pij", "pijnor", "planche", "puck", "qb", "quar", "quar2", "reg", "repuck", "search", "shaku", "shinji", "shinobi", "sin", "sinimp", "six", "six2", "sixcorrect", "sixspectrumsynth", "skij", "sophie1", "space", "sufij", "sufij2", "sunij", "syeq", "tape", "tapein", "tension", "theorbo", "toomuchalone", "toy", "tricot", "uni", "valle", "var14r", "varvln", "vipere", "virgule", "vla", "vlj", "vlnatk", "wendi", "wendj", "wendy", "witches", "wutang", "xylo"

ginstrslen			lenarray gSinstrs

gSaaron[]			init ginchnls
gSalghed[]			init ginchnls
gSalghef[]			init ginchnls
gSalgo[]			init ginchnls
gSalgo2[]			init ginchnls
gSalone[]			init ginchnls
gSalonefr[]			init ginchnls
gSamen[]			init ginchnls
gSamor[]			init ginchnls
gSarm1[]			init ginchnls
gSarm2[]			init ginchnls
gSarmagain[]			init ginchnls
gSbass[]			init ginchnls
gSbebois[]			init ginchnls
gSbeboo[]			init ginchnls
gSbebor[]			init ginchnls
gSbecapr[]			init ginchnls
gSbee[]			init ginchnls
gSbegad[]			init ginchnls
gSbegaf[]			init ginchnls
gSbeme[]			init ginchnls
gSbetween[]			init ginchnls
gSbetweenmore[]			init ginchnls
gSbleu[]			init ginchnls
gSbois[]			init ginchnls
gSbois2[]			init ginchnls
gSbreak[]			init ginchnls
gSburd[]			init ginchnls
gScaillou[]			init ginchnls
gScaiu[]			init ginchnls
gScalin[]			init ginchnls
gScalinin[]			init ginchnls
gScapr1x[]			init ginchnls
gScapr2x[]			init ginchnls
gScapriccio1[]			init ginchnls
gScapriccio2[]			init ginchnls
gScareless[]			init ginchnls
gScareless2[]			init ginchnls
gScascade[]			init ginchnls
gScascadexp[]			init ginchnls
gSchime[]			init ginchnls
gSchiseq[]			init ginchnls
gSclick[]			init ginchnls
gScoeur[]			init ginchnls
gScontempo[]			init ginchnls
gScurij[]			init ginchnls
gScurij2[]			init ginchnls
gSdance[]			init ginchnls
gSdismatter[]			init ginchnls
gSdistmar[]			init ginchnls
gSdmitri[]			init ginchnls
gSdmitrif[]			init ginchnls
gSdrum[]			init ginchnls
gSdrumhigh[]			init ginchnls
gSetag[]			init ginchnls
gSeuarm[]			init ginchnls
gSeuarm2[]			init ginchnls
gSfairest[]			init ginchnls
gSfairest2[]			init ginchnls
gSfalga[]			init ginchnls
gSfim[]			init ginchnls
gSflij[]			init ginchnls
gSflou[]			init ginchnls
gSfragment[]			init ginchnls
gSfuji[]			init ginchnls
gSgameld[]			init ginchnls
gSgamelf[]			init ginchnls
gSgesto1[]			init ginchnls
gSgesto2[]			init ginchnls
gSgesto3[]			init ginchnls
gSgesto4[]			init ginchnls
gSgrind[]			init ginchnls
gSgrind2[]			init ginchnls
gSgrind3[]			init ginchnls
gSgrr[]			init ginchnls
gShh[]			init ginchnls
gSinkick[]			init ginchnls
gSinsna[]			init ginchnls
gSipercluster[]			init ginchnls
gSiveheard[]			init ginchnls
gSixland[]			init ginchnls
gSjunis[]			init ginchnls
gSkali[]			init ginchnls
gSmadcow[]			init ginchnls
gSmaij[]			init ginchnls
gSmaij2[]			init ginchnls
gSmalon[]			init ginchnls
gSmario1[]			init ginchnls
gSmario2[]			init ginchnls
gSmeer[]			init ginchnls
gSmeli[]			init ginchnls
gSmeli2[]			init ginchnls
gSmhon[]			init ginchnls
gSmhon2[]			init ginchnls
gSmhon2q[]			init ginchnls
gSmhonq[]			init ginchnls
gSmirrors[]			init ginchnls
gSninfa[]			init ginchnls
gSnoij[]			init ginchnls
gSnoinput[]			init ginchnls
gSnoneknows[]			init ginchnls
gSnoriff[]			init ginchnls
gSnovember[]			init ginchnls
gSocean[]			init ginchnls
gSohoh[]			init ginchnls
gSorphans[]			init ginchnls
gSorphans2[]			init ginchnls
gSorphans3[]			init ginchnls
gSpert[]			init ginchnls
gSpharm[]			init ginchnls
gSpij[]			init ginchnls
gSpijnor[]			init ginchnls
gSplanche[]			init ginchnls
gSpuck[]			init ginchnls
gSqb[]			init ginchnls
gSquar[]			init ginchnls
gSquar2[]			init ginchnls
gSreg[]			init ginchnls
gSrepuck[]			init ginchnls
gSsearch[]			init ginchnls
gSshaku[]			init ginchnls
gSshinji[]			init ginchnls
gSshinobi[]			init ginchnls
gSsin[]			init ginchnls
gSsinimp[]			init ginchnls
gSsix[]			init ginchnls
gSsix2[]			init ginchnls
gSsixcorrect[]			init ginchnls
gSsixspectrumsynth[]			init ginchnls
gSskij[]			init ginchnls
gSsophie1[]			init ginchnls
gSspace[]			init ginchnls
gSsufij[]			init ginchnls
gSsufij2[]			init ginchnls
gSsunij[]			init ginchnls
gSsyeq[]			init ginchnls
gStape[]			init ginchnls
gStapein[]			init ginchnls
gStension[]			init ginchnls
gStheorbo[]			init ginchnls
gStoomuchalone[]			init ginchnls
gStoy[]			init ginchnls
gStricot[]			init ginchnls
gSuni[]			init ginchnls
gSvalle[]			init ginchnls
gSvar14r[]			init ginchnls
gSvarvln[]			init ginchnls
gSvipere[]			init ginchnls
gSvirgule[]			init ginchnls
gSvla[]			init ginchnls
gSvlj[]			init ginchnls
gSvlnatk[]			init ginchnls
gSwendi[]			init ginchnls
gSwendj[]			init ginchnls
gSwendy[]			init ginchnls
gSwitches[]			init ginchnls
gSwutang[]			init ginchnls
gSxylo[]			init ginchnls

indx	init 0
until	indx == ginchnls do
	gSaaron[indx]			sprintf	"aaron_%i", indx+1
	gSalghed[indx]			sprintf	"alghed_%i", indx+1
	gSalghef[indx]			sprintf	"alghef_%i", indx+1
	gSalgo[indx]			sprintf	"algo_%i", indx+1
	gSalgo2[indx]			sprintf	"algo2_%i", indx+1
	gSalone[indx]			sprintf	"alone_%i", indx+1
	gSalonefr[indx]			sprintf	"alonefr_%i", indx+1
	gSamen[indx]			sprintf	"amen_%i", indx+1
	gSamor[indx]			sprintf	"amor_%i", indx+1
	gSarm1[indx]			sprintf	"arm1_%i", indx+1
	gSarm2[indx]			sprintf	"arm2_%i", indx+1
	gSarmagain[indx]			sprintf	"armagain_%i", indx+1
	gSbass[indx]			sprintf	"bass_%i", indx+1
	gSbebois[indx]			sprintf	"bebois_%i", indx+1
	gSbeboo[indx]			sprintf	"beboo_%i", indx+1
	gSbebor[indx]			sprintf	"bebor_%i", indx+1
	gSbecapr[indx]			sprintf	"becapr_%i", indx+1
	gSbee[indx]			sprintf	"bee_%i", indx+1
	gSbegad[indx]			sprintf	"begad_%i", indx+1
	gSbegaf[indx]			sprintf	"begaf_%i", indx+1
	gSbeme[indx]			sprintf	"beme_%i", indx+1
	gSbetween[indx]			sprintf	"between_%i", indx+1
	gSbetweenmore[indx]			sprintf	"betweenmore_%i", indx+1
	gSbleu[indx]			sprintf	"bleu_%i", indx+1
	gSbois[indx]			sprintf	"bois_%i", indx+1
	gSbois2[indx]			sprintf	"bois2_%i", indx+1
	gSbreak[indx]			sprintf	"break_%i", indx+1
	gSburd[indx]			sprintf	"burd_%i", indx+1
	gScaillou[indx]			sprintf	"caillou_%i", indx+1
	gScaiu[indx]			sprintf	"caiu_%i", indx+1
	gScalin[indx]			sprintf	"calin_%i", indx+1
	gScalinin[indx]			sprintf	"calinin_%i", indx+1
	gScapr1x[indx]			sprintf	"capr1x_%i", indx+1
	gScapr2x[indx]			sprintf	"capr2x_%i", indx+1
	gScapriccio1[indx]			sprintf	"capriccio1_%i", indx+1
	gScapriccio2[indx]			sprintf	"capriccio2_%i", indx+1
	gScareless[indx]			sprintf	"careless_%i", indx+1
	gScareless2[indx]			sprintf	"careless2_%i", indx+1
	gScascade[indx]			sprintf	"cascade_%i", indx+1
	gScascadexp[indx]			sprintf	"cascadexp_%i", indx+1
	gSchime[indx]			sprintf	"chime_%i", indx+1
	gSchiseq[indx]			sprintf	"chiseq_%i", indx+1
	gSclick[indx]			sprintf	"click_%i", indx+1
	gScoeur[indx]			sprintf	"coeur_%i", indx+1
	gScontempo[indx]			sprintf	"contempo_%i", indx+1
	gScurij[indx]			sprintf	"curij_%i", indx+1
	gScurij2[indx]			sprintf	"curij2_%i", indx+1
	gSdance[indx]			sprintf	"dance_%i", indx+1
	gSdismatter[indx]			sprintf	"dismatter_%i", indx+1
	gSdistmar[indx]			sprintf	"distmar_%i", indx+1
	gSdmitri[indx]			sprintf	"dmitri_%i", indx+1
	gSdmitrif[indx]			sprintf	"dmitrif_%i", indx+1
	gSdrum[indx]			sprintf	"drum_%i", indx+1
	gSdrumhigh[indx]			sprintf	"drumhigh_%i", indx+1
	gSetag[indx]			sprintf	"etag_%i", indx+1
	gSeuarm[indx]			sprintf	"euarm_%i", indx+1
	gSeuarm2[indx]			sprintf	"euarm2_%i", indx+1
	gSfairest[indx]			sprintf	"fairest_%i", indx+1
	gSfairest2[indx]			sprintf	"fairest2_%i", indx+1
	gSfalga[indx]			sprintf	"falga_%i", indx+1
	gSfim[indx]			sprintf	"fim_%i", indx+1
	gSflij[indx]			sprintf	"flij_%i", indx+1
	gSflou[indx]			sprintf	"flou_%i", indx+1
	gSfragment[indx]			sprintf	"fragment_%i", indx+1
	gSfuji[indx]			sprintf	"fuji_%i", indx+1
	gSgameld[indx]			sprintf	"gameld_%i", indx+1
	gSgamelf[indx]			sprintf	"gamelf_%i", indx+1
	gSgesto1[indx]			sprintf	"gesto1_%i", indx+1
	gSgesto2[indx]			sprintf	"gesto2_%i", indx+1
	gSgesto3[indx]			sprintf	"gesto3_%i", indx+1
	gSgesto4[indx]			sprintf	"gesto4_%i", indx+1
	gSgrind[indx]			sprintf	"grind_%i", indx+1
	gSgrind2[indx]			sprintf	"grind2_%i", indx+1
	gSgrind3[indx]			sprintf	"grind3_%i", indx+1
	gSgrr[indx]			sprintf	"grr_%i", indx+1
	gShh[indx]			sprintf	"hh_%i", indx+1
	gSinkick[indx]			sprintf	"inkick_%i", indx+1
	gSinsna[indx]			sprintf	"insna_%i", indx+1
	gSipercluster[indx]			sprintf	"ipercluster_%i", indx+1
	gSiveheard[indx]			sprintf	"iveheard_%i", indx+1
	gSixland[indx]			sprintf	"ixland_%i", indx+1
	gSjunis[indx]			sprintf	"junis_%i", indx+1
	gSkali[indx]			sprintf	"kali_%i", indx+1
	gSmadcow[indx]			sprintf	"madcow_%i", indx+1
	gSmaij[indx]			sprintf	"maij_%i", indx+1
	gSmaij2[indx]			sprintf	"maij2_%i", indx+1
	gSmalon[indx]			sprintf	"malon_%i", indx+1
	gSmario1[indx]			sprintf	"mario1_%i", indx+1
	gSmario2[indx]			sprintf	"mario2_%i", indx+1
	gSmeer[indx]			sprintf	"meer_%i", indx+1
	gSmeli[indx]			sprintf	"meli_%i", indx+1
	gSmeli2[indx]			sprintf	"meli2_%i", indx+1
	gSmhon[indx]			sprintf	"mhon_%i", indx+1
	gSmhon2[indx]			sprintf	"mhon2_%i", indx+1
	gSmhon2q[indx]			sprintf	"mhon2q_%i", indx+1
	gSmhonq[indx]			sprintf	"mhonq_%i", indx+1
	gSmirrors[indx]			sprintf	"mirrors_%i", indx+1
	gSninfa[indx]			sprintf	"ninfa_%i", indx+1
	gSnoij[indx]			sprintf	"noij_%i", indx+1
	gSnoinput[indx]			sprintf	"noinput_%i", indx+1
	gSnoneknows[indx]			sprintf	"noneknows_%i", indx+1
	gSnoriff[indx]			sprintf	"noriff_%i", indx+1
	gSnovember[indx]			sprintf	"november_%i", indx+1
	gSocean[indx]			sprintf	"ocean_%i", indx+1
	gSohoh[indx]			sprintf	"ohoh_%i", indx+1
	gSorphans[indx]			sprintf	"orphans_%i", indx+1
	gSorphans2[indx]			sprintf	"orphans2_%i", indx+1
	gSorphans3[indx]			sprintf	"orphans3_%i", indx+1
	gSpert[indx]			sprintf	"pert_%i", indx+1
	gSpharm[indx]			sprintf	"pharm_%i", indx+1
	gSpij[indx]			sprintf	"pij_%i", indx+1
	gSpijnor[indx]			sprintf	"pijnor_%i", indx+1
	gSplanche[indx]			sprintf	"planche_%i", indx+1
	gSpuck[indx]			sprintf	"puck_%i", indx+1
	gSqb[indx]			sprintf	"qb_%i", indx+1
	gSquar[indx]			sprintf	"quar_%i", indx+1
	gSquar2[indx]			sprintf	"quar2_%i", indx+1
	gSreg[indx]			sprintf	"reg_%i", indx+1
	gSrepuck[indx]			sprintf	"repuck_%i", indx+1
	gSsearch[indx]			sprintf	"search_%i", indx+1
	gSshaku[indx]			sprintf	"shaku_%i", indx+1
	gSshinji[indx]			sprintf	"shinji_%i", indx+1
	gSshinobi[indx]			sprintf	"shinobi_%i", indx+1
	gSsin[indx]			sprintf	"sin_%i", indx+1
	gSsinimp[indx]			sprintf	"sinimp_%i", indx+1
	gSsix[indx]			sprintf	"six_%i", indx+1
	gSsix2[indx]			sprintf	"six2_%i", indx+1
	gSsixcorrect[indx]			sprintf	"sixcorrect_%i", indx+1
	gSsixspectrumsynth[indx]			sprintf	"sixspectrumsynth_%i", indx+1
	gSskij[indx]			sprintf	"skij_%i", indx+1
	gSsophie1[indx]			sprintf	"sophie1_%i", indx+1
	gSspace[indx]			sprintf	"space_%i", indx+1
	gSsufij[indx]			sprintf	"sufij_%i", indx+1
	gSsufij2[indx]			sprintf	"sufij2_%i", indx+1
	gSsunij[indx]			sprintf	"sunij_%i", indx+1
	gSsyeq[indx]			sprintf	"syeq_%i", indx+1
	gStape[indx]			sprintf	"tape_%i", indx+1
	gStapein[indx]			sprintf	"tapein_%i", indx+1
	gStension[indx]			sprintf	"tension_%i", indx+1
	gStheorbo[indx]			sprintf	"theorbo_%i", indx+1
	gStoomuchalone[indx]			sprintf	"toomuchalone_%i", indx+1
	gStoy[indx]			sprintf	"toy_%i", indx+1
	gStricot[indx]			sprintf	"tricot_%i", indx+1
	gSuni[indx]			sprintf	"uni_%i", indx+1
	gSvalle[indx]			sprintf	"valle_%i", indx+1
	gSvar14r[indx]			sprintf	"var14r_%i", indx+1
	gSvarvln[indx]			sprintf	"varvln_%i", indx+1
	gSvipere[indx]			sprintf	"vipere_%i", indx+1
	gSvirgule[indx]			sprintf	"virgule_%i", indx+1
	gSvla[indx]			sprintf	"vla_%i", indx+1
	gSvlj[indx]			sprintf	"vlj_%i", indx+1
	gSvlnatk[indx]			sprintf	"vlnatk_%i", indx+1
	gSwendi[indx]			sprintf	"wendi_%i", indx+1
	gSwendj[indx]			sprintf	"wendj_%i", indx+1
	gSwendy[indx]			sprintf	"wendy_%i", indx+1
	gSwitches[indx]			sprintf	"witches_%i", indx+1
	gSwutang[indx]			sprintf	"wutang_%i", indx+1
	gSxylo[indx]			sprintf	"xylo_%i", indx+1
	indx	+= 1
od




;--- ||| --- ||| ---

gSmouth[]		init ginchnls

indx		init 0
until	indx == ginchnls do
	gSmouth[indx]	sprintf	"mouth_%i", indx+1
	indx	+= 1
od
	printarray gSmouth



gkdiv	init 64 ;max division of main tempo for heart and lungs


if gis_midi==1 then
	schedule	"midwrite", 0, .25, 1, 1, 127, 1, "marker"
endif

;	HEART
;	tempo for heart
gkpulse		init 120 ;tempo for heart in BPM

	instr heart

if gkpulse == 0 then
	gkpulse = gizero
endif

gkbeatf		= gkpulse / 60				;frequency for a quarter note in Hz
gkbeats		= 1 / (gkpulse / 60)		;time of a quarter note in sec
gkbeatms	= gkbeats*1000

kph		init 0
kph		phasor (gkpulse / gkdiv) / 60

gkbeatn	init 0				;number of beats from the beginning of session
klast	init -1

if (((kph*gkdiv)%1) < klast) then
	gkbeatn += 1
endif

if (((kph*gkdiv)%4) < klast) then

	if gis_midi==1 then
		schedulek	"midwrite", 0, .25, 1, 1, 127, 1, "marker"
	endif

endif

klast	= ((kph*gkdiv)%1)

	chnset	kph, "heart"


	endin
;	schedule("heart", .5, -1)
	alwayson("heart")


;	LUNGS
;	tempo for lungs
gkbreath	init 120

	instr lungs

gkblowf	= gkbreath / 60		;frequency for a quarter note in Hz
gkblows	= 1 / (gkbreath / 60)	;time of a quarter note in sec

kph		init 0
kph		phasor (gkbreath / gkdiv) / 60

gkblown	init 0			;number of beats from the beginning of session
klast	init -1

if (kph < klast) then
	gkblown += 1
endif

klast	= kph

	chnset	kph, "lungs"

	endin
;	schedule("lungs", .5, -1)
	alwayson("lungs")



gkheartbeat_print_fact init 1

	instr heartbeat_print_control

if	gkpulse < 40 then
	gkheartbeat_print_fact = 16 
elseif	gkpulse > 40 && gkpulse < 160 then
	gkheartbeat_print_fact = 8
else
	gkheartbeat_print_fact = 4
endif

kph	chnget "heart"	
kph	= (kph * gkheartbeat_print_fact)
kph	= kph % 1

klast init -1

schedule "heartbeat_print", .125, 1

if (kph < klast) then
	schedulek "heartbeat_print", 0, 1
endif

klast	= kph

	endin
	alwayson("heartbeat_print_control")

	instr heartbeat_print

gipulse		i gkpulse
gibeats		i gkbeats 
gibeatms	i gkbeatms 
gibeatf		i gkbeatf

prints("\n--------- i'm 🔥beating --------\n")
prints " 💛 %.02fbpm: %.02fs // %.02fHz 💛 \n", gipulse, gibeats, gibeatf

;---ABSOLUTE TIME AND WARN IF INSTRS ARE TOO MANY

indx		init 0
ilen		lenarray gSinstrs
ihowmany	init 75

imin		init int(times:i()/60)
isec		init times:i()%60

until indx == ilen do
	iactive	active gSinstrs[indx]
	if (iactive > ihowmany) then
		prints("🧨 Watch out! %i instaces of %s\n", iactive, gSinstrs[indx])
	endif
	indx	+= 1
od

prints("--------- %.2d'  |  %.2d'' ---------\n", imin, isec)
ifact	i gkheartbeat_print_fact
prints	"---------      %i♩      ---------\n", ifact

	turnoff

	endin









;--- ||| --- ||| ---


;---	2

giarith2			ftgen	0, 0, 2, -2, 1, 2
giline2			ftgen	0, 0, 2, -2, 1, 2
girot2			ftgen	0, 0, 2, -2, 2, 1
gieven2			ftgen	0, 0, 2, -2, 2, 2
giodd2			ftgen	0, 0, 2, -2, 1, 1
gidist2			ftgen	0, 0, 2, -2, 1, 1

;---


;---	3

giarith3			ftgen	0, 0, 3, -2, 1, 2, 3
giline3			ftgen	0, 0, 3, -2, 3, 1, 2
girot3			ftgen	0, 0, 3, -2, 2, 3, 1
gieven3			ftgen	0, 0, 2, -2, 2, 2
giodd3			ftgen	0, 0, 4, -2, 1, 3, 3, 1
gidist3			ftgen	0, 0, 4, -2, 1, 3, 1, 3

;---


;---	4

giarith4			ftgen	0, 0, 4, -2, 1, 2, 3, 4
giline4			ftgen	0, 0, 4, -2, 3, 1, 4, 2
girot4			ftgen	0, 0, 4, -2, 2, 4, 3, 1
gieven4			ftgen	0, 0, 4, -2, 2, 4, 4, 2
giodd4			ftgen	0, 0, 4, -2, 1, 3, 3, 1
gidist4			ftgen	0, 0, 4, -2, 1, 3, 1, 3

;---


;---	5

giarith5			ftgen	0, 0, 5, -2, 1, 2, 3, 4, 5
giline5			ftgen	0, 0, 5, -2, 5, 3, 1, 4, 2
girot5			ftgen	0, 0, 5, -2, 2, 4, 5, 3, 1
gieven5			ftgen	0, 0, 4, -2, 2, 4, 4, 2
giodd5			ftgen	0, 0, 6, -2, 1, 3, 5, 5, 3, 1
gidist5			ftgen	0, 0, 6, -2, 1, 3, 5, 1, 3, 5

;---


;---	6

giarith6			ftgen	0, 0, 6, -2, 1, 2, 3, 4, 5, 6
giline6			ftgen	0, 0, 6, -2, 5, 3, 1, 6, 4, 2
girot6			ftgen	0, 0, 6, -2, 2, 4, 6, 5, 3, 1
gieven6			ftgen	0, 0, 6, -2, 2, 4, 6, 6, 4, 2
giodd6			ftgen	0, 0, 6, -2, 1, 3, 5, 5, 3, 1
gidist6			ftgen	0, 0, 6, -2, 1, 3, 5, 1, 3, 5

;---


;---	7

giarith7			ftgen	0, 0, 7, -2, 1, 2, 3, 4, 5, 6, 7
giline7			ftgen	0, 0, 7, -2, 7, 5, 3, 1, 6, 4, 2
girot7			ftgen	0, 0, 7, -2, 2, 4, 6, 7, 5, 3, 1
gieven7			ftgen	0, 0, 6, -2, 2, 4, 6, 6, 4, 2
giodd7			ftgen	0, 0, 8, -2, 1, 3, 5, 7, 7, 5, 3, 1
gidist7			ftgen	0, 0, 8, -2, 1, 3, 5, 7, 1, 3, 5, 7

;---


;---	8

giarith8			ftgen	0, 0, 8, -2, 1, 2, 3, 4, 5, 6, 7, 8
giline8			ftgen	0, 0, 8, -2, 7, 5, 3, 1, 8, 6, 4, 2
girot8			ftgen	0, 0, 8, -2, 2, 4, 6, 8, 7, 5, 3, 1
gieven8			ftgen	0, 0, 8, -2, 2, 4, 6, 8, 8, 6, 4, 2
giodd8			ftgen	0, 0, 8, -2, 1, 3, 5, 7, 7, 5, 3, 1
gidist8			ftgen	0, 0, 8, -2, 1, 3, 5, 7, 1, 3, 5, 7

;---


;---	9

giarith9			ftgen	0, 0, 9, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9
giline9			ftgen	0, 0, 9, -2, 9, 7, 5, 3, 1, 8, 6, 4, 2
girot9			ftgen	0, 0, 9, -2, 2, 4, 6, 8, 9, 7, 5, 3, 1
gieven9			ftgen	0, 0, 8, -2, 2, 4, 6, 8, 8, 6, 4, 2
giodd9			ftgen	0, 0, 10, -2, 1, 3, 5, 7, 9, 9, 7, 5, 3, 1
gidist9			ftgen	0, 0, 10, -2, 1, 3, 5, 7, 9, 1, 3, 5, 7, 9

;---


;---	10

giarith10			ftgen	0, 0, 10, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
giline10			ftgen	0, 0, 10, -2, 9, 7, 5, 3, 1, 10, 8, 6, 4, 2
girot10			ftgen	0, 0, 10, -2, 2, 4, 6, 8, 10, 9, 7, 5, 3, 1
gieven10			ftgen	0, 0, 10, -2, 2, 4, 6, 8, 10, 10, 8, 6, 4, 2
giodd10			ftgen	0, 0, 10, -2, 1, 3, 5, 7, 9, 9, 7, 5, 3, 1
gidist10			ftgen	0, 0, 10, -2, 1, 3, 5, 7, 9, 1, 3, 5, 7, 9

;---


;---	11

giarith11			ftgen	0, 0, 11, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
giline11			ftgen	0, 0, 11, -2, 11, 9, 7, 5, 3, 1, 10, 8, 6, 4, 2
girot11			ftgen	0, 0, 11, -2, 2, 4, 6, 8, 10, 11, 9, 7, 5, 3, 1
gieven11			ftgen	0, 0, 10, -2, 2, 4, 6, 8, 10, 10, 8, 6, 4, 2
giodd11			ftgen	0, 0, 12, -2, 1, 3, 5, 7, 9, 11, 11, 9, 7, 5, 3, 1
gidist11			ftgen	0, 0, 12, -2, 1, 3, 5, 7, 9, 11, 1, 3, 5, 7, 9, 11

;---


;---	12

giarith12			ftgen	0, 0, 12, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
giline12			ftgen	0, 0, 12, -2, 11, 9, 7, 5, 3, 1, 12, 10, 8, 6, 4, 2
girot12			ftgen	0, 0, 12, -2, 2, 4, 6, 8, 10, 12, 11, 9, 7, 5, 3, 1
gieven12			ftgen	0, 0, 12, -2, 2, 4, 6, 8, 10, 12, 12, 10, 8, 6, 4, 2
giodd12			ftgen	0, 0, 12, -2, 1, 3, 5, 7, 9, 11, 11, 9, 7, 5, 3, 1
gidist12			ftgen	0, 0, 12, -2, 1, 3, 5, 7, 9, 11, 1, 3, 5, 7, 9, 11

;---


;---	13

giarith13			ftgen	0, 0, 13, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
giline13			ftgen	0, 0, 13, -2, 13, 11, 9, 7, 5, 3, 1, 12, 10, 8, 6, 4, 2
girot13			ftgen	0, 0, 13, -2, 2, 4, 6, 8, 10, 12, 13, 11, 9, 7, 5, 3, 1
gieven13			ftgen	0, 0, 12, -2, 2, 4, 6, 8, 10, 12, 12, 10, 8, 6, 4, 2
giodd13			ftgen	0, 0, 14, -2, 1, 3, 5, 7, 9, 11, 13, 13, 11, 9, 7, 5, 3, 1
gidist13			ftgen	0, 0, 14, -2, 1, 3, 5, 7, 9, 11, 13, 1, 3, 5, 7, 9, 11, 13

;---


;---	14

giarith14			ftgen	0, 0, 14, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
giline14			ftgen	0, 0, 14, -2, 13, 11, 9, 7, 5, 3, 1, 14, 12, 10, 8, 6, 4, 2
girot14			ftgen	0, 0, 14, -2, 2, 4, 6, 8, 10, 12, 14, 13, 11, 9, 7, 5, 3, 1
gieven14			ftgen	0, 0, 14, -2, 2, 4, 6, 8, 10, 12, 14, 14, 12, 10, 8, 6, 4, 2
giodd14			ftgen	0, 0, 14, -2, 1, 3, 5, 7, 9, 11, 13, 13, 11, 9, 7, 5, 3, 1
gidist14			ftgen	0, 0, 14, -2, 1, 3, 5, 7, 9, 11, 13, 1, 3, 5, 7, 9, 11, 13

;---


;---	15

giarith15			ftgen	0, 0, 15, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
giline15			ftgen	0, 0, 15, -2, 15, 13, 11, 9, 7, 5, 3, 1, 14, 12, 10, 8, 6, 4, 2
girot15			ftgen	0, 0, 15, -2, 2, 4, 6, 8, 10, 12, 14, 15, 13, 11, 9, 7, 5, 3, 1
gieven15			ftgen	0, 0, 14, -2, 2, 4, 6, 8, 10, 12, 14, 14, 12, 10, 8, 6, 4, 2
giodd15			ftgen	0, 0, 16, -2, 1, 3, 5, 7, 9, 11, 13, 15, 15, 13, 11, 9, 7, 5, 3, 1
gidist15			ftgen	0, 0, 16, -2, 1, 3, 5, 7, 9, 11, 13, 15, 1, 3, 5, 7, 9, 11, 13, 15

;---


;---	16

giarith16			ftgen	0, 0, 16, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
giline16			ftgen	0, 0, 16, -2, 15, 13, 11, 9, 7, 5, 3, 1, 16, 14, 12, 10, 8, 6, 4, 2
girot16			ftgen	0, 0, 16, -2, 2, 4, 6, 8, 10, 12, 14, 16, 15, 13, 11, 9, 7, 5, 3, 1
gieven16			ftgen	0, 0, 16, -2, 2, 4, 6, 8, 10, 12, 14, 16, 16, 14, 12, 10, 8, 6, 4, 2
giodd16			ftgen	0, 0, 16, -2, 1, 3, 5, 7, 9, 11, 13, 15, 15, 13, 11, 9, 7, 5, 3, 1
gidist16			ftgen	0, 0, 16, -2, 1, 3, 5, 7, 9, 11, 13, 15, 1, 3, 5, 7, 9, 11, 13, 15

;---


;---	17

giarith17			ftgen	0, 0, 17, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17
giline17			ftgen	0, 0, 17, -2, 17, 15, 13, 11, 9, 7, 5, 3, 1, 16, 14, 12, 10, 8, 6, 4, 2
girot17			ftgen	0, 0, 17, -2, 2, 4, 6, 8, 10, 12, 14, 16, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven17			ftgen	0, 0, 16, -2, 2, 4, 6, 8, 10, 12, 14, 16, 16, 14, 12, 10, 8, 6, 4, 2
giodd17			ftgen	0, 0, 18, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist17			ftgen	0, 0, 18, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 1, 3, 5, 7, 9, 11, 13, 15, 17

;---


;---	18

giarith18			ftgen	0, 0, 18, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18
giline18			ftgen	0, 0, 18, -2, 17, 15, 13, 11, 9, 7, 5, 3, 1, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot18			ftgen	0, 0, 18, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven18			ftgen	0, 0, 18, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd18			ftgen	0, 0, 18, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist18			ftgen	0, 0, 18, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 1, 3, 5, 7, 9, 11, 13, 15, 17

;---


;---	19

giarith19			ftgen	0, 0, 19, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
giline19			ftgen	0, 0, 19, -2, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot19			ftgen	0, 0, 19, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven19			ftgen	0, 0, 18, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd19			ftgen	0, 0, 20, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist19			ftgen	0, 0, 20, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19

;---


;---	20

giarith20			ftgen	0, 0, 20, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
giline20			ftgen	0, 0, 20, -2, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot20			ftgen	0, 0, 20, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven20			ftgen	0, 0, 20, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd20			ftgen	0, 0, 20, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist20			ftgen	0, 0, 20, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19

;---


;---	21

giarith21			ftgen	0, 0, 21, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21
giline21			ftgen	0, 0, 21, -2, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot21			ftgen	0, 0, 21, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven21			ftgen	0, 0, 20, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd21			ftgen	0, 0, 22, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist21			ftgen	0, 0, 22, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21

;---


;---	22

giarith22			ftgen	0, 0, 22, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22
giline22			ftgen	0, 0, 22, -2, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot22			ftgen	0, 0, 22, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven22			ftgen	0, 0, 22, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd22			ftgen	0, 0, 22, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist22			ftgen	0, 0, 22, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21

;---


;---	23

giarith23			ftgen	0, 0, 23, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23
giline23			ftgen	0, 0, 23, -2, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot23			ftgen	0, 0, 23, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven23			ftgen	0, 0, 22, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd23			ftgen	0, 0, 24, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist23			ftgen	0, 0, 24, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23

;---


;---	24

giarith24			ftgen	0, 0, 24, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24
giline24			ftgen	0, 0, 24, -2, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot24			ftgen	0, 0, 24, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven24			ftgen	0, 0, 24, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd24			ftgen	0, 0, 24, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist24			ftgen	0, 0, 24, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23

;---


;---	25

giarith25			ftgen	0, 0, 25, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25
giline25			ftgen	0, 0, 25, -2, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot25			ftgen	0, 0, 25, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven25			ftgen	0, 0, 24, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd25			ftgen	0, 0, 26, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist25			ftgen	0, 0, 26, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25

;---


;---	26

giarith26			ftgen	0, 0, 26, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26
giline26			ftgen	0, 0, 26, -2, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot26			ftgen	0, 0, 26, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven26			ftgen	0, 0, 26, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd26			ftgen	0, 0, 26, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist26			ftgen	0, 0, 26, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25

;---


;---	27

giarith27			ftgen	0, 0, 27, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27
giline27			ftgen	0, 0, 27, -2, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot27			ftgen	0, 0, 27, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven27			ftgen	0, 0, 26, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd27			ftgen	0, 0, 28, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist27			ftgen	0, 0, 28, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27

;---


;---	28

giarith28			ftgen	0, 0, 28, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28
giline28			ftgen	0, 0, 28, -2, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot28			ftgen	0, 0, 28, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven28			ftgen	0, 0, 28, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd28			ftgen	0, 0, 28, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist28			ftgen	0, 0, 28, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27

;---


;---	29

giarith29			ftgen	0, 0, 29, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
giline29			ftgen	0, 0, 29, -2, 29, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot29			ftgen	0, 0, 29, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 29, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven29			ftgen	0, 0, 28, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd29			ftgen	0, 0, 30, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 29, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist29			ftgen	0, 0, 30, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29

;---


;---	30

giarith30			ftgen	0, 0, 30, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30
giline30			ftgen	0, 0, 30, -2, 29, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot30			ftgen	0, 0, 30, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 29, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven30			ftgen	0, 0, 30, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd30			ftgen	0, 0, 30, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 29, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist30			ftgen	0, 0, 30, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29

;---


;---	31

giarith31			ftgen	0, 0, 31, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
giline31			ftgen	0, 0, 31, -2, 31, 29, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot31			ftgen	0, 0, 31, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 31, 29, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven31			ftgen	0, 0, 30, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd31			ftgen	0, 0, 32, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 31, 29, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist31			ftgen	0, 0, 32, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31

;---


;---	32

giarith32			ftgen	0, 0, 32, -2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
giline32			ftgen	0, 0, 32, -2, 31, 29, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 32, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
girot32			ftgen	0, 0, 32, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 31, 29, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gieven32			ftgen	0, 0, 32, -2, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 32, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2
giodd32			ftgen	0, 0, 32, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 31, 29, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1
gidist32			ftgen	0, 0, 32, -2, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31

;---


;---	STANDARD

giarith		= giarith4
giline		= giline4
girot		= girot4
gieven		= gieven4
giodd		= giodd4
gidist		= gidist4

;---




;--- ||| --- ||| ---

;		ftgen	ifn, itime, isize, igen, iarga


;	OSCIL GEN
gisine		ftgen	0, 0, gioscildur, 10, 1					; sine wave
gisquare	ftgen	0, 0, gioscildur, 7, 1, gioscildur/2, 1, 0, -1, gioscildur/2, -1		; square wave 
gitri		ftgen	0, 0, gioscildur, 7, 0, gioscildur/4, 1, gioscildur/2, -1, gioscildur/4, 0		; triangle wave 
gisaw		ftgen	0, 0, gioscildur, 7, 1, gioscildur, -1				; sawtooth wave, downward slope

;	TIME GEN
girall		ftgen	0, 0, 16384, 5, giexpzero, 14500, .15, 1500, 1, 385, 1
giacc		ftgen	0, 0, 16384, 5, 1, 1500, .15, 1, 14500, giexpzero
gilinear	ftgen	0, 0, 16384, 7, 0, 16384, 1

/*
;	LFOs GEN
gilowsine	ftgen	0, 0, gienvdur, 10, 1				; sine wave
gilowsquare	ftgen	0, 0, gienvdur, 7, 1, gienvdur/2, 1, 0, -1, gienvdur/2, -1	; square wave 
gilowtri	ftgen	0, 0, gienvdur, 7, 0, gienvdur/4, 1, gienvdur/2, -1, gienvdur/4, 0	; triangle wave 
gilowsaw	ftgen	0, 0, gienvdur, 7, 1, gienvdur, -1			; sawtooth wave, downward slope
*/

;					pna, stra, phsa, dcoa

gihsine	ftgen	0, 0, gienvdur, 9, .5, 1, 0
gihsquare	ftgen	0, 0, gienvdur, 7, 1, gienvdur/2, 1, 0, 0, gienvdur/2		; square wave 
gihtri	ftgen	0, 0, gienvdur, 7, 0, gienvdur/2, 1, gienvdur/2, 0		; triangle wave 
gihsaw	ftgen	0, 0, gienvdur, 7, 1, gienvdur, 0			; sawtooth wave, downward slope

gilowasine	init gihsine
gilowasquare	init gihsquare
gilowatri	init gihtri
gilowasaw	init gihsaw

;		MORE
gioddharm	ftgen	0, 0, gioscildur, 13, 1, 2, 0, 3, 2, 0, 9, .333, 180

gihan		ftgen   0, 0, gienvdur, 20, 2
;		WAVESHAPING
gisigm1		ftgen	0, 0, 257, 9, .5, 1, 270
gisigm2		ftgen	0, 0, 257, 9, .5, 1, 270, 1.5, .35, 90, 2.5, .215, 270, 3.5, .145, 90, 4.5, .115, 270



;--- ||| --- ||| ---

#ifdef hydraudiosync

		instr sender;	schedule tick	

	;kph	init 250
	kph	chnget "heart"
	kph	= (kph * 64) * 24
	kph	= kph % 1

	klast init -1
		
	if (kph < klast) then
	;if metro(25)==1 then
		schedulek "sendsamp", 0, 1
	endif

	klast	= kph

		mrtmsg 1

		endin
		schedule("sender", 0, -1)

		instr revive_control

	kph	chnget "heart"
	kph	= (kph * 4)
	kph	= kph % 1

	klast init -1
		
	if (kph < klast) then
	;if metro(25)==1 then
		schedulek "revive", 0, 1
	endif

	klast	= kph

		endin
		schedule("revive_control", 0, -1)

		instr revive

		mrtmsg 1
		turnoff

		endin


		instr sendsamp

	aout	init 1 
		;print 1
		outch 3, aout

		turnoff

		endin

		instr sendtempo

	kval	= gkpulse
	kval	= kval / 300

		outch 4, a(kval)

		endin
		alwayson("sendtempo")

#end


#ifdef midi

gis_midi init 1

prints "MIDISENDMODE"

	instr gotomidi

idur	= p3
iamp	= p4 * 127
icps	= p5

Sinstr	strget p6

ichn	= 1

indx	init 0

while 	indx < ginstrslen do

	ipos	strcmp Sinstr, gSinstrs[indx]

	if	ipos == 0 then
		itrack = indx
	endif

	indx += 1

od

inote	ftom icps, 2

	noteondur2	ichn, inote, iamp, idur

	endin


	instr midwrite

idur	init p3
iamp	init p4
ienv	init p5
icps	init p6
ich 	init p7
Sinstr	strget p8

inote	ftom icps

itime	times

; real score 
idone	system_i 1, sprintf("echo \'i\t\"%s\"\t%f\t%f\t%f\t%f\t\"%s\"\' >> %s", Sinstr, itime, idur, iamp, inote, sprintf("%i_%s", ich, Sinstr), "./*_i.sco")
 
; dummy score for midi
;idone	system_i 1, sprintf("echo \'i\t\"%s\"\t%f\t%f\t%f\t%f\t\"%s\"\' >> %s", "midwrite", itime, idur, iamp, inote, Sinstr, "./___.sco")

iamp	init iamp * 127

	noteondur2	1+ich, inote, limit(iamp, 25, 127), .125
	
	turnoff

	;midiout_i 244, 1+ich, 0, 96

	;midiout_i 144, 1+ich, inote, limit(iamp, 25, 127)
	
	endin


#end

#ifdef diskclavier

gis_midi init 1

prints "MIDISENDMODE"

	instr midwrite

idur	init p3
iamp	init p4*2
ienv	init p5
icps	init p6
ich 	init 0
Sinstr	strget p8

inote	ftom icps

if idur<10 then
	idur *= 100
	idur floor idur
	idur /= 100

elseif idur>=10 && idur<100 then
	idur *= 100
	idur floor idur
	idur /= 100

elseif idur>=100 && idur<1000 then
	idur *= 100
	idur floor idur
	idur /= 10000

endif


itime	times

if itime<10 then 
	itime *= 10
	itime floor itime
	itime /= 10

elseif itime>=10 && itime<100 then
	itime *= 10
	itime floor itime
	itime /= 10

elseif itime>=100 && itime<1000 then
	itime *= 10
	itime floor itime
	itime /= 10

endif

; real score 
idone	system_i 1, sprintf("echo \'i\t\"%s\"\t%f\t%f\t%f\t%f\t\"%s\"\' >> %s", Sinstr, itime, idur, iamp, inote, Sinstr, "./___.sco")
 
; dummy score for midi
;idone	system_i 1, sprintf("echo \'i\t\"%s\"\t%f\t%f\t%f\t%f\t\"%s\"\' >> %s", "midwrite", itime, idur, iamp, inote, Sinstr, "./___.sco")

iamp	init iamp * 127

	noteondur2	1+ich, inote, limit(iamp, 25, 127), idur/2

	endin


#end



;--- ||| --- ||| ---

;	EMIRROR
;	a palindrome 3(6)-points function from linear segments
giemirror_int		init 9
;-----------------------
giemirror_intatk	init .5
giemirror_intdec	init 1
giemirror_intrel	init 3
;-----------------------
giemirror_atk		init giemirror_intatk / giemirror_int
giemirror_dec		init giemirror_intdec / giemirror_int
giemirror_sus		init .35
giemirror_rel		init giemirror_intrel / giemirror_int
;-----------------------
giemirror		ftgen	0, 0, gienvdur, 5, giexpzero, gienvdur*giemirror_atk, 1, gienvdur*giemirror_dec, giemirror_sus, gienvdur*giemirror_rel, giexpzero, gienvdur*giemirror_rel, giemirror_sus, gienvdur*giemirror_dec, 1, gienvdur*giemirror_atk, giexpzero
;-----------------------



;--- ||| --- ||| ---

;	MIRROR
;	a palindrome 3(6)-points function from linear segments
gimirror_int		init 9
;-----------------------
gimirror_intatk		init .5
gimirror_intdec		init 1
gimirror_intrel		init 3
;-----------------------
gimirror_atk		init gimirror_intatk / gimirror_int
gimirror_dec		init gimirror_intdec / gimirror_int
gimirror_sus		init .35
gimirror_rel		init gimirror_intrel / gimirror_int
;-----------------------
gimirror		ftgen	0, 0, gienvdur, 7, 0, gienvdur*gimirror_atk, 1, gienvdur*gimirror_dec, gimirror_sus, gienvdur*gimirror_rel, 0, gienvdur*gimirror_rel, gimirror_sus, gienvdur*gimirror_dec, 1, gienvdur*gimirror_atk, 0
;-----------------------



;--- ||| --- ||| ---

;	ISOTRAP
;	an isosceles trapezoid
gisotrap_ramp		init sr * 15$ms
gisotrap_seg		init gienvdur-(gisotrap_ramp*2)
;-----------------------
gisotrap		ftgen	0, 0, gienvdur, 7, 0, gisotrap_ramp, 1, gisotrap_seg, 1, gisotrap_ramp, 0
;-----------------------



;--- ||| --- ||| ---

;	SPINA
;	GEN08 — Generate a piecewise cubic spline curve.

gispina_y1		init 0
gispina_x1		init gienvdur/4

gispina_y2		init .125
gispina_x2		init gispina_x1+gienvdur/4

;-----------------------
gispina			ftgen	0, 0, gienvdur, 5, giexpzero, gienvdur/2, 1, gienvdur/2, giexpzero
;-----------------------



;--- ||| --- ||| ---

giatk ftgen 0, 0, 8192, -8, 0.0, 111, 0.94426, 277, 0.24657, 221, 0.07443, 716, 0.08342, 1519, 0.06716, 3715, 0.05532, 1633, 0.0 




;--- ||| --- ||| ---

prints "\n---BITE---\n"
;	a 3-points function from segments of exponential curves

ibite_intatk1	init 11
ibite_intdec1	init 9
ibite_sus1	init .65
ibite_intrel1	init 3

ibite_int1		init ibite_intatk1 + ibite_intdec1 + ibite_intrel1

ibite_atk1  	init ibite_intatk1 / ibite_int1
ibite_dec1  	init ibite_intdec1 / ibite_int1
ibite_rel1		init ibite_intrel1 / ibite_int1

ibite_dur1		init gienvdur/2


ibite_intatk2	init 15
ibite_intdec2	init 5
ibite_sus2	init .45
ibite_intrel2	init 9

ibite_int2		init ibite_intatk2 + ibite_intdec2 + ibite_intrel2

ibite_atk2  	init ibite_intatk2 / ibite_int2
ibite_dec2  	init ibite_intdec2 / ibite_int2
ibite_rel2		init ibite_intrel2 / ibite_int2

ibite_dur2		init gienvdur/2
;-----------------------
gibite		ftgen	0, 0, gienvdur, 5, giexpzero, ibite_atk1*ibite_dur1, 1, ibite_dec1*ibite_dur1, ibite_sus1, ibite_rel1*ibite_dur1, giexpzero, ibite_atk2*ibite_dur1, .75, ibite_dec2*ibite_dur1, ibite_sus2, ibite_rel2*ibite_dur1, giexpzero
;-----------------------



;--- ||| --- ||| ---

;	CLASSIC
;	a 3-points function from linear segments
giclassic_atk		init sr * 5$ms
giclassic_dur		init gienvdur - giclassic_atk
giclassic_int		init 9
giclassic_intdec	init 4
giclassic_dec		init giclassic_intdec / giclassic_int
giclassic_sus		init .15
giclassic_intrel	init giclassic_int-giclassic_intdec
giclassic_rel		init giclassic_intrel / giclassic_int
;-----------------------
giclassic		ftgen	0, 0, gienvdur, 7, 0, giclassic_atk, 1, giclassic_dur*giclassic_dec, giclassic_sus, giclassic_dur*giclassic_rel, 0
;-----------------------



;--- ||| --- ||| ---

;	EAU
;	GEN08 — Generate a piecewise cubic spline curve.
;	y + x

gieau_y1		init 0
gieau_x1		init gienvdur/4

gieau_y2		init .125
gieau_x2		init gieau_x1+gienvdur/4

gieau_y3		init 1
gieau_x3		init gieau_x2+gienvdur/4

gieau_y4		init 0
gieau_x4		init gieau_x3+gienvdur/4


;-----------------------
gieau		ftgen	0, 0, gienvdur, 8,	\
			gieau_y1, gieau_x1, 	\
			gieau_y2, gieau_x2,	\
			gieau_y3, gieau_x3,	\
			gieau_y4, gieau_x4	\

;-----------------------



;--- ||| --- ||| ---

;	ECLASSIC
;	a 3-points function from segments of exponential curves
gieclassic_atk		init sr * 5$ms
gieclassic_dur		init gienvdur - gieclassic_atk
gieclassic_int		init 9
gieclassic_intdec	init 5
gieclassic_dec		init gieclassic_intdec / gieclassic_int
gieclassic_sus		init .15
gieclassic_intrel	init gieclassic_int-gieclassic_intdec
gieclassic_rel		init gieclassic_intrel / gieclassic_int
;-----------------------
gieclassic		ftgen	0, 0, gienvdur, 5, giexpzero, gieclassic_atk, 1, gieclassic_dur*gieclassic_dec, gieclassic_sus, gieclassic_dur*gieclassic_rel, giexpzero
;-----------------------



;--- ||| --- ||| ---

gifade ftgen 0, 0, 8192, -16, 0.0, 4947, -1.9153432377049184, 0.9851, 3245, -2.0763960040983664, 0.0 




;--- ||| --- ||| ---

;	KAZAN
;	a 3-points function from segments of exponential curves
gikazan_int		init 11
gikazan_intatk		init 1
gikazan_intdec		init 9
gikazan_intrel		init gikazan_int-gikazan_intatk-gikazan_intdec
;-----------------------
gikazan_atk		init gikazan_intatk / gikazan_int
gikazan_dec		init gikazan_intdec / gikazan_int
gikazan_sus		init .35
gikazan_rel		init gikazan_intrel / gikazan_int
;-----------------------
print gikazan_atk
print gikazan_dec
print gikazan_sus
print gikazan_rel
;-----------------------
gikazan			ftgen	0, 0, gienvdur, 5, giexpzero, gienvdur*gikazan_atk, 1, gienvdur*gikazan_dec, gikazan_sus, gienvdur*gikazan_rel, giexpzero
;-----------------------



;--- ||| --- ||| ---

;	LIKEAREV
;	a 6-points function from linear segments
gilikearev_atk		init sr * 5$ms
gilikearev_dur		init gienvdur - gilikearev_atk
gilikearev_int		init 32
gilikearev_intdec		init 1
gilikearev_dec		init gilikearev_intdec / gilikearev_int

gilikearev_sus1		init .15
gilikearev_intrel1		init 3
gilikearev_rel1		init gilikearev_intrel1 / gilikearev_int

gilikearev_sus2		init .05
gilikearev_intrel2		init gilikearev_int-gilikearev_intdec-gilikearev_intrel1
gilikearev_rel2		init gilikearev_intrel2 / gilikearev_int

;-----------------------
gilikearev		ftgen	0, 0, gienvdur, 7, 0, gilikearev_atk, 1, gilikearev_dur*gilikearev_dec, gilikearev_sus1, gilikearev_dur*gilikearev_rel1, gilikearev_sus2, gilikearev_dur*gilikearev_rel2, 0
;-----------------------



;--- ||| --- ||| ---

gimaigret ftgen 0, 0, 8192, -16, 0.0, 2627, -2.868532274590164, 1.0, 833, 1.9697745901639352, 0.15309, 1687, 2.590612192622951, 0.0, 758, 5.35978056693989, 0.98238, 2287, 4.082671618852462, 0.0 




;--- ||| --- ||| ---

gitimeless	ftgen 0, 0, 0, 1, "/Users/j/Documents/PROJECTs/IDRA/_core/__gen/__wav/timeless.wav", 0, 0, 1
gicaes	ftgen 0, 0, 0, 1, "/Users/j/Documents/PROJECTs/IDRA/_core/__gen/__wav/caes.wav", 0, 0, 1
gicatdiodio	ftgen 0, 0, 0, 1, "/Users/j/Documents/PROJECTs/IDRA/_core/__gen/__wav/catdiodio.wav", 0, 0, 1
gicubcatdio	ftgen 0, 0, 0, 1, "/Users/j/Documents/PROJECTs/IDRA/_core/__gen/__wav/cubcatdio.wav", 0, 0, 1
gicubdio	ftgen 0, 0, 0, 1, "/Users/j/Documents/PROJECTs/IDRA/_core/__gen/__wav/cubdio.wav", 0, 0, 1
gicudio	ftgen 0, 0, 0, 1, "/Users/j/Documents/PROJECTs/IDRA/_core/__gen/__wav/cudio.wav", 0, 0, 1
gidente	ftgen 0, 0, 0, 1, "/Users/j/Documents/PROJECTs/IDRA/_core/__gen/__wav/dente.wav", 0, 0, 1
gidiocle	ftgen 0, 0, 0, 1, "/Users/j/Documents/PROJECTs/IDRA/_core/__gen/__wav/diocle.wav", 0, 0, 1
gifruit	ftgen 0, 0, 0, 1, "/Users/j/Documents/PROJECTs/IDRA/_core/__gen/__wav/fruit.wav", 0, 0, 1
gigrembo	ftgen 0, 0, 0, 1, "/Users/j/Documents/PROJECTs/IDRA/_core/__gen/__wav/grembo.wav", 0, 0, 1
gired	ftgen 0, 0, 0, 1, "/Users/j/Documents/PROJECTs/IDRA/_core/__gen/__wav/red.wav", 0, 0, 1



;--- ||| --- ||| ---

giclassicr		ftgen	0, 0, gienvdur, 7, 0, giclassic_dur*giclassic_rel, giclassic_sus, giclassic_dur*giclassic_dec, 1, giclassic_atk, 0

gieclassicr		ftgen	0, 0, gienvdur, 5, giexpzero, gieclassic_dur*gieclassic_rel, gieclassic_sus, gieclassic_dur*gieclassic_dec, 1, gieclassic_atk, giexpzero

gikazanr		ftgen	0, 0, gienvdur, 5, giexpzero, gienvdur*gikazan_rel, gikazan_sus, gienvdur*gikazan_dec, 1, gienvdur*gikazan_atk, giexpzero

gilikearevr		ftgen	0, 0, gienvdur, 7, 0, gilikearev_dur*gilikearev_rel2, gilikearev_sus2, gilikearev_dur*gilikearev_rel1, gilikearev_sus1, gilikearev_dur*gilikearev_dec, 1, gilikearev_atk, 0

giclassicrr		ftgen	0, 0, gienvdur, 7, 0, giclassic_atk, 1, giclassic_dur*giclassic_dec, giclassic_sus, giclassic_dur*giclassic_rel, 0




;--- ||| --- ||| ---

;	instruments management
instr KillImpl
  Sinstr = p4 
  if (nstrnum(Sinstr) > 0) then
    turnoff2(Sinstr, 0, 0)
  endif
  turnoff
endin

/* Turns off running instances of named instruments.  Useful when livecoding
  audio and control signal process instruments. May not be effective if for
  temporal recursion instruments as they may be non-running but scheduled in the
  event system. In those situations, try using clear_instr to overwrite the
  instrument definition. */
	opcode kill, 0, S

Sinstr xin
schedule("KillImpl", 0, .05, Sinstr)

	endop
/** Starts running a named instrument for indefinite time using p2=0 and p3=-1. 
  Will first turnoff any instances of existing named instrument first.  Useful
  when livecoding always-on audio and control signal process instruments. */
	opcode start, 0, S

Sinstr xin

if (nstrnum(Sinstr) > 0) then
	kill(Sinstr)
	schedule(Sinstr, ksmps / sr, -1)
endif

	endop

/** Given a random chance value between 0 and 1, calculates a random value and
returns 1 if value is less than chance value. For example, giving a value of 0.7,
it can read as "70 percent of time, return 1; else 0" */
	opcode	choose, i, i

iamount xin
ival = 0

if(random(0,1) < limit:i(iamount, 0, 1)) then
	ival = 1 
endif
	xout ival

	endop

	opcode	givemearray, k, kk[]S
	kdiv, karray[], Sorgan xin

klen	lenarray karray

kph	chnget	Sorgan
kph	=	int(kph * (klen * kdiv) % klen)

ktrig	changed	kph

if (karray[kph] == 1 && ktrig == 1) then
	kout = 1	
else
	kout = 0
endif

	xout	kout
		endop


	opcode	Lau, 0, Skk
Sfilcod, kfactor, kamp xin

kph	chnget	"heart"
kph	= (kph * kfactor) % 1

kdur	= (1 / (gkpulse / (60 * 64))) / kfactor

ichnls = filenchnls(Sfilcod)

if (ichnls == 1) then
	if1	ftgen 0, 0, 0, 1, Sfilcod, 0, 0, 1
	if2	ftgen 0, 0, 0, 1, Sfilcod, 0, 0, 1

elseif (ichnls == 2) then
	if1	ftgen 0, 0, 0, 1, Sfilcod, 0, 0, 1
	if2	ftgen 0, 0, 0, 1, Sfilcod, 0, 0, 2

endif

ktrig	init 1
klast	init -1

if (kph < klast) then
	schedulek("Laurence", 0, kdur, Sfilcod, kfactor, kamp, if1, if2)
endif

klast	= kph

		endop

	opcode	jump, k, k
	kfreq xin

kout	abs	lfo(1, kfreq, 3)
kout	portk	kout, .005

	xout kout
		endop



;	SCALE

gispace[] init 32

	opcode F2M, i, io
iFq, iRnd xin
iNotNum = 12 * (log(iFq/220)/log(2)) + 57
iNotNum = (iRnd == 1 ? round(iNotNum) : iNotNum)
xout iNotNum
	endop

	opcode F2M, k, kO
kFq, kRnd xin
kNotNum = 12 * (log(kFq/220)/log(2)) + 57
kNotNum = (kRnd == 1 ? round(kNotNum) : kNotNum)
xout kNotNum
	endop

opcode rotarray, i[], i[]p
 iInArr[], iPos xin
 iLen lenarray iInArr
 iOutArr[] init iLen
 iPos = (iPos < 0) ? iLen-(abs(iPos%iLen)) : iPos
 indx = 0
 while indx < iLen do
  iOutArr[indx] = iInArr[(iPos+indx)%iLen]
  indx += 1
 od
 xout iOutArr
endop

opcode rotarray, k[], k[]P
 kInArr[], kPos xin
 iLen lenarray kInArr
 kOutArr[] init iLen
 kPos = (kPos < 0) ? iLen-(abs(kPos%iLen)) : kPos
 kndx = 0
 while kndx < iLen do
  kOutArr[kndx] = kInArr[(kPos+kndx)%iLen]
  kndx += 1
 od
 xout kOutArr
endop



;--- ||| --- ||| ---

	opcode	eu, k, kkkSO

	konset, kpulses, kdiv, Sorgan, krot xin

kprev	init -1
keu[]	init 64
kndx	init 0

while kndx < kpulses do
	kval		=	int((konset / kpulses) * kndx)
	kndxrot		=	(kndx + krot) % kpulses
	keu[kndxrot]	=	(kval == kprev ? 0 : 1)
	kprev		=	kval
	kndx		+=	1
od

korgan	chnget	Sorgan
kph	=	(korgan * kdiv) % 1
kph	=	int(kph * kpulses)

ktrig	changed	kph

if (keu[kph] == 1 && ktrig == 1) then
	kout = 1		
else
	kout = 0
endif

	xout	kout

	endop

	opcode	eut, k, kkkO

	konset, kpulses, kdiv, krot xin

Sorgan	= "heart"

kprev	init -1
keu[]	init 64
kndx	init 0

while kndx < kpulses do
	kval		=	int((konset / kpulses) * kndx)
	kndxrot		=	(kndx + krot) % kpulses
	keu[kndxrot]	=	(kval == kprev ? 0 : 1)
	kprev		=	kval
	kndx		+=	1
od

printarray keu

korgan	chnget	Sorgan
kph	=	(korgan * kdiv) % 1
kph	=	int(kph * kpulses)

ktrig	changed	kph

if (keu[kph] == 1 && ktrig == 1) then
	kout = 1		
else
	kout = 0
endif

	xout	kout

	endop


	opcode	euc, 0, kkkSSkOOOOOO
	konset, kpulses, kdiv,
	Sorgan,
	Sinstr,
	kp3, kp4, kp5, kp6, kp7, kp8, kp9 xin

kprev	init -1
keu[]	init 64
kndx	init 0

while kndx < kpulses do
	kval	=	int((konset / kpulses) * kndx)
	keu[kndx]	=	(kval == kprev ? 0 : 1)
	kprev	=	kval
	kndx	+=	1
od

korgan	chnget	Sorgan
kph	=	(korgan * kdiv) % 1
kph	=	int(kph * kpulses)

ktrig	changed	kph


if (keu[kph] == 1 && ktrig == 1) then
	event("i", Sinstr, 0, kp3, kp4, kp5, kp6, kp7, kp8, kp9)
endif

		endop

opcode eujo, k, kkkO
	konset, kpulses, kdiv, krot xin

	kphasor	chnget	"heart"

        kph = int( ( ( (kphasor + krot)  * kdiv) % 1) * kpulses)
        keucval = int((konset / kpulses) * kph)

        kold_euc init i(keucval)
        kold_ph init i(kph)


        kres = ((kold_euc != keucval) && (kold_ph != kph)) ? 1 : 0

        kres init i(kres)

        kold_euc = keucval
        kold_ph = kph

        ;print(i(kres))
        ;printk2 kres

        xout kres
endop

opcode eujot, k, kkkOo
	konset, kpulses, kdiv, krot, iskip xin
	kphasor	chnget	"heart"
        kimp = (timek() > 1) ? 0 : 1

        kph = int( ( ( (kphasor + krot)  * kdiv) % 1) * kpulses)
        keucval = int((konset / kpulses) * kph)
        kold_euc init i(keucval)
        kold_ph init i(kph)

        kres = ((kold_euc != keucval) && (kold_ph != kph)) ? 1 : 0
        if(iskip == 1 && kimp == 1) then
                kres = 0
        endif
   
        kres init i(kres)
        kold_euc = keucval
        kold_ph = kph

        printk2 kres
        xout kres
endop



;--- ||| --- ||| ---

	opcode subscale, k, Skk ;subdivide octave from Sroot in ksub step and output kdegree 

	Sroot, ksub, kdegree xin 

kscaleroot mtof ntom(Sroot)

kmin	= kscaleroot / ksub

kfreq	= (kmin * kdegree) + kscaleroot

	xout	kfreq

	endop



	opcode step, k, SikO	;classic step to use scales from Sroot using iscale output kdegree NB the last parameter is kshiftroot to shift root and scale easy NBB if step = 0 then rest

	Sroot, iscale, kdegree, kshiftroot xin 

iscaleroot ntom Sroot

kscaleroot = iscaleroot + kshiftroot

idegrees = ftlen(iscale)

ktrig	changed kdegree

if	(kdegree != 0) then

	kdegree -= 1

	kbase = kscaleroot

	koct = int(kdegree / idegrees)
	kndx = kdegree % idegrees

	if(kndx < 0) then
		koct -= 1
		kndx += idegrees
	endif

	ktab	table kndx, iscale

	kres	= cpsmidinn(kbase + (koct * 12) + ktab)

else
	
	kres	= 0

endif

	xout kres

	endop


	opcode step, k, iikO	;classic step to use scales from Sroot using iscale output kdegree NB the last parameter is kshiftroot to shift root and scale easy NBB if step = 0 then rest

	iscaleroot, iscale, kdegree, kshiftroot xin 

kscaleroot = iscaleroot + kshiftroot

idegrees = ftlen(iscale)

ktrig	changed kdegree

if	(kdegree != 0) then

	kdegree -= 1

	kbase = kscaleroot

	koct = int(kdegree / idegrees)
	kndx = kdegree % idegrees

	if(kndx < 0) then
		koct -= 1
		kndx += idegrees
	endif

	ktab	table kndx, iscale

	kres	= cpsmidinn(kbase + (koct * 12) + ktab)

else
	
	kres	= 0

endif

	xout kres

	endop

	opcode triad, k, SikO	;for each note make a triad 
	Sroot, iscale, kdegree, kshiftroot xin 

iscaleroot ntom Sroot

kscaleroot = iscaleroot + kshiftroot

idegrees = ftlen(iscale)

ktrig	changed kdegree

kwhile	= 0
	
while kwhile < 3 do
	kdegree -= 1

	kbase = kscaleroot

	koct = int(kdegree / idegrees)
	kndx = kdegree % idegrees

	if(kndx < 0) then
		koct -= 1
		kndx += idegrees
	endif

	printk2 kwhile*kndx
	printk2 kndx

	ktab	table kndx+kwhile, iscale

	kres	= cpsmidinn(kbase + (koct * 12) + ktab)

	kwhile += 1
	xout kres
od

	endop


	opcode chromatic, k, Sk ;opcode to easy use chromatic tempered scale

	Sroot, kdegree xin 

iscaleroot ntom Sroot

idegrees = 12

kbase = iscaleroot

koct = int(kdegree / idegrees)
kndx = kdegree % idegrees

if(kndx < 0) then
	koct -= 1
	kndx += idegrees
endif

	xout cpsmidinn(kbase + (koct * 12) + kndx)
	
	endop




;--- ||| --- ||| ---

	opcode accent, k, kJJ
	ieach, kdynacc, kfact xin

if	kfact==-1 then
	kfact = .65
endif

if	kdynacc==-1 then
	kdynacc = $f
endif

kdyn = kdynacc*kfact

klist[]	init ieach
klist[0]= kdynacc
kndx1	init 1

while	kndx1<ieach do
	klist[kndx1] = kdyn
	kndx1 += 1
od

kndx2	init 0
if	kndx2==ieach then
	kndx2 = 0
endif

kres	= klist[kndx2]
kndx2	+= 1


	xout kres
	endop




;--- ||| --- ||| ---

	opcode accenth, k, kJJ
	kdiv, kdyn1, kdyn2 xin

;	INIT

if	kdyn1==-1 then
	kdyn1 = $f
endif

if	kdyn2==-1 then
	kdyn2 = kdyn1*2/3
endif

karr[]	init 16
kval	= 1
until kval==(lenarray(karr)-1) do
	karr[kval] = kdyn2
	kval += 1
od

karr[0]	= kdyn1

kphase	abs floor(kdiv)-kdiv

kndx	= ((chnget:k("heart")*kdiv*gkdiv)+kphase)%1
kndx	*= kdiv

kres	= karr[int(kndx)]

	xout kres
	endop




;--- ||| --- ||| ---

;	e Sk
#define e_Sk_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, kch, Sinstr
	endif

endif

#
	opcode	e, 0, SkkkkOOOO
Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

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
		$e_Sk_kcps(kcps1)
		$e_Sk_kcps(kcps2)
		$e_Sk_kcps(kcps3)
		$e_Sk_kcps(kcps4)
		$e_Sk_kcps(kcps5)

	$showmek

endif

		endop

;	e kSk
#define e_kSk_kcps(kcps) #

if	($kcps != 0) then
	
	if (kch	== 0) then
		kch = 1
		until kch > ginchnls do
			schedulek	Sinstr, gkzero+random:k(0, kmodulo), kdur, kamp, kenv, $kcps, kch
			kch += 1
		od

		if gis_midi==1 then
			schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, kch, Sinstr
		endif

	else 
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch
		
		if gis_midi==1 then
			schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, kch, Sinstr
		endif


	endif

endif

#
	opcode	e, 0, kSkkkkOOOO
kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

	$ch_limit

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
	$e_kSk_kcps(kcps1)
	$e_kSk_kcps(kcps2)
	$e_kSk_kcps(kcps3)
	$e_kSk_kcps(kcps4)
	$e_kSk_kcps(kcps5)

	$showmek

endif

	endop

;	e iSk
#define e_iSk_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, itrack, Sinstr
	endif

endif

#
	opcode	e, 0, iSkkkkOOOO
itrack, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

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
		$e_iSk_kcps(kcps1)
		$e_iSk_kcps(kcps2)
		$e_iSk_kcps(kcps3)
		$e_iSk_kcps(kcps4)
		$e_iSk_kcps(kcps5)

	$showmek

endif

		endop

;	e ikSk
#define e_ikSk_kcps(kcps) #

if	($kcps != 0) then
	
	if (kch	== 0) then
		kch = 1
		until kch > ginchnls do
			schedulek	Sinstr, gkzero+random:k(0, kmodulo), kdur, kamp, kenv, $kcps, kch
			kch += 1
		od

		if gis_midi==1 then
			schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, itrack, Sinstr
		endif

	else 
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch
		
		if gis_midi==1 then
			schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, itrack, Sinstr
		endif


	endif

endif

#
	opcode	e, 0, ikSkkkkOOOO
itrack, kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

	$ch_limit

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
	$e_ikSk_kcps(kcps1)
	$e_ikSk_kcps(kcps2)
	$e_ikSk_kcps(kcps3)
	$e_ikSk_kcps(kcps4)
	$e_ikSk_kcps(kcps5)

	$showmek

endif

	endop




;--- ||| --- ||| ---

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



;--- ||| --- ||| ---

;	ed_kcps
#define ed_kcps(kcps) #

kch1	= kch
kch2	= (kch1%ginchnls)+1

if	($kcps != 0) then
	
	if (kch	== 0) then
		until kch > ginchnls do
			schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch
			kch += 1
		od
	else 
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch1
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch2

	endif

	if gis_midi==1 then
		schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, kch, Sinstr
	endif

endif

#
	opcode	ed, 0, kSkkkkOOOO
kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

$ch_limit

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
	
	$ed_kcps(kcps1)	
	$ed_kcps(kcps2)	
	$ed_kcps(kcps3)	
	$ed_kcps(kcps4)	
	$ed_kcps(kcps5)	
	
	$showmek

endif

	endop

;	ed_ikcps
#define ed_ikcps(kcps) #

kch1	= kch
kch2	= (kch1%ginchnls)+1

if	($kcps != 0) then
	
	if (kch	== 0) then
		until kch > ginchnls do
			schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch
			kch += 1
		od
	else 
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch1
		schedulek	Sinstr, gkzero, kdur, kamp, kenv, $kcps, kch2

	endif

	if gis_midi==1 then
		schedulek	"midwrite", gkzero, kdur, kamp, kenv, $kcps, itrack, Sinstr
	endif

endif

#
	opcode	ed, 0, ikSkkkkOOOO
itrack, kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

$ch_limit

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
	
	$ed_ikcps(kcps1)	
	$ed_ikcps(kcps2)	
	$ed_ikcps(kcps3)	
	$ed_ikcps(kcps4)	
	$ed_ikcps(kcps5)	
	
	$showmek

endif

	endop



;--- ||| --- ||| ---

    opcode edo, i, Sii
Sroot, iedo, ideg xin

icps    mtof ntom(Sroot)

ioctave = floor(((ideg-1)/iedo))+1
istep = (ideg-1)%iedo 
irange = (icps*ioctave)/iedo
ires    = icps*(2^ioctave)+(irange*istep)

    xout ires
    endop

    opcode edo, k, Skk
Sroot, kedo, kdeg xin

kcps    mtof ntom(Sroot)
kstep   = kcps/kedo

kres    = kcps+(kdeg*kstep)

    xout kres
    endop

    opcode rpredo, i, Sii
Sroot, iedo, ideg xin

icps    mtof ntom(Sroot)

ioctave = floor(((ideg-1)/iedo))+1
istep = (ideg-1)%iedo 
irange = (icps*ioctave)/iedo
ires    = icps*(2^ioctave)+(irange*istep)

	prints "%s\n", mton(ftom(ires))

    xout ires
    endop



;--- ||| --- ||| ---

gimorf		ftgen 0, 0, gienvdur, 10, 1
gimorfsyn		ftgen 0, 0, gioscildur, 10, 1

	opcode envgen, a, ii
	idur, iftenv	xin
	
ifenvmod	init	floor(iftenv)-iftenv
iftenvreal	abs	floor(iftenv)

if	ifenvmod == 0 then

	if	iftenv > 0 then
		alinenv	linseg 0, idur, gienvdur
	else
		alinenv	linseg gienvdur, idur, 0
	endif

else 

	iatk	abs ifenvmod

	if	iftenv > 0 then

		ires	init 0
		indx	init 0
		ilast	init idur-iatk
		
		until ires==1 do
			ires	table3 indx, abs(iftenv)
			indx	+= 1
		od

		if	iatk<ilast then
			alinenv	linseg 0, iatk, indx, ilast, gienvdur
		else
			alinenv	linseg 0, idur, gienvdur
		endif

	else

		ires	init 0
		indx	init 0
		ilast	init idur-iatk
			
		until ires==1 do
			ires	table3 indx, abs(iftenv)
			indx	+= 1
		od
		
		if	iatk<ilast then
			alinenv	linseg gienvdur, ilast, indx, iatk, 0
		else
			alinenv	linseg gienvdur, idur, 0
		endif

	endif

endif

if	iftenvreal==gimorf then
	amorf	table3 alinenv, iftenvreal
	aramp	table3 alinenv, gisotrap
	aenv	= amorf*aramp
else
	aenv	table3 alinenv, iftenvreal
endif

	xout aenv
	endop



;--- ||| --- ||| ---

;	eva Sk
#define eva_Sk_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", 0, 1, kamp, kenv, $kcps, kch, Sinstr
	endif

endif

#
	opcode	eva, 0, SkkkkOOOO
Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

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
		$eva_Sk_kcps(kcps1)
		$eva_Sk_kcps(kcps2)
		$eva_Sk_kcps(kcps3)
		$eva_Sk_kcps(kcps4)
		$eva_Sk_kcps(kcps5)

	$showmek

endif

		endop

;	eva kSk
#define eva_kSk_kcps(kcps) #

if	($kcps != 0) then
	
	if (kch	== 0) then
		kch = 1
		until kch > ginchnls do
			schedulek	Sinstr, 0+random:k(0, kmodulo), kdur, kamp, kenv, $kcps, kch
			kch += 1
		od

		if gis_midi==1 then
			schedulek	"midwrite", 0, 1, kamp, kenv, $kcps, kch, Sinstr
		endif

	else 
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
		
		if gis_midi==1 then
			schedulek	"midwrite", 0, 1, kamp, kenv, $kcps, kch, Sinstr
		endif


	endif

endif

#
	opcode	eva, 0, kSkkkkOOOO
kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

	$ch_limit

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
	$eva_kSk_kcps(kcps1)
	$eva_kSk_kcps(kcps2)
	$eva_kSk_kcps(kcps3)
	$eva_kSk_kcps(kcps4)
	$eva_kSk_kcps(kcps5)

	$showmek

endif

	endop


;	eva SS
#define eva_SS_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", 0, 1, kamp, kenv, $kcps, kch, Sinstr
	endif

endif

#
	opcode	eva, 0, SSkkkkOOOO
Sinstr1, Sinstr2, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

kchange		init 0

if	kchange == 0 then
	Sinstr	strcpyk Sinstr1
	kchange = 1
else
	Sinstr	strcpyk Sinstr2
	kchange = 0
endif


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
		$eva_SS_kcps(kcps1)
		$eva_SS_kcps(kcps2)
		$eva_SS_kcps(kcps3)
		$eva_SS_kcps(kcps4)
		$eva_SS_kcps(kcps5)

	$showmek

endif

		endop

;	ieva Sk
#define ieva_Sk_kcps(icps) #

if	($icps != 0) then	
	ich		= 1
	until ich > ginchnls do
		schedule	Sinstr, 0, idur, i(kamp), i(kenv), $icps, ich
		ich += 1
	od
endif

#
	opcode	ieva, 0, SkkkkOOOO
Sinstr, idur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

if	idur > giminnote && kamp > 0 then

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
		$ieva_Sk_kcps(i(kcps1))
		$ieva_Sk_kcps(i(kcps2))
		$ieva_Sk_kcps(i(kcps3))
		$ieva_Sk_kcps(i(kcps4))
		$ieva_Sk_kcps(i(kcps5))


endif

		endop




;--- ||| --- ||| ---

	opcode	evaMIDI, 0, Siiiii
Sinstr, iwhen, idur, iamp, ienv, icps xin

if	idur > giminnote && iamp > 0 then

	;	generate event
	ich		= 1
	until ich > ginchnls do
		schedule	Sinstr, iwhen, idur, iamp, ienv, icps, ich
		ich += 1
	od

endif

	endop

	opcode	evaMIDImode, 0, Siiiiiii
Sinstr, iwhen, idur, iamp, ienv, icps, imode, imodp1 xin

if	idur > giminnote && iamp > 0 then

	;	generate event
	ich		= 1
	until ich > ginchnls do
		schedule	Sinstr, iwhen, idur, iamp, ienv, icps, ich, imode, imodp1
		ich += 1
	od

endif

	endop




;--- ||| --- ||| ---

;	eva_karr
#define eva_karr(kcps) #

kch1	= kcharr[0]
kch2	= kcharr[1]

if	($kcps != 0) then
	
	if (kch1 == 0) then
		until kch1 > ginchnls do
			schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch1
			kch1 += 1
		od
	else 
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch1
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch2

	endif

	if gis_midi==1 then
		schedulek	"midwrite", 0, kdur, kamp, kenv, $kcps, kch1, Sinstr
	endif

endif

#

	opcode	eva, 0, k[]SkkkkOOOO
kcharr[], Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

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
	
	$eva_karr(kcps1)	
	$eva_karr(kcps2)	
	$eva_karr(kcps3)	
	$eva_karr(kcps4)	
	$eva_karr(kcps5)	
	
	$showmek

endif

	endop




;--- ||| --- ||| ---

;	eva Sk

#define eva_disk_Sk_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, 0+.405, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", 0, 1, kamp, kenv, $kcps, kch, Sinstr
	endif

endif

#

	opcode	eva_disk, 0, SkkkkOOOO
Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

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
		$eva_disk_Sk_kcps(kcps1)
		$eva_disk_Sk_kcps(kcps2)
		$eva_disk_Sk_kcps(kcps3)
		$eva_disk_Sk_kcps(kcps4)
		$eva_disk_Sk_kcps(kcps5)

	$showmek

endif

		endop


;	eva Sk

#define eva_disk1_Sk_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, 0+.405, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", 0, 1, kamp, kenv, $kcps*2, kch, Sinstr
	endif

endif

#

	opcode	eva_disk1, 0, SkkkkOOOO
Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

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
		$eva_disk1_Sk_kcps(kcps1)
		$eva_disk1_Sk_kcps(kcps2)
		$eva_disk1_Sk_kcps(kcps3)
		$eva_disk1_Sk_kcps(kcps4)
		$eva_disk1_Sk_kcps(kcps5)

	$showmek

endif

		endop




;--- ||| --- ||| ---

;	eva iSk
#define eva_iSk_kcps(kcps) #

if	($kcps != 0) then
	
	kch		= 1
	until kch > ginchnls do
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
		kch += 1
	od

	if gis_midi==1 then
		schedulek	"midwrite", 0, kdur, kamp, kenv, $kcps, itrack, Sinstr
	endif

endif

#
	opcode	eva_i, 0, iSkkkkOOOO
itrack, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

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
		$eva_iSk_kcps(kcps1)
		$eva_iSk_kcps(kcps2)
		$eva_iSk_kcps(kcps3)
		$eva_iSk_kcps(kcps4)
		$eva_iSk_kcps(kcps5)

	$showmek

endif

		endop

;	eva ikSk
#define eva_ikSk_kcps(kcps) #

if	($kcps != 0) then
	
	if (kch	== 0) then
		kch = 1
		until kch > ginchnls do
			schedulek	Sinstr, 0+random:k(0, kmodulo), kdur, kamp, kenv, $kcps, kch
			kch += 1
		od

		if gis_midi==1 then
			schedulek	"midwrite", 0, kdur, kamp, kenv, $kcps, itrack, Sinstr
		endif

	else 
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
		
		if gis_midi==1 then
			schedulek	"midwrite", 0, kdur, kamp, kenv, $kcps, itrack, Sinstr
		endif


	endif

endif

#
	opcode	eva_i, 0, ikSkkkkOOOO
itrack, kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

	$ch_limit

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
	$eva_ikSk_kcps(kcps1)
	$eva_ikSk_kcps(kcps2)
	$eva_ikSk_kcps(kcps3)
	$eva_ikSk_kcps(kcps4)
	$eva_ikSk_kcps(kcps5)

	$showmek

endif

	endop




;--- ||| --- ||| ---

;	evad_kcps
#define evad_kcps(kcps) #

kch1	= kch
kch2	= (kch1%ginchnls)+1

if	($kcps != 0) then
	
	if (kch	== 0) then
		until kch > ginchnls do
			schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
			kch += 1
		od
	else 
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch1
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch2

	endif

	if gis_midi==1 then
		schedulek	"midwrite", 0, kdur, kamp, kenv, $kcps, kch, Sinstr
	endif

endif

#
	opcode	evad, 0, kSkkkkOOOO
kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

$ch_limit

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
	
	$evad_kcps(kcps1)	
	$evad_kcps(kcps2)	
	$evad_kcps(kcps3)	
	$evad_kcps(kcps4)	
	$evad_kcps(kcps5)	
	
	$showmek

endif

	endop

;	evad_ikcps
#define evad_ikcps(kcps) #

kch1	= kch
kch2	= (kch1%ginchnls)+1

if	($kcps != 0) then
	
	if (kch	== 0) then
		until kch > ginchnls do
			schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch
			kch += 1
		od
	else 
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch1
		schedulek	Sinstr, 0, kdur, kamp, kenv, $kcps, kch2

	endif

	if gis_midi==1 then
		schedulek	"midwrite", 0, kdur, kamp, kenv, $kcps, itrack, Sinstr
	endif

endif

#
	opcode	evad_i, 0, ikSkkkkOOOO
itrack, kch, Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

$ch_limit

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
	
	$evad_ikcps(kcps1)	
	$evad_ikcps(kcps2)	
	$evad_ikcps(kcps3)	
	$evad_ikcps(kcps4)	
	$evad_ikcps(kcps5)	
	
	$showmek

endif

	endop



;--- ||| --- ||| ---

	opcode fc, k, SiSP
	Sroot, igen, Sdest, kdiv xin 

ifreq	ntof Sroot
idest	ntof Sdest

korgan	chnget "heart"
kph	= (korgan * kdiv) % 1
kcurve	tablei kph, igen, 1

if ifreq < idest then

	kres	= ifreq + (kcurve * idest)

else

	kres	= idest + (abs(1-kcurve) * ifreq)

endif

	xout kres

	endop

	opcode fc, k, kikP
	kbase, igen, kdest, kdiv xin 

korgan	chnget "heart"
kph	= (korgan * kdiv) % 1
kcurve	tablei kph, igen, 1

if kbase < kdest then

	kres	= kbase + (kcurve * kdest)

else

	kres	= kdest + (abs(1-kcurve) * kbase)

endif

	xout kres

	endop




;--- ||| --- ||| ---

	opcode fc3, k, SiSP
	Sroot, igen, Sdest, kdiv xin 

ifreq	ntof Sroot
idest	ntof Sdest

korgan	chnget "heart"
kph	= (korgan * kdiv) % 1
kcurve	table3 kph, igen, 1

if ifreq < idest then

	kres	= ifreq + (kcurve * idest)

else

	kres	= idest + (abs(1-kcurve) * ifreq)

endif

	xout kres

	endop

	opcode fc3, k, kikP
	kbase, igen, kdest, kdiv xin 

korgan	chnget "heart"
kph	= (korgan * kdiv) % 1
kcurve	table3 kph, igen, 1

if kbase < kdest then

	kres	= kbase + (kcurve * kdest)

else

	kres	= kdest + (abs(1-kcurve) * kbase)

endif

	xout kres

	endop




;--- ||| --- ||| ---

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




;--- ||| --- ||| ---

	opcode	getallout, 0, Po
kgain, indx xin

if	indx==((ginstrslen*ginchnls)-1) goto next
	getallout kgain, indx+1

next:	

inum	init indx%ginstrslen
ich	init indx%ginchnls

;prints sprintf("%s_%i\n", gSinstrs[inum], ich+1)

ain		chnget sprintf("%s_%i", gSinstrs[inum], ich+1)
aout		= ain * portk(kgain, 5$ms)

		chnmix aout, gSmouth[ich]
	endop




;--- ||| --- ||| ---

	opcode	getmech, 0, SOjPo
Sinstr, kch, ift, kgain, ich	xin

if	ich==ginchnls-1 goto next
		getmech Sinstr, kch, ift, kgain, ich+1

next:	

if ift == -1 then
	ift = girot
endif

imap		table ich, ift

kch		*= ginchnls

if	floor(kch)==imap-1 then
	;printsk "ch: %i map %i -- %f \n", ich+1, imap, floor(kch)

	kch	= kch%1
	ktab	table3 abs(kch/2), gisine, 1
else
	ktab	= 0
endif

ain		chnget sprintf("%s_%i", Sinstr, ich+1)
aout		= ain * ktab * 2
aout		*= kgain

		chnmix aout, gSmouth[ich]

	endop




;--- ||| --- ||| ---

	opcode	getmeout, 0, SPo
Sinstr, kgain, ich	xin

if		ich==ginchnls-1 goto next
		getmeout Sinstr, kgain, ich+1

next:	

ain		chnget sprintf("%s_%i", Sinstr, ich+1)
aout		= ain

aout		*= kgain

		chnmix aout, gSmouth[ich]
	endop

	opcode	getmeout, 0, Sao
Sinstr, again, ich	xin

if		ich==ginchnls-1 goto next
		getmeout Sinstr, again, ich+1

next:	

ain		chnget sprintf("%s_%i", Sinstr, ich+1)
aout		= ain

aout		*= again

		chnmix aout, gSmouth[ich]
	endop




;--- ||| --- ||| ---

#define hex_print
#
if kbit_indx==0 then
	if	kbeat_pat==0 then
		printks	"				𝄿 𝄿 𝄿 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==1 then
		printks	"				𝄿 𝄿 𝄿 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==2 then
		printks	"				𝄿 𝄿 𝅘𝅥𝅯 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==3 then
		printks	"				𝄿 𝄿 𝅘𝅥𝅯 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==4 then
		printks	"				𝄿 𝅘𝅥𝅯 𝄿 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==5 then
		printks	"				𝄿 𝅘𝅥𝅯 𝄿 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==6 then
		printks	"				𝄿 𝄿 𝄿 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==7 then
		printks	"				𝄿 𝅘𝅥𝅯 𝅘𝅥𝅯 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==8 then
		printks	"				𝅘𝅥𝅯 𝄿 𝄿 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==9 then
		printks	"				𝅘𝅥𝅯 𝄿 𝄿 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==10 then
		printks	"				𝅘𝅥𝅯 𝄿 𝅘𝅥𝅯 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==11 then
		printks	"				𝅘𝅥𝅯 𝄿 𝅘𝅥𝅯 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==12 then
		printks	"				𝅘𝅥𝅯 𝅘𝅥𝅯 𝄿 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==13 then
		printks	"				𝅘𝅥𝅯 𝅘𝅥𝅯 𝄿 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==14 then
		printks	"				𝅘𝅥𝅯 𝅘𝅥𝅯 𝅘𝅥𝅯 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==15 then
		printks	"				𝅘𝅥𝅯 𝅘𝅥𝅯 𝅘𝅥𝅯 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	endif
endif
#


opcode hex, k, SkO
	Spat, kdiv, krot xin

	korgan	chnget "heart"
	kph	= (korgan * kdiv) % (1/16)

	klast init -1
	ktick init 0
	kpat_indx init 0
	kend_pat init 1	
	Shex init "0"
	
	if (kph < klast) then

		ktick += 1

		kstrlen = strlenk(Spat)

		if (kstrlen > 0) then

			ktick	+= krot%2
	
			;4 bits/beats per hex value
			kpat_len = strlenk(Spat) * 4
			;get beat within pattern length
			ktick = ktick % kpat_len
			;figure which hex value to use from string
			kpat_indx = int(ktick / 4)
			kend_pat = kpat_indx + 1
			;figure out which bit from hex to use
			kbit_indx = ktick % 4 
			
			Shex		strcatk "0x", strsubk(Spat, kpat_indx, kend_pat)
			;Shex		strcatk "0x", strsubk(Spat, kbeg, kend)
			
			;printks Shex, 0
			;convert individual hex from string to decimal/binary
			kbeat_pat	strtolk Shex
			;kbeat_pat = 0

			$hex_print

			;bit shift/mask to check onset from hex's bits
			kout = (kbeat_pat >> (3 - kbit_indx)) & 1 
			
		endif

	else
	
		kout = 0	

	endif
	
	klast	= kph

	xout kout

endop



;--- ||| --- ||| ---

	opcode	lfh, k, Jj
kdiv, ift xin

;	INIT
if	kdiv == -1 then
	kdiv = 3
elseif	kdiv == 0 then
	kdiv = 1
endif

if	ift == -1 then
	ift init gilowasine
endif

kphase	abs floor(kdiv)-kdiv

kndx		= ((chnget:k("heart")*kdiv)+kphase)%1

kout	table kndx, ift, 1

	xout kout
	endop

	opcode	lfh, a, Jj
kdiv, ift xin

;	INIT
if	kdiv == -1 then
	kdiv = 3
elseif	kdiv == 0 then
	kdiv = 1
endif

if	ift == -1 then
	ift init gilowasine
endif

kphase	abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv)+kphase)%1

aout	table andx, ift, 1

	xout aout
	endop



;--- ||| --- ||| ---

	opcode	metrout, 0, SiiP
Sinstr, iout1, iout2, kgain xin

ain		chnget sprintf("%s_%i", Sinstr, 1)
aout		= ain * portk(kgain, 5$ms)

		outch iout1, aout, iout2, aout

		endop



;--- ||| --- ||| ---


	opcode morpheus, i, kiiooo
	kndx, ift1, ift2, ift3, ift4, ift5 xin

ifno		init giclassic

iftmorf1	abs	floor(ift1)
iftmorf2	abs	floor(ift2)
iftmorf3	abs	floor(ift3)
iftmorf4	abs	floor(ift4)
iftmorf5	abs	floor(ift5)

ifact		init .995

if	ift3==0 then
	ifno	ftgenonce 0, 0, 2, -2, iftmorf1, iftmorf2
		ftmorf kndx*ifact, ifno, gimorf
elseif	ift3>0&&ift4==0 then
	ifno	ftgenonce 0, 0, 3, -2, iftmorf1, iftmorf2, iftmorf3
		ftmorf kndx*(ifact+1), ifno, gimorf
elseif	ift4>0&&ift5==0 then
	ifno	ftgenonce 0, 0, 4, -2, iftmorf1, iftmorf2, iftmorf3, iftmorf4
		ftmorf kndx*(ifact+2), ifno, gimorf
elseif	ift5>0 then
	ifno	ftgenonce 0, 0, 5, -2, iftmorf1, iftmorf2, iftmorf3, iftmorf4, iftmorf5
		ftmorf kndx*(ifact+3), ifno, gimorf
endif

	xout gimorf
	endop

	opcode morpheusyn, i, kiiooo
	kndx, ift1, ift2, ift3, ift4, ift5 xin

ifno		init giclassic

iftmorf1	abs	floor(ift1)
iftmorf2	abs	floor(ift2)
iftmorf3	abs	floor(ift3)
iftmorf4	abs	floor(ift4)
iftmorf5	abs	floor(ift5)

ifact		init .995

if	ift3==0 then
	ifno	ftgenonce 0, 0, 2, -2, iftmorf1, iftmorf2
		ftmorf kndx*ifact, ifno, gimorfsyn
elseif	ift3>0&&ift4==0 then
	ifno	ftgenonce 0, 0, 3, -2, iftmorf1, iftmorf2, iftmorf3
		ftmorf kndx*(ifact+1), ifno, gimorfsyn
elseif	ift4>0&&ift5==0 then
	ifno	ftgenonce 0, 0, 4, -2, iftmorf1, iftmorf2, iftmorf3, iftmorf4
		ftmorf kndx*(ifact+2), ifno, gimorfsyn
elseif	ift5>0 then
	ifno	ftgenonce 0, 0, 5, -2, iftmorf1, iftmorf2, iftmorf3, iftmorf4, iftmorf5
		ftmorf kndx*(ifact+3), ifno, gimorfsyn
endif

	xout gimorf
	endop



;--- ||| --- ||| ---

	opcode once, k, k[]
	kdegrees[] xin

kndx	init 0
klen	lenarray kdegrees

if	kndx==klen then
	kndx = 0
endif

kres	= kdegrees[kndx]
kndx	+= 1

	xout kres
	endop

	opcode once, S, S[]
	String[] xin

kndx	init 0
ilen	lenarray String

if	kndx==ilen then
	kndx = 0
endif

Sout	= String[kndx]
kndx	+= 1

	xout Sout
	endop


	opcode oncegen, k, i
	igen xin

ilen	ftlen abs(igen)
kndx	init 0

if	igen > 0 then
	kfact = +1
elseif	igen < 0 then
	kfact = -1
endif

if	kndx==ilen then
	kndx = 0
endif

kres	tab kndx, abs(igen)

kndx	= ((kndx+kfact)+ilen)%ilen

	xout kres
	endop

	opcode oncegen2, k[], i
	igen xin

ilen	ftlen abs(igen)

kndx	init 0

kres[]	init 2

if	igen > 0 then
	kfact = +1
elseif	igen < 0 then
	kfact = -1
endif

if	kndx==ilen then
	kndx = 0
endif

kndx	= ((kndx+kfact)+ilen)%ilen
kres1	tab kndx, abs(igen)
kres2	tab (kndx+1)%ilen, abs(igen)

kres	fillarray kres1, kres2

	xout kres
	endop





;--- ||| --- ||| ---

	opcode	one, k, 0

kres	init 0

if	kres==1 then
	xout kres
	printk2 kres
endif

kres	+= 1

	endop



;--- ||| --- ||| ---

	opcode	givemeheart, k, kk[]
	kdiv, kheart[] xin

klen	lenarray kheart

kph	chnget	"heart"
kph	=	int(kph * (klen * kdiv) % klen)

ktrig	changed	kph

if (kheart[kph] == 1 && ktrig == 1) then
	kout = 1	
else
	kout = 0
endif

	xout	kout
		endop

	opcode	givemelungs, k, kk[]
	kdiv, klungs[] xin

klen	lenarray klungs

kph	chnget	"heart"
kph	=	int(kph * (klen * kdiv) % klen)

ktrig	changed	kph

if (klungs[kph] == 1 && ktrig == 1) then
	kout = 1	
else
	kout = 0
endif

	xout	kout
		endop

	opcode	circle, k, kk[]

	kdiv, kvals[] xin

	klen	lenarray kvals

	kph	chnget	"heart"
	kph	=	int(((kph * kdiv) % 1) * klen)

	ktrig	changed	kph

	if (ktrig == 1) then
	kout = kvals[kph]	
	endif
	
	xout kout

	endop

	opcode	pump, k, kk[] ; in heart output kvals[] every kdiv
	kdiv, kvals[] xin

kdiv	init i(kdiv)

klen	lenarray kvals

kph	chnget	"heart"
kph	=	int(((kph * kdiv) % 1) * klen)

ktrig	changed	kph

if (ktrig == 1) then
kout = kvals[kph]	
endif
	
	xout kout

	endop

	opcode	pumparr, k[], kk[]
	kdiv, kvals[] xin

kout[]	init 64

klen	lenarray kvals

kph	chnget	"heart"
kph	=	int(((kph * kdiv) % 1) * klen)

ktrig	changed	kph

if (ktrig == 1) then
	kout = kvals[kph]	
endif
	
	xout kout
		endop

	opcode	breathe, k, kk[]
	kdiv, kvals[] xin

	kout	init 0

	klen	lenarray kvals

	kph	chnget	"lungs"
	kph	=	int(((kph * kdiv) % 1) * klen)

	ktrig	changed	kph

	if (ktrig == 1) then
	kout = kvals[kph]	
	endif
	
	xout kout
	endop

	opcode	heartmurmur, k, kk
	kdiv, kval xin

kdyn	init 0

kph	chnget	"heart"
kph	= (kph * kdiv) % 1

kdyn	= kval - (kph * kval)
	
	xout kdyn
		endop

	opcode	suspire, k, kk
	kdiv, kval xin

kdyn	init 0

kph	chnget	"lungs"
kph	= (kph * kdiv) % 1

kdyn	= kval - (kph * kval)
	
	xout kdyn
		endop

	opcode	pumps, S, kS[]
	kdiv, Svals[] xin

	kout	init 0

	klen	lenarray Svals

	kph	chnget	"heart"
	kph	=	int(((kph * kdiv) % 1) * klen)

	ktrig	changed	kph

	if (ktrig == 1) then
	Sout = Svals[kph]	
	endif
	
	xout Sout
	endop

	opcode	breathes, S, kS[]
	kdiv, Svals[] xin

	kout	init 0

	klen	lenarray Svals

	kph	chnget	"lungs"
	kph	=	int(((kph * kdiv) % 1) * klen)

	ktrig	changed	kph

	if (ktrig == 1) then
	Sout = Svals[kph]	
	endif
	
	xout Sout
	endop


	opcode	circleconst, k, kk[]

	kdiv, kvals[] xin

	klen	lenarray kvals

	kph	chnget	"heart"
	kph	=	int(((kph * kdiv) % 1) * klen)
	
	kout = kvals[kph]

	xout kout

	endop

	opcode	circleS, S, kS[]

	kdiv, Svals[] xin

	klen	lenarray Svals

	kph	chnget	"heart"
	kph	=	int(((kph * kdiv) % 1) * klen)

	ktrig	changed	kph

	if (ktrig == 1) then
	Sout = Svals[kph]	
	endif
	
	xout Sout

	endop




;--- ||| --- ||| ---

	opcode	hardduckmeout, 0, SSkk
Sin, Sout, katt, krel xin

Sin1	sprintf	"%s-1", Sin
Sin2	sprintf	"%s-2", Sin

Sout1	sprintf	"%s-1", Sout
Sout2	sprintf	"%s-2", Sout

;	routing
aout1	chnget Sout1
aout2	chnget Sout2

ain1	chnget Sin1
ain2	chnget Sin2

;	instrument
a1	compress ain1, aout1, -60, 0, 48, 9.5, katt, krel, 0
a2	compress ain2, aout2, -60, 0, 48, 9.5, katt, krel, 0

	chnmix dcblock2(a1), "mouth-1"
	chnmix dcblock2(a2), "mouth-2"

		endop

	opcode	softduckmeout, 0, SSkk
Sin, Sout, katt, krel xin

Sin1	sprintf	"%s-1", Sin
Sin2	sprintf	"%s-2", Sin

Sout1	sprintf	"%s-1", Sout
Sout2	sprintf	"%s-2", Sout

;	routing
aout1	chnget Sout1
aout2	chnget Sout2

ain1	chnget Sin1
ain2	chnget Sin2

;	instrument
a1	compress ain1, aout1, -60, 0, 48, 3.5, katt, krel, 0
a2	compress ain2, aout2, -60, 0, 48, 3.5, katt, krel, 0

	chnmix dcblock2(a1), "mouth-1"
	chnmix dcblock2(a2), "mouth-2"

		endop

	opcode	followmeout, 0, SSkkP
Sin, Sout, katt, krel, kgain xin

Sin1	sprintf	"%s-1", Sin
Sin2	sprintf	"%s-2", Sin

Sout1	sprintf	"%s-1", Sout
Sout2	sprintf	"%s-2", Sout

;	routing
ain1	chnget Sin1
ain2	chnget Sin2

aout1	chnget Sout1
aout2	chnget Sout2

;	instrument
af1	follow2 aout1, katt + randomi:k(-katt/2, katt, .05), krel + randomi:k(-krel/2, krel, .05)
af2	follow2 aout2, katt + randomi:k(-katt/2, katt, .05), krel + randomi:k(-krel/2, krel, .05)

a1	= ain1 * af1
a2	= ain2 * af2

a1	*= a(kgain)
a2	*= a(kgain)

	chnmix a1, "mouth-1"
	chnmix a2, "mouth-2"

		endop

	opcode	followdrum, 0, SP
	Sin, kgain xin

Sin1	sprintf	"%s-1", Sin
Sin2	sprintf	"%s-2", Sin

Sout	= "drum"

Sout1	sprintf	"%s-1", Sout
Sout2	sprintf	"%s-2", Sout

;	routing
ain1	chnget Sin1
ain2	chnget Sin2

aout1	chnget Sout1
aout2	chnget Sout2

katt	= .005
krel	= .5

;	instrument
af1	follow2 aout1, katt + randomi:k(-katt/2, katt, .05), krel + randomi:k(-krel/2, krel, .05)
af2	follow2 aout2, katt + randomi:k(-katt/2, katt, .05), krel + randomi:k(-krel/2, krel, .05)

a1	= ain1 * af1
a2	= ain2 * af2

a1	*= a(kgain)
a2	*= a(kgain)

	chnmix a1, "mouth-1"
	chnmix a2, "mouth-2"

		endop



;--- ||| --- ||| ---

;-------DRUMs
	opcode	givemekick, 0, kkkSikk
	konset, kpulses, kdiv, Sorgan, isamp, kvar, kamp xin

if	(isamp > 0 && isamp <= 9) then
	Szero	= "00"
elseif	(isamp > 9 && isamp <= 99) then
	Szero	= "0"
elseif	(isamp > 99) then
	Szero	= ""
endif

Sfile	sprintf "kick/%s%s%d.wav", "XF_Kick_A_", Szero, isamp

if(eu(konset, kpulses, kdiv, Sorgan) == 1) then
	schedulek("drum", 0, .05, Sfile, random:k(-kvar, kvar), kamp, 1)
endif

		endop

	opcode	kali, 0, kkkSkkk
konset, kpulses, kdiv, Sorgan, ksamp, kvar, kamp xin

Sfile	sprintfk "kali/note_%d.wav", ksamp

if(eu(konset, kpulses, kdiv, Sorgan) == 1) then
	schedulek("Kali", 0, .05, Sfile, random:k(-kvar, kvar), kamp, 1)
endif
		endop

gkdnb	init 0

	opcode	givemednb, 0, kkS
	ktempo, kamp, Sorgan xin

ivar	= .05

Sohh	= "HH/open/XF_HatAna48.wav"
if (givemearray(ktempo, fillarray(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), Sorgan)) == 1 then
	schedulek("drum", 0, .05, Sohh, random:k(-ivar, ivar), kamp+random:k(-$pp, $pp), 1)
endif

kschh	init 0

Schh	sprintfk "HH/closed/real/dnb/%i.wav", kschh

if (givemearray(ktempo, fillarray(0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), Sorgan)) == 1 then
	schedulek("drum", 0, .05, Schh, random:k(-ivar, ivar), (kamp-$mf)+random:k(-$mp, $mp), 1)
	kschh = (kschh + 1) % 2
endif

;	SNARE

Ssnare = "snares/Classic/XF_SnrClassic09.wav"

ksnare[]	fillarray	0, 0, 0, 0, 
			1, 0, 0, 0,
			0, 0, 0, 0,
			1, 0, 0, 0

if (givemearray(ktempo, ksnare, Sorgan) == 1) then
	schedulek("drum", 0, .05, Ssnare, random:k(-ivar, ivar), kamp, 1)
endif

;	KICK
Skick	= "kick/XF_Kick_A_009.wav"

kkick[]	init 8

kkick0[]	fillarray 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0
kkick1[]	fillarray 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0
kkick2[]	fillarray 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0
kkick3[]	fillarray 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1

krnd	int 	random(0, 3)

if 	(gkdnb == 0) then
	kkick = kkick0
elseif	(gkdnb == 1) then
	kkick = kkick0
elseif	(gkdnb == 2) then
	kkick = kkick0

elseif	(gkdnb == 3 && krnd == 0) then
	kkick = kkick1
elseif	(gkdnb == 3 && krnd == 1) then
	kkick = kkick2
elseif	(gkdnb == 3 && krnd == 2) then
	kkick = kkick3
endif

if (givemearray(ktempo, kkick, Sorgan) == 1) then
	schedulek("drum", 0, .05, Skick, random:k(-ivar, ivar), kamp, 1)
endif

kph	chnget	Sorgan
kph	= (kph * ktempo) % 1

klast init -1

if (kph < klast) then
	gkdnb = (gkdnb + 1) % 4
endif

klast = kph

		endop



;--- ||| --- ||| ---

	opcode	d, 0, SkkkkOOOO
Sinstr, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

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
				schedulek	Sinstr, 0, kdur, kamp, -kenv, kcps1, kch
				schedulek	Sinstr, 0, kdur, kamp, kenv, kcps1, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, -kenv, kcps1, kch, gScorename)
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", 0, kdur, kamp, kcps1, Sinstr
					#end

		endif

		if	(kcps2 != 0) then

			kch		= 1
			until kch > ginchnls do
				schedulek	Sinstr, 0, kdur, kamp, -kenv, kcps2, kch
				schedulek	Sinstr, 0, kdur, kamp, kenv, kcps2, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, -kenv, kcps2, kch, gScorename)
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps2, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", 0, kdur, kamp, kcps2, Sinstr
					#end

		endif

		if	(kcps3 != 0) then

			kch		= 1
			until kch > ginchnls do
				schedulek	Sinstr, 0, kdur, kamp, -kenv, kcps3, kch
				schedulek	Sinstr, 0, kdur, kamp, kenv, kcps3, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, -kenv, kcps3, kch, gScorename)
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps3, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", 0, kdur, kamp, kcps3, Sinstr
					#end

		endif

		if	(kcps4 != 0) then

			kch		= 1
			until kch > ginchnls do
				schedulek	Sinstr, 0, kdur, kamp, -kenv, kcps4, kch
				schedulek	Sinstr, 0, kdur, kamp, kenv, kcps4, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, -kenv, kcps4, kch, gScorename)
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps4, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", 0, kdur, kamp, kcps4, Sinstr
					#end

		endif

		if	(kcps5 != 0) then

			kch		= 1
			until kch > ginchnls do
				schedulek	Sinstr, 0, kdur, kamp, -kenv, kcps5, kch
				schedulek	Sinstr, 0, kdur, kamp, kenv, kcps5, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, -kenv, kcps5, kch, gScorename)
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps5, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", 0, kdur, kamp, kcps5, Sinstr
					#end

		endif

	$showmek

endif

		endop

	opcode	e, 0, SSkkkkOOOO
Sinstr1, Sinstr2, kdur, kamp, kenv, kcps1, kcps2, kcps3, kcps4, kcps5 xin

kchange		init 0

if	kchange == 0 then
	Sinstr	strcpyk Sinstr1
	kchange = 1
else
	Sinstr	strcpyk Sinstr2
	kchange = 0
endif

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
				schedulek	Sinstr, 0, kdur, kamp, kenv, kcps1, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", 0, kdur, kamp, kcps1, Sinstr
					#end

		endif

		if	(kcps2 != 0) then

			kch		= 1
			until kch > ginchnls do
				schedulek	Sinstr, 0, kdur, kamp, kenv, kcps2, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps2, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", 0, kdur, kamp, kcps2, Sinstr
					#end

		endif

		if	(kcps3 != 0) then

			kch		= 1
			until kch > ginchnls do
				schedulek	Sinstr, 0, kdur, kamp, kenv, kcps3, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps3, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", 0, kdur, kamp, kcps3, Sinstr
					#end

		endif

		if	(kcps4 != 0) then

			kch		= 1
			until kch > ginchnls do
				schedulek	Sinstr, 0, kdur, kamp, kenv, kcps4, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps4, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", 0, kdur, kamp, kcps4, Sinstr
					#end

		endif

		if	(kcps5 != 0) then

			kch		= 1
			until kch > ginchnls do
				schedulek	Sinstr, 0, kdur, kamp, kenv, kcps5, kch
					#ifdef	printscore
						kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps5, kch, gScorename)
					#end
				kch += 1
			od
					#ifdef	midisend
						schedulek "gotomidi", 0, kdur, kamp, kcps5, Sinstr
					#end

		endif

		$showmek

endif


		endop





;--- ||| --- ||| ---

/*
decimator - Sample rate / Bit depth reduce. Based on the work of Steven Cook. k-rate parameters.

DESCRIPTION
This opcode implements one possible algorithm for sample rate / bit depth reduction. It is based on the work of Steven Cook but varies in that it utilizes the local ksmps feature of the UDO and has k-rate input parameters (the original was i-rate and can be viewed here http://www.csounds.com/cook/csound/Decimator.orc)

SYNTAX
aout  decimator  ain, kbitdepth, ksrate

PERFORMANCE
ain  -  Audio input signal.

kbitdepth  -  The bit depth of signal aout. Typically in range (1-16). Floats are OK.

ksrate  -  The sample rate of signal aout. Non-integer values are OK.

CREDITS
Steven Cook. Implemented as a UDO by David Akbari - 2005.
*/

opcode	decimator, a, akk
	setksmps	1
ain, kbit, ksrate		xin

kbits    = 2^kbit			; Bit depth (1 to 16)
kfold    = (sr/ksrate)			; Sample rate
kin      downsamp  ain			; Convert to kr
kin      = (kin + 32768)		; Add DC to avoid (-)
kin      = kin*(kbits / 65536)		; Divide signal level
kin      = int(kin)			; Quantise
aout     upsamp  kin			; Convert to sr
aout     = aout * (65536/kbits) - 32768	; Scale and remove DC

a0ut     fold  aout, kfold		; Resample

	xout      a0ut

	endop



;--- ||| --- ||| ---

;	LFOs
	opcode	lfa, k, kk
	kamp, kfreq	xin

kout	abs	lfo(kamp, kfreq/2)

	xout	kout	
		endop

	opcode	lfi, k, kk
	kamp, kfreq	xin

kout	int	lfo(kamp, kfreq)

	xout	kout	
		endop

	opcode	lfia, k, kk

	kamp, kfreq	xin

kout	int	abs(lfo(kamp, kfreq))

	xout	kout
	
		endop

	opcode	lfp, k, kkk
	kstart,	kamp, kfreq	xin

kout	lfo	kamp, kfreq
kout	+=	kstart

	xout	kout	
		endop

	opcode	lfpa, k, kkk
	kstart,	kamp, kfreq	xin

kout	int	lfo(kamp, kfreq)
kout	+=	kstart

	xout	kout	
		endop

	opcode	lfse, k, kkk
	kstart,	kend, kfreq	xin

kamp	=	kend + (kstart*-1)
khalf	=	kamp / 2
kst	=	kend - khalf

kout	=	kst	+ lfo(khalf, kfreq)

	xout	kout	
		endop

	opcode alo, k, kO
	kfreq, kphase xin

korgan	chnget	"heart"
kph	=	korgan * kfreq
kph	+=	kphase
kph	=	kph % 1

kout	tab	kph, gilowasine, 1

	xout kout
	endop

;	EU modulator
	opcode	peuh, k, kkkOO
	konset, kpulses, kdiv, krot, kport xin

Sorgan	= "heart"

kprev	init -1
keu[]	init 64
kndx	init 0

while kndx < kpulses do
	kval		=	int((konset / kpulses) * kndx)
	kndxrot		=	(kndx + krot) % kpulses
	keu[kndxrot]	=	(kval == kprev ? 0 : 1)
	kprev		=	kval
	kndx		+=	1
od

korgan	chnget	Sorgan
kph	=	(korgan * kdiv) % 1
kph	=	int(kph * kpulses)

	xout	portk(keu[kph], kport/1000)

	endop

;	TEMPO modulator
	opcode	rall, k, kk
	kdiv, kper xin

kphasor	= ((chnget:k("heart")*kdiv)%1)*16384
krall	= tab(kphasor, girall)*kper

	xout krall
	endop

	opcode	acc, k, kk
	kdiv, kper xin

kphasor	= ((chnget:k("heart")*kdiv)%1)*16384
kacc	= tab(kphasor, giacc)*kper

	xout kacc
	endop

	opcode	tempovar, k, kki
	kdiv, kper, itab xin

kphasor		= ((chnget:k("heart")*kdiv)%1)*16384
ktempovar	= tab(kphasor, itab)*kper

	xout ktempovar
	endop

;	TEMPOEXP
;	a 3-points function from segments of exponential curves
gitempoexp_int		init 64
gitempoexp_intramp	init 59
gitempoexp_intbetween	init 3
gitempoexp_inthold	init gitempoexp_int - gitempoexp_intramp - gitempoexp_intbetween
;-----------------------
gitempoexp_ramp		init gitempoexp_intramp / gitempoexp_int
gitempoexp_between	init gitempoexp_intbetween / gitempoexp_int
gitempoexp_hold		init gitempoexp_inthold / gitempoexp_int
gitempoexp_sus		init .115
;-----------------------
gitempoexp		ftgen	0, 0, gienvdur, 5, giexpzero, gienvdur*gitempoexp_ramp, gitempoexp_sus, gienvdur*gitempoexp_between, 1, gienvdur*gitempoexp_hold, 1
;-----------------------

	opcode timeh, k, k
	kdiv xin

kmaxtempo	max gkpulse, delayk(gkpulse, 1.5), delayk(gkpulse, 3.5), delayk(gkpulse, 5), delayk(gkpulse, 9), delayk(gkpulse, 15)
kfact		abs kmaxtempo*.85

kphasor		= ((chnget:k("heart")*kdiv)%1)*gienvdur
ktempovar	= tab(kphasor, gitempoexp)*kfact

	xout ktempovar
	endop




	opcode cunt, k, kik
	kstart, itime, kend xin

kndx	init -1
imax	init itime-1

if	kndx==imax then
	kndx = imax
else
	kndx	+= 1
endif

kres	= kstart + (((kend-kstart)/imax)*kndx)

	xout kres
	endop
	
	opcode cunti, k, kik
	kend, itime, kstart xin

kndx	init -1
imax	init itime-1

if	kndx==imax then
	kndx = imax
else
	kndx	+= 1
endif

kres	= kstart + (((kend-kstart)/imax)*kndx)

	xout kres
	endop



;--- ||| --- ||| ---

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



;--- ||| --- ||| ---

	opcode	rprtab, k, iP
	ift, kdiv xin 

kres	tablei phasor:k(kdiv/p3), ift, 1

	xout kres

	endop



;--- ||| --- ||| ---

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



;--- ||| --- ||| ---

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




;--- ||| --- ||| ---

	opcode tabj, a, ki
	kfreq, ift xin

aenv	oscil 1, kfreq, ift
	
	xout aenv
	endop



;--- ||| --- ||| ---

gSalghed_00_file 	 init "../samples/opcode/alghed/alghed-00.wav"
gialghed_00_1		 ftgen 0, 0, 0, 1, gSalghed_00_file, 0, 0, 1
gialghed_00_2		 ftgen 0, 0, 0, 1, gSalghed_00_file, 0, 0, 2
;---
gSalghed_01_file 	 init "../samples/opcode/alghed/alghed-01.wav"
gialghed_01_1		 ftgen 0, 0, 0, 1, gSalghed_01_file, 0, 0, 1
gialghed_01_2		 ftgen 0, 0, 0, 1, gSalghed_01_file, 0, 0, 2
;---
gSalghed_02_file 	 init "../samples/opcode/alghed/alghed-02.wav"
gialghed_02_1		 ftgen 0, 0, 0, 1, gSalghed_02_file, 0, 0, 1
gialghed_02_2		 ftgen 0, 0, 0, 1, gSalghed_02_file, 0, 0, 2
;---
gSalghed_03_file 	 init "../samples/opcode/alghed/alghed-03.wav"
gialghed_03_1		 ftgen 0, 0, 0, 1, gSalghed_03_file, 0, 0, 1
gialghed_03_2		 ftgen 0, 0, 0, 1, gSalghed_03_file, 0, 0, 2
;---
gSalghed_04_file 	 init "../samples/opcode/alghed/alghed-04.wav"
gialghed_04_1		 ftgen 0, 0, 0, 1, gSalghed_04_file, 0, 0, 1
gialghed_04_2		 ftgen 0, 0, 0, 1, gSalghed_04_file, 0, 0, 2
;---
gSalghed_05_file 	 init "../samples/opcode/alghed/alghed-05.wav"
gialghed_05_1		 ftgen 0, 0, 0, 1, gSalghed_05_file, 0, 0, 1
gialghed_05_2		 ftgen 0, 0, 0, 1, gSalghed_05_file, 0, 0, 2
;---
gSalghed_06_file 	 init "../samples/opcode/alghed/alghed-06.wav"
gialghed_06_1		 ftgen 0, 0, 0, 1, gSalghed_06_file, 0, 0, 1
gialghed_06_2		 ftgen 0, 0, 0, 1, gSalghed_06_file, 0, 0, 2
;---
gSalghed_07_file 	 init "../samples/opcode/alghed/alghed-07.wav"
gialghed_07_1		 ftgen 0, 0, 0, 1, gSalghed_07_file, 0, 0, 1
gialghed_07_2		 ftgen 0, 0, 0, 1, gSalghed_07_file, 0, 0, 2
;---
gSalghed_08_file 	 init "../samples/opcode/alghed/alghed-08.wav"
gialghed_08_1		 ftgen 0, 0, 0, 1, gSalghed_08_file, 0, 0, 1
gialghed_08_2		 ftgen 0, 0, 0, 1, gSalghed_08_file, 0, 0, 2
;---
gSalghed_09_file 	 init "../samples/opcode/alghed/alghed-09.wav"
gialghed_09_1		 ftgen 0, 0, 0, 1, gSalghed_09_file, 0, 0, 1
gialghed_09_2		 ftgen 0, 0, 0, 1, gSalghed_09_file, 0, 0, 2
;---
gSalghed_10_file 	 init "../samples/opcode/alghed/alghed-10.wav"
gialghed_10_1		 ftgen 0, 0, 0, 1, gSalghed_10_file, 0, 0, 1
gialghed_10_2		 ftgen 0, 0, 0, 1, gSalghed_10_file, 0, 0, 2
;---
gSalghed_11_file 	 init "../samples/opcode/alghed/alghed-11.wav"
gialghed_11_1		 ftgen 0, 0, 0, 1, gSalghed_11_file, 0, 0, 1
gialghed_11_2		 ftgen 0, 0, 0, 1, gSalghed_11_file, 0, 0, 2
;---
gSalghed_12_file 	 init "../samples/opcode/alghed/alghed-12.wav"
gialghed_12_1		 ftgen 0, 0, 0, 1, gSalghed_12_file, 0, 0, 1
gialghed_12_2		 ftgen 0, 0, 0, 1, gSalghed_12_file, 0, 0, 2
;---
gSalghed_13_file 	 init "../samples/opcode/alghed/alghed-13.wav"
gialghed_13_1		 ftgen 0, 0, 0, 1, gSalghed_13_file, 0, 0, 1
gialghed_13_2		 ftgen 0, 0, 0, 1, gSalghed_13_file, 0, 0, 2
;---
gSalghed_14_file 	 init "../samples/opcode/alghed/alghed-14.wav"
gialghed_14_1		 ftgen 0, 0, 0, 1, gSalghed_14_file, 0, 0, 1
gialghed_14_2		 ftgen 0, 0, 0, 1, gSalghed_14_file, 0, 0, 2
;---
gSalghed_15_file 	 init "../samples/opcode/alghed/alghed-15.wav"
gialghed_15_1		 ftgen 0, 0, 0, 1, gSalghed_15_file, 0, 0, 1
gialghed_15_2		 ftgen 0, 0, 0, 1, gSalghed_15_file, 0, 0, 2
;---
gSalghed_16_file 	 init "../samples/opcode/alghed/alghed-16.wav"
gialghed_16_1		 ftgen 0, 0, 0, 1, gSalghed_16_file, 0, 0, 1
gialghed_16_2		 ftgen 0, 0, 0, 1, gSalghed_16_file, 0, 0, 2
;---
gSalghed_17_file 	 init "../samples/opcode/alghed/alghed-17.wav"
gialghed_17_1		 ftgen 0, 0, 0, 1, gSalghed_17_file, 0, 0, 1
gialghed_17_2		 ftgen 0, 0, 0, 1, gSalghed_17_file, 0, 0, 2
;---
gSalghed_18_file 	 init "../samples/opcode/alghed/alghed-18.wav"
gialghed_18_1		 ftgen 0, 0, 0, 1, gSalghed_18_file, 0, 0, 1
gialghed_18_2		 ftgen 0, 0, 0, 1, gSalghed_18_file, 0, 0, 2
;---
gialghed_sonvs[]			fillarray	gialghed_00_1, gialghed_00_2, gialghed_01_1, gialghed_01_2, gialghed_02_1, gialghed_02_2, gialghed_03_1, gialghed_03_2, gialghed_04_1, gialghed_04_2, gialghed_05_1, gialghed_05_2, gialghed_06_1, gialghed_06_2, gialghed_07_1, gialghed_07_2, gialghed_08_1, gialghed_08_2, gialghed_09_1, gialghed_09_2, gialghed_10_1, gialghed_10_2, gialghed_11_1, gialghed_11_2, gialghed_12_1, gialghed_12_2, gialghed_13_1, gialghed_13_2, gialghed_14_1, gialghed_14_2, gialghed_15_1, gialghed_15_2, gialghed_16_1, gialghed_16_2, gialghed_17_1, gialghed_17_2, gialghed_18_1, gialghed_18_2
gkalghed_time		init 16
gkalghed_off		init .005
gkalghed_dur		init 1
gkalghed_sonvs		init 1
gialghed_len		init lenarray(gialghed_sonvs)/2

;------------------

	instr alghed

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "alghed"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkalghed_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkalghed_sonvs%(gialghed_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gialghed_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "alghed"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkalghed_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gialghed_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gialghed_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "alghed"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkalghed_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkalghed_sonvs%(gialghed_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gialghed_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	alghed, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "alghed"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkalghed_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkalghed_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	alghed, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "alghed"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkalghed_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkalghed_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSalghef_00_file 	 init "../samples/opcode/alghef/alghef-00.wav"
gialghef_00_1		 ftgen 0, 0, 0, 1, gSalghef_00_file, 0, 0, 1
gialghef_00_2		 ftgen 0, 0, 0, 1, gSalghef_00_file, 0, 0, 2
;---
gSalghef_01_file 	 init "../samples/opcode/alghef/alghef-01.wav"
gialghef_01_1		 ftgen 0, 0, 0, 1, gSalghef_01_file, 0, 0, 1
gialghef_01_2		 ftgen 0, 0, 0, 1, gSalghef_01_file, 0, 0, 2
;---
gSalghef_02_file 	 init "../samples/opcode/alghef/alghef-02.wav"
gialghef_02_1		 ftgen 0, 0, 0, 1, gSalghef_02_file, 0, 0, 1
gialghef_02_2		 ftgen 0, 0, 0, 1, gSalghef_02_file, 0, 0, 2
;---
gSalghef_03_file 	 init "../samples/opcode/alghef/alghef-03.wav"
gialghef_03_1		 ftgen 0, 0, 0, 1, gSalghef_03_file, 0, 0, 1
gialghef_03_2		 ftgen 0, 0, 0, 1, gSalghef_03_file, 0, 0, 2
;---
gSalghef_04_file 	 init "../samples/opcode/alghef/alghef-04.wav"
gialghef_04_1		 ftgen 0, 0, 0, 1, gSalghef_04_file, 0, 0, 1
gialghef_04_2		 ftgen 0, 0, 0, 1, gSalghef_04_file, 0, 0, 2
;---
gSalghef_05_file 	 init "../samples/opcode/alghef/alghef-05.wav"
gialghef_05_1		 ftgen 0, 0, 0, 1, gSalghef_05_file, 0, 0, 1
gialghef_05_2		 ftgen 0, 0, 0, 1, gSalghef_05_file, 0, 0, 2
;---
gSalghef_06_file 	 init "../samples/opcode/alghef/alghef-06.wav"
gialghef_06_1		 ftgen 0, 0, 0, 1, gSalghef_06_file, 0, 0, 1
gialghef_06_2		 ftgen 0, 0, 0, 1, gSalghef_06_file, 0, 0, 2
;---
gSalghef_07_file 	 init "../samples/opcode/alghef/alghef-07.wav"
gialghef_07_1		 ftgen 0, 0, 0, 1, gSalghef_07_file, 0, 0, 1
gialghef_07_2		 ftgen 0, 0, 0, 1, gSalghef_07_file, 0, 0, 2
;---
gSalghef_08_file 	 init "../samples/opcode/alghef/alghef-08.wav"
gialghef_08_1		 ftgen 0, 0, 0, 1, gSalghef_08_file, 0, 0, 1
gialghef_08_2		 ftgen 0, 0, 0, 1, gSalghef_08_file, 0, 0, 2
;---
gSalghef_09_file 	 init "../samples/opcode/alghef/alghef-09.wav"
gialghef_09_1		 ftgen 0, 0, 0, 1, gSalghef_09_file, 0, 0, 1
gialghef_09_2		 ftgen 0, 0, 0, 1, gSalghef_09_file, 0, 0, 2
;---
gSalghef_10_file 	 init "../samples/opcode/alghef/alghef-10.wav"
gialghef_10_1		 ftgen 0, 0, 0, 1, gSalghef_10_file, 0, 0, 1
gialghef_10_2		 ftgen 0, 0, 0, 1, gSalghef_10_file, 0, 0, 2
;---
gSalghef_11_file 	 init "../samples/opcode/alghef/alghef-11.wav"
gialghef_11_1		 ftgen 0, 0, 0, 1, gSalghef_11_file, 0, 0, 1
gialghef_11_2		 ftgen 0, 0, 0, 1, gSalghef_11_file, 0, 0, 2
;---
gialghef_sonvs[]			fillarray	gialghef_00_1, gialghef_00_2, gialghef_01_1, gialghef_01_2, gialghef_02_1, gialghef_02_2, gialghef_03_1, gialghef_03_2, gialghef_04_1, gialghef_04_2, gialghef_05_1, gialghef_05_2, gialghef_06_1, gialghef_06_2, gialghef_07_1, gialghef_07_2, gialghef_08_1, gialghef_08_2, gialghef_09_1, gialghef_09_2, gialghef_10_1, gialghef_10_2, gialghef_11_1, gialghef_11_2
gkalghef_time		init 16
gkalghef_off		init .005
gkalghef_dur		init 1
gkalghef_sonvs		init 1
gialghef_len		init lenarray(gialghef_sonvs)/2

;------------------

	instr alghef

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "alghef"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkalghef_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkalghef_sonvs%(gialghef_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gialghef_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "alghef"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkalghef_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gialghef_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gialghef_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "alghef"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkalghef_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkalghef_sonvs%(gialghef_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gialghef_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	alghef, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "alghef"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkalghef_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkalghef_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	alghef, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "alghef"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkalghef_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkalghef_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSalgo_file	init "../samples/opcode/algo.wav"

gialgo1	ftgen 0, 0, 0, 1, gSalgo_file, 0, 0, 1
gialgo2	ftgen 0, 0, 0, 1, gSalgo_file, 0, 0, 2

gkalgo_time		init 16
gkalgo_off		init .005
gkalgo_dur		init 1
;------------------

	instr algo

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "algo"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkalgo_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gialgo1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "algo"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkalgo_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gialgo1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "algo"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkalgo_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gialgo1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	algo, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "algo"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkalgo_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkalgo_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	algo, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "algo"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkalgo_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkalgo_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSalgo2_file	init "../samples/opcode/algo2.wav"

gialgo21	ftgen 0, 0, 0, 1, gSalgo2_file, 0, 0, 1
gialgo22	ftgen 0, 0, 0, 1, gSalgo2_file, 0, 0, 2

gkalgo2_time		init 16
gkalgo2_off		init .005
gkalgo2_dur		init 1
;------------------

	instr algo2

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "algo2"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkalgo2_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gialgo21+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "algo2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkalgo2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gialgo21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "algo2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkalgo2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gialgo21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	algo2, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "algo2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkalgo2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkalgo2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	algo2, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "algo2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkalgo2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkalgo2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSamen_file	init "../samples/opcode/amen.wav"

giamen1	ftgen 0, 0, 0, 1, gSamen_file, 0, 0, 1
giamen2	ftgen 0, 0, 0, 1, gSamen_file, 0, 0, 2

gkamen_time		init 16
gkamen_off		init .005
gkamen_dur		init 1
;------------------

	instr amen

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "amen"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkamen_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giamen1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "amen"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkamen_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, giamen1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "amen"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkamen_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giamen1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	amen, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "amen"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkamen_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkamen_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	amen, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "amen"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkamen_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkamen_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSamor_file	init "../samples/opcode/amor.wav"

giamor1	ftgen 0, 0, 0, 1, gSamor_file, 0, 0, 1
giamor2	ftgen 0, 0, 0, 1, gSamor_file, 0, 0, 2

gkamor_time		init 16
gkamor_off		init .005
gkamor_dur		init 1
;------------------

	instr amor

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "amor"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkamor_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giamor1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "amor"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkamor_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, giamor1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "amor"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkamor_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giamor1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	amor, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "amor"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkamor_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkamor_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	amor, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "amor"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkamor_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkamor_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSarm1_file	init "../samples/opcode/arm1.wav"

giarm11	ftgen 0, 0, 0, 1, gSarm1_file, 0, 0, 1
giarm12	ftgen 0, 0, 0, 1, gSarm1_file, 0, 0, 2

gkarm1_time		init 16
gkarm1_off		init .005
gkarm1_dur		init 1
;------------------

	instr arm1

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "arm1"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkarm1_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giarm11+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "arm1"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkarm1_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, giarm11+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "arm1"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkarm1_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giarm11+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	arm1, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "arm1"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkarm1_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkarm1_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	arm1, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "arm1"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkarm1_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkarm1_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSarm2_file	init "../samples/opcode/arm2.wav"

giarm21	ftgen 0, 0, 0, 1, gSarm2_file, 0, 0, 1
giarm22	ftgen 0, 0, 0, 1, gSarm2_file, 0, 0, 2

gkarm2_time		init 16
gkarm2_off		init .005
gkarm2_dur		init 1
;------------------

	instr arm2

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "arm2"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkarm2_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giarm21+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "arm2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkarm2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, giarm21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "arm2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkarm2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giarm21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	arm2, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "arm2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkarm2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkarm2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	arm2, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "arm2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkarm2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkarm2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSarmagain_file	init "../samples/opcode/armagain.wav"

giarmagain1	ftgen 0, 0, 0, 1, gSarmagain_file, 0, 0, 1
giarmagain2	ftgen 0, 0, 0, 1, gSarmagain_file, 0, 0, 2

gkarmagain_time		init 16
gkarmagain_off		init .005
gkarmagain_dur		init 1
;------------------

	instr armagain

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "armagain"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkarmagain_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giarmagain1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "armagain"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkarmagain_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, giarmagain1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "armagain"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkarmagain_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giarmagain1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	armagain, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "armagain"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkarmagain_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkarmagain_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	armagain, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "armagain"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkarmagain_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkarmagain_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSbleu_file	init "../samples/opcode/bleu.wav"

gibleu1	ftgen 0, 0, 0, 1, gSbleu_file, 0, 0, 1
gibleu2	ftgen 0, 0, 0, 1, gSbleu_file, 0, 0, 2

gkbleu_time		init 16
gkbleu_off		init .005
gkbleu_dur		init 1
;------------------

	instr bleu

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "bleu"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkbleu_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gibleu1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "bleu"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkbleu_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gibleu1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "bleu"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkbleu_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gibleu1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	bleu, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "bleu"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkbleu_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkbleu_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	bleu, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "bleu"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkbleu_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkbleu_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSbois_file	init "../samples/opcode/bois.wav"

gibois1	ftgen 0, 0, 0, 1, gSbois_file, 0, 0, 1
gibois2	ftgen 0, 0, 0, 1, gSbois_file, 0, 0, 2

gkbois_time		init 16
gkbois_off		init .005
gkbois_dur		init 1
;------------------

	instr bois

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "bois"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkbois_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gibois1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "bois"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkbois_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gibois1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "bois"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkbois_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gibois1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	bois, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "bois"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkbois_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkbois_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	bois, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "bois"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkbois_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkbois_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSbois2_file	init "../samples/opcode/bois2.wav"

gibois21	ftgen 0, 0, 0, 1, gSbois2_file, 0, 0, 1
gibois22	ftgen 0, 0, 0, 1, gSbois2_file, 0, 0, 2

gkbois2_time		init 16
gkbois2_off		init .005
gkbois2_dur		init 1
;------------------

	instr bois2

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "bois2"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkbois2_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gibois21+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "bois2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkbois2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gibois21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "bois2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkbois2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gibois21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	bois2, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "bois2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkbois2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkbois2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	bois2, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "bois2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkbois2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkbois2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSbreak_file	init "../samples/opcode/break.wav"

gibreak1	ftgen 0, 0, 0, 1, gSbreak_file, 0, 0, 1
gibreak2	ftgen 0, 0, 0, 1, gSbreak_file, 0, 0, 2

gkbreak_time		init 16
gkbreak_off		init .005
gkbreak_dur		init 1
;------------------

	instr break

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "break"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkbreak_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gibreak1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "break"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkbreak_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gibreak1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "break"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkbreak_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gibreak1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	break, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "break"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkbreak_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkbreak_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	break, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "break"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkbreak_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkbreak_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gScaillou_001_file 	 init "../samples/opcode/caillou/caillou-001.wav"
gicaillou_001_1		 ftgen 0, 0, 0, 1, gScaillou_001_file, 0, 0, 1
gicaillou_001_2		 ftgen 0, 0, 0, 1, gScaillou_001_file, 0, 0, 2
;---
gScaillou_002_file 	 init "../samples/opcode/caillou/caillou-002.wav"
gicaillou_002_1		 ftgen 0, 0, 0, 1, gScaillou_002_file, 0, 0, 1
gicaillou_002_2		 ftgen 0, 0, 0, 1, gScaillou_002_file, 0, 0, 2
;---
gScaillou_003_file 	 init "../samples/opcode/caillou/caillou-003.wav"
gicaillou_003_1		 ftgen 0, 0, 0, 1, gScaillou_003_file, 0, 0, 1
gicaillou_003_2		 ftgen 0, 0, 0, 1, gScaillou_003_file, 0, 0, 2
;---
gScaillou_004_file 	 init "../samples/opcode/caillou/caillou-004.wav"
gicaillou_004_1		 ftgen 0, 0, 0, 1, gScaillou_004_file, 0, 0, 1
gicaillou_004_2		 ftgen 0, 0, 0, 1, gScaillou_004_file, 0, 0, 2
;---
gScaillou_005_file 	 init "../samples/opcode/caillou/caillou-005.wav"
gicaillou_005_1		 ftgen 0, 0, 0, 1, gScaillou_005_file, 0, 0, 1
gicaillou_005_2		 ftgen 0, 0, 0, 1, gScaillou_005_file, 0, 0, 2
;---
gScaillou_006_file 	 init "../samples/opcode/caillou/caillou-006.wav"
gicaillou_006_1		 ftgen 0, 0, 0, 1, gScaillou_006_file, 0, 0, 1
gicaillou_006_2		 ftgen 0, 0, 0, 1, gScaillou_006_file, 0, 0, 2
;---
gScaillou_007_file 	 init "../samples/opcode/caillou/caillou-007.wav"
gicaillou_007_1		 ftgen 0, 0, 0, 1, gScaillou_007_file, 0, 0, 1
gicaillou_007_2		 ftgen 0, 0, 0, 1, gScaillou_007_file, 0, 0, 2
;---
gicaillou_sonvs[]			fillarray	gicaillou_001_1, gicaillou_001_2, gicaillou_002_1, gicaillou_002_2, gicaillou_003_1, gicaillou_003_2, gicaillou_004_1, gicaillou_004_2, gicaillou_005_1, gicaillou_005_2, gicaillou_006_1, gicaillou_006_2, gicaillou_007_1, gicaillou_007_2
gkcaillou_time		init 16
gkcaillou_off		init .005
gkcaillou_dur		init 1
gkcaillou_sonvs		init 1
gicaillou_len		init lenarray(gicaillou_sonvs)/2

;------------------

	instr caillou

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "caillou"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkcaillou_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkcaillou_sonvs%(gicaillou_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gicaillou_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "caillou"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkcaillou_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gicaillou_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gicaillou_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "caillou"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkcaillou_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkcaillou_sonvs%(gicaillou_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gicaillou_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	caillou, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "caillou"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcaillou_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcaillou_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	caillou, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "caillou"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcaillou_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcaillou_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gScaiu_file	init "../samples/opcode/caiu.wav"

gicaiu1	ftgen 0, 0, 0, 1, gScaiu_file, 0, 0, 1
gicaiu2	ftgen 0, 0, 0, 1, gScaiu_file, 0, 0, 2

gkcaiu_time		init 16
gkcaiu_off		init .005
gkcaiu_dur		init 1
;------------------

	instr caiu

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "caiu"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkcaiu_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gicaiu1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "caiu"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkcaiu_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gicaiu1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "caiu"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkcaiu_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gicaiu1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	caiu, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "caiu"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcaiu_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcaiu_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	caiu, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "caiu"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcaiu_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcaiu_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gScapr1x_00_file 	 init "../samples/opcode/capr1x/capr1x-00.wav"
gicapr1x_00_1		 ftgen 0, 0, 0, 1, gScapr1x_00_file, 0, 0, 1
gicapr1x_00_2		 ftgen 0, 0, 0, 1, gScapr1x_00_file, 0, 0, 2
;---
gScapr1x_01_file 	 init "../samples/opcode/capr1x/capr1x-01.wav"
gicapr1x_01_1		 ftgen 0, 0, 0, 1, gScapr1x_01_file, 0, 0, 1
gicapr1x_01_2		 ftgen 0, 0, 0, 1, gScapr1x_01_file, 0, 0, 2
;---
gScapr1x_02_file 	 init "../samples/opcode/capr1x/capr1x-02.wav"
gicapr1x_02_1		 ftgen 0, 0, 0, 1, gScapr1x_02_file, 0, 0, 1
gicapr1x_02_2		 ftgen 0, 0, 0, 1, gScapr1x_02_file, 0, 0, 2
;---
gScapr1x_03_file 	 init "../samples/opcode/capr1x/capr1x-03.wav"
gicapr1x_03_1		 ftgen 0, 0, 0, 1, gScapr1x_03_file, 0, 0, 1
gicapr1x_03_2		 ftgen 0, 0, 0, 1, gScapr1x_03_file, 0, 0, 2
;---
gScapr1x_04_file 	 init "../samples/opcode/capr1x/capr1x-04.wav"
gicapr1x_04_1		 ftgen 0, 0, 0, 1, gScapr1x_04_file, 0, 0, 1
gicapr1x_04_2		 ftgen 0, 0, 0, 1, gScapr1x_04_file, 0, 0, 2
;---
gicapr1x_sonvs[]			fillarray	gicapr1x_00_1, gicapr1x_00_2, gicapr1x_01_1, gicapr1x_01_2, gicapr1x_02_1, gicapr1x_02_2, gicapr1x_03_1, gicapr1x_03_2, gicapr1x_04_1, gicapr1x_04_2
gkcapr1x_time		init 16
gkcapr1x_off		init .005
gkcapr1x_dur		init 1
gkcapr1x_sonvs		init 1
gicapr1x_len		init lenarray(gicapr1x_sonvs)/2

;------------------

	instr capr1x

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "capr1x"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkcapr1x_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkcapr1x_sonvs%(gicapr1x_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gicapr1x_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "capr1x"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkcapr1x_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gicapr1x_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gicapr1x_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "capr1x"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkcapr1x_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkcapr1x_sonvs%(gicapr1x_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gicapr1x_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	capr1x, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "capr1x"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcapr1x_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcapr1x_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	capr1x, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "capr1x"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcapr1x_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcapr1x_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gScapr2x_001_file 	 init "../samples/opcode/capr2x/capr2x-001.wav"
gicapr2x_001_1		 ftgen 0, 0, 0, 1, gScapr2x_001_file, 0, 0, 1
gicapr2x_001_2		 ftgen 0, 0, 0, 1, gScapr2x_001_file, 0, 0, 2
;---
gScapr2x_002_file 	 init "../samples/opcode/capr2x/capr2x-002.wav"
gicapr2x_002_1		 ftgen 0, 0, 0, 1, gScapr2x_002_file, 0, 0, 1
gicapr2x_002_2		 ftgen 0, 0, 0, 1, gScapr2x_002_file, 0, 0, 2
;---
gScapr2x_003_file 	 init "../samples/opcode/capr2x/capr2x-003.wav"
gicapr2x_003_1		 ftgen 0, 0, 0, 1, gScapr2x_003_file, 0, 0, 1
gicapr2x_003_2		 ftgen 0, 0, 0, 1, gScapr2x_003_file, 0, 0, 2
;---
gScapr2x_004_file 	 init "../samples/opcode/capr2x/capr2x-004.wav"
gicapr2x_004_1		 ftgen 0, 0, 0, 1, gScapr2x_004_file, 0, 0, 1
gicapr2x_004_2		 ftgen 0, 0, 0, 1, gScapr2x_004_file, 0, 0, 2
;---
gScapr2x_005_file 	 init "../samples/opcode/capr2x/capr2x-005.wav"
gicapr2x_005_1		 ftgen 0, 0, 0, 1, gScapr2x_005_file, 0, 0, 1
gicapr2x_005_2		 ftgen 0, 0, 0, 1, gScapr2x_005_file, 0, 0, 2
;---
gScapr2x_006_file 	 init "../samples/opcode/capr2x/capr2x-006.wav"
gicapr2x_006_1		 ftgen 0, 0, 0, 1, gScapr2x_006_file, 0, 0, 1
gicapr2x_006_2		 ftgen 0, 0, 0, 1, gScapr2x_006_file, 0, 0, 2
;---
gScapr2x_007_file 	 init "../samples/opcode/capr2x/capr2x-007.wav"
gicapr2x_007_1		 ftgen 0, 0, 0, 1, gScapr2x_007_file, 0, 0, 1
gicapr2x_007_2		 ftgen 0, 0, 0, 1, gScapr2x_007_file, 0, 0, 2
;---
gScapr2x_008_file 	 init "../samples/opcode/capr2x/capr2x-008.wav"
gicapr2x_008_1		 ftgen 0, 0, 0, 1, gScapr2x_008_file, 0, 0, 1
gicapr2x_008_2		 ftgen 0, 0, 0, 1, gScapr2x_008_file, 0, 0, 2
;---
gicapr2x_sonvs[]			fillarray	gicapr2x_001_1, gicapr2x_001_2, gicapr2x_002_1, gicapr2x_002_2, gicapr2x_003_1, gicapr2x_003_2, gicapr2x_004_1, gicapr2x_004_2, gicapr2x_005_1, gicapr2x_005_2, gicapr2x_006_1, gicapr2x_006_2, gicapr2x_007_1, gicapr2x_007_2, gicapr2x_008_1, gicapr2x_008_2
gkcapr2x_time		init 16
gkcapr2x_off		init .005
gkcapr2x_dur		init 1
gkcapr2x_sonvs		init 1
gicapr2x_len		init lenarray(gicapr2x_sonvs)/2

;------------------

	instr capr2x

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "capr2x"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkcapr2x_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkcapr2x_sonvs%(gicapr2x_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gicapr2x_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "capr2x"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkcapr2x_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gicapr2x_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gicapr2x_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "capr2x"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkcapr2x_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkcapr2x_sonvs%(gicapr2x_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gicapr2x_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	capr2x, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "capr2x"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcapr2x_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcapr2x_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	capr2x, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "capr2x"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcapr2x_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcapr2x_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gScapriccio1_file	init "../samples/opcode/capriccio1.wav"

gicapriccio11	ftgen 0, 0, 0, 1, gScapriccio1_file, 0, 0, 1
gicapriccio12	ftgen 0, 0, 0, 1, gScapriccio1_file, 0, 0, 2

gkcapriccio1_time		init 16
gkcapriccio1_off		init .005
gkcapriccio1_dur		init 1
;------------------

	instr capriccio1

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "capriccio1"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkcapriccio1_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gicapriccio11+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "capriccio1"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkcapriccio1_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gicapriccio11+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "capriccio1"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkcapriccio1_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gicapriccio11+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	capriccio1, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "capriccio1"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcapriccio1_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcapriccio1_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	capriccio1, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "capriccio1"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcapriccio1_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcapriccio1_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gScapriccio2_file	init "../samples/opcode/capriccio2.wav"

gicapriccio21	ftgen 0, 0, 0, 1, gScapriccio2_file, 0, 0, 1
gicapriccio22	ftgen 0, 0, 0, 1, gScapriccio2_file, 0, 0, 2

gkcapriccio2_time		init 16
gkcapriccio2_off		init .005
gkcapriccio2_dur		init 1
;------------------

	instr capriccio2

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "capriccio2"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkcapriccio2_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gicapriccio21+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "capriccio2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkcapriccio2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gicapriccio21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "capriccio2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkcapriccio2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gicapriccio21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	capriccio2, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "capriccio2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcapriccio2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcapriccio2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	capriccio2, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "capriccio2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcapriccio2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcapriccio2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSchime_00_file 	 init "../samples/opcode/chime/chime_00.wav"
gichime_00_1		 ftgen 0, 0, 0, 1, gSchime_00_file, 0, 0, 1
gichime_00_2		 ftgen 0, 0, 0, 1, gSchime_00_file, 0, 0, 2
;---
gSchime_01_file 	 init "../samples/opcode/chime/chime_01.wav"
gichime_01_1		 ftgen 0, 0, 0, 1, gSchime_01_file, 0, 0, 1
gichime_01_2		 ftgen 0, 0, 0, 1, gSchime_01_file, 0, 0, 2
;---
gSchime_02_file 	 init "../samples/opcode/chime/chime_02.wav"
gichime_02_1		 ftgen 0, 0, 0, 1, gSchime_02_file, 0, 0, 1
gichime_02_2		 ftgen 0, 0, 0, 1, gSchime_02_file, 0, 0, 2
;---
gSchime_03_file 	 init "../samples/opcode/chime/chime_03.wav"
gichime_03_1		 ftgen 0, 0, 0, 1, gSchime_03_file, 0, 0, 1
gichime_03_2		 ftgen 0, 0, 0, 1, gSchime_03_file, 0, 0, 2
;---
gSchime_04_file 	 init "../samples/opcode/chime/chime_04.wav"
gichime_04_1		 ftgen 0, 0, 0, 1, gSchime_04_file, 0, 0, 1
gichime_04_2		 ftgen 0, 0, 0, 1, gSchime_04_file, 0, 0, 2
;---
gSchime_05_file 	 init "../samples/opcode/chime/chime_05.wav"
gichime_05_1		 ftgen 0, 0, 0, 1, gSchime_05_file, 0, 0, 1
gichime_05_2		 ftgen 0, 0, 0, 1, gSchime_05_file, 0, 0, 2
;---
gSchime_06_file 	 init "../samples/opcode/chime/chime_06.wav"
gichime_06_1		 ftgen 0, 0, 0, 1, gSchime_06_file, 0, 0, 1
gichime_06_2		 ftgen 0, 0, 0, 1, gSchime_06_file, 0, 0, 2
;---
gSchime_07_file 	 init "../samples/opcode/chime/chime_07.wav"
gichime_07_1		 ftgen 0, 0, 0, 1, gSchime_07_file, 0, 0, 1
gichime_07_2		 ftgen 0, 0, 0, 1, gSchime_07_file, 0, 0, 2
;---
gSchime_08_file 	 init "../samples/opcode/chime/chime_08.wav"
gichime_08_1		 ftgen 0, 0, 0, 1, gSchime_08_file, 0, 0, 1
gichime_08_2		 ftgen 0, 0, 0, 1, gSchime_08_file, 0, 0, 2
;---
gSchime_09_file 	 init "../samples/opcode/chime/chime_09.wav"
gichime_09_1		 ftgen 0, 0, 0, 1, gSchime_09_file, 0, 0, 1
gichime_09_2		 ftgen 0, 0, 0, 1, gSchime_09_file, 0, 0, 2
;---
gSchime_10_file 	 init "../samples/opcode/chime/chime_10.wav"
gichime_10_1		 ftgen 0, 0, 0, 1, gSchime_10_file, 0, 0, 1
gichime_10_2		 ftgen 0, 0, 0, 1, gSchime_10_file, 0, 0, 2
;---
gSchime_11_file 	 init "../samples/opcode/chime/chime_11.wav"
gichime_11_1		 ftgen 0, 0, 0, 1, gSchime_11_file, 0, 0, 1
gichime_11_2		 ftgen 0, 0, 0, 1, gSchime_11_file, 0, 0, 2
;---
gSchime_12_file 	 init "../samples/opcode/chime/chime_12.wav"
gichime_12_1		 ftgen 0, 0, 0, 1, gSchime_12_file, 0, 0, 1
gichime_12_2		 ftgen 0, 0, 0, 1, gSchime_12_file, 0, 0, 2
;---
gSchime_13_file 	 init "../samples/opcode/chime/chime_13.wav"
gichime_13_1		 ftgen 0, 0, 0, 1, gSchime_13_file, 0, 0, 1
gichime_13_2		 ftgen 0, 0, 0, 1, gSchime_13_file, 0, 0, 2
;---
gSchime_14_file 	 init "../samples/opcode/chime/chime_14.wav"
gichime_14_1		 ftgen 0, 0, 0, 1, gSchime_14_file, 0, 0, 1
gichime_14_2		 ftgen 0, 0, 0, 1, gSchime_14_file, 0, 0, 2
;---
gSchime_15_file 	 init "../samples/opcode/chime/chime_15.wav"
gichime_15_1		 ftgen 0, 0, 0, 1, gSchime_15_file, 0, 0, 1
gichime_15_2		 ftgen 0, 0, 0, 1, gSchime_15_file, 0, 0, 2
;---
gSchime_16_file 	 init "../samples/opcode/chime/chime_16.wav"
gichime_16_1		 ftgen 0, 0, 0, 1, gSchime_16_file, 0, 0, 1
gichime_16_2		 ftgen 0, 0, 0, 1, gSchime_16_file, 0, 0, 2
;---
gSchime_17_file 	 init "../samples/opcode/chime/chime_17.wav"
gichime_17_1		 ftgen 0, 0, 0, 1, gSchime_17_file, 0, 0, 1
gichime_17_2		 ftgen 0, 0, 0, 1, gSchime_17_file, 0, 0, 2
;---
gSchime_18_file 	 init "../samples/opcode/chime/chime_18.wav"
gichime_18_1		 ftgen 0, 0, 0, 1, gSchime_18_file, 0, 0, 1
gichime_18_2		 ftgen 0, 0, 0, 1, gSchime_18_file, 0, 0, 2
;---
gSchime_19_file 	 init "../samples/opcode/chime/chime_19.wav"
gichime_19_1		 ftgen 0, 0, 0, 1, gSchime_19_file, 0, 0, 1
gichime_19_2		 ftgen 0, 0, 0, 1, gSchime_19_file, 0, 0, 2
;---
gSchime_20_file 	 init "../samples/opcode/chime/chime_20.wav"
gichime_20_1		 ftgen 0, 0, 0, 1, gSchime_20_file, 0, 0, 1
gichime_20_2		 ftgen 0, 0, 0, 1, gSchime_20_file, 0, 0, 2
;---
gSchime_21_file 	 init "../samples/opcode/chime/chime_21.wav"
gichime_21_1		 ftgen 0, 0, 0, 1, gSchime_21_file, 0, 0, 1
gichime_21_2		 ftgen 0, 0, 0, 1, gSchime_21_file, 0, 0, 2
;---
gSchime_22_file 	 init "../samples/opcode/chime/chime_22.wav"
gichime_22_1		 ftgen 0, 0, 0, 1, gSchime_22_file, 0, 0, 1
gichime_22_2		 ftgen 0, 0, 0, 1, gSchime_22_file, 0, 0, 2
;---
gSchime_23_file 	 init "../samples/opcode/chime/chime_23.wav"
gichime_23_1		 ftgen 0, 0, 0, 1, gSchime_23_file, 0, 0, 1
gichime_23_2		 ftgen 0, 0, 0, 1, gSchime_23_file, 0, 0, 2
;---
gSchime_24_file 	 init "../samples/opcode/chime/chime_24.wav"
gichime_24_1		 ftgen 0, 0, 0, 1, gSchime_24_file, 0, 0, 1
gichime_24_2		 ftgen 0, 0, 0, 1, gSchime_24_file, 0, 0, 2
;---
gSchime_25_file 	 init "../samples/opcode/chime/chime_25.wav"
gichime_25_1		 ftgen 0, 0, 0, 1, gSchime_25_file, 0, 0, 1
gichime_25_2		 ftgen 0, 0, 0, 1, gSchime_25_file, 0, 0, 2
;---
gSchime_26_file 	 init "../samples/opcode/chime/chime_26.wav"
gichime_26_1		 ftgen 0, 0, 0, 1, gSchime_26_file, 0, 0, 1
gichime_26_2		 ftgen 0, 0, 0, 1, gSchime_26_file, 0, 0, 2
;---
gSchime_27_file 	 init "../samples/opcode/chime/chime_27.wav"
gichime_27_1		 ftgen 0, 0, 0, 1, gSchime_27_file, 0, 0, 1
gichime_27_2		 ftgen 0, 0, 0, 1, gSchime_27_file, 0, 0, 2
;---
gSchime_28_file 	 init "../samples/opcode/chime/chime_28.wav"
gichime_28_1		 ftgen 0, 0, 0, 1, gSchime_28_file, 0, 0, 1
gichime_28_2		 ftgen 0, 0, 0, 1, gSchime_28_file, 0, 0, 2
;---
gSchime_29_file 	 init "../samples/opcode/chime/chime_29.wav"
gichime_29_1		 ftgen 0, 0, 0, 1, gSchime_29_file, 0, 0, 1
gichime_29_2		 ftgen 0, 0, 0, 1, gSchime_29_file, 0, 0, 2
;---
gSchime_30_file 	 init "../samples/opcode/chime/chime_30.wav"
gichime_30_1		 ftgen 0, 0, 0, 1, gSchime_30_file, 0, 0, 1
gichime_30_2		 ftgen 0, 0, 0, 1, gSchime_30_file, 0, 0, 2
;---
gSchime_31_file 	 init "../samples/opcode/chime/chime_31.wav"
gichime_31_1		 ftgen 0, 0, 0, 1, gSchime_31_file, 0, 0, 1
gichime_31_2		 ftgen 0, 0, 0, 1, gSchime_31_file, 0, 0, 2
;---
gSchime_32_file 	 init "../samples/opcode/chime/chime_32.wav"
gichime_32_1		 ftgen 0, 0, 0, 1, gSchime_32_file, 0, 0, 1
gichime_32_2		 ftgen 0, 0, 0, 1, gSchime_32_file, 0, 0, 2
;---
gSchime_33_file 	 init "../samples/opcode/chime/chime_33.wav"
gichime_33_1		 ftgen 0, 0, 0, 1, gSchime_33_file, 0, 0, 1
gichime_33_2		 ftgen 0, 0, 0, 1, gSchime_33_file, 0, 0, 2
;---
gSchime_34_file 	 init "../samples/opcode/chime/chime_34.wav"
gichime_34_1		 ftgen 0, 0, 0, 1, gSchime_34_file, 0, 0, 1
gichime_34_2		 ftgen 0, 0, 0, 1, gSchime_34_file, 0, 0, 2
;---
gSchime_35_file 	 init "../samples/opcode/chime/chime_35.wav"
gichime_35_1		 ftgen 0, 0, 0, 1, gSchime_35_file, 0, 0, 1
gichime_35_2		 ftgen 0, 0, 0, 1, gSchime_35_file, 0, 0, 2
;---
gSchime_36_file 	 init "../samples/opcode/chime/chime_36.wav"
gichime_36_1		 ftgen 0, 0, 0, 1, gSchime_36_file, 0, 0, 1
gichime_36_2		 ftgen 0, 0, 0, 1, gSchime_36_file, 0, 0, 2
;---
gSchime_37_file 	 init "../samples/opcode/chime/chime_37.wav"
gichime_37_1		 ftgen 0, 0, 0, 1, gSchime_37_file, 0, 0, 1
gichime_37_2		 ftgen 0, 0, 0, 1, gSchime_37_file, 0, 0, 2
;---
gSchime_38_file 	 init "../samples/opcode/chime/chime_38.wav"
gichime_38_1		 ftgen 0, 0, 0, 1, gSchime_38_file, 0, 0, 1
gichime_38_2		 ftgen 0, 0, 0, 1, gSchime_38_file, 0, 0, 2
;---
gSchime_39_file 	 init "../samples/opcode/chime/chime_39.wav"
gichime_39_1		 ftgen 0, 0, 0, 1, gSchime_39_file, 0, 0, 1
gichime_39_2		 ftgen 0, 0, 0, 1, gSchime_39_file, 0, 0, 2
;---
gSchime_40_file 	 init "../samples/opcode/chime/chime_40.wav"
gichime_40_1		 ftgen 0, 0, 0, 1, gSchime_40_file, 0, 0, 1
gichime_40_2		 ftgen 0, 0, 0, 1, gSchime_40_file, 0, 0, 2
;---
gSchime_41_file 	 init "../samples/opcode/chime/chime_41.wav"
gichime_41_1		 ftgen 0, 0, 0, 1, gSchime_41_file, 0, 0, 1
gichime_41_2		 ftgen 0, 0, 0, 1, gSchime_41_file, 0, 0, 2
;---
gSchime_42_file 	 init "../samples/opcode/chime/chime_42.wav"
gichime_42_1		 ftgen 0, 0, 0, 1, gSchime_42_file, 0, 0, 1
gichime_42_2		 ftgen 0, 0, 0, 1, gSchime_42_file, 0, 0, 2
;---
gSchime_43_file 	 init "../samples/opcode/chime/chime_43.wav"
gichime_43_1		 ftgen 0, 0, 0, 1, gSchime_43_file, 0, 0, 1
gichime_43_2		 ftgen 0, 0, 0, 1, gSchime_43_file, 0, 0, 2
;---
gSchime_44_file 	 init "../samples/opcode/chime/chime_44.wav"
gichime_44_1		 ftgen 0, 0, 0, 1, gSchime_44_file, 0, 0, 1
gichime_44_2		 ftgen 0, 0, 0, 1, gSchime_44_file, 0, 0, 2
;---
gSchime_45_file 	 init "../samples/opcode/chime/chime_45.wav"
gichime_45_1		 ftgen 0, 0, 0, 1, gSchime_45_file, 0, 0, 1
gichime_45_2		 ftgen 0, 0, 0, 1, gSchime_45_file, 0, 0, 2
;---
gSchime_46_file 	 init "../samples/opcode/chime/chime_46.wav"
gichime_46_1		 ftgen 0, 0, 0, 1, gSchime_46_file, 0, 0, 1
gichime_46_2		 ftgen 0, 0, 0, 1, gSchime_46_file, 0, 0, 2
;---
gichime_sonvs[]			fillarray	gichime_00_1, gichime_00_2, gichime_01_1, gichime_01_2, gichime_02_1, gichime_02_2, gichime_03_1, gichime_03_2, gichime_04_1, gichime_04_2, gichime_05_1, gichime_05_2, gichime_06_1, gichime_06_2, gichime_07_1, gichime_07_2, gichime_08_1, gichime_08_2, gichime_09_1, gichime_09_2, gichime_10_1, gichime_10_2, gichime_11_1, gichime_11_2, gichime_12_1, gichime_12_2, gichime_13_1, gichime_13_2, gichime_14_1, gichime_14_2, gichime_15_1, gichime_15_2, gichime_16_1, gichime_16_2, gichime_17_1, gichime_17_2, gichime_18_1, gichime_18_2, gichime_19_1, gichime_19_2, gichime_20_1, gichime_20_2, gichime_21_1, gichime_21_2, gichime_22_1, gichime_22_2, gichime_23_1, gichime_23_2, gichime_24_1, gichime_24_2, gichime_25_1, gichime_25_2, gichime_26_1, gichime_26_2, gichime_27_1, gichime_27_2, gichime_28_1, gichime_28_2, gichime_29_1, gichime_29_2, gichime_30_1, gichime_30_2, gichime_31_1, gichime_31_2, gichime_32_1, gichime_32_2, gichime_33_1, gichime_33_2, gichime_34_1, gichime_34_2, gichime_35_1, gichime_35_2, gichime_36_1, gichime_36_2, gichime_37_1, gichime_37_2, gichime_38_1, gichime_38_2, gichime_39_1, gichime_39_2, gichime_40_1, gichime_40_2, gichime_41_1, gichime_41_2, gichime_42_1, gichime_42_2, gichime_43_1, gichime_43_2, gichime_44_1, gichime_44_2, gichime_45_1, gichime_45_2, gichime_46_1, gichime_46_2
gkchime_time		init 16
gkchime_off		init .005
gkchime_dur		init 1
gkchime_sonvs		init 1
gichime_len		init lenarray(gichime_sonvs)/2

;------------------

	instr chime

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "chime"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkchime_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkchime_sonvs%(gichime_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gichime_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "chime"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkchime_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gichime_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gichime_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "chime"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkchime_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkchime_sonvs%(gichime_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gichime_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	chime, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "chime"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkchime_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkchime_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	chime, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "chime"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkchime_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkchime_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSchiseq_00_file 	 init "../samples/opcode/chiseq/chiseq_00.wav"
gichiseq_00_1		 ftgen 0, 0, 0, 1, gSchiseq_00_file, 0, 0, 1
gichiseq_00_2		 ftgen 0, 0, 0, 1, gSchiseq_00_file, 0, 0, 2
;---
gSchiseq_01_file 	 init "../samples/opcode/chiseq/chiseq_01.wav"
gichiseq_01_1		 ftgen 0, 0, 0, 1, gSchiseq_01_file, 0, 0, 1
gichiseq_01_2		 ftgen 0, 0, 0, 1, gSchiseq_01_file, 0, 0, 2
;---
gSchiseq_02_file 	 init "../samples/opcode/chiseq/chiseq_02.wav"
gichiseq_02_1		 ftgen 0, 0, 0, 1, gSchiseq_02_file, 0, 0, 1
gichiseq_02_2		 ftgen 0, 0, 0, 1, gSchiseq_02_file, 0, 0, 2
;---
gSchiseq_03_file 	 init "../samples/opcode/chiseq/chiseq_03.wav"
gichiseq_03_1		 ftgen 0, 0, 0, 1, gSchiseq_03_file, 0, 0, 1
gichiseq_03_2		 ftgen 0, 0, 0, 1, gSchiseq_03_file, 0, 0, 2
;---
gSchiseq_04_file 	 init "../samples/opcode/chiseq/chiseq_04.wav"
gichiseq_04_1		 ftgen 0, 0, 0, 1, gSchiseq_04_file, 0, 0, 1
gichiseq_04_2		 ftgen 0, 0, 0, 1, gSchiseq_04_file, 0, 0, 2
;---
gSchiseq_05_file 	 init "../samples/opcode/chiseq/chiseq_05.wav"
gichiseq_05_1		 ftgen 0, 0, 0, 1, gSchiseq_05_file, 0, 0, 1
gichiseq_05_2		 ftgen 0, 0, 0, 1, gSchiseq_05_file, 0, 0, 2
;---
gSchiseq_06_file 	 init "../samples/opcode/chiseq/chiseq_06.wav"
gichiseq_06_1		 ftgen 0, 0, 0, 1, gSchiseq_06_file, 0, 0, 1
gichiseq_06_2		 ftgen 0, 0, 0, 1, gSchiseq_06_file, 0, 0, 2
;---
gSchiseq_07_file 	 init "../samples/opcode/chiseq/chiseq_07.wav"
gichiseq_07_1		 ftgen 0, 0, 0, 1, gSchiseq_07_file, 0, 0, 1
gichiseq_07_2		 ftgen 0, 0, 0, 1, gSchiseq_07_file, 0, 0, 2
;---
gSchiseq_08_file 	 init "../samples/opcode/chiseq/chiseq_08.wav"
gichiseq_08_1		 ftgen 0, 0, 0, 1, gSchiseq_08_file, 0, 0, 1
gichiseq_08_2		 ftgen 0, 0, 0, 1, gSchiseq_08_file, 0, 0, 2
;---
gSchiseq_09_file 	 init "../samples/opcode/chiseq/chiseq_09.wav"
gichiseq_09_1		 ftgen 0, 0, 0, 1, gSchiseq_09_file, 0, 0, 1
gichiseq_09_2		 ftgen 0, 0, 0, 1, gSchiseq_09_file, 0, 0, 2
;---
gSchiseq_10_file 	 init "../samples/opcode/chiseq/chiseq_10.wav"
gichiseq_10_1		 ftgen 0, 0, 0, 1, gSchiseq_10_file, 0, 0, 1
gichiseq_10_2		 ftgen 0, 0, 0, 1, gSchiseq_10_file, 0, 0, 2
;---
gSchiseq_11_file 	 init "../samples/opcode/chiseq/chiseq_11.wav"
gichiseq_11_1		 ftgen 0, 0, 0, 1, gSchiseq_11_file, 0, 0, 1
gichiseq_11_2		 ftgen 0, 0, 0, 1, gSchiseq_11_file, 0, 0, 2
;---
gSchiseq_12_file 	 init "../samples/opcode/chiseq/chiseq_12.wav"
gichiseq_12_1		 ftgen 0, 0, 0, 1, gSchiseq_12_file, 0, 0, 1
gichiseq_12_2		 ftgen 0, 0, 0, 1, gSchiseq_12_file, 0, 0, 2
;---
gSchiseq_13_file 	 init "../samples/opcode/chiseq/chiseq_13.wav"
gichiseq_13_1		 ftgen 0, 0, 0, 1, gSchiseq_13_file, 0, 0, 1
gichiseq_13_2		 ftgen 0, 0, 0, 1, gSchiseq_13_file, 0, 0, 2
;---
gSchiseq_14_file 	 init "../samples/opcode/chiseq/chiseq_14.wav"
gichiseq_14_1		 ftgen 0, 0, 0, 1, gSchiseq_14_file, 0, 0, 1
gichiseq_14_2		 ftgen 0, 0, 0, 1, gSchiseq_14_file, 0, 0, 2
;---
gSchiseq_15_file 	 init "../samples/opcode/chiseq/chiseq_15.wav"
gichiseq_15_1		 ftgen 0, 0, 0, 1, gSchiseq_15_file, 0, 0, 1
gichiseq_15_2		 ftgen 0, 0, 0, 1, gSchiseq_15_file, 0, 0, 2
;---
gSchiseq_16_file 	 init "../samples/opcode/chiseq/chiseq_16.wav"
gichiseq_16_1		 ftgen 0, 0, 0, 1, gSchiseq_16_file, 0, 0, 1
gichiseq_16_2		 ftgen 0, 0, 0, 1, gSchiseq_16_file, 0, 0, 2
;---
gSchiseq_17_file 	 init "../samples/opcode/chiseq/chiseq_17.wav"
gichiseq_17_1		 ftgen 0, 0, 0, 1, gSchiseq_17_file, 0, 0, 1
gichiseq_17_2		 ftgen 0, 0, 0, 1, gSchiseq_17_file, 0, 0, 2
;---
gSchiseq_18_file 	 init "../samples/opcode/chiseq/chiseq_18.wav"
gichiseq_18_1		 ftgen 0, 0, 0, 1, gSchiseq_18_file, 0, 0, 1
gichiseq_18_2		 ftgen 0, 0, 0, 1, gSchiseq_18_file, 0, 0, 2
;---
gSchiseq_19_file 	 init "../samples/opcode/chiseq/chiseq_19.wav"
gichiseq_19_1		 ftgen 0, 0, 0, 1, gSchiseq_19_file, 0, 0, 1
gichiseq_19_2		 ftgen 0, 0, 0, 1, gSchiseq_19_file, 0, 0, 2
;---
gSchiseq_20_file 	 init "../samples/opcode/chiseq/chiseq_20.wav"
gichiseq_20_1		 ftgen 0, 0, 0, 1, gSchiseq_20_file, 0, 0, 1
gichiseq_20_2		 ftgen 0, 0, 0, 1, gSchiseq_20_file, 0, 0, 2
;---
gSchiseq_21_file 	 init "../samples/opcode/chiseq/chiseq_21.wav"
gichiseq_21_1		 ftgen 0, 0, 0, 1, gSchiseq_21_file, 0, 0, 1
gichiseq_21_2		 ftgen 0, 0, 0, 1, gSchiseq_21_file, 0, 0, 2
;---
gSchiseq_22_file 	 init "../samples/opcode/chiseq/chiseq_22.wav"
gichiseq_22_1		 ftgen 0, 0, 0, 1, gSchiseq_22_file, 0, 0, 1
gichiseq_22_2		 ftgen 0, 0, 0, 1, gSchiseq_22_file, 0, 0, 2
;---
gSchiseq_23_file 	 init "../samples/opcode/chiseq/chiseq_23.wav"
gichiseq_23_1		 ftgen 0, 0, 0, 1, gSchiseq_23_file, 0, 0, 1
gichiseq_23_2		 ftgen 0, 0, 0, 1, gSchiseq_23_file, 0, 0, 2
;---
gichiseq_sonvs[]			fillarray	gichiseq_00_1, gichiseq_00_2, gichiseq_01_1, gichiseq_01_2, gichiseq_02_1, gichiseq_02_2, gichiseq_03_1, gichiseq_03_2, gichiseq_04_1, gichiseq_04_2, gichiseq_05_1, gichiseq_05_2, gichiseq_06_1, gichiseq_06_2, gichiseq_07_1, gichiseq_07_2, gichiseq_08_1, gichiseq_08_2, gichiseq_09_1, gichiseq_09_2, gichiseq_10_1, gichiseq_10_2, gichiseq_11_1, gichiseq_11_2, gichiseq_12_1, gichiseq_12_2, gichiseq_13_1, gichiseq_13_2, gichiseq_14_1, gichiseq_14_2, gichiseq_15_1, gichiseq_15_2, gichiseq_16_1, gichiseq_16_2, gichiseq_17_1, gichiseq_17_2, gichiseq_18_1, gichiseq_18_2, gichiseq_19_1, gichiseq_19_2, gichiseq_20_1, gichiseq_20_2, gichiseq_21_1, gichiseq_21_2, gichiseq_22_1, gichiseq_22_2, gichiseq_23_1, gichiseq_23_2
gkchiseq_time		init 16
gkchiseq_off		init .005
gkchiseq_dur		init 1
gkchiseq_sonvs		init 1
gichiseq_len		init lenarray(gichiseq_sonvs)/2

;------------------

	instr chiseq

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "chiseq"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkchiseq_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkchiseq_sonvs%(gichiseq_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gichiseq_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "chiseq"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkchiseq_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gichiseq_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gichiseq_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "chiseq"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkchiseq_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkchiseq_sonvs%(gichiseq_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gichiseq_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	chiseq, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "chiseq"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkchiseq_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkchiseq_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	chiseq, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "chiseq"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkchiseq_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkchiseq_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gScoeur_file	init "../samples/opcode/coeur.wav"

gicoeur1	ftgen 0, 0, 0, 1, gScoeur_file, 0, 0, 1
gicoeur2	ftgen 0, 0, 0, 1, gScoeur_file, 0, 0, 2

gkcoeur_time		init 16
gkcoeur_off		init .005
gkcoeur_dur		init 1
;------------------

	instr coeur

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "coeur"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkcoeur_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gicoeur1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "coeur"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkcoeur_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gicoeur1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "coeur"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkcoeur_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gicoeur1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	coeur, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "coeur"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcoeur_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcoeur_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	coeur, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "coeur"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcoeur_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcoeur_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gScontempo_file	init "../samples/opcode/contempo.wav"

gicontempo1	ftgen 0, 0, 0, 1, gScontempo_file, 0, 0, 1
gicontempo2	ftgen 0, 0, 0, 1, gScontempo_file, 0, 0, 2

gkcontempo_time		init 16
gkcontempo_off		init .005
gkcontempo_dur		init 1
;------------------

	instr contempo

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "contempo"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkcontempo_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gicontempo1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "contempo"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkcontempo_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gicontempo1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "contempo"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkcontempo_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gicontempo1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	contempo, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "contempo"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcontempo_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcontempo_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	contempo, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "contempo"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkcontempo_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkcontempo_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSdance_file	init "../samples/opcode/dance.wav"

gidance1	ftgen 0, 0, 0, 1, gSdance_file, 0, 0, 1
gidance2	ftgen 0, 0, 0, 1, gSdance_file, 0, 0, 2

gkdance_time		init 16
gkdance_off		init .005
gkdance_dur		init 1
;------------------

	instr dance

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "dance"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkdance_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gidance1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "dance"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkdance_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gidance1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "dance"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkdance_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gidance1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	dance, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "dance"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkdance_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkdance_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	dance, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "dance"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkdance_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkdance_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSdisfigured_matter_split_sil002_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil002.wav"
gidisfigured_matter_split_sil002_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil002_file, 0, 0, 1
gidisfigured_matter_split_sil002_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil002_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil003_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil003.wav"
gidisfigured_matter_split_sil003_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil003_file, 0, 0, 1
gidisfigured_matter_split_sil003_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil003_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil004_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil004.wav"
gidisfigured_matter_split_sil004_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil004_file, 0, 0, 1
gidisfigured_matter_split_sil004_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil004_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil005_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil005.wav"
gidisfigured_matter_split_sil005_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil005_file, 0, 0, 1
gidisfigured_matter_split_sil005_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil005_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil006_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil006.wav"
gidisfigured_matter_split_sil006_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil006_file, 0, 0, 1
gidisfigured_matter_split_sil006_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil006_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil007_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil007.wav"
gidisfigured_matter_split_sil007_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil007_file, 0, 0, 1
gidisfigured_matter_split_sil007_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil007_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil008_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil008.wav"
gidisfigured_matter_split_sil008_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil008_file, 0, 0, 1
gidisfigured_matter_split_sil008_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil008_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil009_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil009.wav"
gidisfigured_matter_split_sil009_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil009_file, 0, 0, 1
gidisfigured_matter_split_sil009_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil009_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil010_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil010.wav"
gidisfigured_matter_split_sil010_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil010_file, 0, 0, 1
gidisfigured_matter_split_sil010_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil010_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil011_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil011.wav"
gidisfigured_matter_split_sil011_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil011_file, 0, 0, 1
gidisfigured_matter_split_sil011_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil011_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil012_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil012.wav"
gidisfigured_matter_split_sil012_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil012_file, 0, 0, 1
gidisfigured_matter_split_sil012_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil012_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil013_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil013.wav"
gidisfigured_matter_split_sil013_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil013_file, 0, 0, 1
gidisfigured_matter_split_sil013_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil013_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil014_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil014.wav"
gidisfigured_matter_split_sil014_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil014_file, 0, 0, 1
gidisfigured_matter_split_sil014_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil014_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil015_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil015.wav"
gidisfigured_matter_split_sil015_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil015_file, 0, 0, 1
gidisfigured_matter_split_sil015_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil015_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil016_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil016.wav"
gidisfigured_matter_split_sil016_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil016_file, 0, 0, 1
gidisfigured_matter_split_sil016_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil016_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil017_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil017.wav"
gidisfigured_matter_split_sil017_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil017_file, 0, 0, 1
gidisfigured_matter_split_sil017_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil017_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil018_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil018.wav"
gidisfigured_matter_split_sil018_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil018_file, 0, 0, 1
gidisfigured_matter_split_sil018_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil018_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil019_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil019.wav"
gidisfigured_matter_split_sil019_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil019_file, 0, 0, 1
gidisfigured_matter_split_sil019_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil019_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil020_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil020.wav"
gidisfigured_matter_split_sil020_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil020_file, 0, 0, 1
gidisfigured_matter_split_sil020_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil020_file, 0, 0, 2
;---
gSdisfigured_matter_split_sil021_file 	 init "../samples/opcode/dismatter/disfigured_matter_split_sil021.wav"
gidisfigured_matter_split_sil021_1		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil021_file, 0, 0, 1
gidisfigured_matter_split_sil021_2		 ftgen 0, 0, 0, 1, gSdisfigured_matter_split_sil021_file, 0, 0, 2
;---
gidismatter_sonvs[]			fillarray	gidisfigured_matter_split_sil002_1, gidisfigured_matter_split_sil002_2, gidisfigured_matter_split_sil003_1, gidisfigured_matter_split_sil003_2, gidisfigured_matter_split_sil004_1, gidisfigured_matter_split_sil004_2, gidisfigured_matter_split_sil005_1, gidisfigured_matter_split_sil005_2, gidisfigured_matter_split_sil006_1, gidisfigured_matter_split_sil006_2, gidisfigured_matter_split_sil007_1, gidisfigured_matter_split_sil007_2, gidisfigured_matter_split_sil008_1, gidisfigured_matter_split_sil008_2, gidisfigured_matter_split_sil009_1, gidisfigured_matter_split_sil009_2, gidisfigured_matter_split_sil010_1, gidisfigured_matter_split_sil010_2, gidisfigured_matter_split_sil011_1, gidisfigured_matter_split_sil011_2, gidisfigured_matter_split_sil012_1, gidisfigured_matter_split_sil012_2, gidisfigured_matter_split_sil013_1, gidisfigured_matter_split_sil013_2, gidisfigured_matter_split_sil014_1, gidisfigured_matter_split_sil014_2, gidisfigured_matter_split_sil015_1, gidisfigured_matter_split_sil015_2, gidisfigured_matter_split_sil016_1, gidisfigured_matter_split_sil016_2, gidisfigured_matter_split_sil017_1, gidisfigured_matter_split_sil017_2, gidisfigured_matter_split_sil018_1, gidisfigured_matter_split_sil018_2, gidisfigured_matter_split_sil019_1, gidisfigured_matter_split_sil019_2, gidisfigured_matter_split_sil020_1, gidisfigured_matter_split_sil020_2, gidisfigured_matter_split_sil021_1, gidisfigured_matter_split_sil021_2
gkdismatter_time		init 16
gkdismatter_off		init .005
gkdismatter_dur		init 1
gkdismatter_sonvs		init 1
gidismatter_len		init lenarray(gidismatter_sonvs)/2

;------------------

	instr dismatter

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "dismatter"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkdismatter_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkdismatter_sonvs%(gidismatter_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gidismatter_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "dismatter"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkdismatter_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gidismatter_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gidismatter_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "dismatter"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkdismatter_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkdismatter_sonvs%(gidismatter_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gidismatter_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	dismatter, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "dismatter"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkdismatter_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkdismatter_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	dismatter, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "dismatter"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkdismatter_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkdismatter_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSdistmar_00_file 	 init "../samples/opcode/distmar/distmar_00.wav"
gidistmar_00_1		 ftgen 0, 0, 0, 1, gSdistmar_00_file, 0, 0, 1
gidistmar_00_2		 ftgen 0, 0, 0, 1, gSdistmar_00_file, 0, 0, 2
;---
gSdistmar_01_file 	 init "../samples/opcode/distmar/distmar_01.wav"
gidistmar_01_1		 ftgen 0, 0, 0, 1, gSdistmar_01_file, 0, 0, 1
gidistmar_01_2		 ftgen 0, 0, 0, 1, gSdistmar_01_file, 0, 0, 2
;---
gSdistmar_02_file 	 init "../samples/opcode/distmar/distmar_02.wav"
gidistmar_02_1		 ftgen 0, 0, 0, 1, gSdistmar_02_file, 0, 0, 1
gidistmar_02_2		 ftgen 0, 0, 0, 1, gSdistmar_02_file, 0, 0, 2
;---
gSdistmar_03_file 	 init "../samples/opcode/distmar/distmar_03.wav"
gidistmar_03_1		 ftgen 0, 0, 0, 1, gSdistmar_03_file, 0, 0, 1
gidistmar_03_2		 ftgen 0, 0, 0, 1, gSdistmar_03_file, 0, 0, 2
;---
gSdistmar_04_file 	 init "../samples/opcode/distmar/distmar_04.wav"
gidistmar_04_1		 ftgen 0, 0, 0, 1, gSdistmar_04_file, 0, 0, 1
gidistmar_04_2		 ftgen 0, 0, 0, 1, gSdistmar_04_file, 0, 0, 2
;---
gSdistmar_05_file 	 init "../samples/opcode/distmar/distmar_05.wav"
gidistmar_05_1		 ftgen 0, 0, 0, 1, gSdistmar_05_file, 0, 0, 1
gidistmar_05_2		 ftgen 0, 0, 0, 1, gSdistmar_05_file, 0, 0, 2
;---
gSdistmar_06_file 	 init "../samples/opcode/distmar/distmar_06.wav"
gidistmar_06_1		 ftgen 0, 0, 0, 1, gSdistmar_06_file, 0, 0, 1
gidistmar_06_2		 ftgen 0, 0, 0, 1, gSdistmar_06_file, 0, 0, 2
;---
gSdistmar_07_file 	 init "../samples/opcode/distmar/distmar_07.wav"
gidistmar_07_1		 ftgen 0, 0, 0, 1, gSdistmar_07_file, 0, 0, 1
gidistmar_07_2		 ftgen 0, 0, 0, 1, gSdistmar_07_file, 0, 0, 2
;---
gSdistmar_08_file 	 init "../samples/opcode/distmar/distmar_08.wav"
gidistmar_08_1		 ftgen 0, 0, 0, 1, gSdistmar_08_file, 0, 0, 1
gidistmar_08_2		 ftgen 0, 0, 0, 1, gSdistmar_08_file, 0, 0, 2
;---
gSdistmar_09_file 	 init "../samples/opcode/distmar/distmar_09.wav"
gidistmar_09_1		 ftgen 0, 0, 0, 1, gSdistmar_09_file, 0, 0, 1
gidistmar_09_2		 ftgen 0, 0, 0, 1, gSdistmar_09_file, 0, 0, 2
;---
gSdistmar_10_file 	 init "../samples/opcode/distmar/distmar_10.wav"
gidistmar_10_1		 ftgen 0, 0, 0, 1, gSdistmar_10_file, 0, 0, 1
gidistmar_10_2		 ftgen 0, 0, 0, 1, gSdistmar_10_file, 0, 0, 2
;---
gSdistmar_11_file 	 init "../samples/opcode/distmar/distmar_11.wav"
gidistmar_11_1		 ftgen 0, 0, 0, 1, gSdistmar_11_file, 0, 0, 1
gidistmar_11_2		 ftgen 0, 0, 0, 1, gSdistmar_11_file, 0, 0, 2
;---
gSdistmar_12_file 	 init "../samples/opcode/distmar/distmar_12.wav"
gidistmar_12_1		 ftgen 0, 0, 0, 1, gSdistmar_12_file, 0, 0, 1
gidistmar_12_2		 ftgen 0, 0, 0, 1, gSdistmar_12_file, 0, 0, 2
;---
gSdistmar_13_file 	 init "../samples/opcode/distmar/distmar_13.wav"
gidistmar_13_1		 ftgen 0, 0, 0, 1, gSdistmar_13_file, 0, 0, 1
gidistmar_13_2		 ftgen 0, 0, 0, 1, gSdistmar_13_file, 0, 0, 2
;---
gSdistmar_14_file 	 init "../samples/opcode/distmar/distmar_14.wav"
gidistmar_14_1		 ftgen 0, 0, 0, 1, gSdistmar_14_file, 0, 0, 1
gidistmar_14_2		 ftgen 0, 0, 0, 1, gSdistmar_14_file, 0, 0, 2
;---
gSdistmar_15_file 	 init "../samples/opcode/distmar/distmar_15.wav"
gidistmar_15_1		 ftgen 0, 0, 0, 1, gSdistmar_15_file, 0, 0, 1
gidistmar_15_2		 ftgen 0, 0, 0, 1, gSdistmar_15_file, 0, 0, 2
;---
gSdistmar_16_file 	 init "../samples/opcode/distmar/distmar_16.wav"
gidistmar_16_1		 ftgen 0, 0, 0, 1, gSdistmar_16_file, 0, 0, 1
gidistmar_16_2		 ftgen 0, 0, 0, 1, gSdistmar_16_file, 0, 0, 2
;---
gSdistmar_17_file 	 init "../samples/opcode/distmar/distmar_17.wav"
gidistmar_17_1		 ftgen 0, 0, 0, 1, gSdistmar_17_file, 0, 0, 1
gidistmar_17_2		 ftgen 0, 0, 0, 1, gSdistmar_17_file, 0, 0, 2
;---
gSdistmar_18_file 	 init "../samples/opcode/distmar/distmar_18.wav"
gidistmar_18_1		 ftgen 0, 0, 0, 1, gSdistmar_18_file, 0, 0, 1
gidistmar_18_2		 ftgen 0, 0, 0, 1, gSdistmar_18_file, 0, 0, 2
;---
gSdistmar_19_file 	 init "../samples/opcode/distmar/distmar_19.wav"
gidistmar_19_1		 ftgen 0, 0, 0, 1, gSdistmar_19_file, 0, 0, 1
gidistmar_19_2		 ftgen 0, 0, 0, 1, gSdistmar_19_file, 0, 0, 2
;---
gSdistmar_20_file 	 init "../samples/opcode/distmar/distmar_20.wav"
gidistmar_20_1		 ftgen 0, 0, 0, 1, gSdistmar_20_file, 0, 0, 1
gidistmar_20_2		 ftgen 0, 0, 0, 1, gSdistmar_20_file, 0, 0, 2
;---
gSdistmar_21_file 	 init "../samples/opcode/distmar/distmar_21.wav"
gidistmar_21_1		 ftgen 0, 0, 0, 1, gSdistmar_21_file, 0, 0, 1
gidistmar_21_2		 ftgen 0, 0, 0, 1, gSdistmar_21_file, 0, 0, 2
;---
gSdistmar_22_file 	 init "../samples/opcode/distmar/distmar_22.wav"
gidistmar_22_1		 ftgen 0, 0, 0, 1, gSdistmar_22_file, 0, 0, 1
gidistmar_22_2		 ftgen 0, 0, 0, 1, gSdistmar_22_file, 0, 0, 2
;---
gSdistmar_23_file 	 init "../samples/opcode/distmar/distmar_23.wav"
gidistmar_23_1		 ftgen 0, 0, 0, 1, gSdistmar_23_file, 0, 0, 1
gidistmar_23_2		 ftgen 0, 0, 0, 1, gSdistmar_23_file, 0, 0, 2
;---
gSdistmar_24_file 	 init "../samples/opcode/distmar/distmar_24.wav"
gidistmar_24_1		 ftgen 0, 0, 0, 1, gSdistmar_24_file, 0, 0, 1
gidistmar_24_2		 ftgen 0, 0, 0, 1, gSdistmar_24_file, 0, 0, 2
;---
gSdistmar_25_file 	 init "../samples/opcode/distmar/distmar_25.wav"
gidistmar_25_1		 ftgen 0, 0, 0, 1, gSdistmar_25_file, 0, 0, 1
gidistmar_25_2		 ftgen 0, 0, 0, 1, gSdistmar_25_file, 0, 0, 2
;---
gSdistmar_26_file 	 init "../samples/opcode/distmar/distmar_26.wav"
gidistmar_26_1		 ftgen 0, 0, 0, 1, gSdistmar_26_file, 0, 0, 1
gidistmar_26_2		 ftgen 0, 0, 0, 1, gSdistmar_26_file, 0, 0, 2
;---
gSdistmar_27_file 	 init "../samples/opcode/distmar/distmar_27.wav"
gidistmar_27_1		 ftgen 0, 0, 0, 1, gSdistmar_27_file, 0, 0, 1
gidistmar_27_2		 ftgen 0, 0, 0, 1, gSdistmar_27_file, 0, 0, 2
;---
gSdistmar_28_file 	 init "../samples/opcode/distmar/distmar_28.wav"
gidistmar_28_1		 ftgen 0, 0, 0, 1, gSdistmar_28_file, 0, 0, 1
gidistmar_28_2		 ftgen 0, 0, 0, 1, gSdistmar_28_file, 0, 0, 2
;---
gSdistmar_29_file 	 init "../samples/opcode/distmar/distmar_29.wav"
gidistmar_29_1		 ftgen 0, 0, 0, 1, gSdistmar_29_file, 0, 0, 1
gidistmar_29_2		 ftgen 0, 0, 0, 1, gSdistmar_29_file, 0, 0, 2
;---
gidistmar_sonvs[]			fillarray	gidistmar_00_1, gidistmar_00_2, gidistmar_01_1, gidistmar_01_2, gidistmar_02_1, gidistmar_02_2, gidistmar_03_1, gidistmar_03_2, gidistmar_04_1, gidistmar_04_2, gidistmar_05_1, gidistmar_05_2, gidistmar_06_1, gidistmar_06_2, gidistmar_07_1, gidistmar_07_2, gidistmar_08_1, gidistmar_08_2, gidistmar_09_1, gidistmar_09_2, gidistmar_10_1, gidistmar_10_2, gidistmar_11_1, gidistmar_11_2, gidistmar_12_1, gidistmar_12_2, gidistmar_13_1, gidistmar_13_2, gidistmar_14_1, gidistmar_14_2, gidistmar_15_1, gidistmar_15_2, gidistmar_16_1, gidistmar_16_2, gidistmar_17_1, gidistmar_17_2, gidistmar_18_1, gidistmar_18_2, gidistmar_19_1, gidistmar_19_2, gidistmar_20_1, gidistmar_20_2, gidistmar_21_1, gidistmar_21_2, gidistmar_22_1, gidistmar_22_2, gidistmar_23_1, gidistmar_23_2, gidistmar_24_1, gidistmar_24_2, gidistmar_25_1, gidistmar_25_2, gidistmar_26_1, gidistmar_26_2, gidistmar_27_1, gidistmar_27_2, gidistmar_28_1, gidistmar_28_2, gidistmar_29_1, gidistmar_29_2
gkdistmar_time		init 16
gkdistmar_off		init .005
gkdistmar_dur		init 1
gkdistmar_sonvs		init 1
gidistmar_len		init lenarray(gidistmar_sonvs)/2

;------------------

	instr distmar

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "distmar"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkdistmar_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkdistmar_sonvs%(gidistmar_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gidistmar_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "distmar"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkdistmar_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gidistmar_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gidistmar_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "distmar"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkdistmar_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkdistmar_sonvs%(gidistmar_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gidistmar_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	distmar, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "distmar"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkdistmar_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkdistmar_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	distmar, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "distmar"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkdistmar_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkdistmar_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSdrum_file	init "../samples/opcode/drum.wav"

gidrum1	ftgen 0, 0, 0, 1, gSdrum_file, 0, 0, 1
gidrum2	ftgen 0, 0, 0, 1, gSdrum_file, 0, 0, 2

gkdrum_time		init 16
gkdrum_off		init .005
gkdrum_dur		init 1
;------------------

	instr drum

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "drum"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkdrum_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gidrum1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "drum"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkdrum_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gidrum1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "drum"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkdrum_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gidrum1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	drum, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "drum"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkdrum_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkdrum_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	drum, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "drum"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkdrum_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkdrum_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSdrumhigh_file	init "../samples/opcode/drumhigh.wav"

gidrumhigh1	ftgen 0, 0, 0, 1, gSdrumhigh_file, 0, 0, 1
gidrumhigh2	ftgen 0, 0, 0, 1, gSdrumhigh_file, 0, 0, 2

gkdrumhigh_time		init 16
gkdrumhigh_off		init .005
gkdrumhigh_dur		init 1
;------------------

	instr drumhigh

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "drumhigh"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkdrumhigh_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gidrumhigh1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "drumhigh"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkdrumhigh_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gidrumhigh1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "drumhigh"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkdrumhigh_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gidrumhigh1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	drumhigh, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "drumhigh"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkdrumhigh_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkdrumhigh_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	drumhigh, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "drumhigh"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkdrumhigh_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkdrumhigh_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSetag_file	init "../samples/opcode/etag.wav"

gietag1	ftgen 0, 0, 0, 1, gSetag_file, 0, 0, 1
gietag2	ftgen 0, 0, 0, 1, gSetag_file, 0, 0, 2

gketag_time		init 16
gketag_off		init .005
gketag_dur		init 1
;------------------

	instr etag

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "etag"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gketag_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gietag1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "etag"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gketag_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gietag1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "etag"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gketag_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gietag1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	etag, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "etag"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gketag_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gketag_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	etag, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "etag"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gketag_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gketag_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSfalga_01_file 	 init "../samples/opcode/falga/falga-01.wav"
gifalga_01_1		 ftgen 0, 0, 0, 1, gSfalga_01_file, 0, 0, 1
gifalga_01_2		 ftgen 0, 0, 0, 1, gSfalga_01_file, 0, 0, 2
;---
gSfalga_02_file 	 init "../samples/opcode/falga/falga-02.wav"
gifalga_02_1		 ftgen 0, 0, 0, 1, gSfalga_02_file, 0, 0, 1
gifalga_02_2		 ftgen 0, 0, 0, 1, gSfalga_02_file, 0, 0, 2
;---
gSfalga_03_file 	 init "../samples/opcode/falga/falga-03.wav"
gifalga_03_1		 ftgen 0, 0, 0, 1, gSfalga_03_file, 0, 0, 1
gifalga_03_2		 ftgen 0, 0, 0, 1, gSfalga_03_file, 0, 0, 2
;---
gSfalga_04_file 	 init "../samples/opcode/falga/falga-04.wav"
gifalga_04_1		 ftgen 0, 0, 0, 1, gSfalga_04_file, 0, 0, 1
gifalga_04_2		 ftgen 0, 0, 0, 1, gSfalga_04_file, 0, 0, 2
;---
gSfalga_05_file 	 init "../samples/opcode/falga/falga-05.wav"
gifalga_05_1		 ftgen 0, 0, 0, 1, gSfalga_05_file, 0, 0, 1
gifalga_05_2		 ftgen 0, 0, 0, 1, gSfalga_05_file, 0, 0, 2
;---
gifalga_sonvs[]			fillarray	gifalga_01_1, gifalga_01_2, gifalga_02_1, gifalga_02_2, gifalga_03_1, gifalga_03_2, gifalga_04_1, gifalga_04_2, gifalga_05_1, gifalga_05_2
gkfalga_time		init 16
gkfalga_off		init .005
gkfalga_dur		init 1
gkfalga_sonvs		init 1
gifalga_len		init lenarray(gifalga_sonvs)/2

;------------------

	instr falga

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "falga"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkfalga_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkfalga_sonvs%(gifalga_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gifalga_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "falga"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkfalga_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gifalga_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gifalga_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "falga"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkfalga_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkfalga_sonvs%(gifalga_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gifalga_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	falga, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "falga"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkfalga_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkfalga_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	falga, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "falga"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkfalga_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkfalga_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSfragment_file	init "../samples/opcode/fragment.wav"

gifragment1	ftgen 0, 0, 0, 1, gSfragment_file, 0, 0, 1
gifragment2	ftgen 0, 0, 0, 1, gSfragment_file, 0, 0, 2

gkfragment_time		init 16
gkfragment_off		init .005
gkfragment_dur		init 1
;------------------

	instr fragment

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "fragment"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkfragment_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gifragment1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "fragment"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkfragment_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gifragment1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "fragment"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkfragment_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gifragment1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	fragment, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "fragment"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkfragment_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkfragment_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	fragment, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "fragment"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkfragment_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkfragment_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSgameld_00_file 	 init "../samples/opcode/gameld/gameld_00.wav"
gigameld_00_1		 ftgen 0, 0, 0, 1, gSgameld_00_file, 0, 0, 1
gigameld_00_2		 ftgen 0, 0, 0, 1, gSgameld_00_file, 0, 0, 2
;---
gSgameld_01_file 	 init "../samples/opcode/gameld/gameld_01.wav"
gigameld_01_1		 ftgen 0, 0, 0, 1, gSgameld_01_file, 0, 0, 1
gigameld_01_2		 ftgen 0, 0, 0, 1, gSgameld_01_file, 0, 0, 2
;---
gSgameld_02_file 	 init "../samples/opcode/gameld/gameld_02.wav"
gigameld_02_1		 ftgen 0, 0, 0, 1, gSgameld_02_file, 0, 0, 1
gigameld_02_2		 ftgen 0, 0, 0, 1, gSgameld_02_file, 0, 0, 2
;---
gSgameld_03_file 	 init "../samples/opcode/gameld/gameld_03.wav"
gigameld_03_1		 ftgen 0, 0, 0, 1, gSgameld_03_file, 0, 0, 1
gigameld_03_2		 ftgen 0, 0, 0, 1, gSgameld_03_file, 0, 0, 2
;---
gSgameld_04_file 	 init "../samples/opcode/gameld/gameld_04.wav"
gigameld_04_1		 ftgen 0, 0, 0, 1, gSgameld_04_file, 0, 0, 1
gigameld_04_2		 ftgen 0, 0, 0, 1, gSgameld_04_file, 0, 0, 2
;---
gSgameld_05_file 	 init "../samples/opcode/gameld/gameld_05.wav"
gigameld_05_1		 ftgen 0, 0, 0, 1, gSgameld_05_file, 0, 0, 1
gigameld_05_2		 ftgen 0, 0, 0, 1, gSgameld_05_file, 0, 0, 2
;---
gSgameld_06_file 	 init "../samples/opcode/gameld/gameld_06.wav"
gigameld_06_1		 ftgen 0, 0, 0, 1, gSgameld_06_file, 0, 0, 1
gigameld_06_2		 ftgen 0, 0, 0, 1, gSgameld_06_file, 0, 0, 2
;---
gSgameld_07_file 	 init "../samples/opcode/gameld/gameld_07.wav"
gigameld_07_1		 ftgen 0, 0, 0, 1, gSgameld_07_file, 0, 0, 1
gigameld_07_2		 ftgen 0, 0, 0, 1, gSgameld_07_file, 0, 0, 2
;---
gSgameld_08_file 	 init "../samples/opcode/gameld/gameld_08.wav"
gigameld_08_1		 ftgen 0, 0, 0, 1, gSgameld_08_file, 0, 0, 1
gigameld_08_2		 ftgen 0, 0, 0, 1, gSgameld_08_file, 0, 0, 2
;---
gSgameld_09_file 	 init "../samples/opcode/gameld/gameld_09.wav"
gigameld_09_1		 ftgen 0, 0, 0, 1, gSgameld_09_file, 0, 0, 1
gigameld_09_2		 ftgen 0, 0, 0, 1, gSgameld_09_file, 0, 0, 2
;---
gSgameld_10_file 	 init "../samples/opcode/gameld/gameld_10.wav"
gigameld_10_1		 ftgen 0, 0, 0, 1, gSgameld_10_file, 0, 0, 1
gigameld_10_2		 ftgen 0, 0, 0, 1, gSgameld_10_file, 0, 0, 2
;---
gSgameld_11_file 	 init "../samples/opcode/gameld/gameld_11.wav"
gigameld_11_1		 ftgen 0, 0, 0, 1, gSgameld_11_file, 0, 0, 1
gigameld_11_2		 ftgen 0, 0, 0, 1, gSgameld_11_file, 0, 0, 2
;---
gSgameld_12_file 	 init "../samples/opcode/gameld/gameld_12.wav"
gigameld_12_1		 ftgen 0, 0, 0, 1, gSgameld_12_file, 0, 0, 1
gigameld_12_2		 ftgen 0, 0, 0, 1, gSgameld_12_file, 0, 0, 2
;---
gigameld_sonvs[]			fillarray	gigameld_00_1, gigameld_00_2, gigameld_01_1, gigameld_01_2, gigameld_02_1, gigameld_02_2, gigameld_03_1, gigameld_03_2, gigameld_04_1, gigameld_04_2, gigameld_05_1, gigameld_05_2, gigameld_06_1, gigameld_06_2, gigameld_07_1, gigameld_07_2, gigameld_08_1, gigameld_08_2, gigameld_09_1, gigameld_09_2, gigameld_10_1, gigameld_10_2, gigameld_11_1, gigameld_11_2, gigameld_12_1, gigameld_12_2
gkgameld_time		init 16
gkgameld_off		init .005
gkgameld_dur		init 1
gkgameld_sonvs		init 1
gigameld_len		init lenarray(gigameld_sonvs)/2

;------------------

	instr gameld

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "gameld"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkgameld_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkgameld_sonvs%(gigameld_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gigameld_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "gameld"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkgameld_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gigameld_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gigameld_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "gameld"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkgameld_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkgameld_sonvs%(gigameld_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gigameld_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	gameld, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gameld"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgameld_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgameld_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	gameld, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gameld"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgameld_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgameld_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSgamelf_00_file 	 init "../samples/opcode/gamelf/gamelf_00.wav"
gigamelf_00_1		 ftgen 0, 0, 0, 1, gSgamelf_00_file, 0, 0, 1
gigamelf_00_2		 ftgen 0, 0, 0, 1, gSgamelf_00_file, 0, 0, 2
;---
gSgamelf_01_file 	 init "../samples/opcode/gamelf/gamelf_01.wav"
gigamelf_01_1		 ftgen 0, 0, 0, 1, gSgamelf_01_file, 0, 0, 1
gigamelf_01_2		 ftgen 0, 0, 0, 1, gSgamelf_01_file, 0, 0, 2
;---
gSgamelf_02_file 	 init "../samples/opcode/gamelf/gamelf_02.wav"
gigamelf_02_1		 ftgen 0, 0, 0, 1, gSgamelf_02_file, 0, 0, 1
gigamelf_02_2		 ftgen 0, 0, 0, 1, gSgamelf_02_file, 0, 0, 2
;---
gSgamelf_03_file 	 init "../samples/opcode/gamelf/gamelf_03.wav"
gigamelf_03_1		 ftgen 0, 0, 0, 1, gSgamelf_03_file, 0, 0, 1
gigamelf_03_2		 ftgen 0, 0, 0, 1, gSgamelf_03_file, 0, 0, 2
;---
gSgamelf_04_file 	 init "../samples/opcode/gamelf/gamelf_04.wav"
gigamelf_04_1		 ftgen 0, 0, 0, 1, gSgamelf_04_file, 0, 0, 1
gigamelf_04_2		 ftgen 0, 0, 0, 1, gSgamelf_04_file, 0, 0, 2
;---
gSgamelf_05_file 	 init "../samples/opcode/gamelf/gamelf_05.wav"
gigamelf_05_1		 ftgen 0, 0, 0, 1, gSgamelf_05_file, 0, 0, 1
gigamelf_05_2		 ftgen 0, 0, 0, 1, gSgamelf_05_file, 0, 0, 2
;---
gSgamelf_06_file 	 init "../samples/opcode/gamelf/gamelf_06.wav"
gigamelf_06_1		 ftgen 0, 0, 0, 1, gSgamelf_06_file, 0, 0, 1
gigamelf_06_2		 ftgen 0, 0, 0, 1, gSgamelf_06_file, 0, 0, 2
;---
gSgamelf_07_file 	 init "../samples/opcode/gamelf/gamelf_07.wav"
gigamelf_07_1		 ftgen 0, 0, 0, 1, gSgamelf_07_file, 0, 0, 1
gigamelf_07_2		 ftgen 0, 0, 0, 1, gSgamelf_07_file, 0, 0, 2
;---
gSgamelf_08_file 	 init "../samples/opcode/gamelf/gamelf_08.wav"
gigamelf_08_1		 ftgen 0, 0, 0, 1, gSgamelf_08_file, 0, 0, 1
gigamelf_08_2		 ftgen 0, 0, 0, 1, gSgamelf_08_file, 0, 0, 2
;---
gSgamelf_09_file 	 init "../samples/opcode/gamelf/gamelf_09.wav"
gigamelf_09_1		 ftgen 0, 0, 0, 1, gSgamelf_09_file, 0, 0, 1
gigamelf_09_2		 ftgen 0, 0, 0, 1, gSgamelf_09_file, 0, 0, 2
;---
gSgamelf_10_file 	 init "../samples/opcode/gamelf/gamelf_10.wav"
gigamelf_10_1		 ftgen 0, 0, 0, 1, gSgamelf_10_file, 0, 0, 1
gigamelf_10_2		 ftgen 0, 0, 0, 1, gSgamelf_10_file, 0, 0, 2
;---
gSgamelf_11_file 	 init "../samples/opcode/gamelf/gamelf_11.wav"
gigamelf_11_1		 ftgen 0, 0, 0, 1, gSgamelf_11_file, 0, 0, 1
gigamelf_11_2		 ftgen 0, 0, 0, 1, gSgamelf_11_file, 0, 0, 2
;---
gSgamelf_12_file 	 init "../samples/opcode/gamelf/gamelf_12.wav"
gigamelf_12_1		 ftgen 0, 0, 0, 1, gSgamelf_12_file, 0, 0, 1
gigamelf_12_2		 ftgen 0, 0, 0, 1, gSgamelf_12_file, 0, 0, 2
;---
gigamelf_sonvs[]			fillarray	gigamelf_00_1, gigamelf_00_2, gigamelf_01_1, gigamelf_01_2, gigamelf_02_1, gigamelf_02_2, gigamelf_03_1, gigamelf_03_2, gigamelf_04_1, gigamelf_04_2, gigamelf_05_1, gigamelf_05_2, gigamelf_06_1, gigamelf_06_2, gigamelf_07_1, gigamelf_07_2, gigamelf_08_1, gigamelf_08_2, gigamelf_09_1, gigamelf_09_2, gigamelf_10_1, gigamelf_10_2, gigamelf_11_1, gigamelf_11_2, gigamelf_12_1, gigamelf_12_2
gkgamelf_time		init 16
gkgamelf_off		init .005
gkgamelf_dur		init 1
gkgamelf_sonvs		init 1
gigamelf_len		init lenarray(gigamelf_sonvs)/2

;------------------

	instr gamelf

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "gamelf"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkgamelf_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkgamelf_sonvs%(gigamelf_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gigamelf_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "gamelf"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkgamelf_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gigamelf_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gigamelf_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "gamelf"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkgamelf_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkgamelf_sonvs%(gigamelf_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gigamelf_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	gamelf, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gamelf"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgamelf_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgamelf_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	gamelf, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gamelf"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgamelf_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgamelf_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSgesto1_file	init "../samples/opcode/gesto1.wav"

gigesto11	ftgen 0, 0, 0, 1, gSgesto1_file, 0, 0, 1
gigesto12	ftgen 0, 0, 0, 1, gSgesto1_file, 0, 0, 2

gkgesto1_time		init 16
gkgesto1_off		init .005
gkgesto1_dur		init 1
;------------------

	instr gesto1

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "gesto1"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkgesto1_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gigesto11+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "gesto1"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkgesto1_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gigesto11+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "gesto1"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkgesto1_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gigesto11+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	gesto1, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gesto1"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgesto1_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgesto1_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	gesto1, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gesto1"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgesto1_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgesto1_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSgesto2_file	init "../samples/opcode/gesto2.wav"

gigesto21	ftgen 0, 0, 0, 1, gSgesto2_file, 0, 0, 1
gigesto22	ftgen 0, 0, 0, 1, gSgesto2_file, 0, 0, 2

gkgesto2_time		init 16
gkgesto2_off		init .005
gkgesto2_dur		init 1
;------------------

	instr gesto2

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "gesto2"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkgesto2_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gigesto21+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "gesto2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkgesto2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gigesto21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "gesto2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkgesto2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gigesto21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	gesto2, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gesto2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgesto2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgesto2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	gesto2, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gesto2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgesto2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgesto2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSgesto3_file	init "../samples/opcode/gesto3.wav"

gigesto31	ftgen 0, 0, 0, 1, gSgesto3_file, 0, 0, 1
gigesto32	ftgen 0, 0, 0, 1, gSgesto3_file, 0, 0, 2

gkgesto3_time		init 16
gkgesto3_off		init .005
gkgesto3_dur		init 1
;------------------

	instr gesto3

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "gesto3"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkgesto3_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gigesto31+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "gesto3"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkgesto3_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gigesto31+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "gesto3"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkgesto3_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gigesto31+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	gesto3, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gesto3"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgesto3_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgesto3_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	gesto3, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gesto3"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgesto3_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgesto3_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSgesto4_file	init "../samples/opcode/gesto4.wav"

gigesto41	ftgen 0, 0, 0, 1, gSgesto4_file, 0, 0, 1
gigesto42	ftgen 0, 0, 0, 1, gSgesto4_file, 0, 0, 2

gkgesto4_time		init 16
gkgesto4_off		init .005
gkgesto4_dur		init 1
;------------------

	instr gesto4

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "gesto4"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkgesto4_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gigesto41+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "gesto4"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkgesto4_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gigesto41+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "gesto4"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkgesto4_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gigesto41+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	gesto4, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gesto4"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgesto4_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgesto4_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	gesto4, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "gesto4"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgesto4_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgesto4_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSmarimba_split_sil001_file 	 init "../samples/opcode/grr/marimba_split_sil001.wav"
gimarimba_split_sil001_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil001_file, 0, 0, 1
gimarimba_split_sil001_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil001_file, 0, 0, 2
;---
gSmarimba_split_sil002_file 	 init "../samples/opcode/grr/marimba_split_sil002.wav"
gimarimba_split_sil002_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil002_file, 0, 0, 1
gimarimba_split_sil002_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil002_file, 0, 0, 2
;---
gSmarimba_split_sil003_file 	 init "../samples/opcode/grr/marimba_split_sil003.wav"
gimarimba_split_sil003_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil003_file, 0, 0, 1
gimarimba_split_sil003_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil003_file, 0, 0, 2
;---
gSmarimba_split_sil004_file 	 init "../samples/opcode/grr/marimba_split_sil004.wav"
gimarimba_split_sil004_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil004_file, 0, 0, 1
gimarimba_split_sil004_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil004_file, 0, 0, 2
;---
gSmarimba_split_sil005_file 	 init "../samples/opcode/grr/marimba_split_sil005.wav"
gimarimba_split_sil005_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil005_file, 0, 0, 1
gimarimba_split_sil005_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil005_file, 0, 0, 2
;---
gSmarimba_split_sil006_file 	 init "../samples/opcode/grr/marimba_split_sil006.wav"
gimarimba_split_sil006_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil006_file, 0, 0, 1
gimarimba_split_sil006_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil006_file, 0, 0, 2
;---
gSmarimba_split_sil007_file 	 init "../samples/opcode/grr/marimba_split_sil007.wav"
gimarimba_split_sil007_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil007_file, 0, 0, 1
gimarimba_split_sil007_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil007_file, 0, 0, 2
;---
gSmarimba_split_sil008_file 	 init "../samples/opcode/grr/marimba_split_sil008.wav"
gimarimba_split_sil008_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil008_file, 0, 0, 1
gimarimba_split_sil008_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil008_file, 0, 0, 2
;---
gSmarimba_split_sil009_file 	 init "../samples/opcode/grr/marimba_split_sil009.wav"
gimarimba_split_sil009_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil009_file, 0, 0, 1
gimarimba_split_sil009_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil009_file, 0, 0, 2
;---
gSmarimba_split_sil010_file 	 init "../samples/opcode/grr/marimba_split_sil010.wav"
gimarimba_split_sil010_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil010_file, 0, 0, 1
gimarimba_split_sil010_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil010_file, 0, 0, 2
;---
gSmarimba_split_sil011_file 	 init "../samples/opcode/grr/marimba_split_sil011.wav"
gimarimba_split_sil011_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil011_file, 0, 0, 1
gimarimba_split_sil011_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil011_file, 0, 0, 2
;---
gSmarimba_split_sil012_file 	 init "../samples/opcode/grr/marimba_split_sil012.wav"
gimarimba_split_sil012_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil012_file, 0, 0, 1
gimarimba_split_sil012_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil012_file, 0, 0, 2
;---
gSmarimba_split_sil013_file 	 init "../samples/opcode/grr/marimba_split_sil013.wav"
gimarimba_split_sil013_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil013_file, 0, 0, 1
gimarimba_split_sil013_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil013_file, 0, 0, 2
;---
gSmarimba_split_sil014_file 	 init "../samples/opcode/grr/marimba_split_sil014.wav"
gimarimba_split_sil014_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil014_file, 0, 0, 1
gimarimba_split_sil014_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil014_file, 0, 0, 2
;---
gSmarimba_split_sil015_file 	 init "../samples/opcode/grr/marimba_split_sil015.wav"
gimarimba_split_sil015_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil015_file, 0, 0, 1
gimarimba_split_sil015_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil015_file, 0, 0, 2
;---
gSmarimba_split_sil016_file 	 init "../samples/opcode/grr/marimba_split_sil016.wav"
gimarimba_split_sil016_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil016_file, 0, 0, 1
gimarimba_split_sil016_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil016_file, 0, 0, 2
;---
gSmarimba_split_sil017_file 	 init "../samples/opcode/grr/marimba_split_sil017.wav"
gimarimba_split_sil017_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil017_file, 0, 0, 1
gimarimba_split_sil017_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil017_file, 0, 0, 2
;---
gSmarimba_split_sil018_file 	 init "../samples/opcode/grr/marimba_split_sil018.wav"
gimarimba_split_sil018_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil018_file, 0, 0, 1
gimarimba_split_sil018_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil018_file, 0, 0, 2
;---
gSmarimba_split_sil019_file 	 init "../samples/opcode/grr/marimba_split_sil019.wav"
gimarimba_split_sil019_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil019_file, 0, 0, 1
gimarimba_split_sil019_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil019_file, 0, 0, 2
;---
gSmarimba_split_sil020_file 	 init "../samples/opcode/grr/marimba_split_sil020.wav"
gimarimba_split_sil020_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil020_file, 0, 0, 1
gimarimba_split_sil020_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil020_file, 0, 0, 2
;---
gSmarimba_split_sil021_file 	 init "../samples/opcode/grr/marimba_split_sil021.wav"
gimarimba_split_sil021_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil021_file, 0, 0, 1
gimarimba_split_sil021_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil021_file, 0, 0, 2
;---
gSmarimba_split_sil022_file 	 init "../samples/opcode/grr/marimba_split_sil022.wav"
gimarimba_split_sil022_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil022_file, 0, 0, 1
gimarimba_split_sil022_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil022_file, 0, 0, 2
;---
gSmarimba_split_sil023_file 	 init "../samples/opcode/grr/marimba_split_sil023.wav"
gimarimba_split_sil023_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil023_file, 0, 0, 1
gimarimba_split_sil023_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil023_file, 0, 0, 2
;---
gSmarimba_split_sil024_file 	 init "../samples/opcode/grr/marimba_split_sil024.wav"
gimarimba_split_sil024_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil024_file, 0, 0, 1
gimarimba_split_sil024_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil024_file, 0, 0, 2
;---
gSmarimba_split_sil025_file 	 init "../samples/opcode/grr/marimba_split_sil025.wav"
gimarimba_split_sil025_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil025_file, 0, 0, 1
gimarimba_split_sil025_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil025_file, 0, 0, 2
;---
gSmarimba_split_sil026_file 	 init "../samples/opcode/grr/marimba_split_sil026.wav"
gimarimba_split_sil026_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil026_file, 0, 0, 1
gimarimba_split_sil026_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil026_file, 0, 0, 2
;---
gSmarimba_split_sil027_file 	 init "../samples/opcode/grr/marimba_split_sil027.wav"
gimarimba_split_sil027_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil027_file, 0, 0, 1
gimarimba_split_sil027_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil027_file, 0, 0, 2
;---
gSmarimba_split_sil028_file 	 init "../samples/opcode/grr/marimba_split_sil028.wav"
gimarimba_split_sil028_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil028_file, 0, 0, 1
gimarimba_split_sil028_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil028_file, 0, 0, 2
;---
gSmarimba_split_sil029_file 	 init "../samples/opcode/grr/marimba_split_sil029.wav"
gimarimba_split_sil029_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil029_file, 0, 0, 1
gimarimba_split_sil029_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil029_file, 0, 0, 2
;---
gSmarimba_split_sil030_file 	 init "../samples/opcode/grr/marimba_split_sil030.wav"
gimarimba_split_sil030_1		 ftgen 0, 0, 0, 1, gSmarimba_split_sil030_file, 0, 0, 1
gimarimba_split_sil030_2		 ftgen 0, 0, 0, 1, gSmarimba_split_sil030_file, 0, 0, 2
;---
gigrr_sonvs[]			fillarray	gimarimba_split_sil001_1, gimarimba_split_sil001_2, gimarimba_split_sil002_1, gimarimba_split_sil002_2, gimarimba_split_sil003_1, gimarimba_split_sil003_2, gimarimba_split_sil004_1, gimarimba_split_sil004_2, gimarimba_split_sil005_1, gimarimba_split_sil005_2, gimarimba_split_sil006_1, gimarimba_split_sil006_2, gimarimba_split_sil007_1, gimarimba_split_sil007_2, gimarimba_split_sil008_1, gimarimba_split_sil008_2, gimarimba_split_sil009_1, gimarimba_split_sil009_2, gimarimba_split_sil010_1, gimarimba_split_sil010_2, gimarimba_split_sil011_1, gimarimba_split_sil011_2, gimarimba_split_sil012_1, gimarimba_split_sil012_2, gimarimba_split_sil013_1, gimarimba_split_sil013_2, gimarimba_split_sil014_1, gimarimba_split_sil014_2, gimarimba_split_sil015_1, gimarimba_split_sil015_2, gimarimba_split_sil016_1, gimarimba_split_sil016_2, gimarimba_split_sil017_1, gimarimba_split_sil017_2, gimarimba_split_sil018_1, gimarimba_split_sil018_2, gimarimba_split_sil019_1, gimarimba_split_sil019_2, gimarimba_split_sil020_1, gimarimba_split_sil020_2, gimarimba_split_sil021_1, gimarimba_split_sil021_2, gimarimba_split_sil022_1, gimarimba_split_sil022_2, gimarimba_split_sil023_1, gimarimba_split_sil023_2, gimarimba_split_sil024_1, gimarimba_split_sil024_2, gimarimba_split_sil025_1, gimarimba_split_sil025_2, gimarimba_split_sil026_1, gimarimba_split_sil026_2, gimarimba_split_sil027_1, gimarimba_split_sil027_2, gimarimba_split_sil028_1, gimarimba_split_sil028_2, gimarimba_split_sil029_1, gimarimba_split_sil029_2, gimarimba_split_sil030_1, gimarimba_split_sil030_2
gkgrr_time		init 16
gkgrr_off		init .005
gkgrr_dur		init 1
gkgrr_sonvs		init 1
gigrr_len		init lenarray(gigrr_sonvs)/2

;------------------

	instr grr

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "grr"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkgrr_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkgrr_sonvs%(gigrr_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gigrr_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "grr"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkgrr_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gigrr_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gigrr_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "grr"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkgrr_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkgrr_sonvs%(gigrr_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gigrr_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	grr, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "grr"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgrr_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgrr_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	grr, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "grr"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkgrr_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkgrr_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gShh_file	init "../samples/opcode/hh.wav"

gihh1	ftgen 0, 0, 0, 1, gShh_file, 0, 0, 1
gihh2	ftgen 0, 0, 0, 1, gShh_file, 0, 0, 2

gkhh_time		init 16
gkhh_off		init .005
gkhh_dur		init 1
;------------------

	instr hh

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "hh"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkhh_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gihh1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "hh"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkhh_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gihh1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "hh"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkhh_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gihh1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	hh, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "hh"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkhh_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkhh_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	hh, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "hh"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkhh_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkhh_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSive_heard_a_piano_00a_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_00a.wav"
giive_heard_a_piano_00a_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_00a_file, 0, 0, 1
giive_heard_a_piano_00a_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_00a_file, 0, 0, 2
;---
gSive_heard_a_piano_00b_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_00b.wav"
giive_heard_a_piano_00b_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_00b_file, 0, 0, 1
giive_heard_a_piano_00b_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_00b_file, 0, 0, 2
;---
gSive_heard_a_piano_01_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_01.wav"
giive_heard_a_piano_01_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_01_file, 0, 0, 1
giive_heard_a_piano_01_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_01_file, 0, 0, 2
;---
gSive_heard_a_piano_02_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_02.wav"
giive_heard_a_piano_02_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_02_file, 0, 0, 1
giive_heard_a_piano_02_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_02_file, 0, 0, 2
;---
gSive_heard_a_piano_03_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_03.wav"
giive_heard_a_piano_03_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_03_file, 0, 0, 1
giive_heard_a_piano_03_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_03_file, 0, 0, 2
;---
gSive_heard_a_piano_04_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_04.wav"
giive_heard_a_piano_04_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_04_file, 0, 0, 1
giive_heard_a_piano_04_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_04_file, 0, 0, 2
;---
gSive_heard_a_piano_05_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_05.wav"
giive_heard_a_piano_05_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_05_file, 0, 0, 1
giive_heard_a_piano_05_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_05_file, 0, 0, 2
;---
gSive_heard_a_piano_06_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_06.wav"
giive_heard_a_piano_06_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_06_file, 0, 0, 1
giive_heard_a_piano_06_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_06_file, 0, 0, 2
;---
gSive_heard_a_piano_07_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_07.wav"
giive_heard_a_piano_07_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_07_file, 0, 0, 1
giive_heard_a_piano_07_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_07_file, 0, 0, 2
;---
gSive_heard_a_piano_08_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_08.wav"
giive_heard_a_piano_08_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_08_file, 0, 0, 1
giive_heard_a_piano_08_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_08_file, 0, 0, 2
;---
gSive_heard_a_piano_09_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_09.wav"
giive_heard_a_piano_09_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_09_file, 0, 0, 1
giive_heard_a_piano_09_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_09_file, 0, 0, 2
;---
gSive_heard_a_piano_10_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_10.wav"
giive_heard_a_piano_10_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_10_file, 0, 0, 1
giive_heard_a_piano_10_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_10_file, 0, 0, 2
;---
gSive_heard_a_piano_11_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_11.wav"
giive_heard_a_piano_11_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_11_file, 0, 0, 1
giive_heard_a_piano_11_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_11_file, 0, 0, 2
;---
gSive_heard_a_piano_12_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_12.wav"
giive_heard_a_piano_12_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_12_file, 0, 0, 1
giive_heard_a_piano_12_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_12_file, 0, 0, 2
;---
gSive_heard_a_piano_13_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_13.wav"
giive_heard_a_piano_13_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_13_file, 0, 0, 1
giive_heard_a_piano_13_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_13_file, 0, 0, 2
;---
gSive_heard_a_piano_14_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_14.wav"
giive_heard_a_piano_14_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_14_file, 0, 0, 1
giive_heard_a_piano_14_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_14_file, 0, 0, 2
;---
gSive_heard_a_piano_15_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_15.wav"
giive_heard_a_piano_15_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_15_file, 0, 0, 1
giive_heard_a_piano_15_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_15_file, 0, 0, 2
;---
gSive_heard_a_piano_16_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_16.wav"
giive_heard_a_piano_16_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_16_file, 0, 0, 1
giive_heard_a_piano_16_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_16_file, 0, 0, 2
;---
gSive_heard_a_piano_17_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_17.wav"
giive_heard_a_piano_17_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_17_file, 0, 0, 1
giive_heard_a_piano_17_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_17_file, 0, 0, 2
;---
gSive_heard_a_piano_18_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_18.wav"
giive_heard_a_piano_18_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_18_file, 0, 0, 1
giive_heard_a_piano_18_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_18_file, 0, 0, 2
;---
gSive_heard_a_piano_19_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_19.wav"
giive_heard_a_piano_19_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_19_file, 0, 0, 1
giive_heard_a_piano_19_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_19_file, 0, 0, 2
;---
gSive_heard_a_piano_20_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_20.wav"
giive_heard_a_piano_20_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_20_file, 0, 0, 1
giive_heard_a_piano_20_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_20_file, 0, 0, 2
;---
gSive_heard_a_piano_21_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_21.wav"
giive_heard_a_piano_21_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_21_file, 0, 0, 1
giive_heard_a_piano_21_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_21_file, 0, 0, 2
;---
gSive_heard_a_piano_22_file 	 init "../samples/opcode/iveheard/ive-heard-a-piano_22.wav"
giive_heard_a_piano_22_1		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_22_file, 0, 0, 1
giive_heard_a_piano_22_2		 ftgen 0, 0, 0, 1, gSive_heard_a_piano_22_file, 0, 0, 2
;---
giiveheard_sonvs[]			fillarray	giive_heard_a_piano_00a_1, giive_heard_a_piano_00a_2, giive_heard_a_piano_00b_1, giive_heard_a_piano_00b_2, giive_heard_a_piano_01_1, giive_heard_a_piano_01_2, giive_heard_a_piano_02_1, giive_heard_a_piano_02_2, giive_heard_a_piano_03_1, giive_heard_a_piano_03_2, giive_heard_a_piano_04_1, giive_heard_a_piano_04_2, giive_heard_a_piano_05_1, giive_heard_a_piano_05_2, giive_heard_a_piano_06_1, giive_heard_a_piano_06_2, giive_heard_a_piano_07_1, giive_heard_a_piano_07_2, giive_heard_a_piano_08_1, giive_heard_a_piano_08_2, giive_heard_a_piano_09_1, giive_heard_a_piano_09_2, giive_heard_a_piano_10_1, giive_heard_a_piano_10_2, giive_heard_a_piano_11_1, giive_heard_a_piano_11_2, giive_heard_a_piano_12_1, giive_heard_a_piano_12_2, giive_heard_a_piano_13_1, giive_heard_a_piano_13_2, giive_heard_a_piano_14_1, giive_heard_a_piano_14_2, giive_heard_a_piano_15_1, giive_heard_a_piano_15_2, giive_heard_a_piano_16_1, giive_heard_a_piano_16_2, giive_heard_a_piano_17_1, giive_heard_a_piano_17_2, giive_heard_a_piano_18_1, giive_heard_a_piano_18_2, giive_heard_a_piano_19_1, giive_heard_a_piano_19_2, giive_heard_a_piano_20_1, giive_heard_a_piano_20_2, giive_heard_a_piano_21_1, giive_heard_a_piano_21_2, giive_heard_a_piano_22_1, giive_heard_a_piano_22_2
gkiveheard_time		init 16
gkiveheard_off		init .005
gkiveheard_dur		init 1
gkiveheard_sonvs		init 1
giiveheard_len		init lenarray(giiveheard_sonvs)/2

;------------------

	instr iveheard

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "iveheard"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkiveheard_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkiveheard_sonvs%(giiveheard_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init giiveheard_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "iveheard"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkiveheard_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(giiveheard_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init giiveheard_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "iveheard"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkiveheard_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkiveheard_sonvs%(giiveheard_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init giiveheard_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	iveheard, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "iveheard"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkiveheard_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkiveheard_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	iveheard, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "iveheard"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkiveheard_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkiveheard_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSjunis_file	init "../samples/opcode/junis.wav"

gijunis1	ftgen 0, 0, 0, 1, gSjunis_file, 0, 0, 1
gijunis2	ftgen 0, 0, 0, 1, gSjunis_file, 0, 0, 2

gkjunis_time		init 16
gkjunis_off		init .005
gkjunis_dur		init 1
;------------------

	instr junis

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "junis"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkjunis_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gijunis1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "junis"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkjunis_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gijunis1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "junis"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkjunis_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gijunis1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	junis, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "junis"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkjunis_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkjunis_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	junis, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "junis"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkjunis_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkjunis_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSnote_1_file 	 init "../samples/opcode/kali/note_1.wav"
ginote_1_1		 ftgen 0, 0, 0, 1, gSnote_1_file, 0, 0, 1
ginote_1_2		 ftgen 0, 0, 0, 1, gSnote_1_file, 0, 0, 2
;---
gSnote_10_file 	 init "../samples/opcode/kali/note_10.wav"
ginote_10_1		 ftgen 0, 0, 0, 1, gSnote_10_file, 0, 0, 1
ginote_10_2		 ftgen 0, 0, 0, 1, gSnote_10_file, 0, 0, 2
;---
gSnote_11_file 	 init "../samples/opcode/kali/note_11.wav"
ginote_11_1		 ftgen 0, 0, 0, 1, gSnote_11_file, 0, 0, 1
ginote_11_2		 ftgen 0, 0, 0, 1, gSnote_11_file, 0, 0, 2
;---
gSnote_2_file 	 init "../samples/opcode/kali/note_2.wav"
ginote_2_1		 ftgen 0, 0, 0, 1, gSnote_2_file, 0, 0, 1
ginote_2_2		 ftgen 0, 0, 0, 1, gSnote_2_file, 0, 0, 2
;---
gSnote_3_file 	 init "../samples/opcode/kali/note_3.wav"
ginote_3_1		 ftgen 0, 0, 0, 1, gSnote_3_file, 0, 0, 1
ginote_3_2		 ftgen 0, 0, 0, 1, gSnote_3_file, 0, 0, 2
;---
gSnote_4_file 	 init "../samples/opcode/kali/note_4.wav"
ginote_4_1		 ftgen 0, 0, 0, 1, gSnote_4_file, 0, 0, 1
ginote_4_2		 ftgen 0, 0, 0, 1, gSnote_4_file, 0, 0, 2
;---
gSnote_5_file 	 init "../samples/opcode/kali/note_5.wav"
ginote_5_1		 ftgen 0, 0, 0, 1, gSnote_5_file, 0, 0, 1
ginote_5_2		 ftgen 0, 0, 0, 1, gSnote_5_file, 0, 0, 2
;---
gSnote_6_file 	 init "../samples/opcode/kali/note_6.wav"
ginote_6_1		 ftgen 0, 0, 0, 1, gSnote_6_file, 0, 0, 1
ginote_6_2		 ftgen 0, 0, 0, 1, gSnote_6_file, 0, 0, 2
;---
gSnote_7_file 	 init "../samples/opcode/kali/note_7.wav"
ginote_7_1		 ftgen 0, 0, 0, 1, gSnote_7_file, 0, 0, 1
ginote_7_2		 ftgen 0, 0, 0, 1, gSnote_7_file, 0, 0, 2
;---
gSnote_8_file 	 init "../samples/opcode/kali/note_8.wav"
ginote_8_1		 ftgen 0, 0, 0, 1, gSnote_8_file, 0, 0, 1
ginote_8_2		 ftgen 0, 0, 0, 1, gSnote_8_file, 0, 0, 2
;---
gSnote_9_file 	 init "../samples/opcode/kali/note_9.wav"
ginote_9_1		 ftgen 0, 0, 0, 1, gSnote_9_file, 0, 0, 1
ginote_9_2		 ftgen 0, 0, 0, 1, gSnote_9_file, 0, 0, 2
;---
gikali_sonvs[]			fillarray	ginote_1_1, ginote_1_2, ginote_10_1, ginote_10_2, ginote_11_1, ginote_11_2, ginote_2_1, ginote_2_2, ginote_3_1, ginote_3_2, ginote_4_1, ginote_4_2, ginote_5_1, ginote_5_2, ginote_6_1, ginote_6_2, ginote_7_1, ginote_7_2, ginote_8_1, ginote_8_2, ginote_9_1, ginote_9_2
gkkali_time		init 16
gkkali_off		init .005
gkkali_dur		init 1
gkkali_sonvs		init 1
gikali_len		init lenarray(gikali_sonvs)/2

;------------------

	instr kali

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "kali"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkkali_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkkali_sonvs%(gikali_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gikali_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "kali"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkkali_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gikali_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gikali_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "kali"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkkali_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkkali_sonvs%(gikali_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gikali_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	kali, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "kali"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkkali_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkkali_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	kali, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "kali"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkkali_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkkali_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSmadcow_file	init "../samples/opcode/madcow.wav"

gimadcow1	ftgen 0, 0, 0, 1, gSmadcow_file, 0, 0, 1
gimadcow2	ftgen 0, 0, 0, 1, gSmadcow_file, 0, 0, 2

gkmadcow_time		init 16
gkmadcow_off		init .005
gkmadcow_dur		init 1
;------------------

	instr madcow

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "madcow"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkmadcow_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gimadcow1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "madcow"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkmadcow_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gimadcow1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "madcow"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkmadcow_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gimadcow1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	madcow, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "madcow"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmadcow_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmadcow_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	madcow, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "madcow"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmadcow_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmadcow_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSmalon_00_file 	 init "../samples/opcode/malon/malon_00.wav"
gimalon_00_1		 ftgen 0, 0, 0, 1, gSmalon_00_file, 0, 0, 1
gimalon_00_2		 ftgen 0, 0, 0, 1, gSmalon_00_file, 0, 0, 2
;---
gSmalon_01_file 	 init "../samples/opcode/malon/malon_01.wav"
gimalon_01_1		 ftgen 0, 0, 0, 1, gSmalon_01_file, 0, 0, 1
gimalon_01_2		 ftgen 0, 0, 0, 1, gSmalon_01_file, 0, 0, 2
;---
gSmalon_02_file 	 init "../samples/opcode/malon/malon_02.wav"
gimalon_02_1		 ftgen 0, 0, 0, 1, gSmalon_02_file, 0, 0, 1
gimalon_02_2		 ftgen 0, 0, 0, 1, gSmalon_02_file, 0, 0, 2
;---
gSmalon_03_file 	 init "../samples/opcode/malon/malon_03.wav"
gimalon_03_1		 ftgen 0, 0, 0, 1, gSmalon_03_file, 0, 0, 1
gimalon_03_2		 ftgen 0, 0, 0, 1, gSmalon_03_file, 0, 0, 2
;---
gSmalon_04_file 	 init "../samples/opcode/malon/malon_04.wav"
gimalon_04_1		 ftgen 0, 0, 0, 1, gSmalon_04_file, 0, 0, 1
gimalon_04_2		 ftgen 0, 0, 0, 1, gSmalon_04_file, 0, 0, 2
;---
gSmalon_05_file 	 init "../samples/opcode/malon/malon_05.wav"
gimalon_05_1		 ftgen 0, 0, 0, 1, gSmalon_05_file, 0, 0, 1
gimalon_05_2		 ftgen 0, 0, 0, 1, gSmalon_05_file, 0, 0, 2
;---
gSmalon_06_file 	 init "../samples/opcode/malon/malon_06.wav"
gimalon_06_1		 ftgen 0, 0, 0, 1, gSmalon_06_file, 0, 0, 1
gimalon_06_2		 ftgen 0, 0, 0, 1, gSmalon_06_file, 0, 0, 2
;---
gSmalon_07_file 	 init "../samples/opcode/malon/malon_07.wav"
gimalon_07_1		 ftgen 0, 0, 0, 1, gSmalon_07_file, 0, 0, 1
gimalon_07_2		 ftgen 0, 0, 0, 1, gSmalon_07_file, 0, 0, 2
;---
gSmalon_08_file 	 init "../samples/opcode/malon/malon_08.wav"
gimalon_08_1		 ftgen 0, 0, 0, 1, gSmalon_08_file, 0, 0, 1
gimalon_08_2		 ftgen 0, 0, 0, 1, gSmalon_08_file, 0, 0, 2
;---
gSmalon_09_file 	 init "../samples/opcode/malon/malon_09.wav"
gimalon_09_1		 ftgen 0, 0, 0, 1, gSmalon_09_file, 0, 0, 1
gimalon_09_2		 ftgen 0, 0, 0, 1, gSmalon_09_file, 0, 0, 2
;---
gimalon_sonvs[]			fillarray	gimalon_00_1, gimalon_00_2, gimalon_01_1, gimalon_01_2, gimalon_02_1, gimalon_02_2, gimalon_03_1, gimalon_03_2, gimalon_04_1, gimalon_04_2, gimalon_05_1, gimalon_05_2, gimalon_06_1, gimalon_06_2, gimalon_07_1, gimalon_07_2, gimalon_08_1, gimalon_08_2, gimalon_09_1, gimalon_09_2
gkmalon_time		init 16
gkmalon_off		init .005
gkmalon_dur		init 1
gkmalon_sonvs		init 1
gimalon_len		init lenarray(gimalon_sonvs)/2

;------------------

	instr malon

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "malon"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkmalon_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkmalon_sonvs%(gimalon_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gimalon_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "malon"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkmalon_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gimalon_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gimalon_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "malon"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkmalon_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkmalon_sonvs%(gimalon_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gimalon_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	malon, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "malon"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmalon_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmalon_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	malon, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "malon"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmalon_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmalon_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSmario1_file	init "../samples/opcode/mario1.wav"

gimario11	ftgen 0, 0, 0, 1, gSmario1_file, 0, 0, 1
gimario12	ftgen 0, 0, 0, 1, gSmario1_file, 0, 0, 2

gkmario1_time		init 16
gkmario1_off		init .005
gkmario1_dur		init 1
;------------------

	instr mario1

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "mario1"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkmario1_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gimario11+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "mario1"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkmario1_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gimario11+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "mario1"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkmario1_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gimario11+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	mario1, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "mario1"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmario1_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmario1_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	mario1, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "mario1"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmario1_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmario1_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSmario2_file	init "../samples/opcode/mario2.wav"

gimario21	ftgen 0, 0, 0, 1, gSmario2_file, 0, 0, 1
gimario22	ftgen 0, 0, 0, 1, gSmario2_file, 0, 0, 2

gkmario2_time		init 16
gkmario2_off		init .005
gkmario2_dur		init 1
;------------------

	instr mario2

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "mario2"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkmario2_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gimario21+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "mario2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkmario2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gimario21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "mario2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkmario2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gimario21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	mario2, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "mario2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmario2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmario2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	mario2, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "mario2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmario2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmario2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSmeer_file	init "../samples/opcode/meer.wav"

gimeer1	ftgen 0, 0, 0, 1, gSmeer_file, 0, 0, 1
gimeer2	ftgen 0, 0, 0, 1, gSmeer_file, 0, 0, 2

gkmeer_time		init 16
gkmeer_off		init .005
gkmeer_dur		init 1
;------------------

	instr meer

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "meer"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkmeer_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gimeer1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "meer"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkmeer_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gimeer1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "meer"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkmeer_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gimeer1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	meer, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "meer"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmeer_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmeer_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	meer, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "meer"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmeer_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmeer_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSmeli_001_file 	 init "../samples/opcode/meli/meli-001.wav"
gimeli_001_1		 ftgen 0, 0, 0, 1, gSmeli_001_file, 0, 0, 1
gimeli_001_2		 ftgen 0, 0, 0, 1, gSmeli_001_file, 0, 0, 2
;---
gSmeli_002_file 	 init "../samples/opcode/meli/meli-002.wav"
gimeli_002_1		 ftgen 0, 0, 0, 1, gSmeli_002_file, 0, 0, 1
gimeli_002_2		 ftgen 0, 0, 0, 1, gSmeli_002_file, 0, 0, 2
;---
gSmeli_003_file 	 init "../samples/opcode/meli/meli-003.wav"
gimeli_003_1		 ftgen 0, 0, 0, 1, gSmeli_003_file, 0, 0, 1
gimeli_003_2		 ftgen 0, 0, 0, 1, gSmeli_003_file, 0, 0, 2
;---
gSmeli_004_file 	 init "../samples/opcode/meli/meli-004.wav"
gimeli_004_1		 ftgen 0, 0, 0, 1, gSmeli_004_file, 0, 0, 1
gimeli_004_2		 ftgen 0, 0, 0, 1, gSmeli_004_file, 0, 0, 2
;---
gSmeli_005_file 	 init "../samples/opcode/meli/meli-005.wav"
gimeli_005_1		 ftgen 0, 0, 0, 1, gSmeli_005_file, 0, 0, 1
gimeli_005_2		 ftgen 0, 0, 0, 1, gSmeli_005_file, 0, 0, 2
;---
gSmeli_006_file 	 init "../samples/opcode/meli/meli-006.wav"
gimeli_006_1		 ftgen 0, 0, 0, 1, gSmeli_006_file, 0, 0, 1
gimeli_006_2		 ftgen 0, 0, 0, 1, gSmeli_006_file, 0, 0, 2
;---
gSmeli_007_file 	 init "../samples/opcode/meli/meli-007.wav"
gimeli_007_1		 ftgen 0, 0, 0, 1, gSmeli_007_file, 0, 0, 1
gimeli_007_2		 ftgen 0, 0, 0, 1, gSmeli_007_file, 0, 0, 2
;---
gSmeli_008_file 	 init "../samples/opcode/meli/meli-008.wav"
gimeli_008_1		 ftgen 0, 0, 0, 1, gSmeli_008_file, 0, 0, 1
gimeli_008_2		 ftgen 0, 0, 0, 1, gSmeli_008_file, 0, 0, 2
;---
gSmeli_009_file 	 init "../samples/opcode/meli/meli-009.wav"
gimeli_009_1		 ftgen 0, 0, 0, 1, gSmeli_009_file, 0, 0, 1
gimeli_009_2		 ftgen 0, 0, 0, 1, gSmeli_009_file, 0, 0, 2
;---
gSmeli_010_file 	 init "../samples/opcode/meli/meli-010.wav"
gimeli_010_1		 ftgen 0, 0, 0, 1, gSmeli_010_file, 0, 0, 1
gimeli_010_2		 ftgen 0, 0, 0, 1, gSmeli_010_file, 0, 0, 2
;---
gSmeli_011_file 	 init "../samples/opcode/meli/meli-011.wav"
gimeli_011_1		 ftgen 0, 0, 0, 1, gSmeli_011_file, 0, 0, 1
gimeli_011_2		 ftgen 0, 0, 0, 1, gSmeli_011_file, 0, 0, 2
;---
gSmeli_012_file 	 init "../samples/opcode/meli/meli-012.wav"
gimeli_012_1		 ftgen 0, 0, 0, 1, gSmeli_012_file, 0, 0, 1
gimeli_012_2		 ftgen 0, 0, 0, 1, gSmeli_012_file, 0, 0, 2
;---
gSmeli_013_file 	 init "../samples/opcode/meli/meli-013.wav"
gimeli_013_1		 ftgen 0, 0, 0, 1, gSmeli_013_file, 0, 0, 1
gimeli_013_2		 ftgen 0, 0, 0, 1, gSmeli_013_file, 0, 0, 2
;---
gSmeli_014_file 	 init "../samples/opcode/meli/meli-014.wav"
gimeli_014_1		 ftgen 0, 0, 0, 1, gSmeli_014_file, 0, 0, 1
gimeli_014_2		 ftgen 0, 0, 0, 1, gSmeli_014_file, 0, 0, 2
;---
gSmeli_015_file 	 init "../samples/opcode/meli/meli-015.wav"
gimeli_015_1		 ftgen 0, 0, 0, 1, gSmeli_015_file, 0, 0, 1
gimeli_015_2		 ftgen 0, 0, 0, 1, gSmeli_015_file, 0, 0, 2
;---
gSmeli_016_file 	 init "../samples/opcode/meli/meli-016.wav"
gimeli_016_1		 ftgen 0, 0, 0, 1, gSmeli_016_file, 0, 0, 1
gimeli_016_2		 ftgen 0, 0, 0, 1, gSmeli_016_file, 0, 0, 2
;---
gSmeli_017_file 	 init "../samples/opcode/meli/meli-017.wav"
gimeli_017_1		 ftgen 0, 0, 0, 1, gSmeli_017_file, 0, 0, 1
gimeli_017_2		 ftgen 0, 0, 0, 1, gSmeli_017_file, 0, 0, 2
;---
gimeli_sonvs[]			fillarray	gimeli_001_1, gimeli_001_2, gimeli_002_1, gimeli_002_2, gimeli_003_1, gimeli_003_2, gimeli_004_1, gimeli_004_2, gimeli_005_1, gimeli_005_2, gimeli_006_1, gimeli_006_2, gimeli_007_1, gimeli_007_2, gimeli_008_1, gimeli_008_2, gimeli_009_1, gimeli_009_2, gimeli_010_1, gimeli_010_2, gimeli_011_1, gimeli_011_2, gimeli_012_1, gimeli_012_2, gimeli_013_1, gimeli_013_2, gimeli_014_1, gimeli_014_2, gimeli_015_1, gimeli_015_2, gimeli_016_1, gimeli_016_2, gimeli_017_1, gimeli_017_2
gkmeli_time		init 16
gkmeli_off		init .005
gkmeli_dur		init 1
gkmeli_sonvs		init 1
gimeli_len		init lenarray(gimeli_sonvs)/2

;------------------

	instr meli

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "meli"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkmeli_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkmeli_sonvs%(gimeli_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gimeli_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "meli"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkmeli_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gimeli_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gimeli_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "meli"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkmeli_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkmeli_sonvs%(gimeli_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gimeli_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	meli, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "meli"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmeli_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmeli_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	meli, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "meli"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmeli_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmeli_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSmirrors_file	init "../samples/opcode/mirrors.wav"

gimirrors1	ftgen 0, 0, 0, 1, gSmirrors_file, 0, 0, 1
gimirrors2	ftgen 0, 0, 0, 1, gSmirrors_file, 0, 0, 2

gkmirrors_time		init 16
gkmirrors_off		init .005
gkmirrors_dur		init 1
;------------------

	instr mirrors

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "mirrors"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkmirrors_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gimirrors1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "mirrors"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkmirrors_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gimirrors1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "mirrors"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkmirrors_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gimirrors1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	mirrors, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "mirrors"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmirrors_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmirrors_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	mirrors, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "mirrors"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkmirrors_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkmirrors_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSninfa_file	init "../samples/opcode/ninfa.wav"

gininfa1	ftgen 0, 0, 0, 1, gSninfa_file, 0, 0, 1
gininfa2	ftgen 0, 0, 0, 1, gSninfa_file, 0, 0, 2

gkninfa_time		init 16
gkninfa_off		init .005
gkninfa_dur		init 1
;------------------

	instr ninfa

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "ninfa"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkninfa_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gininfa1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "ninfa"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkninfa_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gininfa1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "ninfa"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkninfa_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gininfa1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	ninfa, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "ninfa"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkninfa_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkninfa_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	ninfa, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "ninfa"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkninfa_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkninfa_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSnoinput_01_file 	 init "../samples/opcode/noinput/noinput-01.wav"
ginoinput_01_1		 ftgen 0, 0, 0, 1, gSnoinput_01_file, 0, 0, 1
ginoinput_01_2		 ftgen 0, 0, 0, 1, gSnoinput_01_file, 0, 0, 2
;---
gSnoinput_02_file 	 init "../samples/opcode/noinput/noinput-02.wav"
ginoinput_02_1		 ftgen 0, 0, 0, 1, gSnoinput_02_file, 0, 0, 1
ginoinput_02_2		 ftgen 0, 0, 0, 1, gSnoinput_02_file, 0, 0, 2
;---
gSnoinput_03_file 	 init "../samples/opcode/noinput/noinput-03.wav"
ginoinput_03_1		 ftgen 0, 0, 0, 1, gSnoinput_03_file, 0, 0, 1
ginoinput_03_2		 ftgen 0, 0, 0, 1, gSnoinput_03_file, 0, 0, 2
;---
gSnoinput_04_file 	 init "../samples/opcode/noinput/noinput-04.wav"
ginoinput_04_1		 ftgen 0, 0, 0, 1, gSnoinput_04_file, 0, 0, 1
ginoinput_04_2		 ftgen 0, 0, 0, 1, gSnoinput_04_file, 0, 0, 2
;---
gSnoinput_05_file 	 init "../samples/opcode/noinput/noinput-05.wav"
ginoinput_05_1		 ftgen 0, 0, 0, 1, gSnoinput_05_file, 0, 0, 1
ginoinput_05_2		 ftgen 0, 0, 0, 1, gSnoinput_05_file, 0, 0, 2
;---
gSnoinput_06_file 	 init "../samples/opcode/noinput/noinput-06.wav"
ginoinput_06_1		 ftgen 0, 0, 0, 1, gSnoinput_06_file, 0, 0, 1
ginoinput_06_2		 ftgen 0, 0, 0, 1, gSnoinput_06_file, 0, 0, 2
;---
gSnoinput_07_file 	 init "../samples/opcode/noinput/noinput-07.wav"
ginoinput_07_1		 ftgen 0, 0, 0, 1, gSnoinput_07_file, 0, 0, 1
ginoinput_07_2		 ftgen 0, 0, 0, 1, gSnoinput_07_file, 0, 0, 2
;---
gSnoinput_08_file 	 init "../samples/opcode/noinput/noinput-08.wav"
ginoinput_08_1		 ftgen 0, 0, 0, 1, gSnoinput_08_file, 0, 0, 1
ginoinput_08_2		 ftgen 0, 0, 0, 1, gSnoinput_08_file, 0, 0, 2
;---
gSnoinput_09_file 	 init "../samples/opcode/noinput/noinput-09.wav"
ginoinput_09_1		 ftgen 0, 0, 0, 1, gSnoinput_09_file, 0, 0, 1
ginoinput_09_2		 ftgen 0, 0, 0, 1, gSnoinput_09_file, 0, 0, 2
;---
gSnoinput_10_file 	 init "../samples/opcode/noinput/noinput-10.wav"
ginoinput_10_1		 ftgen 0, 0, 0, 1, gSnoinput_10_file, 0, 0, 1
ginoinput_10_2		 ftgen 0, 0, 0, 1, gSnoinput_10_file, 0, 0, 2
;---
gSnoinput_11_file 	 init "../samples/opcode/noinput/noinput-11.wav"
ginoinput_11_1		 ftgen 0, 0, 0, 1, gSnoinput_11_file, 0, 0, 1
ginoinput_11_2		 ftgen 0, 0, 0, 1, gSnoinput_11_file, 0, 0, 2
;---
gSnoinput_12_file 	 init "../samples/opcode/noinput/noinput-12.wav"
ginoinput_12_1		 ftgen 0, 0, 0, 1, gSnoinput_12_file, 0, 0, 1
ginoinput_12_2		 ftgen 0, 0, 0, 1, gSnoinput_12_file, 0, 0, 2
;---
gSnoinput_13_file 	 init "../samples/opcode/noinput/noinput-13.wav"
ginoinput_13_1		 ftgen 0, 0, 0, 1, gSnoinput_13_file, 0, 0, 1
ginoinput_13_2		 ftgen 0, 0, 0, 1, gSnoinput_13_file, 0, 0, 2
;---
gSnoinput_14_file 	 init "../samples/opcode/noinput/noinput-14.wav"
ginoinput_14_1		 ftgen 0, 0, 0, 1, gSnoinput_14_file, 0, 0, 1
ginoinput_14_2		 ftgen 0, 0, 0, 1, gSnoinput_14_file, 0, 0, 2
;---
gSnoinput_15_file 	 init "../samples/opcode/noinput/noinput-15.wav"
ginoinput_15_1		 ftgen 0, 0, 0, 1, gSnoinput_15_file, 0, 0, 1
ginoinput_15_2		 ftgen 0, 0, 0, 1, gSnoinput_15_file, 0, 0, 2
;---
gSnoinput_16_file 	 init "../samples/opcode/noinput/noinput-16.wav"
ginoinput_16_1		 ftgen 0, 0, 0, 1, gSnoinput_16_file, 0, 0, 1
ginoinput_16_2		 ftgen 0, 0, 0, 1, gSnoinput_16_file, 0, 0, 2
;---
gSnoinput_17_file 	 init "../samples/opcode/noinput/noinput-17.wav"
ginoinput_17_1		 ftgen 0, 0, 0, 1, gSnoinput_17_file, 0, 0, 1
ginoinput_17_2		 ftgen 0, 0, 0, 1, gSnoinput_17_file, 0, 0, 2
;---
gSnoinput_18_file 	 init "../samples/opcode/noinput/noinput-18.wav"
ginoinput_18_1		 ftgen 0, 0, 0, 1, gSnoinput_18_file, 0, 0, 1
ginoinput_18_2		 ftgen 0, 0, 0, 1, gSnoinput_18_file, 0, 0, 2
;---
gSnoinput_19_file 	 init "../samples/opcode/noinput/noinput-19.wav"
ginoinput_19_1		 ftgen 0, 0, 0, 1, gSnoinput_19_file, 0, 0, 1
ginoinput_19_2		 ftgen 0, 0, 0, 1, gSnoinput_19_file, 0, 0, 2
;---
gSnoinput_20_file 	 init "../samples/opcode/noinput/noinput-20.wav"
ginoinput_20_1		 ftgen 0, 0, 0, 1, gSnoinput_20_file, 0, 0, 1
ginoinput_20_2		 ftgen 0, 0, 0, 1, gSnoinput_20_file, 0, 0, 2
;---
gSnoinput_21_file 	 init "../samples/opcode/noinput/noinput-21.wav"
ginoinput_21_1		 ftgen 0, 0, 0, 1, gSnoinput_21_file, 0, 0, 1
ginoinput_21_2		 ftgen 0, 0, 0, 1, gSnoinput_21_file, 0, 0, 2
;---
gSnoinput_22_file 	 init "../samples/opcode/noinput/noinput-22.wav"
ginoinput_22_1		 ftgen 0, 0, 0, 1, gSnoinput_22_file, 0, 0, 1
ginoinput_22_2		 ftgen 0, 0, 0, 1, gSnoinput_22_file, 0, 0, 2
;---
gSnoinput_23_file 	 init "../samples/opcode/noinput/noinput-23.wav"
ginoinput_23_1		 ftgen 0, 0, 0, 1, gSnoinput_23_file, 0, 0, 1
ginoinput_23_2		 ftgen 0, 0, 0, 1, gSnoinput_23_file, 0, 0, 2
;---
gSnoinput_24_file 	 init "../samples/opcode/noinput/noinput-24.wav"
ginoinput_24_1		 ftgen 0, 0, 0, 1, gSnoinput_24_file, 0, 0, 1
ginoinput_24_2		 ftgen 0, 0, 0, 1, gSnoinput_24_file, 0, 0, 2
;---
gSnoinput_25_file 	 init "../samples/opcode/noinput/noinput-25.wav"
ginoinput_25_1		 ftgen 0, 0, 0, 1, gSnoinput_25_file, 0, 0, 1
ginoinput_25_2		 ftgen 0, 0, 0, 1, gSnoinput_25_file, 0, 0, 2
;---
gSnoinput_26_file 	 init "../samples/opcode/noinput/noinput-26.wav"
ginoinput_26_1		 ftgen 0, 0, 0, 1, gSnoinput_26_file, 0, 0, 1
ginoinput_26_2		 ftgen 0, 0, 0, 1, gSnoinput_26_file, 0, 0, 2
;---
gSnoinput_27_file 	 init "../samples/opcode/noinput/noinput-27.wav"
ginoinput_27_1		 ftgen 0, 0, 0, 1, gSnoinput_27_file, 0, 0, 1
ginoinput_27_2		 ftgen 0, 0, 0, 1, gSnoinput_27_file, 0, 0, 2
;---
gSnoinput_28_file 	 init "../samples/opcode/noinput/noinput-28.wav"
ginoinput_28_1		 ftgen 0, 0, 0, 1, gSnoinput_28_file, 0, 0, 1
ginoinput_28_2		 ftgen 0, 0, 0, 1, gSnoinput_28_file, 0, 0, 2
;---
gSnoinput_29_file 	 init "../samples/opcode/noinput/noinput-29.wav"
ginoinput_29_1		 ftgen 0, 0, 0, 1, gSnoinput_29_file, 0, 0, 1
ginoinput_29_2		 ftgen 0, 0, 0, 1, gSnoinput_29_file, 0, 0, 2
;---
gSnoinput_30_file 	 init "../samples/opcode/noinput/noinput-30.wav"
ginoinput_30_1		 ftgen 0, 0, 0, 1, gSnoinput_30_file, 0, 0, 1
ginoinput_30_2		 ftgen 0, 0, 0, 1, gSnoinput_30_file, 0, 0, 2
;---
gSnoinput_31_file 	 init "../samples/opcode/noinput/noinput-31.wav"
ginoinput_31_1		 ftgen 0, 0, 0, 1, gSnoinput_31_file, 0, 0, 1
ginoinput_31_2		 ftgen 0, 0, 0, 1, gSnoinput_31_file, 0, 0, 2
;---
gSnoinput_32_file 	 init "../samples/opcode/noinput/noinput-32.wav"
ginoinput_32_1		 ftgen 0, 0, 0, 1, gSnoinput_32_file, 0, 0, 1
ginoinput_32_2		 ftgen 0, 0, 0, 1, gSnoinput_32_file, 0, 0, 2
;---
gSnoinput_33_file 	 init "../samples/opcode/noinput/noinput-33.wav"
ginoinput_33_1		 ftgen 0, 0, 0, 1, gSnoinput_33_file, 0, 0, 1
ginoinput_33_2		 ftgen 0, 0, 0, 1, gSnoinput_33_file, 0, 0, 2
;---
gSnoinput_34_file 	 init "../samples/opcode/noinput/noinput-34.wav"
ginoinput_34_1		 ftgen 0, 0, 0, 1, gSnoinput_34_file, 0, 0, 1
ginoinput_34_2		 ftgen 0, 0, 0, 1, gSnoinput_34_file, 0, 0, 2
;---
gSnoinput_35_file 	 init "../samples/opcode/noinput/noinput-35.wav"
ginoinput_35_1		 ftgen 0, 0, 0, 1, gSnoinput_35_file, 0, 0, 1
ginoinput_35_2		 ftgen 0, 0, 0, 1, gSnoinput_35_file, 0, 0, 2
;---
gSnoinput_36_file 	 init "../samples/opcode/noinput/noinput-36.wav"
ginoinput_36_1		 ftgen 0, 0, 0, 1, gSnoinput_36_file, 0, 0, 1
ginoinput_36_2		 ftgen 0, 0, 0, 1, gSnoinput_36_file, 0, 0, 2
;---
gSnoinput_37_file 	 init "../samples/opcode/noinput/noinput-37.wav"
ginoinput_37_1		 ftgen 0, 0, 0, 1, gSnoinput_37_file, 0, 0, 1
ginoinput_37_2		 ftgen 0, 0, 0, 1, gSnoinput_37_file, 0, 0, 2
;---
ginoinput_sonvs[]			fillarray	ginoinput_01_1, ginoinput_01_2, ginoinput_02_1, ginoinput_02_2, ginoinput_03_1, ginoinput_03_2, ginoinput_04_1, ginoinput_04_2, ginoinput_05_1, ginoinput_05_2, ginoinput_06_1, ginoinput_06_2, ginoinput_07_1, ginoinput_07_2, ginoinput_08_1, ginoinput_08_2, ginoinput_09_1, ginoinput_09_2, ginoinput_10_1, ginoinput_10_2, ginoinput_11_1, ginoinput_11_2, ginoinput_12_1, ginoinput_12_2, ginoinput_13_1, ginoinput_13_2, ginoinput_14_1, ginoinput_14_2, ginoinput_15_1, ginoinput_15_2, ginoinput_16_1, ginoinput_16_2, ginoinput_17_1, ginoinput_17_2, ginoinput_18_1, ginoinput_18_2, ginoinput_19_1, ginoinput_19_2, ginoinput_20_1, ginoinput_20_2, ginoinput_21_1, ginoinput_21_2, ginoinput_22_1, ginoinput_22_2, ginoinput_23_1, ginoinput_23_2, ginoinput_24_1, ginoinput_24_2, ginoinput_25_1, ginoinput_25_2, ginoinput_26_1, ginoinput_26_2, ginoinput_27_1, ginoinput_27_2, ginoinput_28_1, ginoinput_28_2, ginoinput_29_1, ginoinput_29_2, ginoinput_30_1, ginoinput_30_2, ginoinput_31_1, ginoinput_31_2, ginoinput_32_1, ginoinput_32_2, ginoinput_33_1, ginoinput_33_2, ginoinput_34_1, ginoinput_34_2, ginoinput_35_1, ginoinput_35_2, ginoinput_36_1, ginoinput_36_2, ginoinput_37_1, ginoinput_37_2
gknoinput_time		init 16
gknoinput_off		init .005
gknoinput_dur		init 1
gknoinput_sonvs		init 1
ginoinput_len		init lenarray(ginoinput_sonvs)/2

;------------------

	instr noinput

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "noinput"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gknoinput_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gknoinput_sonvs%(ginoinput_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init ginoinput_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "noinput"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gknoinput_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(ginoinput_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init ginoinput_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "noinput"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gknoinput_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gknoinput_sonvs%(ginoinput_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init ginoinput_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	noinput, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "noinput"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gknoinput_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gknoinput_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	noinput, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "noinput"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gknoinput_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gknoinput_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSnoneknows_file	init "../samples/opcode/noneknows.wav"

ginoneknows1	ftgen 0, 0, 0, 1, gSnoneknows_file, 0, 0, 1
ginoneknows2	ftgen 0, 0, 0, 1, gSnoneknows_file, 0, 0, 2

gknoneknows_time		init 16
gknoneknows_off		init .005
gknoneknows_dur		init 1
;------------------

	instr noneknows

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "noneknows"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gknoneknows_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, ginoneknows1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "noneknows"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gknoneknows_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, ginoneknows1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "noneknows"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gknoneknows_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, ginoneknows1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	noneknows, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "noneknows"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gknoneknows_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gknoneknows_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	noneknows, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "noneknows"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gknoneknows_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gknoneknows_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSnoriff_file	init "../samples/opcode/noriff.wav"

ginoriff1	ftgen 0, 0, 0, 1, gSnoriff_file, 0, 0, 1
ginoriff2	ftgen 0, 0, 0, 1, gSnoriff_file, 0, 0, 2

gknoriff_time		init 16
gknoriff_off		init .005
gknoriff_dur		init 1
;------------------

	instr noriff

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "noriff"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gknoriff_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, ginoriff1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "noriff"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gknoriff_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, ginoriff1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "noriff"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gknoriff_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, ginoriff1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	noriff, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "noriff"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gknoriff_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gknoriff_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	noriff, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "noriff"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gknoriff_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gknoriff_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSnovember_file	init "../samples/opcode/november.wav"

ginovember1	ftgen 0, 0, 0, 1, gSnovember_file, 0, 0, 1
ginovember2	ftgen 0, 0, 0, 1, gSnovember_file, 0, 0, 2

gknovember_time		init 16
gknovember_off		init .005
gknovember_dur		init 1
;------------------

	instr november

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "november"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gknovember_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, ginovember1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "november"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gknovember_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, ginovember1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "november"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gknovember_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, ginovember1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	november, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "november"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gknovember_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gknovember_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	november, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "november"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gknovember_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gknovember_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSocean_file	init "../samples/opcode/ocean.wav"

giocean1	ftgen 0, 0, 0, 1, gSocean_file, 0, 0, 1
giocean2	ftgen 0, 0, 0, 1, gSocean_file, 0, 0, 2

gkocean_time		init 16
gkocean_off		init .005
gkocean_dur		init 1
;------------------

	instr ocean

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "ocean"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkocean_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giocean1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "ocean"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkocean_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, giocean1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "ocean"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkocean_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giocean1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	ocean, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "ocean"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkocean_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkocean_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	ocean, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "ocean"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkocean_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkocean_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSpert_00_file 	 init "../samples/opcode/pert/pert-00.wav"
gipert_00_1		 ftgen 0, 0, 0, 1, gSpert_00_file, 0, 0, 1
gipert_00_2		 ftgen 0, 0, 0, 1, gSpert_00_file, 0, 0, 2
;---
gSpert_01_file 	 init "../samples/opcode/pert/pert-01.wav"
gipert_01_1		 ftgen 0, 0, 0, 1, gSpert_01_file, 0, 0, 1
gipert_01_2		 ftgen 0, 0, 0, 1, gSpert_01_file, 0, 0, 2
;---
gSpert_02_file 	 init "../samples/opcode/pert/pert-02.wav"
gipert_02_1		 ftgen 0, 0, 0, 1, gSpert_02_file, 0, 0, 1
gipert_02_2		 ftgen 0, 0, 0, 1, gSpert_02_file, 0, 0, 2
;---
gSpert_03_file 	 init "../samples/opcode/pert/pert-03.wav"
gipert_03_1		 ftgen 0, 0, 0, 1, gSpert_03_file, 0, 0, 1
gipert_03_2		 ftgen 0, 0, 0, 1, gSpert_03_file, 0, 0, 2
;---
gSpert_04_file 	 init "../samples/opcode/pert/pert-04.wav"
gipert_04_1		 ftgen 0, 0, 0, 1, gSpert_04_file, 0, 0, 1
gipert_04_2		 ftgen 0, 0, 0, 1, gSpert_04_file, 0, 0, 2
;---
gSpert_05_file 	 init "../samples/opcode/pert/pert-05.wav"
gipert_05_1		 ftgen 0, 0, 0, 1, gSpert_05_file, 0, 0, 1
gipert_05_2		 ftgen 0, 0, 0, 1, gSpert_05_file, 0, 0, 2
;---
gSpert_06_file 	 init "../samples/opcode/pert/pert-06.wav"
gipert_06_1		 ftgen 0, 0, 0, 1, gSpert_06_file, 0, 0, 1
gipert_06_2		 ftgen 0, 0, 0, 1, gSpert_06_file, 0, 0, 2
;---
gSpert_07_file 	 init "../samples/opcode/pert/pert-07.wav"
gipert_07_1		 ftgen 0, 0, 0, 1, gSpert_07_file, 0, 0, 1
gipert_07_2		 ftgen 0, 0, 0, 1, gSpert_07_file, 0, 0, 2
;---
gSpert_08_file 	 init "../samples/opcode/pert/pert-08.wav"
gipert_08_1		 ftgen 0, 0, 0, 1, gSpert_08_file, 0, 0, 1
gipert_08_2		 ftgen 0, 0, 0, 1, gSpert_08_file, 0, 0, 2
;---
gSpert_09_file 	 init "../samples/opcode/pert/pert-09.wav"
gipert_09_1		 ftgen 0, 0, 0, 1, gSpert_09_file, 0, 0, 1
gipert_09_2		 ftgen 0, 0, 0, 1, gSpert_09_file, 0, 0, 2
;---
gSpert_10_file 	 init "../samples/opcode/pert/pert-10.wav"
gipert_10_1		 ftgen 0, 0, 0, 1, gSpert_10_file, 0, 0, 1
gipert_10_2		 ftgen 0, 0, 0, 1, gSpert_10_file, 0, 0, 2
;---
gSpert_11_file 	 init "../samples/opcode/pert/pert-11.wav"
gipert_11_1		 ftgen 0, 0, 0, 1, gSpert_11_file, 0, 0, 1
gipert_11_2		 ftgen 0, 0, 0, 1, gSpert_11_file, 0, 0, 2
;---
gSpert_12_file 	 init "../samples/opcode/pert/pert-12.wav"
gipert_12_1		 ftgen 0, 0, 0, 1, gSpert_12_file, 0, 0, 1
gipert_12_2		 ftgen 0, 0, 0, 1, gSpert_12_file, 0, 0, 2
;---
gSpert_13_file 	 init "../samples/opcode/pert/pert-13.wav"
gipert_13_1		 ftgen 0, 0, 0, 1, gSpert_13_file, 0, 0, 1
gipert_13_2		 ftgen 0, 0, 0, 1, gSpert_13_file, 0, 0, 2
;---
gSpert_14_file 	 init "../samples/opcode/pert/pert-14.wav"
gipert_14_1		 ftgen 0, 0, 0, 1, gSpert_14_file, 0, 0, 1
gipert_14_2		 ftgen 0, 0, 0, 1, gSpert_14_file, 0, 0, 2
;---
gSpert_15_file 	 init "../samples/opcode/pert/pert-15.wav"
gipert_15_1		 ftgen 0, 0, 0, 1, gSpert_15_file, 0, 0, 1
gipert_15_2		 ftgen 0, 0, 0, 1, gSpert_15_file, 0, 0, 2
;---
gSpert_16_file 	 init "../samples/opcode/pert/pert-16.wav"
gipert_16_1		 ftgen 0, 0, 0, 1, gSpert_16_file, 0, 0, 1
gipert_16_2		 ftgen 0, 0, 0, 1, gSpert_16_file, 0, 0, 2
;---
gSpert_17_file 	 init "../samples/opcode/pert/pert-17.wav"
gipert_17_1		 ftgen 0, 0, 0, 1, gSpert_17_file, 0, 0, 1
gipert_17_2		 ftgen 0, 0, 0, 1, gSpert_17_file, 0, 0, 2
;---
gSpert_18_file 	 init "../samples/opcode/pert/pert-18.wav"
gipert_18_1		 ftgen 0, 0, 0, 1, gSpert_18_file, 0, 0, 1
gipert_18_2		 ftgen 0, 0, 0, 1, gSpert_18_file, 0, 0, 2
;---
gSpert_19_file 	 init "../samples/opcode/pert/pert-19.wav"
gipert_19_1		 ftgen 0, 0, 0, 1, gSpert_19_file, 0, 0, 1
gipert_19_2		 ftgen 0, 0, 0, 1, gSpert_19_file, 0, 0, 2
;---
gSpert_20_file 	 init "../samples/opcode/pert/pert-20.wav"
gipert_20_1		 ftgen 0, 0, 0, 1, gSpert_20_file, 0, 0, 1
gipert_20_2		 ftgen 0, 0, 0, 1, gSpert_20_file, 0, 0, 2
;---
gSpert_21_file 	 init "../samples/opcode/pert/pert-21.wav"
gipert_21_1		 ftgen 0, 0, 0, 1, gSpert_21_file, 0, 0, 1
gipert_21_2		 ftgen 0, 0, 0, 1, gSpert_21_file, 0, 0, 2
;---
gSpert_22_file 	 init "../samples/opcode/pert/pert-22.wav"
gipert_22_1		 ftgen 0, 0, 0, 1, gSpert_22_file, 0, 0, 1
gipert_22_2		 ftgen 0, 0, 0, 1, gSpert_22_file, 0, 0, 2
;---
gSpert_23_file 	 init "../samples/opcode/pert/pert-23.wav"
gipert_23_1		 ftgen 0, 0, 0, 1, gSpert_23_file, 0, 0, 1
gipert_23_2		 ftgen 0, 0, 0, 1, gSpert_23_file, 0, 0, 2
;---
gSpert_24_file 	 init "../samples/opcode/pert/pert-24.wav"
gipert_24_1		 ftgen 0, 0, 0, 1, gSpert_24_file, 0, 0, 1
gipert_24_2		 ftgen 0, 0, 0, 1, gSpert_24_file, 0, 0, 2
;---
gSpert_25_file 	 init "../samples/opcode/pert/pert-25.wav"
gipert_25_1		 ftgen 0, 0, 0, 1, gSpert_25_file, 0, 0, 1
gipert_25_2		 ftgen 0, 0, 0, 1, gSpert_25_file, 0, 0, 2
;---
gSpert_26_file 	 init "../samples/opcode/pert/pert-26.wav"
gipert_26_1		 ftgen 0, 0, 0, 1, gSpert_26_file, 0, 0, 1
gipert_26_2		 ftgen 0, 0, 0, 1, gSpert_26_file, 0, 0, 2
;---
gSpert_27_file 	 init "../samples/opcode/pert/pert-27.wav"
gipert_27_1		 ftgen 0, 0, 0, 1, gSpert_27_file, 0, 0, 1
gipert_27_2		 ftgen 0, 0, 0, 1, gSpert_27_file, 0, 0, 2
;---
gSpert_28_file 	 init "../samples/opcode/pert/pert-28.wav"
gipert_28_1		 ftgen 0, 0, 0, 1, gSpert_28_file, 0, 0, 1
gipert_28_2		 ftgen 0, 0, 0, 1, gSpert_28_file, 0, 0, 2
;---
gSpert_29_file 	 init "../samples/opcode/pert/pert-29.wav"
gipert_29_1		 ftgen 0, 0, 0, 1, gSpert_29_file, 0, 0, 1
gipert_29_2		 ftgen 0, 0, 0, 1, gSpert_29_file, 0, 0, 2
;---
gipert_sonvs[]			fillarray	gipert_00_1, gipert_00_2, gipert_01_1, gipert_01_2, gipert_02_1, gipert_02_2, gipert_03_1, gipert_03_2, gipert_04_1, gipert_04_2, gipert_05_1, gipert_05_2, gipert_06_1, gipert_06_2, gipert_07_1, gipert_07_2, gipert_08_1, gipert_08_2, gipert_09_1, gipert_09_2, gipert_10_1, gipert_10_2, gipert_11_1, gipert_11_2, gipert_12_1, gipert_12_2, gipert_13_1, gipert_13_2, gipert_14_1, gipert_14_2, gipert_15_1, gipert_15_2, gipert_16_1, gipert_16_2, gipert_17_1, gipert_17_2, gipert_18_1, gipert_18_2, gipert_19_1, gipert_19_2, gipert_20_1, gipert_20_2, gipert_21_1, gipert_21_2, gipert_22_1, gipert_22_2, gipert_23_1, gipert_23_2, gipert_24_1, gipert_24_2, gipert_25_1, gipert_25_2, gipert_26_1, gipert_26_2, gipert_27_1, gipert_27_2, gipert_28_1, gipert_28_2, gipert_29_1, gipert_29_2
gkpert_time		init 16
gkpert_off		init .005
gkpert_dur		init 1
gkpert_sonvs		init 1
gipert_len		init lenarray(gipert_sonvs)/2

;------------------

	instr pert

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "pert"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkpert_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkpert_sonvs%(gipert_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gipert_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "pert"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkpert_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gipert_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gipert_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "pert"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkpert_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkpert_sonvs%(gipert_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gipert_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	pert, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "pert"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkpert_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkpert_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	pert, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "pert"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkpert_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkpert_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSD3_2_1_file 	 init "../samples/opcode/pharm/D3_2_1.wav"
giD3_2_1_1		 ftgen 0, 0, 0, 1, gSD3_2_1_file, 0, 0, 1
giD3_2_1_2		 ftgen 0, 0, 0, 1, gSD3_2_1_file, 0, 0, 2
;---
gSD3_3_1_file 	 init "../samples/opcode/pharm/D3_3_1.wav"
giD3_3_1_1		 ftgen 0, 0, 0, 1, gSD3_3_1_file, 0, 0, 1
giD3_3_1_2		 ftgen 0, 0, 0, 1, gSD3_3_1_file, 0, 0, 2
;---
gSD3_4_1_file 	 init "../samples/opcode/pharm/D3_4_1.wav"
giD3_4_1_1		 ftgen 0, 0, 0, 1, gSD3_4_1_file, 0, 0, 1
giD3_4_1_2		 ftgen 0, 0, 0, 1, gSD3_4_1_file, 0, 0, 2
;---
gSD3_5_1_file 	 init "../samples/opcode/pharm/D3_5_1.wav"
giD3_5_1_1		 ftgen 0, 0, 0, 1, gSD3_5_1_file, 0, 0, 1
giD3_5_1_2		 ftgen 0, 0, 0, 1, gSD3_5_1_file, 0, 0, 2
;---
gSD3_7_2_file 	 init "../samples/opcode/pharm/D3_7_2.wav"
giD3_7_2_1		 ftgen 0, 0, 0, 1, gSD3_7_2_file, 0, 0, 1
giD3_7_2_2		 ftgen 0, 0, 0, 1, gSD3_7_2_file, 0, 0, 2
;---
gSD4_2_1_file 	 init "../samples/opcode/pharm/D4_2_1.wav"
giD4_2_1_1		 ftgen 0, 0, 0, 1, gSD4_2_1_file, 0, 0, 1
giD4_2_1_2		 ftgen 0, 0, 0, 1, gSD4_2_1_file, 0, 0, 2
;---
gSD4_3_1_file 	 init "../samples/opcode/pharm/D4_3_1.wav"
giD4_3_1_1		 ftgen 0, 0, 0, 1, gSD4_3_1_file, 0, 0, 1
giD4_3_1_2		 ftgen 0, 0, 0, 1, gSD4_3_1_file, 0, 0, 2
;---
gSD4_4_1_file 	 init "../samples/opcode/pharm/D4_4_1.wav"
giD4_4_1_1		 ftgen 0, 0, 0, 1, gSD4_4_1_file, 0, 0, 1
giD4_4_1_2		 ftgen 0, 0, 0, 1, gSD4_4_1_file, 0, 0, 2
;---
gSF3_2_1_file 	 init "../samples/opcode/pharm/F3_2_1.wav"
giF3_2_1_1		 ftgen 0, 0, 0, 1, gSF3_2_1_file, 0, 0, 1
giF3_2_1_2		 ftgen 0, 0, 0, 1, gSF3_2_1_file, 0, 0, 2
;---
gSF3_3_1_file 	 init "../samples/opcode/pharm/F3_3_1.wav"
giF3_3_1_1		 ftgen 0, 0, 0, 1, gSF3_3_1_file, 0, 0, 1
giF3_3_1_2		 ftgen 0, 0, 0, 1, gSF3_3_1_file, 0, 0, 2
;---
gSF3_4_1_file 	 init "../samples/opcode/pharm/F3_4_1.wav"
giF3_4_1_1		 ftgen 0, 0, 0, 1, gSF3_4_1_file, 0, 0, 1
giF3_4_1_2		 ftgen 0, 0, 0, 1, gSF3_4_1_file, 0, 0, 2
;---
gSF3_5_1_file 	 init "../samples/opcode/pharm/F3_5_1.wav"
giF3_5_1_1		 ftgen 0, 0, 0, 1, gSF3_5_1_file, 0, 0, 1
giF3_5_1_2		 ftgen 0, 0, 0, 1, gSF3_5_1_file, 0, 0, 2
;---
gSF3_7_2_file 	 init "../samples/opcode/pharm/F3_7_2.wav"
giF3_7_2_1		 ftgen 0, 0, 0, 1, gSF3_7_2_file, 0, 0, 1
giF3_7_2_2		 ftgen 0, 0, 0, 1, gSF3_7_2_file, 0, 0, 2
;---
gSF4_2_1_file 	 init "../samples/opcode/pharm/F4_2_1.wav"
giF4_2_1_1		 ftgen 0, 0, 0, 1, gSF4_2_1_file, 0, 0, 1
giF4_2_1_2		 ftgen 0, 0, 0, 1, gSF4_2_1_file, 0, 0, 2
;---
gSF4_3_1_file 	 init "../samples/opcode/pharm/F4_3_1.wav"
giF4_3_1_1		 ftgen 0, 0, 0, 1, gSF4_3_1_file, 0, 0, 1
giF4_3_1_2		 ftgen 0, 0, 0, 1, gSF4_3_1_file, 0, 0, 2
;---
gipharm_sonvs[]			fillarray	giD3_2_1_1, giD3_2_1_2, giD3_3_1_1, giD3_3_1_2, giD3_4_1_1, giD3_4_1_2, giD3_5_1_1, giD3_5_1_2, giD3_7_2_1, giD3_7_2_2, giD4_2_1_1, giD4_2_1_2, giD4_3_1_1, giD4_3_1_2, giD4_4_1_1, giD4_4_1_2, giF3_2_1_1, giF3_2_1_2, giF3_3_1_1, giF3_3_1_2, giF3_4_1_1, giF3_4_1_2, giF3_5_1_1, giF3_5_1_2, giF3_7_2_1, giF3_7_2_2, giF4_2_1_1, giF4_2_1_2, giF4_3_1_1, giF4_3_1_2
gkpharm_time		init 16
gkpharm_off		init .005
gkpharm_dur		init 1
gkpharm_sonvs		init 1
gipharm_len		init lenarray(gipharm_sonvs)/2

;------------------

	instr pharm

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "pharm"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkpharm_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkpharm_sonvs%(gipharm_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gipharm_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "pharm"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkpharm_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gipharm_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gipharm_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "pharm"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkpharm_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkpharm_sonvs%(gipharm_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gipharm_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	pharm, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "pharm"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkpharm_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkpharm_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	pharm, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "pharm"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkpharm_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkpharm_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSplanche_file	init "../samples/opcode/planche.wav"

giplanche1	ftgen 0, 0, 0, 1, gSplanche_file, 0, 0, 1
giplanche2	ftgen 0, 0, 0, 1, gSplanche_file, 0, 0, 2

gkplanche_time		init 16
gkplanche_off		init .005
gkplanche_dur		init 1
;------------------

	instr planche

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "planche"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkplanche_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giplanche1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "planche"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkplanche_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, giplanche1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "planche"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkplanche_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, giplanche1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	planche, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "planche"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkplanche_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkplanche_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	planche, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "planche"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkplanche_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkplanche_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSquar_01_file 	 init "../samples/opcode/quar/quar-01.wav"
giquar_01_1		 ftgen 0, 0, 0, 1, gSquar_01_file, 0, 0, 1
giquar_01_2		 ftgen 0, 0, 0, 1, gSquar_01_file, 0, 0, 2
;---
gSquar_02_file 	 init "../samples/opcode/quar/quar-02.wav"
giquar_02_1		 ftgen 0, 0, 0, 1, gSquar_02_file, 0, 0, 1
giquar_02_2		 ftgen 0, 0, 0, 1, gSquar_02_file, 0, 0, 2
;---
gSquar_03_file 	 init "../samples/opcode/quar/quar-03.wav"
giquar_03_1		 ftgen 0, 0, 0, 1, gSquar_03_file, 0, 0, 1
giquar_03_2		 ftgen 0, 0, 0, 1, gSquar_03_file, 0, 0, 2
;---
gSquar_04_file 	 init "../samples/opcode/quar/quar-04.wav"
giquar_04_1		 ftgen 0, 0, 0, 1, gSquar_04_file, 0, 0, 1
giquar_04_2		 ftgen 0, 0, 0, 1, gSquar_04_file, 0, 0, 2
;---
gSquar_05_file 	 init "../samples/opcode/quar/quar-05.wav"
giquar_05_1		 ftgen 0, 0, 0, 1, gSquar_05_file, 0, 0, 1
giquar_05_2		 ftgen 0, 0, 0, 1, gSquar_05_file, 0, 0, 2
;---
gSquar_06_file 	 init "../samples/opcode/quar/quar-06.wav"
giquar_06_1		 ftgen 0, 0, 0, 1, gSquar_06_file, 0, 0, 1
giquar_06_2		 ftgen 0, 0, 0, 1, gSquar_06_file, 0, 0, 2
;---
gSquar_07_file 	 init "../samples/opcode/quar/quar-07.wav"
giquar_07_1		 ftgen 0, 0, 0, 1, gSquar_07_file, 0, 0, 1
giquar_07_2		 ftgen 0, 0, 0, 1, gSquar_07_file, 0, 0, 2
;---
gSquar_08_file 	 init "../samples/opcode/quar/quar-08.wav"
giquar_08_1		 ftgen 0, 0, 0, 1, gSquar_08_file, 0, 0, 1
giquar_08_2		 ftgen 0, 0, 0, 1, gSquar_08_file, 0, 0, 2
;---
gSquar_09_file 	 init "../samples/opcode/quar/quar-09.wav"
giquar_09_1		 ftgen 0, 0, 0, 1, gSquar_09_file, 0, 0, 1
giquar_09_2		 ftgen 0, 0, 0, 1, gSquar_09_file, 0, 0, 2
;---
gSquar_10_file 	 init "../samples/opcode/quar/quar-10.wav"
giquar_10_1		 ftgen 0, 0, 0, 1, gSquar_10_file, 0, 0, 1
giquar_10_2		 ftgen 0, 0, 0, 1, gSquar_10_file, 0, 0, 2
;---
giquar_sonvs[]			fillarray	giquar_01_1, giquar_01_2, giquar_02_1, giquar_02_2, giquar_03_1, giquar_03_2, giquar_04_1, giquar_04_2, giquar_05_1, giquar_05_2, giquar_06_1, giquar_06_2, giquar_07_1, giquar_07_2, giquar_08_1, giquar_08_2, giquar_09_1, giquar_09_2, giquar_10_1, giquar_10_2
gkquar_time		init 16
gkquar_off		init .005
gkquar_dur		init 1
gkquar_sonvs		init 1
giquar_len		init lenarray(giquar_sonvs)/2

;------------------

	instr quar

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "quar"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkquar_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkquar_sonvs%(giquar_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init giquar_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "quar"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkquar_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(giquar_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init giquar_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "quar"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkquar_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkquar_sonvs%(giquar_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init giquar_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	quar, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "quar"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkquar_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkquar_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	quar, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "quar"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkquar_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkquar_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSquar2_01_file 	 init "../samples/opcode/quar2/quar2-01.wav"
giquar2_01_1		 ftgen 0, 0, 0, 1, gSquar2_01_file, 0, 0, 1
giquar2_01_2		 ftgen 0, 0, 0, 1, gSquar2_01_file, 0, 0, 2
;---
gSquar2_02_file 	 init "../samples/opcode/quar2/quar2-02.wav"
giquar2_02_1		 ftgen 0, 0, 0, 1, gSquar2_02_file, 0, 0, 1
giquar2_02_2		 ftgen 0, 0, 0, 1, gSquar2_02_file, 0, 0, 2
;---
gSquar2_05_file 	 init "../samples/opcode/quar2/quar2-05.wav"
giquar2_05_1		 ftgen 0, 0, 0, 1, gSquar2_05_file, 0, 0, 1
giquar2_05_2		 ftgen 0, 0, 0, 1, gSquar2_05_file, 0, 0, 2
;---
giquar2_sonvs[]			fillarray	giquar2_01_1, giquar2_01_2, giquar2_02_1, giquar2_02_2, giquar2_05_1, giquar2_05_2
gkquar2_time		init 16
gkquar2_off		init .005
gkquar2_dur		init 1
gkquar2_sonvs		init 1
giquar2_len		init lenarray(giquar2_sonvs)/2

;------------------

	instr quar2

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "quar2"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkquar2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkquar2_sonvs%(giquar2_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init giquar2_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "quar2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkquar2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(giquar2_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init giquar2_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "quar2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkquar2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkquar2_sonvs%(giquar2_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init giquar2_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	quar2, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "quar2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkquar2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkquar2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	quar2, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "quar2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkquar2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkquar2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSreg_file	init "../samples/opcode/reg.wav"

gireg1	ftgen 0, 0, 0, 1, gSreg_file, 0, 0, 1
gireg2	ftgen 0, 0, 0, 1, gSreg_file, 0, 0, 2

gkreg_time		init 16
gkreg_off		init .005
gkreg_dur		init 1
;------------------

	instr reg

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "reg"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkreg_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gireg1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "reg"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkreg_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gireg1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "reg"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkreg_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gireg1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	reg, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "reg"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkreg_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkreg_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	reg, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "reg"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkreg_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkreg_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSsearch_file	init "../samples/opcode/search.wav"

gisearch1	ftgen 0, 0, 0, 1, gSsearch_file, 0, 0, 1
gisearch2	ftgen 0, 0, 0, 1, gSsearch_file, 0, 0, 2

gksearch_time		init 16
gksearch_off		init .005
gksearch_dur		init 1
;------------------

	instr search

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "search"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gksearch_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisearch1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "search"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gksearch_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gisearch1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "search"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gksearch_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisearch1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	search, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "search"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksearch_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksearch_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	search, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "search"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksearch_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksearch_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSshaku_file	init "../samples/opcode/shaku.wav"

gishaku1	ftgen 0, 0, 0, 1, gSshaku_file, 0, 0, 1
gishaku2	ftgen 0, 0, 0, 1, gSshaku_file, 0, 0, 2

gkshaku_time		init 16
gkshaku_off		init .005
gkshaku_dur		init 1
;------------------

	instr shaku

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "shaku"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkshaku_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gishaku1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "shaku"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkshaku_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gishaku1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "shaku"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkshaku_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gishaku1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	shaku, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "shaku"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkshaku_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkshaku_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	shaku, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "shaku"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkshaku_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkshaku_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSshinji_file	init "../samples/opcode/shinji.wav"

gishinji1	ftgen 0, 0, 0, 1, gSshinji_file, 0, 0, 1
gishinji2	ftgen 0, 0, 0, 1, gSshinji_file, 0, 0, 2

gkshinji_time		init 16
gkshinji_off		init .005
gkshinji_dur		init 1
;------------------

	instr shinji

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "shinji"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkshinji_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gishinji1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "shinji"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkshinji_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gishinji1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "shinji"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkshinji_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gishinji1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	shinji, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "shinji"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkshinji_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkshinji_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	shinji, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "shinji"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkshinji_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkshinji_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSshinobi_file	init "../samples/opcode/shinobi.wav"

gishinobi1	ftgen 0, 0, 0, 1, gSshinobi_file, 0, 0, 1
gishinobi2	ftgen 0, 0, 0, 1, gSshinobi_file, 0, 0, 2

gkshinobi_time		init 16
gkshinobi_off		init .005
gkshinobi_dur		init 1
;------------------

	instr shinobi

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "shinobi"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkshinobi_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gishinobi1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "shinobi"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkshinobi_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gishinobi1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "shinobi"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkshinobi_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gishinobi1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	shinobi, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "shinobi"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkshinobi_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkshinobi_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	shinobi, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "shinobi"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkshinobi_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkshinobi_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSsin_00_file 	 init "../samples/opcode/sin/sin-00.wav"
gisin_00_1		 ftgen 0, 0, 0, 1, gSsin_00_file, 0, 0, 1
gisin_00_2		 ftgen 0, 0, 0, 1, gSsin_00_file, 0, 0, 2
;---
gSsin_01_file 	 init "../samples/opcode/sin/sin-01.wav"
gisin_01_1		 ftgen 0, 0, 0, 1, gSsin_01_file, 0, 0, 1
gisin_01_2		 ftgen 0, 0, 0, 1, gSsin_01_file, 0, 0, 2
;---
gSsin_02_file 	 init "../samples/opcode/sin/sin-02.wav"
gisin_02_1		 ftgen 0, 0, 0, 1, gSsin_02_file, 0, 0, 1
gisin_02_2		 ftgen 0, 0, 0, 1, gSsin_02_file, 0, 0, 2
;---
gSsin_03_file 	 init "../samples/opcode/sin/sin-03.wav"
gisin_03_1		 ftgen 0, 0, 0, 1, gSsin_03_file, 0, 0, 1
gisin_03_2		 ftgen 0, 0, 0, 1, gSsin_03_file, 0, 0, 2
;---
gSsin_04_file 	 init "../samples/opcode/sin/sin-04.wav"
gisin_04_1		 ftgen 0, 0, 0, 1, gSsin_04_file, 0, 0, 1
gisin_04_2		 ftgen 0, 0, 0, 1, gSsin_04_file, 0, 0, 2
;---
gSsin_05_file 	 init "../samples/opcode/sin/sin-05.wav"
gisin_05_1		 ftgen 0, 0, 0, 1, gSsin_05_file, 0, 0, 1
gisin_05_2		 ftgen 0, 0, 0, 1, gSsin_05_file, 0, 0, 2
;---
gSsin_06_file 	 init "../samples/opcode/sin/sin-06.wav"
gisin_06_1		 ftgen 0, 0, 0, 1, gSsin_06_file, 0, 0, 1
gisin_06_2		 ftgen 0, 0, 0, 1, gSsin_06_file, 0, 0, 2
;---
gSsin_07_file 	 init "../samples/opcode/sin/sin-07.wav"
gisin_07_1		 ftgen 0, 0, 0, 1, gSsin_07_file, 0, 0, 1
gisin_07_2		 ftgen 0, 0, 0, 1, gSsin_07_file, 0, 0, 2
;---
gSsin_08_file 	 init "../samples/opcode/sin/sin-08.wav"
gisin_08_1		 ftgen 0, 0, 0, 1, gSsin_08_file, 0, 0, 1
gisin_08_2		 ftgen 0, 0, 0, 1, gSsin_08_file, 0, 0, 2
;---
gSsin_09_file 	 init "../samples/opcode/sin/sin-09.wav"
gisin_09_1		 ftgen 0, 0, 0, 1, gSsin_09_file, 0, 0, 1
gisin_09_2		 ftgen 0, 0, 0, 1, gSsin_09_file, 0, 0, 2
;---
gSsin_10_file 	 init "../samples/opcode/sin/sin-10.wav"
gisin_10_1		 ftgen 0, 0, 0, 1, gSsin_10_file, 0, 0, 1
gisin_10_2		 ftgen 0, 0, 0, 1, gSsin_10_file, 0, 0, 2
;---
gSsin_11_file 	 init "../samples/opcode/sin/sin-11.wav"
gisin_11_1		 ftgen 0, 0, 0, 1, gSsin_11_file, 0, 0, 1
gisin_11_2		 ftgen 0, 0, 0, 1, gSsin_11_file, 0, 0, 2
;---
gSsin_12_file 	 init "../samples/opcode/sin/sin-12.wav"
gisin_12_1		 ftgen 0, 0, 0, 1, gSsin_12_file, 0, 0, 1
gisin_12_2		 ftgen 0, 0, 0, 1, gSsin_12_file, 0, 0, 2
;---
gSsin_13_file 	 init "../samples/opcode/sin/sin-13.wav"
gisin_13_1		 ftgen 0, 0, 0, 1, gSsin_13_file, 0, 0, 1
gisin_13_2		 ftgen 0, 0, 0, 1, gSsin_13_file, 0, 0, 2
;---
gSsin_14_file 	 init "../samples/opcode/sin/sin-14.wav"
gisin_14_1		 ftgen 0, 0, 0, 1, gSsin_14_file, 0, 0, 1
gisin_14_2		 ftgen 0, 0, 0, 1, gSsin_14_file, 0, 0, 2
;---
gSsin_15_file 	 init "../samples/opcode/sin/sin-15.wav"
gisin_15_1		 ftgen 0, 0, 0, 1, gSsin_15_file, 0, 0, 1
gisin_15_2		 ftgen 0, 0, 0, 1, gSsin_15_file, 0, 0, 2
;---
gSsin_16_file 	 init "../samples/opcode/sin/sin-16.wav"
gisin_16_1		 ftgen 0, 0, 0, 1, gSsin_16_file, 0, 0, 1
gisin_16_2		 ftgen 0, 0, 0, 1, gSsin_16_file, 0, 0, 2
;---
gSsin_17_file 	 init "../samples/opcode/sin/sin-17.wav"
gisin_17_1		 ftgen 0, 0, 0, 1, gSsin_17_file, 0, 0, 1
gisin_17_2		 ftgen 0, 0, 0, 1, gSsin_17_file, 0, 0, 2
;---
gSsin_18_file 	 init "../samples/opcode/sin/sin-18.wav"
gisin_18_1		 ftgen 0, 0, 0, 1, gSsin_18_file, 0, 0, 1
gisin_18_2		 ftgen 0, 0, 0, 1, gSsin_18_file, 0, 0, 2
;---
gSsin_19_file 	 init "../samples/opcode/sin/sin-19.wav"
gisin_19_1		 ftgen 0, 0, 0, 1, gSsin_19_file, 0, 0, 1
gisin_19_2		 ftgen 0, 0, 0, 1, gSsin_19_file, 0, 0, 2
;---
gSsin_20_file 	 init "../samples/opcode/sin/sin-20.wav"
gisin_20_1		 ftgen 0, 0, 0, 1, gSsin_20_file, 0, 0, 1
gisin_20_2		 ftgen 0, 0, 0, 1, gSsin_20_file, 0, 0, 2
;---
gSsin_21_file 	 init "../samples/opcode/sin/sin-21.wav"
gisin_21_1		 ftgen 0, 0, 0, 1, gSsin_21_file, 0, 0, 1
gisin_21_2		 ftgen 0, 0, 0, 1, gSsin_21_file, 0, 0, 2
;---
gSsin_22_file 	 init "../samples/opcode/sin/sin-22.wav"
gisin_22_1		 ftgen 0, 0, 0, 1, gSsin_22_file, 0, 0, 1
gisin_22_2		 ftgen 0, 0, 0, 1, gSsin_22_file, 0, 0, 2
;---
gSsin_23_file 	 init "../samples/opcode/sin/sin-23.wav"
gisin_23_1		 ftgen 0, 0, 0, 1, gSsin_23_file, 0, 0, 1
gisin_23_2		 ftgen 0, 0, 0, 1, gSsin_23_file, 0, 0, 2
;---
gSsin_24_file 	 init "../samples/opcode/sin/sin-24.wav"
gisin_24_1		 ftgen 0, 0, 0, 1, gSsin_24_file, 0, 0, 1
gisin_24_2		 ftgen 0, 0, 0, 1, gSsin_24_file, 0, 0, 2
;---
gSsin_25_file 	 init "../samples/opcode/sin/sin-25.wav"
gisin_25_1		 ftgen 0, 0, 0, 1, gSsin_25_file, 0, 0, 1
gisin_25_2		 ftgen 0, 0, 0, 1, gSsin_25_file, 0, 0, 2
;---
gSsin_26_file 	 init "../samples/opcode/sin/sin-26.wav"
gisin_26_1		 ftgen 0, 0, 0, 1, gSsin_26_file, 0, 0, 1
gisin_26_2		 ftgen 0, 0, 0, 1, gSsin_26_file, 0, 0, 2
;---
gisin_sonvs[]			fillarray	gisin_00_1, gisin_00_2, gisin_01_1, gisin_01_2, gisin_02_1, gisin_02_2, gisin_03_1, gisin_03_2, gisin_04_1, gisin_04_2, gisin_05_1, gisin_05_2, gisin_06_1, gisin_06_2, gisin_07_1, gisin_07_2, gisin_08_1, gisin_08_2, gisin_09_1, gisin_09_2, gisin_10_1, gisin_10_2, gisin_11_1, gisin_11_2, gisin_12_1, gisin_12_2, gisin_13_1, gisin_13_2, gisin_14_1, gisin_14_2, gisin_15_1, gisin_15_2, gisin_16_1, gisin_16_2, gisin_17_1, gisin_17_2, gisin_18_1, gisin_18_2, gisin_19_1, gisin_19_2, gisin_20_1, gisin_20_2, gisin_21_1, gisin_21_2, gisin_22_1, gisin_22_2, gisin_23_1, gisin_23_2, gisin_24_1, gisin_24_2, gisin_25_1, gisin_25_2, gisin_26_1, gisin_26_2
gksin_time		init 16
gksin_off		init .005
gksin_dur		init 1
gksin_sonvs		init 1
gisin_len		init lenarray(gisin_sonvs)/2

;------------------

	instr sin

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "sin"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gksin_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gksin_sonvs%(gisin_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gisin_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "sin"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gksin_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gisin_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gisin_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "sin"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gksin_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gksin_sonvs%(gisin_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gisin_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	sin, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "sin"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksin_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksin_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	sin, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "sin"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksin_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksin_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSsinimp_000_file 	 init "../samples/opcode/sinimp/sinimp-000.wav"
gisinimp_000_1		 ftgen 0, 0, 0, 1, gSsinimp_000_file, 0, 0, 1
gisinimp_000_2		 ftgen 0, 0, 0, 1, gSsinimp_000_file, 0, 0, 2
;---
gSsinimp_001_file 	 init "../samples/opcode/sinimp/sinimp-001.wav"
gisinimp_001_1		 ftgen 0, 0, 0, 1, gSsinimp_001_file, 0, 0, 1
gisinimp_001_2		 ftgen 0, 0, 0, 1, gSsinimp_001_file, 0, 0, 2
;---
gSsinimp_002_file 	 init "../samples/opcode/sinimp/sinimp-002.wav"
gisinimp_002_1		 ftgen 0, 0, 0, 1, gSsinimp_002_file, 0, 0, 1
gisinimp_002_2		 ftgen 0, 0, 0, 1, gSsinimp_002_file, 0, 0, 2
;---
gSsinimp_003_file 	 init "../samples/opcode/sinimp/sinimp-003.wav"
gisinimp_003_1		 ftgen 0, 0, 0, 1, gSsinimp_003_file, 0, 0, 1
gisinimp_003_2		 ftgen 0, 0, 0, 1, gSsinimp_003_file, 0, 0, 2
;---
gSsinimp_004_file 	 init "../samples/opcode/sinimp/sinimp-004.wav"
gisinimp_004_1		 ftgen 0, 0, 0, 1, gSsinimp_004_file, 0, 0, 1
gisinimp_004_2		 ftgen 0, 0, 0, 1, gSsinimp_004_file, 0, 0, 2
;---
gSsinimp_005_file 	 init "../samples/opcode/sinimp/sinimp-005.wav"
gisinimp_005_1		 ftgen 0, 0, 0, 1, gSsinimp_005_file, 0, 0, 1
gisinimp_005_2		 ftgen 0, 0, 0, 1, gSsinimp_005_file, 0, 0, 2
;---
gSsinimp_006_file 	 init "../samples/opcode/sinimp/sinimp-006.wav"
gisinimp_006_1		 ftgen 0, 0, 0, 1, gSsinimp_006_file, 0, 0, 1
gisinimp_006_2		 ftgen 0, 0, 0, 1, gSsinimp_006_file, 0, 0, 2
;---
gSsinimp_007_file 	 init "../samples/opcode/sinimp/sinimp-007.wav"
gisinimp_007_1		 ftgen 0, 0, 0, 1, gSsinimp_007_file, 0, 0, 1
gisinimp_007_2		 ftgen 0, 0, 0, 1, gSsinimp_007_file, 0, 0, 2
;---
gSsinimp_008_file 	 init "../samples/opcode/sinimp/sinimp-008.wav"
gisinimp_008_1		 ftgen 0, 0, 0, 1, gSsinimp_008_file, 0, 0, 1
gisinimp_008_2		 ftgen 0, 0, 0, 1, gSsinimp_008_file, 0, 0, 2
;---
gSsinimp_009_file 	 init "../samples/opcode/sinimp/sinimp-009.wav"
gisinimp_009_1		 ftgen 0, 0, 0, 1, gSsinimp_009_file, 0, 0, 1
gisinimp_009_2		 ftgen 0, 0, 0, 1, gSsinimp_009_file, 0, 0, 2
;---
gSsinimp_010_file 	 init "../samples/opcode/sinimp/sinimp-010.wav"
gisinimp_010_1		 ftgen 0, 0, 0, 1, gSsinimp_010_file, 0, 0, 1
gisinimp_010_2		 ftgen 0, 0, 0, 1, gSsinimp_010_file, 0, 0, 2
;---
gSsinimp_011_file 	 init "../samples/opcode/sinimp/sinimp-011.wav"
gisinimp_011_1		 ftgen 0, 0, 0, 1, gSsinimp_011_file, 0, 0, 1
gisinimp_011_2		 ftgen 0, 0, 0, 1, gSsinimp_011_file, 0, 0, 2
;---
gSsinimp_012_file 	 init "../samples/opcode/sinimp/sinimp-012.wav"
gisinimp_012_1		 ftgen 0, 0, 0, 1, gSsinimp_012_file, 0, 0, 1
gisinimp_012_2		 ftgen 0, 0, 0, 1, gSsinimp_012_file, 0, 0, 2
;---
gSsinimp_013_file 	 init "../samples/opcode/sinimp/sinimp-013.wav"
gisinimp_013_1		 ftgen 0, 0, 0, 1, gSsinimp_013_file, 0, 0, 1
gisinimp_013_2		 ftgen 0, 0, 0, 1, gSsinimp_013_file, 0, 0, 2
;---
gSsinimp_014_file 	 init "../samples/opcode/sinimp/sinimp-014.wav"
gisinimp_014_1		 ftgen 0, 0, 0, 1, gSsinimp_014_file, 0, 0, 1
gisinimp_014_2		 ftgen 0, 0, 0, 1, gSsinimp_014_file, 0, 0, 2
;---
gSsinimp_015_file 	 init "../samples/opcode/sinimp/sinimp-015.wav"
gisinimp_015_1		 ftgen 0, 0, 0, 1, gSsinimp_015_file, 0, 0, 1
gisinimp_015_2		 ftgen 0, 0, 0, 1, gSsinimp_015_file, 0, 0, 2
;---
gSsinimp_016_file 	 init "../samples/opcode/sinimp/sinimp-016.wav"
gisinimp_016_1		 ftgen 0, 0, 0, 1, gSsinimp_016_file, 0, 0, 1
gisinimp_016_2		 ftgen 0, 0, 0, 1, gSsinimp_016_file, 0, 0, 2
;---
gSsinimp_017_file 	 init "../samples/opcode/sinimp/sinimp-017.wav"
gisinimp_017_1		 ftgen 0, 0, 0, 1, gSsinimp_017_file, 0, 0, 1
gisinimp_017_2		 ftgen 0, 0, 0, 1, gSsinimp_017_file, 0, 0, 2
;---
gSsinimp_018_file 	 init "../samples/opcode/sinimp/sinimp-018.wav"
gisinimp_018_1		 ftgen 0, 0, 0, 1, gSsinimp_018_file, 0, 0, 1
gisinimp_018_2		 ftgen 0, 0, 0, 1, gSsinimp_018_file, 0, 0, 2
;---
gSsinimp_019_file 	 init "../samples/opcode/sinimp/sinimp-019.wav"
gisinimp_019_1		 ftgen 0, 0, 0, 1, gSsinimp_019_file, 0, 0, 1
gisinimp_019_2		 ftgen 0, 0, 0, 1, gSsinimp_019_file, 0, 0, 2
;---
gSsinimp_020_file 	 init "../samples/opcode/sinimp/sinimp-020.wav"
gisinimp_020_1		 ftgen 0, 0, 0, 1, gSsinimp_020_file, 0, 0, 1
gisinimp_020_2		 ftgen 0, 0, 0, 1, gSsinimp_020_file, 0, 0, 2
;---
gSsinimp_021_file 	 init "../samples/opcode/sinimp/sinimp-021.wav"
gisinimp_021_1		 ftgen 0, 0, 0, 1, gSsinimp_021_file, 0, 0, 1
gisinimp_021_2		 ftgen 0, 0, 0, 1, gSsinimp_021_file, 0, 0, 2
;---
gSsinimp_022_file 	 init "../samples/opcode/sinimp/sinimp-022.wav"
gisinimp_022_1		 ftgen 0, 0, 0, 1, gSsinimp_022_file, 0, 0, 1
gisinimp_022_2		 ftgen 0, 0, 0, 1, gSsinimp_022_file, 0, 0, 2
;---
gSsinimp_023_file 	 init "../samples/opcode/sinimp/sinimp-023.wav"
gisinimp_023_1		 ftgen 0, 0, 0, 1, gSsinimp_023_file, 0, 0, 1
gisinimp_023_2		 ftgen 0, 0, 0, 1, gSsinimp_023_file, 0, 0, 2
;---
gSsinimp_024_file 	 init "../samples/opcode/sinimp/sinimp-024.wav"
gisinimp_024_1		 ftgen 0, 0, 0, 1, gSsinimp_024_file, 0, 0, 1
gisinimp_024_2		 ftgen 0, 0, 0, 1, gSsinimp_024_file, 0, 0, 2
;---
gSsinimp_025_file 	 init "../samples/opcode/sinimp/sinimp-025.wav"
gisinimp_025_1		 ftgen 0, 0, 0, 1, gSsinimp_025_file, 0, 0, 1
gisinimp_025_2		 ftgen 0, 0, 0, 1, gSsinimp_025_file, 0, 0, 2
;---
gSsinimp_026_file 	 init "../samples/opcode/sinimp/sinimp-026.wav"
gisinimp_026_1		 ftgen 0, 0, 0, 1, gSsinimp_026_file, 0, 0, 1
gisinimp_026_2		 ftgen 0, 0, 0, 1, gSsinimp_026_file, 0, 0, 2
;---
gSsinimp_027_file 	 init "../samples/opcode/sinimp/sinimp-027.wav"
gisinimp_027_1		 ftgen 0, 0, 0, 1, gSsinimp_027_file, 0, 0, 1
gisinimp_027_2		 ftgen 0, 0, 0, 1, gSsinimp_027_file, 0, 0, 2
;---
gSsinimp_028_file 	 init "../samples/opcode/sinimp/sinimp-028.wav"
gisinimp_028_1		 ftgen 0, 0, 0, 1, gSsinimp_028_file, 0, 0, 1
gisinimp_028_2		 ftgen 0, 0, 0, 1, gSsinimp_028_file, 0, 0, 2
;---
gSsinimp_029_file 	 init "../samples/opcode/sinimp/sinimp-029.wav"
gisinimp_029_1		 ftgen 0, 0, 0, 1, gSsinimp_029_file, 0, 0, 1
gisinimp_029_2		 ftgen 0, 0, 0, 1, gSsinimp_029_file, 0, 0, 2
;---
gSsinimp_030_file 	 init "../samples/opcode/sinimp/sinimp-030.wav"
gisinimp_030_1		 ftgen 0, 0, 0, 1, gSsinimp_030_file, 0, 0, 1
gisinimp_030_2		 ftgen 0, 0, 0, 1, gSsinimp_030_file, 0, 0, 2
;---
gSsinimp_031_file 	 init "../samples/opcode/sinimp/sinimp-031.wav"
gisinimp_031_1		 ftgen 0, 0, 0, 1, gSsinimp_031_file, 0, 0, 1
gisinimp_031_2		 ftgen 0, 0, 0, 1, gSsinimp_031_file, 0, 0, 2
;---
gSsinimp_032_file 	 init "../samples/opcode/sinimp/sinimp-032.wav"
gisinimp_032_1		 ftgen 0, 0, 0, 1, gSsinimp_032_file, 0, 0, 1
gisinimp_032_2		 ftgen 0, 0, 0, 1, gSsinimp_032_file, 0, 0, 2
;---
gSsinimp_033_file 	 init "../samples/opcode/sinimp/sinimp-033.wav"
gisinimp_033_1		 ftgen 0, 0, 0, 1, gSsinimp_033_file, 0, 0, 1
gisinimp_033_2		 ftgen 0, 0, 0, 1, gSsinimp_033_file, 0, 0, 2
;---
gSsinimp_034_file 	 init "../samples/opcode/sinimp/sinimp-034.wav"
gisinimp_034_1		 ftgen 0, 0, 0, 1, gSsinimp_034_file, 0, 0, 1
gisinimp_034_2		 ftgen 0, 0, 0, 1, gSsinimp_034_file, 0, 0, 2
;---
gSsinimp_035_file 	 init "../samples/opcode/sinimp/sinimp-035.wav"
gisinimp_035_1		 ftgen 0, 0, 0, 1, gSsinimp_035_file, 0, 0, 1
gisinimp_035_2		 ftgen 0, 0, 0, 1, gSsinimp_035_file, 0, 0, 2
;---
gSsinimp_036_file 	 init "../samples/opcode/sinimp/sinimp-036.wav"
gisinimp_036_1		 ftgen 0, 0, 0, 1, gSsinimp_036_file, 0, 0, 1
gisinimp_036_2		 ftgen 0, 0, 0, 1, gSsinimp_036_file, 0, 0, 2
;---
gSsinimp_037_file 	 init "../samples/opcode/sinimp/sinimp-037.wav"
gisinimp_037_1		 ftgen 0, 0, 0, 1, gSsinimp_037_file, 0, 0, 1
gisinimp_037_2		 ftgen 0, 0, 0, 1, gSsinimp_037_file, 0, 0, 2
;---
gSsinimp_038_file 	 init "../samples/opcode/sinimp/sinimp-038.wav"
gisinimp_038_1		 ftgen 0, 0, 0, 1, gSsinimp_038_file, 0, 0, 1
gisinimp_038_2		 ftgen 0, 0, 0, 1, gSsinimp_038_file, 0, 0, 2
;---
gSsinimp_039_file 	 init "../samples/opcode/sinimp/sinimp-039.wav"
gisinimp_039_1		 ftgen 0, 0, 0, 1, gSsinimp_039_file, 0, 0, 1
gisinimp_039_2		 ftgen 0, 0, 0, 1, gSsinimp_039_file, 0, 0, 2
;---
gSsinimp_040_file 	 init "../samples/opcode/sinimp/sinimp-040.wav"
gisinimp_040_1		 ftgen 0, 0, 0, 1, gSsinimp_040_file, 0, 0, 1
gisinimp_040_2		 ftgen 0, 0, 0, 1, gSsinimp_040_file, 0, 0, 2
;---
gSsinimp_041_file 	 init "../samples/opcode/sinimp/sinimp-041.wav"
gisinimp_041_1		 ftgen 0, 0, 0, 1, gSsinimp_041_file, 0, 0, 1
gisinimp_041_2		 ftgen 0, 0, 0, 1, gSsinimp_041_file, 0, 0, 2
;---
gSsinimp_042_file 	 init "../samples/opcode/sinimp/sinimp-042.wav"
gisinimp_042_1		 ftgen 0, 0, 0, 1, gSsinimp_042_file, 0, 0, 1
gisinimp_042_2		 ftgen 0, 0, 0, 1, gSsinimp_042_file, 0, 0, 2
;---
gSsinimp_043_file 	 init "../samples/opcode/sinimp/sinimp-043.wav"
gisinimp_043_1		 ftgen 0, 0, 0, 1, gSsinimp_043_file, 0, 0, 1
gisinimp_043_2		 ftgen 0, 0, 0, 1, gSsinimp_043_file, 0, 0, 2
;---
gSsinimp_044_file 	 init "../samples/opcode/sinimp/sinimp-044.wav"
gisinimp_044_1		 ftgen 0, 0, 0, 1, gSsinimp_044_file, 0, 0, 1
gisinimp_044_2		 ftgen 0, 0, 0, 1, gSsinimp_044_file, 0, 0, 2
;---
gSsinimp_045_file 	 init "../samples/opcode/sinimp/sinimp-045.wav"
gisinimp_045_1		 ftgen 0, 0, 0, 1, gSsinimp_045_file, 0, 0, 1
gisinimp_045_2		 ftgen 0, 0, 0, 1, gSsinimp_045_file, 0, 0, 2
;---
gSsinimp_046_file 	 init "../samples/opcode/sinimp/sinimp-046.wav"
gisinimp_046_1		 ftgen 0, 0, 0, 1, gSsinimp_046_file, 0, 0, 1
gisinimp_046_2		 ftgen 0, 0, 0, 1, gSsinimp_046_file, 0, 0, 2
;---
gSsinimp_047_file 	 init "../samples/opcode/sinimp/sinimp-047.wav"
gisinimp_047_1		 ftgen 0, 0, 0, 1, gSsinimp_047_file, 0, 0, 1
gisinimp_047_2		 ftgen 0, 0, 0, 1, gSsinimp_047_file, 0, 0, 2
;---
gSsinimp_048_file 	 init "../samples/opcode/sinimp/sinimp-048.wav"
gisinimp_048_1		 ftgen 0, 0, 0, 1, gSsinimp_048_file, 0, 0, 1
gisinimp_048_2		 ftgen 0, 0, 0, 1, gSsinimp_048_file, 0, 0, 2
;---
gSsinimp_049_file 	 init "../samples/opcode/sinimp/sinimp-049.wav"
gisinimp_049_1		 ftgen 0, 0, 0, 1, gSsinimp_049_file, 0, 0, 1
gisinimp_049_2		 ftgen 0, 0, 0, 1, gSsinimp_049_file, 0, 0, 2
;---
gSsinimp_050_file 	 init "../samples/opcode/sinimp/sinimp-050.wav"
gisinimp_050_1		 ftgen 0, 0, 0, 1, gSsinimp_050_file, 0, 0, 1
gisinimp_050_2		 ftgen 0, 0, 0, 1, gSsinimp_050_file, 0, 0, 2
;---
gSsinimp_051_file 	 init "../samples/opcode/sinimp/sinimp-051.wav"
gisinimp_051_1		 ftgen 0, 0, 0, 1, gSsinimp_051_file, 0, 0, 1
gisinimp_051_2		 ftgen 0, 0, 0, 1, gSsinimp_051_file, 0, 0, 2
;---
gSsinimp_052_file 	 init "../samples/opcode/sinimp/sinimp-052.wav"
gisinimp_052_1		 ftgen 0, 0, 0, 1, gSsinimp_052_file, 0, 0, 1
gisinimp_052_2		 ftgen 0, 0, 0, 1, gSsinimp_052_file, 0, 0, 2
;---
gSsinimp_053_file 	 init "../samples/opcode/sinimp/sinimp-053.wav"
gisinimp_053_1		 ftgen 0, 0, 0, 1, gSsinimp_053_file, 0, 0, 1
gisinimp_053_2		 ftgen 0, 0, 0, 1, gSsinimp_053_file, 0, 0, 2
;---
gSsinimp_054_file 	 init "../samples/opcode/sinimp/sinimp-054.wav"
gisinimp_054_1		 ftgen 0, 0, 0, 1, gSsinimp_054_file, 0, 0, 1
gisinimp_054_2		 ftgen 0, 0, 0, 1, gSsinimp_054_file, 0, 0, 2
;---
gSsinimp_055_file 	 init "../samples/opcode/sinimp/sinimp-055.wav"
gisinimp_055_1		 ftgen 0, 0, 0, 1, gSsinimp_055_file, 0, 0, 1
gisinimp_055_2		 ftgen 0, 0, 0, 1, gSsinimp_055_file, 0, 0, 2
;---
gSsinimp_056_file 	 init "../samples/opcode/sinimp/sinimp-056.wav"
gisinimp_056_1		 ftgen 0, 0, 0, 1, gSsinimp_056_file, 0, 0, 1
gisinimp_056_2		 ftgen 0, 0, 0, 1, gSsinimp_056_file, 0, 0, 2
;---
gSsinimp_057_file 	 init "../samples/opcode/sinimp/sinimp-057.wav"
gisinimp_057_1		 ftgen 0, 0, 0, 1, gSsinimp_057_file, 0, 0, 1
gisinimp_057_2		 ftgen 0, 0, 0, 1, gSsinimp_057_file, 0, 0, 2
;---
gSsinimp_058_file 	 init "../samples/opcode/sinimp/sinimp-058.wav"
gisinimp_058_1		 ftgen 0, 0, 0, 1, gSsinimp_058_file, 0, 0, 1
gisinimp_058_2		 ftgen 0, 0, 0, 1, gSsinimp_058_file, 0, 0, 2
;---
gSsinimp_059_file 	 init "../samples/opcode/sinimp/sinimp-059.wav"
gisinimp_059_1		 ftgen 0, 0, 0, 1, gSsinimp_059_file, 0, 0, 1
gisinimp_059_2		 ftgen 0, 0, 0, 1, gSsinimp_059_file, 0, 0, 2
;---
gSsinimp_060_file 	 init "../samples/opcode/sinimp/sinimp-060.wav"
gisinimp_060_1		 ftgen 0, 0, 0, 1, gSsinimp_060_file, 0, 0, 1
gisinimp_060_2		 ftgen 0, 0, 0, 1, gSsinimp_060_file, 0, 0, 2
;---
gSsinimp_061_file 	 init "../samples/opcode/sinimp/sinimp-061.wav"
gisinimp_061_1		 ftgen 0, 0, 0, 1, gSsinimp_061_file, 0, 0, 1
gisinimp_061_2		 ftgen 0, 0, 0, 1, gSsinimp_061_file, 0, 0, 2
;---
gSsinimp_062_file 	 init "../samples/opcode/sinimp/sinimp-062.wav"
gisinimp_062_1		 ftgen 0, 0, 0, 1, gSsinimp_062_file, 0, 0, 1
gisinimp_062_2		 ftgen 0, 0, 0, 1, gSsinimp_062_file, 0, 0, 2
;---
gSsinimp_063_file 	 init "../samples/opcode/sinimp/sinimp-063.wav"
gisinimp_063_1		 ftgen 0, 0, 0, 1, gSsinimp_063_file, 0, 0, 1
gisinimp_063_2		 ftgen 0, 0, 0, 1, gSsinimp_063_file, 0, 0, 2
;---
gSsinimp_064_file 	 init "../samples/opcode/sinimp/sinimp-064.wav"
gisinimp_064_1		 ftgen 0, 0, 0, 1, gSsinimp_064_file, 0, 0, 1
gisinimp_064_2		 ftgen 0, 0, 0, 1, gSsinimp_064_file, 0, 0, 2
;---
gSsinimp_065_file 	 init "../samples/opcode/sinimp/sinimp-065.wav"
gisinimp_065_1		 ftgen 0, 0, 0, 1, gSsinimp_065_file, 0, 0, 1
gisinimp_065_2		 ftgen 0, 0, 0, 1, gSsinimp_065_file, 0, 0, 2
;---
gSsinimp_066_file 	 init "../samples/opcode/sinimp/sinimp-066.wav"
gisinimp_066_1		 ftgen 0, 0, 0, 1, gSsinimp_066_file, 0, 0, 1
gisinimp_066_2		 ftgen 0, 0, 0, 1, gSsinimp_066_file, 0, 0, 2
;---
gSsinimp_067_file 	 init "../samples/opcode/sinimp/sinimp-067.wav"
gisinimp_067_1		 ftgen 0, 0, 0, 1, gSsinimp_067_file, 0, 0, 1
gisinimp_067_2		 ftgen 0, 0, 0, 1, gSsinimp_067_file, 0, 0, 2
;---
gSsinimp_068_file 	 init "../samples/opcode/sinimp/sinimp-068.wav"
gisinimp_068_1		 ftgen 0, 0, 0, 1, gSsinimp_068_file, 0, 0, 1
gisinimp_068_2		 ftgen 0, 0, 0, 1, gSsinimp_068_file, 0, 0, 2
;---
gSsinimp_069_file 	 init "../samples/opcode/sinimp/sinimp-069.wav"
gisinimp_069_1		 ftgen 0, 0, 0, 1, gSsinimp_069_file, 0, 0, 1
gisinimp_069_2		 ftgen 0, 0, 0, 1, gSsinimp_069_file, 0, 0, 2
;---
gSsinimp_070_file 	 init "../samples/opcode/sinimp/sinimp-070.wav"
gisinimp_070_1		 ftgen 0, 0, 0, 1, gSsinimp_070_file, 0, 0, 1
gisinimp_070_2		 ftgen 0, 0, 0, 1, gSsinimp_070_file, 0, 0, 2
;---
gSsinimp_071_file 	 init "../samples/opcode/sinimp/sinimp-071.wav"
gisinimp_071_1		 ftgen 0, 0, 0, 1, gSsinimp_071_file, 0, 0, 1
gisinimp_071_2		 ftgen 0, 0, 0, 1, gSsinimp_071_file, 0, 0, 2
;---
gSsinimp_072_file 	 init "../samples/opcode/sinimp/sinimp-072.wav"
gisinimp_072_1		 ftgen 0, 0, 0, 1, gSsinimp_072_file, 0, 0, 1
gisinimp_072_2		 ftgen 0, 0, 0, 1, gSsinimp_072_file, 0, 0, 2
;---
gSsinimp_073_file 	 init "../samples/opcode/sinimp/sinimp-073.wav"
gisinimp_073_1		 ftgen 0, 0, 0, 1, gSsinimp_073_file, 0, 0, 1
gisinimp_073_2		 ftgen 0, 0, 0, 1, gSsinimp_073_file, 0, 0, 2
;---
gSsinimp_074_file 	 init "../samples/opcode/sinimp/sinimp-074.wav"
gisinimp_074_1		 ftgen 0, 0, 0, 1, gSsinimp_074_file, 0, 0, 1
gisinimp_074_2		 ftgen 0, 0, 0, 1, gSsinimp_074_file, 0, 0, 2
;---
gSsinimp_075_file 	 init "../samples/opcode/sinimp/sinimp-075.wav"
gisinimp_075_1		 ftgen 0, 0, 0, 1, gSsinimp_075_file, 0, 0, 1
gisinimp_075_2		 ftgen 0, 0, 0, 1, gSsinimp_075_file, 0, 0, 2
;---
gSsinimp_076_file 	 init "../samples/opcode/sinimp/sinimp-076.wav"
gisinimp_076_1		 ftgen 0, 0, 0, 1, gSsinimp_076_file, 0, 0, 1
gisinimp_076_2		 ftgen 0, 0, 0, 1, gSsinimp_076_file, 0, 0, 2
;---
gSsinimp_077_file 	 init "../samples/opcode/sinimp/sinimp-077.wav"
gisinimp_077_1		 ftgen 0, 0, 0, 1, gSsinimp_077_file, 0, 0, 1
gisinimp_077_2		 ftgen 0, 0, 0, 1, gSsinimp_077_file, 0, 0, 2
;---
gSsinimp_078_file 	 init "../samples/opcode/sinimp/sinimp-078.wav"
gisinimp_078_1		 ftgen 0, 0, 0, 1, gSsinimp_078_file, 0, 0, 1
gisinimp_078_2		 ftgen 0, 0, 0, 1, gSsinimp_078_file, 0, 0, 2
;---
gSsinimp_079_file 	 init "../samples/opcode/sinimp/sinimp-079.wav"
gisinimp_079_1		 ftgen 0, 0, 0, 1, gSsinimp_079_file, 0, 0, 1
gisinimp_079_2		 ftgen 0, 0, 0, 1, gSsinimp_079_file, 0, 0, 2
;---
gSsinimp_080_file 	 init "../samples/opcode/sinimp/sinimp-080.wav"
gisinimp_080_1		 ftgen 0, 0, 0, 1, gSsinimp_080_file, 0, 0, 1
gisinimp_080_2		 ftgen 0, 0, 0, 1, gSsinimp_080_file, 0, 0, 2
;---
gSsinimp_081_file 	 init "../samples/opcode/sinimp/sinimp-081.wav"
gisinimp_081_1		 ftgen 0, 0, 0, 1, gSsinimp_081_file, 0, 0, 1
gisinimp_081_2		 ftgen 0, 0, 0, 1, gSsinimp_081_file, 0, 0, 2
;---
gSsinimp_082_file 	 init "../samples/opcode/sinimp/sinimp-082.wav"
gisinimp_082_1		 ftgen 0, 0, 0, 1, gSsinimp_082_file, 0, 0, 1
gisinimp_082_2		 ftgen 0, 0, 0, 1, gSsinimp_082_file, 0, 0, 2
;---
gSsinimp_083_file 	 init "../samples/opcode/sinimp/sinimp-083.wav"
gisinimp_083_1		 ftgen 0, 0, 0, 1, gSsinimp_083_file, 0, 0, 1
gisinimp_083_2		 ftgen 0, 0, 0, 1, gSsinimp_083_file, 0, 0, 2
;---
gSsinimp_084_file 	 init "../samples/opcode/sinimp/sinimp-084.wav"
gisinimp_084_1		 ftgen 0, 0, 0, 1, gSsinimp_084_file, 0, 0, 1
gisinimp_084_2		 ftgen 0, 0, 0, 1, gSsinimp_084_file, 0, 0, 2
;---
gSsinimp_085_file 	 init "../samples/opcode/sinimp/sinimp-085.wav"
gisinimp_085_1		 ftgen 0, 0, 0, 1, gSsinimp_085_file, 0, 0, 1
gisinimp_085_2		 ftgen 0, 0, 0, 1, gSsinimp_085_file, 0, 0, 2
;---
gSsinimp_086_file 	 init "../samples/opcode/sinimp/sinimp-086.wav"
gisinimp_086_1		 ftgen 0, 0, 0, 1, gSsinimp_086_file, 0, 0, 1
gisinimp_086_2		 ftgen 0, 0, 0, 1, gSsinimp_086_file, 0, 0, 2
;---
gSsinimp_087_file 	 init "../samples/opcode/sinimp/sinimp-087.wav"
gisinimp_087_1		 ftgen 0, 0, 0, 1, gSsinimp_087_file, 0, 0, 1
gisinimp_087_2		 ftgen 0, 0, 0, 1, gSsinimp_087_file, 0, 0, 2
;---
gSsinimp_088_file 	 init "../samples/opcode/sinimp/sinimp-088.wav"
gisinimp_088_1		 ftgen 0, 0, 0, 1, gSsinimp_088_file, 0, 0, 1
gisinimp_088_2		 ftgen 0, 0, 0, 1, gSsinimp_088_file, 0, 0, 2
;---
gSsinimp_089_file 	 init "../samples/opcode/sinimp/sinimp-089.wav"
gisinimp_089_1		 ftgen 0, 0, 0, 1, gSsinimp_089_file, 0, 0, 1
gisinimp_089_2		 ftgen 0, 0, 0, 1, gSsinimp_089_file, 0, 0, 2
;---
gSsinimp_090_file 	 init "../samples/opcode/sinimp/sinimp-090.wav"
gisinimp_090_1		 ftgen 0, 0, 0, 1, gSsinimp_090_file, 0, 0, 1
gisinimp_090_2		 ftgen 0, 0, 0, 1, gSsinimp_090_file, 0, 0, 2
;---
gSsinimp_091_file 	 init "../samples/opcode/sinimp/sinimp-091.wav"
gisinimp_091_1		 ftgen 0, 0, 0, 1, gSsinimp_091_file, 0, 0, 1
gisinimp_091_2		 ftgen 0, 0, 0, 1, gSsinimp_091_file, 0, 0, 2
;---
gSsinimp_092_file 	 init "../samples/opcode/sinimp/sinimp-092.wav"
gisinimp_092_1		 ftgen 0, 0, 0, 1, gSsinimp_092_file, 0, 0, 1
gisinimp_092_2		 ftgen 0, 0, 0, 1, gSsinimp_092_file, 0, 0, 2
;---
gSsinimp_093_file 	 init "../samples/opcode/sinimp/sinimp-093.wav"
gisinimp_093_1		 ftgen 0, 0, 0, 1, gSsinimp_093_file, 0, 0, 1
gisinimp_093_2		 ftgen 0, 0, 0, 1, gSsinimp_093_file, 0, 0, 2
;---
gSsinimp_094_file 	 init "../samples/opcode/sinimp/sinimp-094.wav"
gisinimp_094_1		 ftgen 0, 0, 0, 1, gSsinimp_094_file, 0, 0, 1
gisinimp_094_2		 ftgen 0, 0, 0, 1, gSsinimp_094_file, 0, 0, 2
;---
gSsinimp_095_file 	 init "../samples/opcode/sinimp/sinimp-095.wav"
gisinimp_095_1		 ftgen 0, 0, 0, 1, gSsinimp_095_file, 0, 0, 1
gisinimp_095_2		 ftgen 0, 0, 0, 1, gSsinimp_095_file, 0, 0, 2
;---
gSsinimp_096_file 	 init "../samples/opcode/sinimp/sinimp-096.wav"
gisinimp_096_1		 ftgen 0, 0, 0, 1, gSsinimp_096_file, 0, 0, 1
gisinimp_096_2		 ftgen 0, 0, 0, 1, gSsinimp_096_file, 0, 0, 2
;---
gSsinimp_097_file 	 init "../samples/opcode/sinimp/sinimp-097.wav"
gisinimp_097_1		 ftgen 0, 0, 0, 1, gSsinimp_097_file, 0, 0, 1
gisinimp_097_2		 ftgen 0, 0, 0, 1, gSsinimp_097_file, 0, 0, 2
;---
gSsinimp_098_file 	 init "../samples/opcode/sinimp/sinimp-098.wav"
gisinimp_098_1		 ftgen 0, 0, 0, 1, gSsinimp_098_file, 0, 0, 1
gisinimp_098_2		 ftgen 0, 0, 0, 1, gSsinimp_098_file, 0, 0, 2
;---
gisinimp_sonvs[]			fillarray	gisinimp_000_1, gisinimp_000_2, gisinimp_001_1, gisinimp_001_2, gisinimp_002_1, gisinimp_002_2, gisinimp_003_1, gisinimp_003_2, gisinimp_004_1, gisinimp_004_2, gisinimp_005_1, gisinimp_005_2, gisinimp_006_1, gisinimp_006_2, gisinimp_007_1, gisinimp_007_2, gisinimp_008_1, gisinimp_008_2, gisinimp_009_1, gisinimp_009_2, gisinimp_010_1, gisinimp_010_2, gisinimp_011_1, gisinimp_011_2, gisinimp_012_1, gisinimp_012_2, gisinimp_013_1, gisinimp_013_2, gisinimp_014_1, gisinimp_014_2, gisinimp_015_1, gisinimp_015_2, gisinimp_016_1, gisinimp_016_2, gisinimp_017_1, gisinimp_017_2, gisinimp_018_1, gisinimp_018_2, gisinimp_019_1, gisinimp_019_2, gisinimp_020_1, gisinimp_020_2, gisinimp_021_1, gisinimp_021_2, gisinimp_022_1, gisinimp_022_2, gisinimp_023_1, gisinimp_023_2, gisinimp_024_1, gisinimp_024_2, gisinimp_025_1, gisinimp_025_2, gisinimp_026_1, gisinimp_026_2, gisinimp_027_1, gisinimp_027_2, gisinimp_028_1, gisinimp_028_2, gisinimp_029_1, gisinimp_029_2, gisinimp_030_1, gisinimp_030_2, gisinimp_031_1, gisinimp_031_2, gisinimp_032_1, gisinimp_032_2, gisinimp_033_1, gisinimp_033_2, gisinimp_034_1, gisinimp_034_2, gisinimp_035_1, gisinimp_035_2, gisinimp_036_1, gisinimp_036_2, gisinimp_037_1, gisinimp_037_2, gisinimp_038_1, gisinimp_038_2, gisinimp_039_1, gisinimp_039_2, gisinimp_040_1, gisinimp_040_2, gisinimp_041_1, gisinimp_041_2, gisinimp_042_1, gisinimp_042_2, gisinimp_043_1, gisinimp_043_2, gisinimp_044_1, gisinimp_044_2, gisinimp_045_1, gisinimp_045_2, gisinimp_046_1, gisinimp_046_2, gisinimp_047_1, gisinimp_047_2, gisinimp_048_1, gisinimp_048_2, gisinimp_049_1, gisinimp_049_2, gisinimp_050_1, gisinimp_050_2, gisinimp_051_1, gisinimp_051_2, gisinimp_052_1, gisinimp_052_2, gisinimp_053_1, gisinimp_053_2, gisinimp_054_1, gisinimp_054_2, gisinimp_055_1, gisinimp_055_2, gisinimp_056_1, gisinimp_056_2, gisinimp_057_1, gisinimp_057_2, gisinimp_058_1, gisinimp_058_2, gisinimp_059_1, gisinimp_059_2, gisinimp_060_1, gisinimp_060_2, gisinimp_061_1, gisinimp_061_2, gisinimp_062_1, gisinimp_062_2, gisinimp_063_1, gisinimp_063_2, gisinimp_064_1, gisinimp_064_2, gisinimp_065_1, gisinimp_065_2, gisinimp_066_1, gisinimp_066_2, gisinimp_067_1, gisinimp_067_2, gisinimp_068_1, gisinimp_068_2, gisinimp_069_1, gisinimp_069_2, gisinimp_070_1, gisinimp_070_2, gisinimp_071_1, gisinimp_071_2, gisinimp_072_1, gisinimp_072_2, gisinimp_073_1, gisinimp_073_2, gisinimp_074_1, gisinimp_074_2, gisinimp_075_1, gisinimp_075_2, gisinimp_076_1, gisinimp_076_2, gisinimp_077_1, gisinimp_077_2, gisinimp_078_1, gisinimp_078_2, gisinimp_079_1, gisinimp_079_2, gisinimp_080_1, gisinimp_080_2, gisinimp_081_1, gisinimp_081_2, gisinimp_082_1, gisinimp_082_2, gisinimp_083_1, gisinimp_083_2, gisinimp_084_1, gisinimp_084_2, gisinimp_085_1, gisinimp_085_2, gisinimp_086_1, gisinimp_086_2, gisinimp_087_1, gisinimp_087_2, gisinimp_088_1, gisinimp_088_2, gisinimp_089_1, gisinimp_089_2, gisinimp_090_1, gisinimp_090_2, gisinimp_091_1, gisinimp_091_2, gisinimp_092_1, gisinimp_092_2, gisinimp_093_1, gisinimp_093_2, gisinimp_094_1, gisinimp_094_2, gisinimp_095_1, gisinimp_095_2, gisinimp_096_1, gisinimp_096_2, gisinimp_097_1, gisinimp_097_2, gisinimp_098_1, gisinimp_098_2
gksinimp_time		init 16
gksinimp_off		init .005
gksinimp_dur		init 1
gksinimp_sonvs		init 1
gisinimp_len		init lenarray(gisinimp_sonvs)/2

;------------------

	instr sinimp

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "sinimp"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gksinimp_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gksinimp_sonvs%(gisinimp_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gisinimp_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "sinimp"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gksinimp_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gisinimp_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gisinimp_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "sinimp"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gksinimp_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gksinimp_sonvs%(gisinimp_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gisinimp_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	sinimp, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "sinimp"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksinimp_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksinimp_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	sinimp, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "sinimp"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksinimp_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksinimp_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSsix_file	init "../samples/opcode/six.wav"

gisix1	ftgen 0, 0, 0, 1, gSsix_file, 0, 0, 1
gisix2	ftgen 0, 0, 0, 1, gSsix_file, 0, 0, 2

gksix_time		init 16
gksix_off		init .005
gksix_dur		init 1
;------------------

	instr six

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "six"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gksix_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisix1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "six"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gksix_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gisix1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "six"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gksix_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisix1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	six, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "six"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksix_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksix_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	six, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "six"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksix_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksix_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSsix2_file	init "../samples/opcode/six2.wav"

gisix21	ftgen 0, 0, 0, 1, gSsix2_file, 0, 0, 1
gisix22	ftgen 0, 0, 0, 1, gSsix2_file, 0, 0, 2

gksix2_time		init 16
gksix2_off		init .005
gksix2_dur		init 1
;------------------

	instr six2

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "six2"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gksix2_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisix21+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "six2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gksix2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gisix21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "six2"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gksix2_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisix21+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	six2, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "six2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksix2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksix2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	six2, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "six2"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksix2_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksix2_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSsixcorrect_file	init "../samples/opcode/sixcorrect.wav"

gisixcorrect1	ftgen 0, 0, 0, 1, gSsixcorrect_file, 0, 0, 1
gisixcorrect2	ftgen 0, 0, 0, 1, gSsixcorrect_file, 0, 0, 2

gksixcorrect_time		init 16
gksixcorrect_off		init .005
gksixcorrect_dur		init 1
;------------------

	instr sixcorrect

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "sixcorrect"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gksixcorrect_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisixcorrect1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "sixcorrect"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gksixcorrect_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gisixcorrect1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "sixcorrect"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gksixcorrect_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisixcorrect1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	sixcorrect, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "sixcorrect"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksixcorrect_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksixcorrect_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	sixcorrect, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "sixcorrect"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksixcorrect_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksixcorrect_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSsixspectrumsynth_file	init "../samples/opcode/sixspectrumsynth.wav"

gisixspectrumsynth1	ftgen 0, 0, 0, 1, gSsixspectrumsynth_file, 0, 0, 1
gisixspectrumsynth2	ftgen 0, 0, 0, 1, gSsixspectrumsynth_file, 0, 0, 2

gksixspectrumsynth_time		init 16
gksixspectrumsynth_off		init .005
gksixspectrumsynth_dur		init 1
;------------------

	instr sixspectrumsynth

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "sixspectrumsynth"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gksixspectrumsynth_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisixspectrumsynth1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "sixspectrumsynth"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gksixspectrumsynth_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gisixspectrumsynth1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "sixspectrumsynth"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gksixspectrumsynth_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisixspectrumsynth1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	sixspectrumsynth, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "sixspectrumsynth"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksixspectrumsynth_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksixspectrumsynth_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	sixspectrumsynth, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "sixspectrumsynth"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksixspectrumsynth_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksixspectrumsynth_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSsophie1_file	init "../samples/opcode/sophie1.wav"

gisophie11	ftgen 0, 0, 0, 1, gSsophie1_file, 0, 0, 1
gisophie12	ftgen 0, 0, 0, 1, gSsophie1_file, 0, 0, 2

gksophie1_time		init 16
gksophie1_off		init .005
gksophie1_dur		init 1
;------------------

	instr sophie1

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "sophie1"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gksophie1_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisophie11+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "sophie1"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gksophie1_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gisophie11+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "sophie1"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gksophie1_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisophie11+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	sophie1, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "sophie1"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksophie1_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksophie1_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	sophie1, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "sophie1"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksophie1_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksophie1_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSspace_00_file 	 init "../samples/opcode/space/space-00.wav"
gispace_00_1		 ftgen 0, 0, 0, 1, gSspace_00_file, 0, 0, 1
gispace_00_2		 ftgen 0, 0, 0, 1, gSspace_00_file, 0, 0, 2
;---
gSspace_01_file 	 init "../samples/opcode/space/space-01.wav"
gispace_01_1		 ftgen 0, 0, 0, 1, gSspace_01_file, 0, 0, 1
gispace_01_2		 ftgen 0, 0, 0, 1, gSspace_01_file, 0, 0, 2
;---
gSspace_02_file 	 init "../samples/opcode/space/space-02.wav"
gispace_02_1		 ftgen 0, 0, 0, 1, gSspace_02_file, 0, 0, 1
gispace_02_2		 ftgen 0, 0, 0, 1, gSspace_02_file, 0, 0, 2
;---
gSspace_03_file 	 init "../samples/opcode/space/space-03.wav"
gispace_03_1		 ftgen 0, 0, 0, 1, gSspace_03_file, 0, 0, 1
gispace_03_2		 ftgen 0, 0, 0, 1, gSspace_03_file, 0, 0, 2
;---
gSspace_04_file 	 init "../samples/opcode/space/space-04.wav"
gispace_04_1		 ftgen 0, 0, 0, 1, gSspace_04_file, 0, 0, 1
gispace_04_2		 ftgen 0, 0, 0, 1, gSspace_04_file, 0, 0, 2
;---
gSspace_05_file 	 init "../samples/opcode/space/space-05.wav"
gispace_05_1		 ftgen 0, 0, 0, 1, gSspace_05_file, 0, 0, 1
gispace_05_2		 ftgen 0, 0, 0, 1, gSspace_05_file, 0, 0, 2
;---
gSspace_06_file 	 init "../samples/opcode/space/space-06.wav"
gispace_06_1		 ftgen 0, 0, 0, 1, gSspace_06_file, 0, 0, 1
gispace_06_2		 ftgen 0, 0, 0, 1, gSspace_06_file, 0, 0, 2
;---
gSspace_07_file 	 init "../samples/opcode/space/space-07.wav"
gispace_07_1		 ftgen 0, 0, 0, 1, gSspace_07_file, 0, 0, 1
gispace_07_2		 ftgen 0, 0, 0, 1, gSspace_07_file, 0, 0, 2
;---
gSspace_08_file 	 init "../samples/opcode/space/space-08.wav"
gispace_08_1		 ftgen 0, 0, 0, 1, gSspace_08_file, 0, 0, 1
gispace_08_2		 ftgen 0, 0, 0, 1, gSspace_08_file, 0, 0, 2
;---
gSspace_09_file 	 init "../samples/opcode/space/space-09.wav"
gispace_09_1		 ftgen 0, 0, 0, 1, gSspace_09_file, 0, 0, 1
gispace_09_2		 ftgen 0, 0, 0, 1, gSspace_09_file, 0, 0, 2
;---
gSspace_10_file 	 init "../samples/opcode/space/space-10.wav"
gispace_10_1		 ftgen 0, 0, 0, 1, gSspace_10_file, 0, 0, 1
gispace_10_2		 ftgen 0, 0, 0, 1, gSspace_10_file, 0, 0, 2
;---
gSspace_11_file 	 init "../samples/opcode/space/space-11.wav"
gispace_11_1		 ftgen 0, 0, 0, 1, gSspace_11_file, 0, 0, 1
gispace_11_2		 ftgen 0, 0, 0, 1, gSspace_11_file, 0, 0, 2
;---
gSspace_12_file 	 init "../samples/opcode/space/space-12.wav"
gispace_12_1		 ftgen 0, 0, 0, 1, gSspace_12_file, 0, 0, 1
gispace_12_2		 ftgen 0, 0, 0, 1, gSspace_12_file, 0, 0, 2
;---
gSspace_13_file 	 init "../samples/opcode/space/space-13.wav"
gispace_13_1		 ftgen 0, 0, 0, 1, gSspace_13_file, 0, 0, 1
gispace_13_2		 ftgen 0, 0, 0, 1, gSspace_13_file, 0, 0, 2
;---
gSspace_14_file 	 init "../samples/opcode/space/space-14.wav"
gispace_14_1		 ftgen 0, 0, 0, 1, gSspace_14_file, 0, 0, 1
gispace_14_2		 ftgen 0, 0, 0, 1, gSspace_14_file, 0, 0, 2
;---
gSspace_15_file 	 init "../samples/opcode/space/space-15.wav"
gispace_15_1		 ftgen 0, 0, 0, 1, gSspace_15_file, 0, 0, 1
gispace_15_2		 ftgen 0, 0, 0, 1, gSspace_15_file, 0, 0, 2
;---
gispace_sonvs[]			fillarray	gispace_00_1, gispace_00_2, gispace_01_1, gispace_01_2, gispace_02_1, gispace_02_2, gispace_03_1, gispace_03_2, gispace_04_1, gispace_04_2, gispace_05_1, gispace_05_2, gispace_06_1, gispace_06_2, gispace_07_1, gispace_07_2, gispace_08_1, gispace_08_2, gispace_09_1, gispace_09_2, gispace_10_1, gispace_10_2, gispace_11_1, gispace_11_2, gispace_12_1, gispace_12_2, gispace_13_1, gispace_13_2, gispace_14_1, gispace_14_2, gispace_15_1, gispace_15_2
gkspace_time		init 16
gkspace_off		init .005
gkspace_dur		init 1
gkspace_sonvs		init 1
gispace_len		init lenarray(gispace_sonvs)/2

;------------------

	instr space

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "space"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkspace_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkspace_sonvs%(gispace_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gispace_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "space"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkspace_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gispace_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gispace_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "space"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkspace_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkspace_sonvs%(gispace_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gispace_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	space, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "space"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkspace_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkspace_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	space, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "space"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkspace_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkspace_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSsyeq_file	init "../samples/opcode/syeq.wav"

gisyeq1	ftgen 0, 0, 0, 1, gSsyeq_file, 0, 0, 1
gisyeq2	ftgen 0, 0, 0, 1, gSsyeq_file, 0, 0, 2

gksyeq_time		init 16
gksyeq_off		init .005
gksyeq_dur		init 1
;------------------

	instr syeq

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "syeq"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gksyeq_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisyeq1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "syeq"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gksyeq_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gisyeq1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "syeq"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gksyeq_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gisyeq1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	syeq, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "syeq"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksyeq_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksyeq_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	syeq, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "syeq"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gksyeq_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gksyeq_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gStape_00_file 	 init "../samples/opcode/tape/tape-00.wav"
gitape_00_1		 ftgen 0, 0, 0, 1, gStape_00_file, 0, 0, 1
gitape_00_2		 ftgen 0, 0, 0, 1, gStape_00_file, 0, 0, 2
;---
gStape_01_file 	 init "../samples/opcode/tape/tape-01.wav"
gitape_01_1		 ftgen 0, 0, 0, 1, gStape_01_file, 0, 0, 1
gitape_01_2		 ftgen 0, 0, 0, 1, gStape_01_file, 0, 0, 2
;---
gStape_02_file 	 init "../samples/opcode/tape/tape-02.wav"
gitape_02_1		 ftgen 0, 0, 0, 1, gStape_02_file, 0, 0, 1
gitape_02_2		 ftgen 0, 0, 0, 1, gStape_02_file, 0, 0, 2
;---
gStape_03_file 	 init "../samples/opcode/tape/tape-03.wav"
gitape_03_1		 ftgen 0, 0, 0, 1, gStape_03_file, 0, 0, 1
gitape_03_2		 ftgen 0, 0, 0, 1, gStape_03_file, 0, 0, 2
;---
gStape_04_file 	 init "../samples/opcode/tape/tape-04.wav"
gitape_04_1		 ftgen 0, 0, 0, 1, gStape_04_file, 0, 0, 1
gitape_04_2		 ftgen 0, 0, 0, 1, gStape_04_file, 0, 0, 2
;---
gStape_05_file 	 init "../samples/opcode/tape/tape-05.wav"
gitape_05_1		 ftgen 0, 0, 0, 1, gStape_05_file, 0, 0, 1
gitape_05_2		 ftgen 0, 0, 0, 1, gStape_05_file, 0, 0, 2
;---
gStape_06_file 	 init "../samples/opcode/tape/tape-06.wav"
gitape_06_1		 ftgen 0, 0, 0, 1, gStape_06_file, 0, 0, 1
gitape_06_2		 ftgen 0, 0, 0, 1, gStape_06_file, 0, 0, 2
;---
gStape_07_file 	 init "../samples/opcode/tape/tape-07.wav"
gitape_07_1		 ftgen 0, 0, 0, 1, gStape_07_file, 0, 0, 1
gitape_07_2		 ftgen 0, 0, 0, 1, gStape_07_file, 0, 0, 2
;---
gStape_08_file 	 init "../samples/opcode/tape/tape-08.wav"
gitape_08_1		 ftgen 0, 0, 0, 1, gStape_08_file, 0, 0, 1
gitape_08_2		 ftgen 0, 0, 0, 1, gStape_08_file, 0, 0, 2
;---
gStape_09_file 	 init "../samples/opcode/tape/tape-09.wav"
gitape_09_1		 ftgen 0, 0, 0, 1, gStape_09_file, 0, 0, 1
gitape_09_2		 ftgen 0, 0, 0, 1, gStape_09_file, 0, 0, 2
;---
gStape_10_file 	 init "../samples/opcode/tape/tape-10.wav"
gitape_10_1		 ftgen 0, 0, 0, 1, gStape_10_file, 0, 0, 1
gitape_10_2		 ftgen 0, 0, 0, 1, gStape_10_file, 0, 0, 2
;---
gStape_11_file 	 init "../samples/opcode/tape/tape-11.wav"
gitape_11_1		 ftgen 0, 0, 0, 1, gStape_11_file, 0, 0, 1
gitape_11_2		 ftgen 0, 0, 0, 1, gStape_11_file, 0, 0, 2
;---
gStape_12_file 	 init "../samples/opcode/tape/tape-12.wav"
gitape_12_1		 ftgen 0, 0, 0, 1, gStape_12_file, 0, 0, 1
gitape_12_2		 ftgen 0, 0, 0, 1, gStape_12_file, 0, 0, 2
;---
gStape_13_file 	 init "../samples/opcode/tape/tape-13.wav"
gitape_13_1		 ftgen 0, 0, 0, 1, gStape_13_file, 0, 0, 1
gitape_13_2		 ftgen 0, 0, 0, 1, gStape_13_file, 0, 0, 2
;---
gStape_14_file 	 init "../samples/opcode/tape/tape-14.wav"
gitape_14_1		 ftgen 0, 0, 0, 1, gStape_14_file, 0, 0, 1
gitape_14_2		 ftgen 0, 0, 0, 1, gStape_14_file, 0, 0, 2
;---
gStape_15_file 	 init "../samples/opcode/tape/tape-15.wav"
gitape_15_1		 ftgen 0, 0, 0, 1, gStape_15_file, 0, 0, 1
gitape_15_2		 ftgen 0, 0, 0, 1, gStape_15_file, 0, 0, 2
;---
gStape_16_file 	 init "../samples/opcode/tape/tape-16.wav"
gitape_16_1		 ftgen 0, 0, 0, 1, gStape_16_file, 0, 0, 1
gitape_16_2		 ftgen 0, 0, 0, 1, gStape_16_file, 0, 0, 2
;---
gitape_sonvs[]			fillarray	gitape_00_1, gitape_00_2, gitape_01_1, gitape_01_2, gitape_02_1, gitape_02_2, gitape_03_1, gitape_03_2, gitape_04_1, gitape_04_2, gitape_05_1, gitape_05_2, gitape_06_1, gitape_06_2, gitape_07_1, gitape_07_2, gitape_08_1, gitape_08_2, gitape_09_1, gitape_09_2, gitape_10_1, gitape_10_2, gitape_11_1, gitape_11_2, gitape_12_1, gitape_12_2, gitape_13_1, gitape_13_2, gitape_14_1, gitape_14_2, gitape_15_1, gitape_15_2, gitape_16_1, gitape_16_2
gktape_time		init 16
gktape_off		init .005
gktape_dur		init 1
gktape_sonvs		init 1
gitape_len		init lenarray(gitape_sonvs)/2

;------------------

	instr tape

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "tape"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gktape_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gktape_sonvs%(gitape_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gitape_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "tape"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gktape_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gitape_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gitape_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "tape"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gktape_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gktape_sonvs%(gitape_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gitape_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	tape, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "tape"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktape_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktape_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	tape, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "tape"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktape_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktape_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gStapein_00_file 	 init "../samples/opcode/tapein/tapein-00.wav"
gitapein_00_1		 ftgen 0, 0, 0, 1, gStapein_00_file, 0, 0, 1
gitapein_00_2		 ftgen 0, 0, 0, 1, gStapein_00_file, 0, 0, 2
;---
gStapein_01_file 	 init "../samples/opcode/tapein/tapein-01.wav"
gitapein_01_1		 ftgen 0, 0, 0, 1, gStapein_01_file, 0, 0, 1
gitapein_01_2		 ftgen 0, 0, 0, 1, gStapein_01_file, 0, 0, 2
;---
gStapein_02_file 	 init "../samples/opcode/tapein/tapein-02.wav"
gitapein_02_1		 ftgen 0, 0, 0, 1, gStapein_02_file, 0, 0, 1
gitapein_02_2		 ftgen 0, 0, 0, 1, gStapein_02_file, 0, 0, 2
;---
gStapein_03_file 	 init "../samples/opcode/tapein/tapein-03.wav"
gitapein_03_1		 ftgen 0, 0, 0, 1, gStapein_03_file, 0, 0, 1
gitapein_03_2		 ftgen 0, 0, 0, 1, gStapein_03_file, 0, 0, 2
;---
gStapein_04_file 	 init "../samples/opcode/tapein/tapein-04.wav"
gitapein_04_1		 ftgen 0, 0, 0, 1, gStapein_04_file, 0, 0, 1
gitapein_04_2		 ftgen 0, 0, 0, 1, gStapein_04_file, 0, 0, 2
;---
gStapein_05_file 	 init "../samples/opcode/tapein/tapein-05.wav"
gitapein_05_1		 ftgen 0, 0, 0, 1, gStapein_05_file, 0, 0, 1
gitapein_05_2		 ftgen 0, 0, 0, 1, gStapein_05_file, 0, 0, 2
;---
gStapein_06_file 	 init "../samples/opcode/tapein/tapein-06.wav"
gitapein_06_1		 ftgen 0, 0, 0, 1, gStapein_06_file, 0, 0, 1
gitapein_06_2		 ftgen 0, 0, 0, 1, gStapein_06_file, 0, 0, 2
;---
gStapein_07_file 	 init "../samples/opcode/tapein/tapein-07.wav"
gitapein_07_1		 ftgen 0, 0, 0, 1, gStapein_07_file, 0, 0, 1
gitapein_07_2		 ftgen 0, 0, 0, 1, gStapein_07_file, 0, 0, 2
;---
gStapein_08_file 	 init "../samples/opcode/tapein/tapein-08.wav"
gitapein_08_1		 ftgen 0, 0, 0, 1, gStapein_08_file, 0, 0, 1
gitapein_08_2		 ftgen 0, 0, 0, 1, gStapein_08_file, 0, 0, 2
;---
gStapein_09_file 	 init "../samples/opcode/tapein/tapein-09.wav"
gitapein_09_1		 ftgen 0, 0, 0, 1, gStapein_09_file, 0, 0, 1
gitapein_09_2		 ftgen 0, 0, 0, 1, gStapein_09_file, 0, 0, 2
;---
gStapein_10_file 	 init "../samples/opcode/tapein/tapein-10.wav"
gitapein_10_1		 ftgen 0, 0, 0, 1, gStapein_10_file, 0, 0, 1
gitapein_10_2		 ftgen 0, 0, 0, 1, gStapein_10_file, 0, 0, 2
;---
gStapein_11_file 	 init "../samples/opcode/tapein/tapein-11.wav"
gitapein_11_1		 ftgen 0, 0, 0, 1, gStapein_11_file, 0, 0, 1
gitapein_11_2		 ftgen 0, 0, 0, 1, gStapein_11_file, 0, 0, 2
;---
gStapein_12_file 	 init "../samples/opcode/tapein/tapein-12.wav"
gitapein_12_1		 ftgen 0, 0, 0, 1, gStapein_12_file, 0, 0, 1
gitapein_12_2		 ftgen 0, 0, 0, 1, gStapein_12_file, 0, 0, 2
;---
gStapein_13_file 	 init "../samples/opcode/tapein/tapein-13.wav"
gitapein_13_1		 ftgen 0, 0, 0, 1, gStapein_13_file, 0, 0, 1
gitapein_13_2		 ftgen 0, 0, 0, 1, gStapein_13_file, 0, 0, 2
;---
gStapein_14_file 	 init "../samples/opcode/tapein/tapein-14.wav"
gitapein_14_1		 ftgen 0, 0, 0, 1, gStapein_14_file, 0, 0, 1
gitapein_14_2		 ftgen 0, 0, 0, 1, gStapein_14_file, 0, 0, 2
;---
gStapein_15_file 	 init "../samples/opcode/tapein/tapein-15.wav"
gitapein_15_1		 ftgen 0, 0, 0, 1, gStapein_15_file, 0, 0, 1
gitapein_15_2		 ftgen 0, 0, 0, 1, gStapein_15_file, 0, 0, 2
;---
gStapein_16_file 	 init "../samples/opcode/tapein/tapein-16.wav"
gitapein_16_1		 ftgen 0, 0, 0, 1, gStapein_16_file, 0, 0, 1
gitapein_16_2		 ftgen 0, 0, 0, 1, gStapein_16_file, 0, 0, 2
;---
gStapein_17_file 	 init "../samples/opcode/tapein/tapein-17.wav"
gitapein_17_1		 ftgen 0, 0, 0, 1, gStapein_17_file, 0, 0, 1
gitapein_17_2		 ftgen 0, 0, 0, 1, gStapein_17_file, 0, 0, 2
;---
gStapein_18_file 	 init "../samples/opcode/tapein/tapein-18.wav"
gitapein_18_1		 ftgen 0, 0, 0, 1, gStapein_18_file, 0, 0, 1
gitapein_18_2		 ftgen 0, 0, 0, 1, gStapein_18_file, 0, 0, 2
;---
gStapein_19_file 	 init "../samples/opcode/tapein/tapein-19.wav"
gitapein_19_1		 ftgen 0, 0, 0, 1, gStapein_19_file, 0, 0, 1
gitapein_19_2		 ftgen 0, 0, 0, 1, gStapein_19_file, 0, 0, 2
;---
gStapein_20_file 	 init "../samples/opcode/tapein/tapein-20.wav"
gitapein_20_1		 ftgen 0, 0, 0, 1, gStapein_20_file, 0, 0, 1
gitapein_20_2		 ftgen 0, 0, 0, 1, gStapein_20_file, 0, 0, 2
;---
gStapein_21_file 	 init "../samples/opcode/tapein/tapein-21.wav"
gitapein_21_1		 ftgen 0, 0, 0, 1, gStapein_21_file, 0, 0, 1
gitapein_21_2		 ftgen 0, 0, 0, 1, gStapein_21_file, 0, 0, 2
;---
gStapein_22_file 	 init "../samples/opcode/tapein/tapein-22.wav"
gitapein_22_1		 ftgen 0, 0, 0, 1, gStapein_22_file, 0, 0, 1
gitapein_22_2		 ftgen 0, 0, 0, 1, gStapein_22_file, 0, 0, 2
;---
gStapein_23_file 	 init "../samples/opcode/tapein/tapein-23.wav"
gitapein_23_1		 ftgen 0, 0, 0, 1, gStapein_23_file, 0, 0, 1
gitapein_23_2		 ftgen 0, 0, 0, 1, gStapein_23_file, 0, 0, 2
;---
gStapein_24_file 	 init "../samples/opcode/tapein/tapein-24.wav"
gitapein_24_1		 ftgen 0, 0, 0, 1, gStapein_24_file, 0, 0, 1
gitapein_24_2		 ftgen 0, 0, 0, 1, gStapein_24_file, 0, 0, 2
;---
gStapein_25_file 	 init "../samples/opcode/tapein/tapein-25.wav"
gitapein_25_1		 ftgen 0, 0, 0, 1, gStapein_25_file, 0, 0, 1
gitapein_25_2		 ftgen 0, 0, 0, 1, gStapein_25_file, 0, 0, 2
;---
gStapein_26_file 	 init "../samples/opcode/tapein/tapein-26.wav"
gitapein_26_1		 ftgen 0, 0, 0, 1, gStapein_26_file, 0, 0, 1
gitapein_26_2		 ftgen 0, 0, 0, 1, gStapein_26_file, 0, 0, 2
;---
gitapein_sonvs[]			fillarray	gitapein_00_1, gitapein_00_2, gitapein_01_1, gitapein_01_2, gitapein_02_1, gitapein_02_2, gitapein_03_1, gitapein_03_2, gitapein_04_1, gitapein_04_2, gitapein_05_1, gitapein_05_2, gitapein_06_1, gitapein_06_2, gitapein_07_1, gitapein_07_2, gitapein_08_1, gitapein_08_2, gitapein_09_1, gitapein_09_2, gitapein_10_1, gitapein_10_2, gitapein_11_1, gitapein_11_2, gitapein_12_1, gitapein_12_2, gitapein_13_1, gitapein_13_2, gitapein_14_1, gitapein_14_2, gitapein_15_1, gitapein_15_2, gitapein_16_1, gitapein_16_2, gitapein_17_1, gitapein_17_2, gitapein_18_1, gitapein_18_2, gitapein_19_1, gitapein_19_2, gitapein_20_1, gitapein_20_2, gitapein_21_1, gitapein_21_2, gitapein_22_1, gitapein_22_2, gitapein_23_1, gitapein_23_2, gitapein_24_1, gitapein_24_2, gitapein_25_1, gitapein_25_2, gitapein_26_1, gitapein_26_2
gktapein_time		init 16
gktapein_off		init .005
gktapein_dur		init 1
gktapein_sonvs		init 1
gitapein_len		init lenarray(gitapein_sonvs)/2

;------------------

	instr tapein

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "tapein"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gktapein_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gktapein_sonvs%(gitapein_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gitapein_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "tapein"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gktapein_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gitapein_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gitapein_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "tapein"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gktapein_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gktapein_sonvs%(gitapein_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gitapein_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	tapein, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "tapein"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktapein_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktapein_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	tapein, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "tapein"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktapein_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktapein_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gStension_file	init "../samples/opcode/tension.wav"

gitension1	ftgen 0, 0, 0, 1, gStension_file, 0, 0, 1
gitension2	ftgen 0, 0, 0, 1, gStension_file, 0, 0, 2

gktension_time		init 16
gktension_off		init .005
gktension_dur		init 1
;------------------

	instr tension

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "tension"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gktension_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gitension1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "tension"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gktension_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gitension1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "tension"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gktension_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gitension1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	tension, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "tension"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktension_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktension_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	tension, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "tension"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktension_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktension_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gStheorbo_05_file 	 init "../samples/opcode/theorbo/theorbo-05.wav"
githeorbo_05_1		 ftgen 0, 0, 0, 1, gStheorbo_05_file, 0, 0, 1
githeorbo_05_2		 ftgen 0, 0, 0, 1, gStheorbo_05_file, 0, 0, 2
;---
gStheorbo_06_file 	 init "../samples/opcode/theorbo/theorbo-06.wav"
githeorbo_06_1		 ftgen 0, 0, 0, 1, gStheorbo_06_file, 0, 0, 1
githeorbo_06_2		 ftgen 0, 0, 0, 1, gStheorbo_06_file, 0, 0, 2
;---
gStheorbo_07_file 	 init "../samples/opcode/theorbo/theorbo-07.wav"
githeorbo_07_1		 ftgen 0, 0, 0, 1, gStheorbo_07_file, 0, 0, 1
githeorbo_07_2		 ftgen 0, 0, 0, 1, gStheorbo_07_file, 0, 0, 2
;---
gStheorbo_08_file 	 init "../samples/opcode/theorbo/theorbo-08.wav"
githeorbo_08_1		 ftgen 0, 0, 0, 1, gStheorbo_08_file, 0, 0, 1
githeorbo_08_2		 ftgen 0, 0, 0, 1, gStheorbo_08_file, 0, 0, 2
;---
gStheorbo_09_file 	 init "../samples/opcode/theorbo/theorbo-09.wav"
githeorbo_09_1		 ftgen 0, 0, 0, 1, gStheorbo_09_file, 0, 0, 1
githeorbo_09_2		 ftgen 0, 0, 0, 1, gStheorbo_09_file, 0, 0, 2
;---
githeorbo_sonvs[]			fillarray	githeorbo_05_1, githeorbo_05_2, githeorbo_06_1, githeorbo_06_2, githeorbo_07_1, githeorbo_07_2, githeorbo_08_1, githeorbo_08_2, githeorbo_09_1, githeorbo_09_2
gktheorbo_time		init 16
gktheorbo_off		init .005
gktheorbo_dur		init 1
gktheorbo_sonvs		init 1
githeorbo_len		init lenarray(githeorbo_sonvs)/2

;------------------

	instr theorbo

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "theorbo"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gktheorbo_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gktheorbo_sonvs%(githeorbo_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init githeorbo_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "theorbo"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gktheorbo_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(githeorbo_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init githeorbo_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "theorbo"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gktheorbo_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gktheorbo_sonvs%(githeorbo_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init githeorbo_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	theorbo, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "theorbo"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktheorbo_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktheorbo_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	theorbo, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "theorbo"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktheorbo_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktheorbo_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gStoy_00_file 	 init "../samples/opcode/toy/toy_00.wav"
gitoy_00_1		 ftgen 0, 0, 0, 1, gStoy_00_file, 0, 0, 1
gitoy_00_2		 ftgen 0, 0, 0, 1, gStoy_00_file, 0, 0, 2
;---
gStoy_01_file 	 init "../samples/opcode/toy/toy_01.wav"
gitoy_01_1		 ftgen 0, 0, 0, 1, gStoy_01_file, 0, 0, 1
gitoy_01_2		 ftgen 0, 0, 0, 1, gStoy_01_file, 0, 0, 2
;---
gStoy_02_file 	 init "../samples/opcode/toy/toy_02.wav"
gitoy_02_1		 ftgen 0, 0, 0, 1, gStoy_02_file, 0, 0, 1
gitoy_02_2		 ftgen 0, 0, 0, 1, gStoy_02_file, 0, 0, 2
;---
gStoy_03_file 	 init "../samples/opcode/toy/toy_03.wav"
gitoy_03_1		 ftgen 0, 0, 0, 1, gStoy_03_file, 0, 0, 1
gitoy_03_2		 ftgen 0, 0, 0, 1, gStoy_03_file, 0, 0, 2
;---
gStoy_04_file 	 init "../samples/opcode/toy/toy_04.wav"
gitoy_04_1		 ftgen 0, 0, 0, 1, gStoy_04_file, 0, 0, 1
gitoy_04_2		 ftgen 0, 0, 0, 1, gStoy_04_file, 0, 0, 2
;---
gStoy_05_file 	 init "../samples/opcode/toy/toy_05.wav"
gitoy_05_1		 ftgen 0, 0, 0, 1, gStoy_05_file, 0, 0, 1
gitoy_05_2		 ftgen 0, 0, 0, 1, gStoy_05_file, 0, 0, 2
;---
gStoy_06_file 	 init "../samples/opcode/toy/toy_06.wav"
gitoy_06_1		 ftgen 0, 0, 0, 1, gStoy_06_file, 0, 0, 1
gitoy_06_2		 ftgen 0, 0, 0, 1, gStoy_06_file, 0, 0, 2
;---
gStoy_07_file 	 init "../samples/opcode/toy/toy_07.wav"
gitoy_07_1		 ftgen 0, 0, 0, 1, gStoy_07_file, 0, 0, 1
gitoy_07_2		 ftgen 0, 0, 0, 1, gStoy_07_file, 0, 0, 2
;---
gStoy_08_file 	 init "../samples/opcode/toy/toy_08.wav"
gitoy_08_1		 ftgen 0, 0, 0, 1, gStoy_08_file, 0, 0, 1
gitoy_08_2		 ftgen 0, 0, 0, 1, gStoy_08_file, 0, 0, 2
;---
gitoy_sonvs[]			fillarray	gitoy_00_1, gitoy_00_2, gitoy_01_1, gitoy_01_2, gitoy_02_1, gitoy_02_2, gitoy_03_1, gitoy_03_2, gitoy_04_1, gitoy_04_2, gitoy_05_1, gitoy_05_2, gitoy_06_1, gitoy_06_2, gitoy_07_1, gitoy_07_2, gitoy_08_1, gitoy_08_2
gktoy_time		init 16
gktoy_off		init .005
gktoy_dur		init 1
gktoy_sonvs		init 1
gitoy_len		init lenarray(gitoy_sonvs)/2

;------------------

	instr toy

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "toy"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gktoy_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gktoy_sonvs%(gitoy_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gitoy_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "toy"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gktoy_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(gitoy_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init gitoy_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "toy"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gktoy_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gktoy_sonvs%(gitoy_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init gitoy_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	toy, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "toy"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktoy_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktoy_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	toy, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "toy"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktoy_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktoy_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gStricot_file	init "../samples/opcode/tricot.wav"

gitricot1	ftgen 0, 0, 0, 1, gStricot_file, 0, 0, 1
gitricot2	ftgen 0, 0, 0, 1, gStricot_file, 0, 0, 2

gktricot_time		init 16
gktricot_off		init .005
gktricot_dur		init 1
;------------------

	instr tricot

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "tricot"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gktricot_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gitricot1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "tricot"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gktricot_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, gitricot1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "tricot"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gktricot_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, gitricot1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	tricot, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "tricot"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktricot_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktricot_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	tricot, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "tricot"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gktricot_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gktricot_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSvalle_file	init "../samples/opcode/valle.wav"

givalle1	ftgen 0, 0, 0, 1, gSvalle_file, 0, 0, 1
givalle2	ftgen 0, 0, 0, 1, gSvalle_file, 0, 0, 2

gkvalle_time		init 16
gkvalle_off		init .005
gkvalle_dur		init 1
;------------------

	instr valle

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "valle"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkvalle_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, givalle1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "valle"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkvalle_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, givalle1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "valle"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkvalle_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, givalle1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	valle, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "valle"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvalle_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvalle_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	valle, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "valle"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvalle_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvalle_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSvar14r_00_file 	 init "../samples/opcode/var14r/var14r-00.wav"
givar14r_00_1		 ftgen 0, 0, 0, 1, gSvar14r_00_file, 0, 0, 1
givar14r_00_2		 ftgen 0, 0, 0, 1, gSvar14r_00_file, 0, 0, 2
;---
gSvar14r_01_file 	 init "../samples/opcode/var14r/var14r-01.wav"
givar14r_01_1		 ftgen 0, 0, 0, 1, gSvar14r_01_file, 0, 0, 1
givar14r_01_2		 ftgen 0, 0, 0, 1, gSvar14r_01_file, 0, 0, 2
;---
gSvar14r_02_file 	 init "../samples/opcode/var14r/var14r-02.wav"
givar14r_02_1		 ftgen 0, 0, 0, 1, gSvar14r_02_file, 0, 0, 1
givar14r_02_2		 ftgen 0, 0, 0, 1, gSvar14r_02_file, 0, 0, 2
;---
gSvar14r_03_file 	 init "../samples/opcode/var14r/var14r-03.wav"
givar14r_03_1		 ftgen 0, 0, 0, 1, gSvar14r_03_file, 0, 0, 1
givar14r_03_2		 ftgen 0, 0, 0, 1, gSvar14r_03_file, 0, 0, 2
;---
gSvar14r_04_file 	 init "../samples/opcode/var14r/var14r-04.wav"
givar14r_04_1		 ftgen 0, 0, 0, 1, gSvar14r_04_file, 0, 0, 1
givar14r_04_2		 ftgen 0, 0, 0, 1, gSvar14r_04_file, 0, 0, 2
;---
gSvar14r_05_file 	 init "../samples/opcode/var14r/var14r-05.wav"
givar14r_05_1		 ftgen 0, 0, 0, 1, gSvar14r_05_file, 0, 0, 1
givar14r_05_2		 ftgen 0, 0, 0, 1, gSvar14r_05_file, 0, 0, 2
;---
gSvar14r_06_file 	 init "../samples/opcode/var14r/var14r-06.wav"
givar14r_06_1		 ftgen 0, 0, 0, 1, gSvar14r_06_file, 0, 0, 1
givar14r_06_2		 ftgen 0, 0, 0, 1, gSvar14r_06_file, 0, 0, 2
;---
gSvar14r_07_file 	 init "../samples/opcode/var14r/var14r-07.wav"
givar14r_07_1		 ftgen 0, 0, 0, 1, gSvar14r_07_file, 0, 0, 1
givar14r_07_2		 ftgen 0, 0, 0, 1, gSvar14r_07_file, 0, 0, 2
;---
gSvar14r_08_file 	 init "../samples/opcode/var14r/var14r-08.wav"
givar14r_08_1		 ftgen 0, 0, 0, 1, gSvar14r_08_file, 0, 0, 1
givar14r_08_2		 ftgen 0, 0, 0, 1, gSvar14r_08_file, 0, 0, 2
;---
gSvar14r_09_file 	 init "../samples/opcode/var14r/var14r-09.wav"
givar14r_09_1		 ftgen 0, 0, 0, 1, gSvar14r_09_file, 0, 0, 1
givar14r_09_2		 ftgen 0, 0, 0, 1, gSvar14r_09_file, 0, 0, 2
;---
gSvar14r_10_file 	 init "../samples/opcode/var14r/var14r-10.wav"
givar14r_10_1		 ftgen 0, 0, 0, 1, gSvar14r_10_file, 0, 0, 1
givar14r_10_2		 ftgen 0, 0, 0, 1, gSvar14r_10_file, 0, 0, 2
;---
gSvar14r_11_file 	 init "../samples/opcode/var14r/var14r-11.wav"
givar14r_11_1		 ftgen 0, 0, 0, 1, gSvar14r_11_file, 0, 0, 1
givar14r_11_2		 ftgen 0, 0, 0, 1, gSvar14r_11_file, 0, 0, 2
;---
gSvar14r_12_file 	 init "../samples/opcode/var14r/var14r-12.wav"
givar14r_12_1		 ftgen 0, 0, 0, 1, gSvar14r_12_file, 0, 0, 1
givar14r_12_2		 ftgen 0, 0, 0, 1, gSvar14r_12_file, 0, 0, 2
;---
gSvar14r_13_file 	 init "../samples/opcode/var14r/var14r-13.wav"
givar14r_13_1		 ftgen 0, 0, 0, 1, gSvar14r_13_file, 0, 0, 1
givar14r_13_2		 ftgen 0, 0, 0, 1, gSvar14r_13_file, 0, 0, 2
;---
gSvar14r_14_file 	 init "../samples/opcode/var14r/var14r-14.wav"
givar14r_14_1		 ftgen 0, 0, 0, 1, gSvar14r_14_file, 0, 0, 1
givar14r_14_2		 ftgen 0, 0, 0, 1, gSvar14r_14_file, 0, 0, 2
;---
gSvar14r_15_file 	 init "../samples/opcode/var14r/var14r-15.wav"
givar14r_15_1		 ftgen 0, 0, 0, 1, gSvar14r_15_file, 0, 0, 1
givar14r_15_2		 ftgen 0, 0, 0, 1, gSvar14r_15_file, 0, 0, 2
;---
gSvar14r_16_file 	 init "../samples/opcode/var14r/var14r-16.wav"
givar14r_16_1		 ftgen 0, 0, 0, 1, gSvar14r_16_file, 0, 0, 1
givar14r_16_2		 ftgen 0, 0, 0, 1, gSvar14r_16_file, 0, 0, 2
;---
gSvar14r_17_file 	 init "../samples/opcode/var14r/var14r-17.wav"
givar14r_17_1		 ftgen 0, 0, 0, 1, gSvar14r_17_file, 0, 0, 1
givar14r_17_2		 ftgen 0, 0, 0, 1, gSvar14r_17_file, 0, 0, 2
;---
gSvar14r_18_file 	 init "../samples/opcode/var14r/var14r-18.wav"
givar14r_18_1		 ftgen 0, 0, 0, 1, gSvar14r_18_file, 0, 0, 1
givar14r_18_2		 ftgen 0, 0, 0, 1, gSvar14r_18_file, 0, 0, 2
;---
gSvar14r_19_file 	 init "../samples/opcode/var14r/var14r-19.wav"
givar14r_19_1		 ftgen 0, 0, 0, 1, gSvar14r_19_file, 0, 0, 1
givar14r_19_2		 ftgen 0, 0, 0, 1, gSvar14r_19_file, 0, 0, 2
;---
gSvar14r_20_file 	 init "../samples/opcode/var14r/var14r-20.wav"
givar14r_20_1		 ftgen 0, 0, 0, 1, gSvar14r_20_file, 0, 0, 1
givar14r_20_2		 ftgen 0, 0, 0, 1, gSvar14r_20_file, 0, 0, 2
;---
gSvar14r_21_file 	 init "../samples/opcode/var14r/var14r-21.wav"
givar14r_21_1		 ftgen 0, 0, 0, 1, gSvar14r_21_file, 0, 0, 1
givar14r_21_2		 ftgen 0, 0, 0, 1, gSvar14r_21_file, 0, 0, 2
;---
givar14r_sonvs[]			fillarray	givar14r_00_1, givar14r_00_2, givar14r_01_1, givar14r_01_2, givar14r_02_1, givar14r_02_2, givar14r_03_1, givar14r_03_2, givar14r_04_1, givar14r_04_2, givar14r_05_1, givar14r_05_2, givar14r_06_1, givar14r_06_2, givar14r_07_1, givar14r_07_2, givar14r_08_1, givar14r_08_2, givar14r_09_1, givar14r_09_2, givar14r_10_1, givar14r_10_2, givar14r_11_1, givar14r_11_2, givar14r_12_1, givar14r_12_2, givar14r_13_1, givar14r_13_2, givar14r_14_1, givar14r_14_2, givar14r_15_1, givar14r_15_2, givar14r_16_1, givar14r_16_2, givar14r_17_1, givar14r_17_2, givar14r_18_1, givar14r_18_2, givar14r_19_1, givar14r_19_2, givar14r_20_1, givar14r_20_2, givar14r_21_1, givar14r_21_2
gkvar14r_time		init 16
gkvar14r_off		init .005
gkvar14r_dur		init 1
gkvar14r_sonvs		init 1
givar14r_len		init lenarray(givar14r_sonvs)/2

;------------------

	instr var14r

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "var14r"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkvar14r_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvar14r_sonvs%(givar14r_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givar14r_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "var14r"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkvar14r_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(givar14r_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init givar14r_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "var14r"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkvar14r_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvar14r_sonvs%(givar14r_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givar14r_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	var14r, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "var14r"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvar14r_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvar14r_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	var14r, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "var14r"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvar14r_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvar14r_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSvarvln_00_file 	 init "../samples/opcode/varvln/varvln-00.wav"
givarvln_00_1		 ftgen 0, 0, 0, 1, gSvarvln_00_file, 0, 0, 1
givarvln_00_2		 ftgen 0, 0, 0, 1, gSvarvln_00_file, 0, 0, 2
;---
gSvarvln_01_file 	 init "../samples/opcode/varvln/varvln-01.wav"
givarvln_01_1		 ftgen 0, 0, 0, 1, gSvarvln_01_file, 0, 0, 1
givarvln_01_2		 ftgen 0, 0, 0, 1, gSvarvln_01_file, 0, 0, 2
;---
gSvarvln_02_file 	 init "../samples/opcode/varvln/varvln-02.wav"
givarvln_02_1		 ftgen 0, 0, 0, 1, gSvarvln_02_file, 0, 0, 1
givarvln_02_2		 ftgen 0, 0, 0, 1, gSvarvln_02_file, 0, 0, 2
;---
gSvarvln_03_file 	 init "../samples/opcode/varvln/varvln-03.wav"
givarvln_03_1		 ftgen 0, 0, 0, 1, gSvarvln_03_file, 0, 0, 1
givarvln_03_2		 ftgen 0, 0, 0, 1, gSvarvln_03_file, 0, 0, 2
;---
gSvarvln_04_file 	 init "../samples/opcode/varvln/varvln-04.wav"
givarvln_04_1		 ftgen 0, 0, 0, 1, gSvarvln_04_file, 0, 0, 1
givarvln_04_2		 ftgen 0, 0, 0, 1, gSvarvln_04_file, 0, 0, 2
;---
gSvarvln_05_file 	 init "../samples/opcode/varvln/varvln-05.wav"
givarvln_05_1		 ftgen 0, 0, 0, 1, gSvarvln_05_file, 0, 0, 1
givarvln_05_2		 ftgen 0, 0, 0, 1, gSvarvln_05_file, 0, 0, 2
;---
gSvarvln_06_file 	 init "../samples/opcode/varvln/varvln-06.wav"
givarvln_06_1		 ftgen 0, 0, 0, 1, gSvarvln_06_file, 0, 0, 1
givarvln_06_2		 ftgen 0, 0, 0, 1, gSvarvln_06_file, 0, 0, 2
;---
gSvarvln_07_file 	 init "../samples/opcode/varvln/varvln-07.wav"
givarvln_07_1		 ftgen 0, 0, 0, 1, gSvarvln_07_file, 0, 0, 1
givarvln_07_2		 ftgen 0, 0, 0, 1, gSvarvln_07_file, 0, 0, 2
;---
gSvarvln_08_file 	 init "../samples/opcode/varvln/varvln-08.wav"
givarvln_08_1		 ftgen 0, 0, 0, 1, gSvarvln_08_file, 0, 0, 1
givarvln_08_2		 ftgen 0, 0, 0, 1, gSvarvln_08_file, 0, 0, 2
;---
gSvarvln_09_file 	 init "../samples/opcode/varvln/varvln-09.wav"
givarvln_09_1		 ftgen 0, 0, 0, 1, gSvarvln_09_file, 0, 0, 1
givarvln_09_2		 ftgen 0, 0, 0, 1, gSvarvln_09_file, 0, 0, 2
;---
gSvarvln_10_file 	 init "../samples/opcode/varvln/varvln-10.wav"
givarvln_10_1		 ftgen 0, 0, 0, 1, gSvarvln_10_file, 0, 0, 1
givarvln_10_2		 ftgen 0, 0, 0, 1, gSvarvln_10_file, 0, 0, 2
;---
gSvarvln_11_file 	 init "../samples/opcode/varvln/varvln-11.wav"
givarvln_11_1		 ftgen 0, 0, 0, 1, gSvarvln_11_file, 0, 0, 1
givarvln_11_2		 ftgen 0, 0, 0, 1, gSvarvln_11_file, 0, 0, 2
;---
gSvarvln_12_file 	 init "../samples/opcode/varvln/varvln-12.wav"
givarvln_12_1		 ftgen 0, 0, 0, 1, gSvarvln_12_file, 0, 0, 1
givarvln_12_2		 ftgen 0, 0, 0, 1, gSvarvln_12_file, 0, 0, 2
;---
gSvarvln_13_file 	 init "../samples/opcode/varvln/varvln-13.wav"
givarvln_13_1		 ftgen 0, 0, 0, 1, gSvarvln_13_file, 0, 0, 1
givarvln_13_2		 ftgen 0, 0, 0, 1, gSvarvln_13_file, 0, 0, 2
;---
gSvarvln_14_file 	 init "../samples/opcode/varvln/varvln-14.wav"
givarvln_14_1		 ftgen 0, 0, 0, 1, gSvarvln_14_file, 0, 0, 1
givarvln_14_2		 ftgen 0, 0, 0, 1, gSvarvln_14_file, 0, 0, 2
;---
gSvarvln_15_file 	 init "../samples/opcode/varvln/varvln-15.wav"
givarvln_15_1		 ftgen 0, 0, 0, 1, gSvarvln_15_file, 0, 0, 1
givarvln_15_2		 ftgen 0, 0, 0, 1, gSvarvln_15_file, 0, 0, 2
;---
gSvarvln_16_file 	 init "../samples/opcode/varvln/varvln-16.wav"
givarvln_16_1		 ftgen 0, 0, 0, 1, gSvarvln_16_file, 0, 0, 1
givarvln_16_2		 ftgen 0, 0, 0, 1, gSvarvln_16_file, 0, 0, 2
;---
gSvarvln_17_file 	 init "../samples/opcode/varvln/varvln-17.wav"
givarvln_17_1		 ftgen 0, 0, 0, 1, gSvarvln_17_file, 0, 0, 1
givarvln_17_2		 ftgen 0, 0, 0, 1, gSvarvln_17_file, 0, 0, 2
;---
gSvarvln_18_file 	 init "../samples/opcode/varvln/varvln-18.wav"
givarvln_18_1		 ftgen 0, 0, 0, 1, gSvarvln_18_file, 0, 0, 1
givarvln_18_2		 ftgen 0, 0, 0, 1, gSvarvln_18_file, 0, 0, 2
;---
gSvarvln_19_file 	 init "../samples/opcode/varvln/varvln-19.wav"
givarvln_19_1		 ftgen 0, 0, 0, 1, gSvarvln_19_file, 0, 0, 1
givarvln_19_2		 ftgen 0, 0, 0, 1, gSvarvln_19_file, 0, 0, 2
;---
gSvarvln_20_file 	 init "../samples/opcode/varvln/varvln-20.wav"
givarvln_20_1		 ftgen 0, 0, 0, 1, gSvarvln_20_file, 0, 0, 1
givarvln_20_2		 ftgen 0, 0, 0, 1, gSvarvln_20_file, 0, 0, 2
;---
gSvarvln_21_file 	 init "../samples/opcode/varvln/varvln-21.wav"
givarvln_21_1		 ftgen 0, 0, 0, 1, gSvarvln_21_file, 0, 0, 1
givarvln_21_2		 ftgen 0, 0, 0, 1, gSvarvln_21_file, 0, 0, 2
;---
givarvln_sonvs[]			fillarray	givarvln_00_1, givarvln_00_2, givarvln_01_1, givarvln_01_2, givarvln_02_1, givarvln_02_2, givarvln_03_1, givarvln_03_2, givarvln_04_1, givarvln_04_2, givarvln_05_1, givarvln_05_2, givarvln_06_1, givarvln_06_2, givarvln_07_1, givarvln_07_2, givarvln_08_1, givarvln_08_2, givarvln_09_1, givarvln_09_2, givarvln_10_1, givarvln_10_2, givarvln_11_1, givarvln_11_2, givarvln_12_1, givarvln_12_2, givarvln_13_1, givarvln_13_2, givarvln_14_1, givarvln_14_2, givarvln_15_1, givarvln_15_2, givarvln_16_1, givarvln_16_2, givarvln_17_1, givarvln_17_2, givarvln_18_1, givarvln_18_2, givarvln_19_1, givarvln_19_2, givarvln_20_1, givarvln_20_2, givarvln_21_1, givarvln_21_2
gkvarvln_time		init 16
gkvarvln_off		init .005
gkvarvln_dur		init 1
gkvarvln_sonvs		init 1
givarvln_len		init lenarray(givarvln_sonvs)/2

;------------------

	instr varvln

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "varvln"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkvarvln_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvarvln_sonvs%(givarvln_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givarvln_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "varvln"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkvarvln_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(givarvln_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init givarvln_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "varvln"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkvarvln_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvarvln_sonvs%(givarvln_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givarvln_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	varvln, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "varvln"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvarvln_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvarvln_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	varvln, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "varvln"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvarvln_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvarvln_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSvipere_00_file 	 init "../samples/opcode/vipere/vipere-00.wav"
givipere_00_1		 ftgen 0, 0, 0, 1, gSvipere_00_file, 0, 0, 1
givipere_00_2		 ftgen 0, 0, 0, 1, gSvipere_00_file, 0, 0, 2
;---
gSvipere_01_file 	 init "../samples/opcode/vipere/vipere-01.wav"
givipere_01_1		 ftgen 0, 0, 0, 1, gSvipere_01_file, 0, 0, 1
givipere_01_2		 ftgen 0, 0, 0, 1, gSvipere_01_file, 0, 0, 2
;---
gSvipere_02_file 	 init "../samples/opcode/vipere/vipere-02.wav"
givipere_02_1		 ftgen 0, 0, 0, 1, gSvipere_02_file, 0, 0, 1
givipere_02_2		 ftgen 0, 0, 0, 1, gSvipere_02_file, 0, 0, 2
;---
gSvipere_03_file 	 init "../samples/opcode/vipere/vipere-03.wav"
givipere_03_1		 ftgen 0, 0, 0, 1, gSvipere_03_file, 0, 0, 1
givipere_03_2		 ftgen 0, 0, 0, 1, gSvipere_03_file, 0, 0, 2
;---
gSvipere_04_file 	 init "../samples/opcode/vipere/vipere-04.wav"
givipere_04_1		 ftgen 0, 0, 0, 1, gSvipere_04_file, 0, 0, 1
givipere_04_2		 ftgen 0, 0, 0, 1, gSvipere_04_file, 0, 0, 2
;---
gSvipere_05_file 	 init "../samples/opcode/vipere/vipere-05.wav"
givipere_05_1		 ftgen 0, 0, 0, 1, gSvipere_05_file, 0, 0, 1
givipere_05_2		 ftgen 0, 0, 0, 1, gSvipere_05_file, 0, 0, 2
;---
gSvipere_06_file 	 init "../samples/opcode/vipere/vipere-06.wav"
givipere_06_1		 ftgen 0, 0, 0, 1, gSvipere_06_file, 0, 0, 1
givipere_06_2		 ftgen 0, 0, 0, 1, gSvipere_06_file, 0, 0, 2
;---
gSvipere_07_file 	 init "../samples/opcode/vipere/vipere-07.wav"
givipere_07_1		 ftgen 0, 0, 0, 1, gSvipere_07_file, 0, 0, 1
givipere_07_2		 ftgen 0, 0, 0, 1, gSvipere_07_file, 0, 0, 2
;---
gSvipere_08_file 	 init "../samples/opcode/vipere/vipere-08.wav"
givipere_08_1		 ftgen 0, 0, 0, 1, gSvipere_08_file, 0, 0, 1
givipere_08_2		 ftgen 0, 0, 0, 1, gSvipere_08_file, 0, 0, 2
;---
gSvipere_09_file 	 init "../samples/opcode/vipere/vipere-09.wav"
givipere_09_1		 ftgen 0, 0, 0, 1, gSvipere_09_file, 0, 0, 1
givipere_09_2		 ftgen 0, 0, 0, 1, gSvipere_09_file, 0, 0, 2
;---
gSvipere_10_file 	 init "../samples/opcode/vipere/vipere-10.wav"
givipere_10_1		 ftgen 0, 0, 0, 1, gSvipere_10_file, 0, 0, 1
givipere_10_2		 ftgen 0, 0, 0, 1, gSvipere_10_file, 0, 0, 2
;---
gSvipere_11_file 	 init "../samples/opcode/vipere/vipere-11.wav"
givipere_11_1		 ftgen 0, 0, 0, 1, gSvipere_11_file, 0, 0, 1
givipere_11_2		 ftgen 0, 0, 0, 1, gSvipere_11_file, 0, 0, 2
;---
gSvipere_12_file 	 init "../samples/opcode/vipere/vipere-12.wav"
givipere_12_1		 ftgen 0, 0, 0, 1, gSvipere_12_file, 0, 0, 1
givipere_12_2		 ftgen 0, 0, 0, 1, gSvipere_12_file, 0, 0, 2
;---
gSvipere_13_file 	 init "../samples/opcode/vipere/vipere-13.wav"
givipere_13_1		 ftgen 0, 0, 0, 1, gSvipere_13_file, 0, 0, 1
givipere_13_2		 ftgen 0, 0, 0, 1, gSvipere_13_file, 0, 0, 2
;---
gSvipere_14_file 	 init "../samples/opcode/vipere/vipere-14.wav"
givipere_14_1		 ftgen 0, 0, 0, 1, gSvipere_14_file, 0, 0, 1
givipere_14_2		 ftgen 0, 0, 0, 1, gSvipere_14_file, 0, 0, 2
;---
gSvipere_15_file 	 init "../samples/opcode/vipere/vipere-15.wav"
givipere_15_1		 ftgen 0, 0, 0, 1, gSvipere_15_file, 0, 0, 1
givipere_15_2		 ftgen 0, 0, 0, 1, gSvipere_15_file, 0, 0, 2
;---
gSvipere_16_file 	 init "../samples/opcode/vipere/vipere-16.wav"
givipere_16_1		 ftgen 0, 0, 0, 1, gSvipere_16_file, 0, 0, 1
givipere_16_2		 ftgen 0, 0, 0, 1, gSvipere_16_file, 0, 0, 2
;---
gSvipere_17_file 	 init "../samples/opcode/vipere/vipere-17.wav"
givipere_17_1		 ftgen 0, 0, 0, 1, gSvipere_17_file, 0, 0, 1
givipere_17_2		 ftgen 0, 0, 0, 1, gSvipere_17_file, 0, 0, 2
;---
gSvipere_18_file 	 init "../samples/opcode/vipere/vipere-18.wav"
givipere_18_1		 ftgen 0, 0, 0, 1, gSvipere_18_file, 0, 0, 1
givipere_18_2		 ftgen 0, 0, 0, 1, gSvipere_18_file, 0, 0, 2
;---
gSvipere_19_file 	 init "../samples/opcode/vipere/vipere-19.wav"
givipere_19_1		 ftgen 0, 0, 0, 1, gSvipere_19_file, 0, 0, 1
givipere_19_2		 ftgen 0, 0, 0, 1, gSvipere_19_file, 0, 0, 2
;---
gSvipere_20_file 	 init "../samples/opcode/vipere/vipere-20.wav"
givipere_20_1		 ftgen 0, 0, 0, 1, gSvipere_20_file, 0, 0, 1
givipere_20_2		 ftgen 0, 0, 0, 1, gSvipere_20_file, 0, 0, 2
;---
gSvipere_21_file 	 init "../samples/opcode/vipere/vipere-21.wav"
givipere_21_1		 ftgen 0, 0, 0, 1, gSvipere_21_file, 0, 0, 1
givipere_21_2		 ftgen 0, 0, 0, 1, gSvipere_21_file, 0, 0, 2
;---
gSvipere_22_file 	 init "../samples/opcode/vipere/vipere-22.wav"
givipere_22_1		 ftgen 0, 0, 0, 1, gSvipere_22_file, 0, 0, 1
givipere_22_2		 ftgen 0, 0, 0, 1, gSvipere_22_file, 0, 0, 2
;---
gSvipere_23_file 	 init "../samples/opcode/vipere/vipere-23.wav"
givipere_23_1		 ftgen 0, 0, 0, 1, gSvipere_23_file, 0, 0, 1
givipere_23_2		 ftgen 0, 0, 0, 1, gSvipere_23_file, 0, 0, 2
;---
gSvipere_24_file 	 init "../samples/opcode/vipere/vipere-24.wav"
givipere_24_1		 ftgen 0, 0, 0, 1, gSvipere_24_file, 0, 0, 1
givipere_24_2		 ftgen 0, 0, 0, 1, gSvipere_24_file, 0, 0, 2
;---
gSvipere_25_file 	 init "../samples/opcode/vipere/vipere-25.wav"
givipere_25_1		 ftgen 0, 0, 0, 1, gSvipere_25_file, 0, 0, 1
givipere_25_2		 ftgen 0, 0, 0, 1, gSvipere_25_file, 0, 0, 2
;---
gSvipere_26_file 	 init "../samples/opcode/vipere/vipere-26.wav"
givipere_26_1		 ftgen 0, 0, 0, 1, gSvipere_26_file, 0, 0, 1
givipere_26_2		 ftgen 0, 0, 0, 1, gSvipere_26_file, 0, 0, 2
;---
gSvipere_27_file 	 init "../samples/opcode/vipere/vipere-27.wav"
givipere_27_1		 ftgen 0, 0, 0, 1, gSvipere_27_file, 0, 0, 1
givipere_27_2		 ftgen 0, 0, 0, 1, gSvipere_27_file, 0, 0, 2
;---
gSvipere_28_file 	 init "../samples/opcode/vipere/vipere-28.wav"
givipere_28_1		 ftgen 0, 0, 0, 1, gSvipere_28_file, 0, 0, 1
givipere_28_2		 ftgen 0, 0, 0, 1, gSvipere_28_file, 0, 0, 2
;---
gSvipere_29_file 	 init "../samples/opcode/vipere/vipere-29.wav"
givipere_29_1		 ftgen 0, 0, 0, 1, gSvipere_29_file, 0, 0, 1
givipere_29_2		 ftgen 0, 0, 0, 1, gSvipere_29_file, 0, 0, 2
;---
givipere_sonvs[]			fillarray	givipere_00_1, givipere_00_2, givipere_01_1, givipere_01_2, givipere_02_1, givipere_02_2, givipere_03_1, givipere_03_2, givipere_04_1, givipere_04_2, givipere_05_1, givipere_05_2, givipere_06_1, givipere_06_2, givipere_07_1, givipere_07_2, givipere_08_1, givipere_08_2, givipere_09_1, givipere_09_2, givipere_10_1, givipere_10_2, givipere_11_1, givipere_11_2, givipere_12_1, givipere_12_2, givipere_13_1, givipere_13_2, givipere_14_1, givipere_14_2, givipere_15_1, givipere_15_2, givipere_16_1, givipere_16_2, givipere_17_1, givipere_17_2, givipere_18_1, givipere_18_2, givipere_19_1, givipere_19_2, givipere_20_1, givipere_20_2, givipere_21_1, givipere_21_2, givipere_22_1, givipere_22_2, givipere_23_1, givipere_23_2, givipere_24_1, givipere_24_2, givipere_25_1, givipere_25_2, givipere_26_1, givipere_26_2, givipere_27_1, givipere_27_2, givipere_28_1, givipere_28_2, givipere_29_1, givipere_29_2
gkvipere_time		init 16
gkvipere_off		init .005
gkvipere_dur		init 1
gkvipere_sonvs		init 1
givipere_len		init lenarray(givipere_sonvs)/2

;------------------

	instr vipere

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "vipere"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkvipere_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvipere_sonvs%(givipere_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givipere_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "vipere"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkvipere_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(givipere_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init givipere_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "vipere"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkvipere_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvipere_sonvs%(givipere_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givipere_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	vipere, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "vipere"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvipere_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvipere_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	vipere, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "vipere"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvipere_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvipere_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSvirgule_file	init "../samples/opcode/virgule.wav"

givirgule1	ftgen 0, 0, 0, 1, gSvirgule_file, 0, 0, 1
givirgule2	ftgen 0, 0, 0, 1, gSvirgule_file, 0, 0, 2

gkvirgule_time		init 16
gkvirgule_off		init .005
gkvirgule_dur		init 1
;------------------

	instr virgule

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "virgule"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkvirgule_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, givirgule1+(itab), 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

		$mix

elseif imode == is_midi then

	Sinstr		init "virgule"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	idummy		init p9
	ioff		i gkvirgule_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	itab	init ich%2
	aout	tablei aph, givirgule1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "virgule"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkvirgule_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	itab	init ich%2
	aout	tablei aph, givirgule1+(itab), 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	virgule, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "virgule"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvirgule_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvirgule_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	virgule, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "virgule"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvirgule_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvirgule_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSvla_01_file 	 init "../samples/opcode/vla/vla-01.wav"
givla_01_1		 ftgen 0, 0, 0, 1, gSvla_01_file, 0, 0, 1
givla_01_2		 ftgen 0, 0, 0, 1, gSvla_01_file, 0, 0, 2
;---
gSvla_02_file 	 init "../samples/opcode/vla/vla-02.wav"
givla_02_1		 ftgen 0, 0, 0, 1, gSvla_02_file, 0, 0, 1
givla_02_2		 ftgen 0, 0, 0, 1, gSvla_02_file, 0, 0, 2
;---
gSvla_03_file 	 init "../samples/opcode/vla/vla-03.wav"
givla_03_1		 ftgen 0, 0, 0, 1, gSvla_03_file, 0, 0, 1
givla_03_2		 ftgen 0, 0, 0, 1, gSvla_03_file, 0, 0, 2
;---
gSvla_04_file 	 init "../samples/opcode/vla/vla-04.wav"
givla_04_1		 ftgen 0, 0, 0, 1, gSvla_04_file, 0, 0, 1
givla_04_2		 ftgen 0, 0, 0, 1, gSvla_04_file, 0, 0, 2
;---
gSvla_05_file 	 init "../samples/opcode/vla/vla-05.wav"
givla_05_1		 ftgen 0, 0, 0, 1, gSvla_05_file, 0, 0, 1
givla_05_2		 ftgen 0, 0, 0, 1, gSvla_05_file, 0, 0, 2
;---
gSvla_06_file 	 init "../samples/opcode/vla/vla-06.wav"
givla_06_1		 ftgen 0, 0, 0, 1, gSvla_06_file, 0, 0, 1
givla_06_2		 ftgen 0, 0, 0, 1, gSvla_06_file, 0, 0, 2
;---
gSvla_07_file 	 init "../samples/opcode/vla/vla-07.wav"
givla_07_1		 ftgen 0, 0, 0, 1, gSvla_07_file, 0, 0, 1
givla_07_2		 ftgen 0, 0, 0, 1, gSvla_07_file, 0, 0, 2
;---
givla_sonvs[]			fillarray	givla_01_1, givla_01_2, givla_02_1, givla_02_2, givla_03_1, givla_03_2, givla_04_1, givla_04_2, givla_05_1, givla_05_2, givla_06_1, givla_06_2, givla_07_1, givla_07_2
gkvla_time		init 16
gkvla_off		init .005
gkvla_dur		init 1
gkvla_sonvs		init 1
givla_len		init lenarray(givla_sonvs)/2

;------------------

	instr vla

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "vla"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkvla_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvla_sonvs%(givla_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givla_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "vla"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkvla_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(givla_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init givla_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "vla"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkvla_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvla_sonvs%(givla_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givla_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	vla, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "vla"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvla_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvla_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	vla, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "vla"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvla_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvla_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSvlj_01_file 	 init "../samples/opcode/vlj/vlj_01.wav"
givlj_01_1		 ftgen 0, 0, 0, 1, gSvlj_01_file, 0, 0, 1
givlj_01_2		 ftgen 0, 0, 0, 1, gSvlj_01_file, 0, 0, 2
;---
gSvlj_02_file 	 init "../samples/opcode/vlj/vlj_02.wav"
givlj_02_1		 ftgen 0, 0, 0, 1, gSvlj_02_file, 0, 0, 1
givlj_02_2		 ftgen 0, 0, 0, 1, gSvlj_02_file, 0, 0, 2
;---
gSvlj_03_file 	 init "../samples/opcode/vlj/vlj_03.wav"
givlj_03_1		 ftgen 0, 0, 0, 1, gSvlj_03_file, 0, 0, 1
givlj_03_2		 ftgen 0, 0, 0, 1, gSvlj_03_file, 0, 0, 2
;---
gSvlj_04_file 	 init "../samples/opcode/vlj/vlj_04.wav"
givlj_04_1		 ftgen 0, 0, 0, 1, gSvlj_04_file, 0, 0, 1
givlj_04_2		 ftgen 0, 0, 0, 1, gSvlj_04_file, 0, 0, 2
;---
gSvlj_05_file 	 init "../samples/opcode/vlj/vlj_05.wav"
givlj_05_1		 ftgen 0, 0, 0, 1, gSvlj_05_file, 0, 0, 1
givlj_05_2		 ftgen 0, 0, 0, 1, gSvlj_05_file, 0, 0, 2
;---
gSvlj_06_file 	 init "../samples/opcode/vlj/vlj_06.wav"
givlj_06_1		 ftgen 0, 0, 0, 1, gSvlj_06_file, 0, 0, 1
givlj_06_2		 ftgen 0, 0, 0, 1, gSvlj_06_file, 0, 0, 2
;---
gSvlj_07_file 	 init "../samples/opcode/vlj/vlj_07.wav"
givlj_07_1		 ftgen 0, 0, 0, 1, gSvlj_07_file, 0, 0, 1
givlj_07_2		 ftgen 0, 0, 0, 1, gSvlj_07_file, 0, 0, 2
;---
gSvlj_08_file 	 init "../samples/opcode/vlj/vlj_08.wav"
givlj_08_1		 ftgen 0, 0, 0, 1, gSvlj_08_file, 0, 0, 1
givlj_08_2		 ftgen 0, 0, 0, 1, gSvlj_08_file, 0, 0, 2
;---
gSvlj_09_file 	 init "../samples/opcode/vlj/vlj_09.wav"
givlj_09_1		 ftgen 0, 0, 0, 1, gSvlj_09_file, 0, 0, 1
givlj_09_2		 ftgen 0, 0, 0, 1, gSvlj_09_file, 0, 0, 2
;---
gSvlj_10_file 	 init "../samples/opcode/vlj/vlj_10.wav"
givlj_10_1		 ftgen 0, 0, 0, 1, gSvlj_10_file, 0, 0, 1
givlj_10_2		 ftgen 0, 0, 0, 1, gSvlj_10_file, 0, 0, 2
;---
gSvlj_11_file 	 init "../samples/opcode/vlj/vlj_11.wav"
givlj_11_1		 ftgen 0, 0, 0, 1, gSvlj_11_file, 0, 0, 1
givlj_11_2		 ftgen 0, 0, 0, 1, gSvlj_11_file, 0, 0, 2
;---
gSvlj_12_file 	 init "../samples/opcode/vlj/vlj_12.wav"
givlj_12_1		 ftgen 0, 0, 0, 1, gSvlj_12_file, 0, 0, 1
givlj_12_2		 ftgen 0, 0, 0, 1, gSvlj_12_file, 0, 0, 2
;---
gSvlj_13_file 	 init "../samples/opcode/vlj/vlj_13.wav"
givlj_13_1		 ftgen 0, 0, 0, 1, gSvlj_13_file, 0, 0, 1
givlj_13_2		 ftgen 0, 0, 0, 1, gSvlj_13_file, 0, 0, 2
;---
gSvlj_14_file 	 init "../samples/opcode/vlj/vlj_14.wav"
givlj_14_1		 ftgen 0, 0, 0, 1, gSvlj_14_file, 0, 0, 1
givlj_14_2		 ftgen 0, 0, 0, 1, gSvlj_14_file, 0, 0, 2
;---
gSvlj_15_file 	 init "../samples/opcode/vlj/vlj_15.wav"
givlj_15_1		 ftgen 0, 0, 0, 1, gSvlj_15_file, 0, 0, 1
givlj_15_2		 ftgen 0, 0, 0, 1, gSvlj_15_file, 0, 0, 2
;---
gSvlj_16_file 	 init "../samples/opcode/vlj/vlj_16.wav"
givlj_16_1		 ftgen 0, 0, 0, 1, gSvlj_16_file, 0, 0, 1
givlj_16_2		 ftgen 0, 0, 0, 1, gSvlj_16_file, 0, 0, 2
;---
gSvlj_17_file 	 init "../samples/opcode/vlj/vlj_17.wav"
givlj_17_1		 ftgen 0, 0, 0, 1, gSvlj_17_file, 0, 0, 1
givlj_17_2		 ftgen 0, 0, 0, 1, gSvlj_17_file, 0, 0, 2
;---
gSvlj_18_file 	 init "../samples/opcode/vlj/vlj_18.wav"
givlj_18_1		 ftgen 0, 0, 0, 1, gSvlj_18_file, 0, 0, 1
givlj_18_2		 ftgen 0, 0, 0, 1, gSvlj_18_file, 0, 0, 2
;---
gSvlj_19_file 	 init "../samples/opcode/vlj/vlj_19.wav"
givlj_19_1		 ftgen 0, 0, 0, 1, gSvlj_19_file, 0, 0, 1
givlj_19_2		 ftgen 0, 0, 0, 1, gSvlj_19_file, 0, 0, 2
;---
gSvlj_20_file 	 init "../samples/opcode/vlj/vlj_20.wav"
givlj_20_1		 ftgen 0, 0, 0, 1, gSvlj_20_file, 0, 0, 1
givlj_20_2		 ftgen 0, 0, 0, 1, gSvlj_20_file, 0, 0, 2
;---
gSvlj_21_file 	 init "../samples/opcode/vlj/vlj_21.wav"
givlj_21_1		 ftgen 0, 0, 0, 1, gSvlj_21_file, 0, 0, 1
givlj_21_2		 ftgen 0, 0, 0, 1, gSvlj_21_file, 0, 0, 2
;---
gSvlj_22_file 	 init "../samples/opcode/vlj/vlj_22.wav"
givlj_22_1		 ftgen 0, 0, 0, 1, gSvlj_22_file, 0, 0, 1
givlj_22_2		 ftgen 0, 0, 0, 1, gSvlj_22_file, 0, 0, 2
;---
gSvlj_23_file 	 init "../samples/opcode/vlj/vlj_23.wav"
givlj_23_1		 ftgen 0, 0, 0, 1, gSvlj_23_file, 0, 0, 1
givlj_23_2		 ftgen 0, 0, 0, 1, gSvlj_23_file, 0, 0, 2
;---
gSvlj_24_file 	 init "../samples/opcode/vlj/vlj_24.wav"
givlj_24_1		 ftgen 0, 0, 0, 1, gSvlj_24_file, 0, 0, 1
givlj_24_2		 ftgen 0, 0, 0, 1, gSvlj_24_file, 0, 0, 2
;---
gSvlj_25_file 	 init "../samples/opcode/vlj/vlj_25.wav"
givlj_25_1		 ftgen 0, 0, 0, 1, gSvlj_25_file, 0, 0, 1
givlj_25_2		 ftgen 0, 0, 0, 1, gSvlj_25_file, 0, 0, 2
;---
gSvlj_26_file 	 init "../samples/opcode/vlj/vlj_26.wav"
givlj_26_1		 ftgen 0, 0, 0, 1, gSvlj_26_file, 0, 0, 1
givlj_26_2		 ftgen 0, 0, 0, 1, gSvlj_26_file, 0, 0, 2
;---
gSvlj_27_file 	 init "../samples/opcode/vlj/vlj_27.wav"
givlj_27_1		 ftgen 0, 0, 0, 1, gSvlj_27_file, 0, 0, 1
givlj_27_2		 ftgen 0, 0, 0, 1, gSvlj_27_file, 0, 0, 2
;---
gSvlj_28_file 	 init "../samples/opcode/vlj/vlj_28.wav"
givlj_28_1		 ftgen 0, 0, 0, 1, gSvlj_28_file, 0, 0, 1
givlj_28_2		 ftgen 0, 0, 0, 1, gSvlj_28_file, 0, 0, 2
;---
gSvlj_29_file 	 init "../samples/opcode/vlj/vlj_29.wav"
givlj_29_1		 ftgen 0, 0, 0, 1, gSvlj_29_file, 0, 0, 1
givlj_29_2		 ftgen 0, 0, 0, 1, gSvlj_29_file, 0, 0, 2
;---
gSvlj_30_file 	 init "../samples/opcode/vlj/vlj_30.wav"
givlj_30_1		 ftgen 0, 0, 0, 1, gSvlj_30_file, 0, 0, 1
givlj_30_2		 ftgen 0, 0, 0, 1, gSvlj_30_file, 0, 0, 2
;---
gSvlj_31_file 	 init "../samples/opcode/vlj/vlj_31.wav"
givlj_31_1		 ftgen 0, 0, 0, 1, gSvlj_31_file, 0, 0, 1
givlj_31_2		 ftgen 0, 0, 0, 1, gSvlj_31_file, 0, 0, 2
;---
gSvlj_32_file 	 init "../samples/opcode/vlj/vlj_32.wav"
givlj_32_1		 ftgen 0, 0, 0, 1, gSvlj_32_file, 0, 0, 1
givlj_32_2		 ftgen 0, 0, 0, 1, gSvlj_32_file, 0, 0, 2
;---
gSvlj_33_file 	 init "../samples/opcode/vlj/vlj_33.wav"
givlj_33_1		 ftgen 0, 0, 0, 1, gSvlj_33_file, 0, 0, 1
givlj_33_2		 ftgen 0, 0, 0, 1, gSvlj_33_file, 0, 0, 2
;---
gSvlj_34_file 	 init "../samples/opcode/vlj/vlj_34.wav"
givlj_34_1		 ftgen 0, 0, 0, 1, gSvlj_34_file, 0, 0, 1
givlj_34_2		 ftgen 0, 0, 0, 1, gSvlj_34_file, 0, 0, 2
;---
gSvlj_35_file 	 init "../samples/opcode/vlj/vlj_35.wav"
givlj_35_1		 ftgen 0, 0, 0, 1, gSvlj_35_file, 0, 0, 1
givlj_35_2		 ftgen 0, 0, 0, 1, gSvlj_35_file, 0, 0, 2
;---
gSvlj_36_file 	 init "../samples/opcode/vlj/vlj_36.wav"
givlj_36_1		 ftgen 0, 0, 0, 1, gSvlj_36_file, 0, 0, 1
givlj_36_2		 ftgen 0, 0, 0, 1, gSvlj_36_file, 0, 0, 2
;---
gSvlj_37_file 	 init "../samples/opcode/vlj/vlj_37.wav"
givlj_37_1		 ftgen 0, 0, 0, 1, gSvlj_37_file, 0, 0, 1
givlj_37_2		 ftgen 0, 0, 0, 1, gSvlj_37_file, 0, 0, 2
;---
gSvlj_38_file 	 init "../samples/opcode/vlj/vlj_38.wav"
givlj_38_1		 ftgen 0, 0, 0, 1, gSvlj_38_file, 0, 0, 1
givlj_38_2		 ftgen 0, 0, 0, 1, gSvlj_38_file, 0, 0, 2
;---
gSvlj_39_file 	 init "../samples/opcode/vlj/vlj_39.wav"
givlj_39_1		 ftgen 0, 0, 0, 1, gSvlj_39_file, 0, 0, 1
givlj_39_2		 ftgen 0, 0, 0, 1, gSvlj_39_file, 0, 0, 2
;---
gSvlj_40_file 	 init "../samples/opcode/vlj/vlj_40.wav"
givlj_40_1		 ftgen 0, 0, 0, 1, gSvlj_40_file, 0, 0, 1
givlj_40_2		 ftgen 0, 0, 0, 1, gSvlj_40_file, 0, 0, 2
;---
gSvlj_41_file 	 init "../samples/opcode/vlj/vlj_41.wav"
givlj_41_1		 ftgen 0, 0, 0, 1, gSvlj_41_file, 0, 0, 1
givlj_41_2		 ftgen 0, 0, 0, 1, gSvlj_41_file, 0, 0, 2
;---
gSvlj_42_file 	 init "../samples/opcode/vlj/vlj_42.wav"
givlj_42_1		 ftgen 0, 0, 0, 1, gSvlj_42_file, 0, 0, 1
givlj_42_2		 ftgen 0, 0, 0, 1, gSvlj_42_file, 0, 0, 2
;---
gSvlj_43_file 	 init "../samples/opcode/vlj/vlj_43.wav"
givlj_43_1		 ftgen 0, 0, 0, 1, gSvlj_43_file, 0, 0, 1
givlj_43_2		 ftgen 0, 0, 0, 1, gSvlj_43_file, 0, 0, 2
;---
gSvlj_44_file 	 init "../samples/opcode/vlj/vlj_44.wav"
givlj_44_1		 ftgen 0, 0, 0, 1, gSvlj_44_file, 0, 0, 1
givlj_44_2		 ftgen 0, 0, 0, 1, gSvlj_44_file, 0, 0, 2
;---
gSvlj_45_file 	 init "../samples/opcode/vlj/vlj_45.wav"
givlj_45_1		 ftgen 0, 0, 0, 1, gSvlj_45_file, 0, 0, 1
givlj_45_2		 ftgen 0, 0, 0, 1, gSvlj_45_file, 0, 0, 2
;---
gSvlj_46_file 	 init "../samples/opcode/vlj/vlj_46.wav"
givlj_46_1		 ftgen 0, 0, 0, 1, gSvlj_46_file, 0, 0, 1
givlj_46_2		 ftgen 0, 0, 0, 1, gSvlj_46_file, 0, 0, 2
;---
gSvlj_47_file 	 init "../samples/opcode/vlj/vlj_47.wav"
givlj_47_1		 ftgen 0, 0, 0, 1, gSvlj_47_file, 0, 0, 1
givlj_47_2		 ftgen 0, 0, 0, 1, gSvlj_47_file, 0, 0, 2
;---
gSvlj_48_file 	 init "../samples/opcode/vlj/vlj_48.wav"
givlj_48_1		 ftgen 0, 0, 0, 1, gSvlj_48_file, 0, 0, 1
givlj_48_2		 ftgen 0, 0, 0, 1, gSvlj_48_file, 0, 0, 2
;---
gSvlj_49_file 	 init "../samples/opcode/vlj/vlj_49.wav"
givlj_49_1		 ftgen 0, 0, 0, 1, gSvlj_49_file, 0, 0, 1
givlj_49_2		 ftgen 0, 0, 0, 1, gSvlj_49_file, 0, 0, 2
;---
gSvlj_50_file 	 init "../samples/opcode/vlj/vlj_50.wav"
givlj_50_1		 ftgen 0, 0, 0, 1, gSvlj_50_file, 0, 0, 1
givlj_50_2		 ftgen 0, 0, 0, 1, gSvlj_50_file, 0, 0, 2
;---
givlj_sonvs[]			fillarray	givlj_01_1, givlj_01_2, givlj_02_1, givlj_02_2, givlj_03_1, givlj_03_2, givlj_04_1, givlj_04_2, givlj_05_1, givlj_05_2, givlj_06_1, givlj_06_2, givlj_07_1, givlj_07_2, givlj_08_1, givlj_08_2, givlj_09_1, givlj_09_2, givlj_10_1, givlj_10_2, givlj_11_1, givlj_11_2, givlj_12_1, givlj_12_2, givlj_13_1, givlj_13_2, givlj_14_1, givlj_14_2, givlj_15_1, givlj_15_2, givlj_16_1, givlj_16_2, givlj_17_1, givlj_17_2, givlj_18_1, givlj_18_2, givlj_19_1, givlj_19_2, givlj_20_1, givlj_20_2, givlj_21_1, givlj_21_2, givlj_22_1, givlj_22_2, givlj_23_1, givlj_23_2, givlj_24_1, givlj_24_2, givlj_25_1, givlj_25_2, givlj_26_1, givlj_26_2, givlj_27_1, givlj_27_2, givlj_28_1, givlj_28_2, givlj_29_1, givlj_29_2, givlj_30_1, givlj_30_2, givlj_31_1, givlj_31_2, givlj_32_1, givlj_32_2, givlj_33_1, givlj_33_2, givlj_34_1, givlj_34_2, givlj_35_1, givlj_35_2, givlj_36_1, givlj_36_2, givlj_37_1, givlj_37_2, givlj_38_1, givlj_38_2, givlj_39_1, givlj_39_2, givlj_40_1, givlj_40_2, givlj_41_1, givlj_41_2, givlj_42_1, givlj_42_2, givlj_43_1, givlj_43_2, givlj_44_1, givlj_44_2, givlj_45_1, givlj_45_2, givlj_46_1, givlj_46_2, givlj_47_1, givlj_47_2, givlj_48_1, givlj_48_2, givlj_49_1, givlj_49_2, givlj_50_1, givlj_50_2
gkvlj_time		init 16
gkvlj_off		init .005
gkvlj_dur		init 1
gkvlj_sonvs		init 1
givlj_len		init lenarray(givlj_sonvs)/2

;------------------

	instr vlj

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "vlj"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkvlj_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvlj_sonvs%(givlj_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givlj_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "vlj"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkvlj_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(givlj_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init givlj_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "vlj"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkvlj_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvlj_sonvs%(givlj_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givlj_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	vlj, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "vlj"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvlj_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvlj_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	vlj, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "vlj"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvlj_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvlj_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

gSvlnatk_00_file 	 init "../samples/opcode/vlnatk/vlnatk-00.wav"
givlnatk_00_1		 ftgen 0, 0, 0, 1, gSvlnatk_00_file, 0, 0, 1
givlnatk_00_2		 ftgen 0, 0, 0, 1, gSvlnatk_00_file, 0, 0, 2
;---
gSvlnatk_01_file 	 init "../samples/opcode/vlnatk/vlnatk-01.wav"
givlnatk_01_1		 ftgen 0, 0, 0, 1, gSvlnatk_01_file, 0, 0, 1
givlnatk_01_2		 ftgen 0, 0, 0, 1, gSvlnatk_01_file, 0, 0, 2
;---
gSvlnatk_02_file 	 init "../samples/opcode/vlnatk/vlnatk-02.wav"
givlnatk_02_1		 ftgen 0, 0, 0, 1, gSvlnatk_02_file, 0, 0, 1
givlnatk_02_2		 ftgen 0, 0, 0, 1, gSvlnatk_02_file, 0, 0, 2
;---
gSvlnatk_03_file 	 init "../samples/opcode/vlnatk/vlnatk-03.wav"
givlnatk_03_1		 ftgen 0, 0, 0, 1, gSvlnatk_03_file, 0, 0, 1
givlnatk_03_2		 ftgen 0, 0, 0, 1, gSvlnatk_03_file, 0, 0, 2
;---
gSvlnatk_04_file 	 init "../samples/opcode/vlnatk/vlnatk-04.wav"
givlnatk_04_1		 ftgen 0, 0, 0, 1, gSvlnatk_04_file, 0, 0, 1
givlnatk_04_2		 ftgen 0, 0, 0, 1, gSvlnatk_04_file, 0, 0, 2
;---
gSvlnatk_05_file 	 init "../samples/opcode/vlnatk/vlnatk-05.wav"
givlnatk_05_1		 ftgen 0, 0, 0, 1, gSvlnatk_05_file, 0, 0, 1
givlnatk_05_2		 ftgen 0, 0, 0, 1, gSvlnatk_05_file, 0, 0, 2
;---
gSvlnatk_06_file 	 init "../samples/opcode/vlnatk/vlnatk-06.wav"
givlnatk_06_1		 ftgen 0, 0, 0, 1, gSvlnatk_06_file, 0, 0, 1
givlnatk_06_2		 ftgen 0, 0, 0, 1, gSvlnatk_06_file, 0, 0, 2
;---
givlnatk_sonvs[]			fillarray	givlnatk_00_1, givlnatk_00_2, givlnatk_01_1, givlnatk_01_2, givlnatk_02_1, givlnatk_02_2, givlnatk_03_1, givlnatk_03_2, givlnatk_04_1, givlnatk_04_2, givlnatk_05_1, givlnatk_05_2, givlnatk_06_1, givlnatk_06_2
gkvlnatk_time		init 16
gkvlnatk_off		init .005
gkvlnatk_dur		init 1
gkvlnatk_sonvs		init 1
givlnatk_len		init lenarray(givlnatk_sonvs)/2

;------------------

	instr vlnatk

imode		init p8
is_opcode	init 1
is_midi		init 2

if imode == is_opcode then

	Sinstr		init "vlnatk"
	idur		init p3
	iamp		init p4
	idiv		init p5%i(gksamp_mod)
	ix			init p6
	ich			init p7
	ioff		i gkvlnatk_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvlnatk_sonvs%(givlnatk_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givlnatk_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= cosseg:a(0, ix, 1, idur-(ix*2), 1, ix, 0)
	aout	*= $ampvar

	$mix

elseif imode == is_midi then

	Sinstr		init "vlnatk"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	isonvs		init p9
	ix			init idur/4
	ioff		i gkvlnatk_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		= isonvs%(givlnatk_len+1)

	ifreq	init limit(1/idur, .125, idiv/8)
	aph		tablei phasor(ifreq/2), gitri, 1

	imod		init ich%2
	ift_sonvs	init givlnatk_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

else

	Sinstr		init "vlnatk"
	idur		init p3
	iamp		init p4
	iftenv		init p5
	idiv		init p6%i(gksamp_mod)
	ich			init p7
	ix			init idur/4
	ioff		i gkvlnatk_off
	
	if ioff!=0 then
		ioff		random 0, ioff
	endif

	isonvs		i gkvlnatk_sonvs%(givlnatk_len+1)

	korgan	chnget	"heart"
	aorgan	a korgan
	aph	= ((aorgan * idiv)+ioff) % 1

	imod		init ich%2
	ift_sonvs	init givlnatk_sonvs[isonvs]+imod
	aout	tablei aph, ift_sonvs, 1
	aout	*= $ampvar

	ienvvar		init idur/5

	$death

endif

	endin

;------------------

	opcode	vlnatk, 0, iJ
idiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "vlnatk"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvlnatk_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvlnatk_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, idiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, idiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop

	opcode	vlnatk, 0, kJ
kdiv, kamp xin

if kamp == -1 then
	kamp = $f
endif

Sinstr	init "vlnatk"
imax	init 8
kndx 	init 1

is_opcode init 1

if 	hex("8", gkvlnatk_time) == 1 then

	if kndx == imax+1 then
		kndx = 1
	endif

	kdur	= gkbeats*gkvlnatk_dur

	kx		= kdur/4

	kch		= 1

	until kch > ginchnls do
		schedulek nstrnum(Sinstr)+(kndx/1000), 0, kdur+kx, kamp, kdiv, kx, kch, is_opcode
		#ifdef	printscore
			kdone	system gkabstime, sprintfk("echo \'i\t\"%s\"\t%f\t%f\t%f\t%i\t%f\' >> %s", Sinstr, gkabstime, kdur, kamp, kenv, kcps1, kch, gScorename)
		#end
		if	kch == 1 then
			printsk "• %s\t%.1fs | %.3f | %.2f\n", Sinstr, kamp, kdur+kx, kdiv
		endif
		kch += 1
	od
	kndx += 1
endif

	endop	



;--- ||| --- ||| ---

;a sweet sound with a tiny, harsh attack

gkaaron_mod	init 1 ;mod parameter for aaron instr
gkaaron_indx	init 3 ;index parameter for aaron instr
gkaaron_detune	init 0 ;detune parameter for aaron instr

giaaron_atk		init .0095

	instr aaron_instr_1

Sinstr		init "aaron"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

//

indx		init i(gkaaron_indx)
idetune 	init i(gkaaron_detune)

//

ivibdiv		random 4, 8

amp		= abs(lfo:a($ampvar, cosseg(random:i(idur*.35, idur*.95)/ivibdiv, idur, random:i(idur*.75, idur*3.5)/ivibdiv)))

//

kcar 	= 1
kmod 	= gkaaron_mod
kndx	= expseg:k(indx, idur, .05)

kcps	= icps + vibr(expseg(.05, idur, icps/(icps*12)), randomi:k(idur*3, idur*5, icps/(icps*12)), gisine)

aout	foscili amp, kcps+randomi:k(-.05, .05, 1/idur, 2, 0), kcar, kmod+randomi:k(-.0015, .0015, 1/idur, 2, 0), kndx+randomi:k(-.05, .05, 1/idur), gisine

;	ENVELOPE
ienvvar		init idur/100

		$death

	endin

	instr aaron_instr_2

Sinstr	init "aaron"

//

irel	init .015

p3		init giaaron_atk + irel
idur 	init p3
iamp 	init p4
icps 	init p6
ich		init p7

ipanfreq	init random:i(-.95, .95)

aout	repluck random:i(.015, .35), iamp, icps + random:i(-ipanfreq, ipanfreq), randomh:k(.25, .95, random:i(.05, .15)), random:i(.05, .65), oscil3:a(1, random:i(.05, .25),  gitri)
aout	dcblock2 aout

aout	*= cosseg(0, giaaron_atk, 1, irel, 0)

	$mix

	endin

	instr aaron_instr_3

Sinstr	init "aaron"

//

idur 	init p3
iamp 	init p4
icps 	init p6
ich	init p7

ipanfreq	= random:i(-.95, .95)

//

aout	repluck random:i(.015, .35), $ampvar, icps + random:i(-ipanfreq, ipanfreq), randomh:k(.25, .95, random:i(.05, .15)), random:i(.05, .65), oscil3:a(1, random:i(.05, .25), gisine)
aout	dcblock2 aout

aout	*= cosseg(0, giaaron_atk, 1, idur/5, 0)

	$mix

	endin

	instr aaron_instr_4

Sinstr	= "aaron"

//

idur 	init p3 / 3
iamp	init p4
amp		= abs(lfo:a(iamp, cosseg(random:i(idur*.5, idur*.75)/2, idur, random:i(idur*.75, idur*3.5)/2)))

icps 	init p6
ich		init p7
//

af		fractalnoise random:i(.05, .75), random:i(.05, .75)

kcps	= icps + vibr(expseg(.05, idur, icps/(icps*12)), randomi:k(idur*3, idur*5, icps/(icps*12)), gisine)

arout	resonx	af, kcps, icps/5

aout	balance arout, af

aout	*= amp

aout	*= cosseg(0, giaaron_atk, iamp, idur, 0)

	$mix

	endin

;---

	instr aaron

Sinstr		init "aaron"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

indx		init i(gkaaron_indx)
idetune 	init i(gkaaron_detune)

	event "i", sprintf("%s_instr_1", Sinstr), 0,	idur, iamp,		iftenv, icps, ich

	event "i", sprintf("%s_instr_2", Sinstr), 0,	idur, iamp/6,	iftenv, icps+idetune, ich
	event "i", sprintf("%s_instr_3", Sinstr), 0,	idur, iamp/6,	iftenv, icps+idetune, ich

	event "i", sprintf("%s_instr_2", Sinstr), 0,	idur, iamp/3,	iftenv, icps*2.11+idetune, ich
	event "i", sprintf("%s_instr_3", Sinstr), 0,	idur, iamp/3,	iftenv, icps*1.97+idetune, ich

	event "i", sprintf("%s_instr_4", Sinstr), 0,	idur, iamp/5,	iftenv, icps, ich

	turnoff

	endin



;--- ||| --- ||| ---

maxalloc "alone_instr", nchnls
maxalloc "alone", nchnls*4

gkalone_env init 0
gkalone_cps init 20

gialone_count init 1

	instr alone

idur		init p3
iamp		init p4*.65
iftenv		init p5
icps		init p6
ich		init p7

ienvvar		init idur/10

if ich == 1 then

	gkalone_dur	portk idur, 5$ms

	gkalone_env = envgen(idur-random:i(0, ienvvar), iftenv)*$ampvar
	gkalone_cps init icps

	gkalone_harm init gialone_count
	gialone_count += 1

	if gialone_count == 9 then
		gialone_count init 1
	endif

endif

	endin

	instr alone_instr

Sinstr		init "alone"
ich		init p4

kharm		int abs(lfo(9, gkalone_harm/gkalone_dur))
kharm		+= 3/2

avco1		vco2 portk(gkalone_env, 5$ms), portk(gkalone_cps, limit(gkalone_dur/1000, 35$ms, 1))+randomi:k(-gkalone_cps/1000, gkalone_cps/1000, 1/gkalone_dur)

avco2		oscil3 portk(gkalone_env, 5$ms), kharm*portk(gkalone_cps, limit(gkalone_dur/1000, 5$ms, 125$ms))+randomi:k(-gkalone_cps/1000, gkalone_cps/1000, 1/gkalone_dur), gitri
avco2		flanger avco2, a(gkalone_dur/9), .75

avco		sum avco1, avco2


aout		moogladder2 avco, gkalone_cps+(gkalone_cps*portk(gkalone_env*64, 5$ms)), .5
aout		phaser1 aout, gkalone_cps/1000, 9, .95
aout		balance2 aout, avco

	$mix

	endin

indx	init 0
until	indx == nchnls do
	schedule nstrnum("alone_instr")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od



;--- ||| --- ||| ---

if active(nstrnum("alonefr_instr"))>0 then
	turnoff2 "alonefr_instr", 0, 0
endif


if active(nstrnum("alone"))>0 then
	turnoff2 "alone", 0, 0
endif

maxalloc "alonefr_instr", nchnls
maxalloc "alonefr", nchnls*4

gkalonefr_env init 0
gkalonefr_cps init 20

gialonefr_count init 1
gkalonefr_env	init 0


	instr alonefr

idur		init p3
iamp		init p4/2
iftenv		init p5
icps		init p6
ich			init p7


if ich == 1 then
	gkalonefr_dur	portk idur, 5$ms

	gkalonefr_env = envgen(idur, iftenv)*$ampvar

	gkalonefr_cps init icps

	gkalonefr_harm init gialonefr_count
	gialonefr_count += 1

	if gialonefr_count == 4 then
		gialonefr_count init 1
	endif

endif

	endin

	instr alonefr_instr

Sinstr		init "alonefr"
ich		init p4

kharm		int abs(lfo(9, gkalonefr_harm/gkalonefr_dur))
kharm		+= 3/2

kamp		= portk(gkalonefr_env, 35$ms, 0)
kfreq		= portk(gkalonefr_cps*gkalonefr_harm, limit(gkalonefr_dur/1000, 75$ms, 1))+randomi:k(-gkalonefr_cps/1000, gkalonefr_cps/1000, 1/gkalonefr_dur)
avco1		oscil3 kamp, kfreq, gisaw
avco2		oscil3 kamp, kfreq*kharm, gitri
avco3		oscil3 kamp, kfreq*kharm/2, gisine

avco		sum avco1, avco2, avco3

adel		= gkalonefr_dur/(kharm)
kfb		= (1-gkalonefr_env)*.25
adel		flanger avco, adel*gkalonefr_harm, kfb

amoog		moogladder2 adel, gkalonefr_cps+(gkalonefr_cps*portk((1-gkalonefr_env)*64, 5$ms)), .5

aout		phaser1 amoog, gkalonefr_cps, 12, gkalonefr_env

	$mix

	endin

indx	init 0
until	indx == nchnls do
	schedule nstrnum("alonefr_instr")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od





;--- ||| --- ||| ---

	instr bass

Sinstr		init "bass"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

a1_out		oscil3 $ampvar, icps, gisine
a2_out		foscil $ampvar, icps, cosseg(1, idur/24, 2), cosseg(2, idur, .5), line(.25, idur, 1), gisine
a3_out		foscil $ampvar, icps*3/2, cosseg(.25, idur/32, 2), .25, line(1, idur, 0), gisine

aout		= a1_out + a2_out/4 + a3_out/8
ienvvar		init idur/50

	$death

	endin



;--- ||| --- ||| ---

;almost some drop of water!

gibebois_imp	ftgen 0, 0, 0, 1, "../samples/opcode/bois.wav", 0, 0, 0

	instr bebois

Sinstr		init "bebois"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

;		OSC1
ihard		init $ampvar	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init 1-$ampvar	; where the block is hit, in the range 0 to 1

imp		init gibebois_imp

kvrate		expseg 3, idur, 12/idur
kvdepth		init $ampvar
ivibfn		init gisine

abel		gogobel $ampvar, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn
arev1		vcomb abel/2, idur*(1+k(envgen(idur, iftenv)*2)), .5/icps, idur
arev2		vcomb abel/3, idur*(1+k(envgen(idur, iftenv)*3)), 1/icps, idur
arev3		vcomb abel/4, idur*(1+k(envgen(idur, iftenv)*4)), 1/(icps*9/8), idur

aout		= abel + arev1/12 + arev2/9 + arev3/7

	$mix

	endin



;--- ||| --- ||| ---

;almost some drop of water!

gibeboo_imp	ftgen 0, 0, 0, 1, "../samples/opcode/bois.wav", 0, 0, 0

	instr beboo

Sinstr		init "beboo"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

;		OSC1
ihard		init $ampvar	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init 1-$ampvar	; where the block is hit, in the range 0 to 1

imp		init gibeboo_imp

kvrate		expseg 3, idur, 12/idur
kvdepth		init $ampvar
ivibfn		init gisine

abel		gogobel $ampvar, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn
adel		flanger abel, idur/(icps/100+((icps/250)*envgen(idur, iftenv))), $ampvar

aout		= adel

	$mix

	endin



;--- ||| --- ||| ---

;almost some drop of water!

gibebor_imp	ftgen 0, 0, 0, 1, "../samples/opcode/bois.wav", 0, 0, 0

	instr bebor

Sinstr		init "bebor"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

;		OSC1
ihard		init 1-$ampvar	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init 1-$ampvar	; where the block is hit, in the range 0 to 1

imp		init gibebor_imp

kvrate		expseg 3, idur, 12/idur
kvdepth		init $ampvar
ivibfn		init gisine

abel		gogobel $ampvar, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn
adel		flanger abel/2, idur/cosseg:a(icps/500, idur, icps/100), icps%.995

aout		= adel

	$mix

	endin



;--- ||| --- ||| ---

gibecapr_imp1	ftgen 0, 0, 0, 1, "../samples/opcode/capr2x/capr2x-006.wav", 0, 0, 0
gibecapr_imp2	ftgen 0, 0, 0, 1, "../samples/opcode/capr2x/capr2x-007.wav", 0, 0, 0
gibecapr_imp3	ftgen 0, 0, 0, 1, "../samples/opcode/capr2x/capr2x-008.wav", 0, 0, 0

gibecapr_indx	init 0
gibecapr_arr[]	fillarray gibecapr_imp1, gibecapr_imp2, gibecapr_imp3

	instr becapr

Sinstr		init "becapr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

if gibecapr_indx >= lenarray(gibecapr_arr) then
	gibecapr_indx init 0
endif

if ich == 1 then

	gibecapr_imp init gibecapr_arr[gibecapr_indx]
	
	gibecapr_indx += 1

else

	gibecapr_imp init gibecapr_arr[gibecapr_indx]
	
endif

;		OSC1
ihard		init $ampvar	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init $ampvar	; where the block is hit, in the range 0 to 1

imp		init gibecapr_imp

kvrate		expseg 3, idur, 12/idur
kvdepth		init $ampvar
ivibfn		init gitri

abel		gogobel $ampvar, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn

aout		= abel/8

	$mix

	endin



;--- ||| --- ||| ---

gibee_imp	ftgen 0, 0, 0, 1, "../samples/instr/bee/bee02.wav", 0, 0, 0

	instr bee

Sinstr		init "bee"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

;		OSC1
ihard		init $ampvar	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init $ampvar	; where the block is hit, in the range 0 to 1

imp		init gibee_imp

kvrate		expseg random:i(3, 5), idur/2, random:i(.25, .5)/idur
kvdepth		init iamp
ivibfn		init gisine

ai1		gogobel $ampvar/6, icps, ihard/6, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn

;		OSC2
kc1		cosseg $ampvar*icps/(idur*50), idur, $ampvar*icps/(idur*100)
kc2		init 1

ai2		fmbell $ampvar, icps, kc1, kc2, kvdepth, kvrate+random:i(-.05, .05), gisine, gisine, gisine, gitri, gisine, idur-random:i(0, idur/10)

ishapefn 	init gisaw

ai2   		table3 random:i(.05, .35)*ai2, ishapefn, 1, .5, 1

;		SUM
aout		sum ai1, ai2

ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

;almost some drop of water!

gibegad_indx init 0

	instr begad

Sinstr		init "begad"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

if gibegad_indx >= lenarray(gigameld_sonvs) then
	gibegad_indx init 0
endif

if ich == 1 then

	gibegad_imp init gigameld_sonvs[gibegad_indx]

	gibegad_indx += 1
	
else

	gibegad_imp init gigameld_sonvs[gibegad_indx]

endif
	

;		OSC1
ihard		init 1-$ampvar	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init $ampvar	; where the block is hit, in the range 0 to 1

imp		init gibegad_imp

kvrate		expseg 3, idur, 12/idur
kvdepth		init $ampvar
ivibfn		init gisine

abel		gogobel $ampvar, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn
arev1		vcomb abel/2, idur*(1+k(envgen(idur, iftenv)*2)), .5/icps, idur
arev2		vcomb abel/3, idur*(1+k(envgen(idur, iftenv)*3)), 1/icps, idur
arev3		vcomb abel/3, idur*(1+k(envgen(idur, iftenv)*4)), 1/(icps*3/2), idur

aout		= abel + arev1/12 + arev2/9 + arev3/7
aout		/= 3
	$mix

	endin



;--- ||| --- ||| ---

;almost some drop of water!

gibegaf_indx init 0

	instr begaf

Sinstr		init "begaf"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

if gibegaf_indx >= lenarray(gigameld_sonvs) then
	gibegaf_indx init 0
endif

if ich == 1 then

	gibegaf_imp init gigameld_sonvs[gibegaf_indx]

	gibegaf_indx += 1	

else

	gibegaf_imp init gigameld_sonvs[gibegaf_indx]

endif


;		OSC1
ihard		init 1-$ampvar	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init $ampvar	; where the block is hit, in the range 0 to 1

imp		init gibegaf_imp

kvrate		expseg 3, idur, 12/idur
kvdepth		init $ampvar
ivibfn		init gisine

abel		gogobel $ampvar, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn
arev1		vcomb abel/2, idur*(1+k(envgen(idur, iftenv)*2)), .5/icps, idur
arev2		vcomb abel/3, idur*(1+k(envgen(idur, iftenv)*3)), 1/icps, idur
arev3		vcomb abel/3, idur*(1+k(envgen(idur, iftenv)*4)), 1/(icps*3/2), idur

aout		= abel + arev1/12 + arev2/9 + arev3/7
aout		/= 3
	$mix

	endin



;--- ||| --- ||| ---

;almost some drop of water!

gibeme_indx init 0

	instr beme

Sinstr		init "beme"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

if gibeme_indx >= lenarray(gichime_sonvs) then
	gibeme_indx init 0
endif

if ich == 1 then

	gibeme_imp init gichime_sonvs[gibeme_indx]
	
	gibeme_indx += 1	

else

	gibeme_imp init gichime_sonvs[gibeme_indx]

endif	

;		OSC1
ihard		init 1-$ampvar	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init $ampvar	; where the block is hit, in the range 0 to 1

imp		init gibeme_imp

kvrate		expseg 3, idur, 12/idur
kvdepth		init $ampvar
ivibfn		init gisine

abel		gogobel $ampvar, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn
arev1		vcomb abel/2, idur*(1+k(envgen(idur, iftenv)*2)), .5/icps, idur
arev2		vcomb abel/3, idur*(1+k(envgen(idur, iftenv)*3)), 1/icps, idur
arev3		vcomb abel/3, idur*(1+k(envgen(idur, iftenv)*4)), 1/(icps*3/2), idur

aout		= abel + arev1/12 + arev2/9 + arev3/7
aout		/= 3
	$mix

	endin



;--- ||| --- ||| ---

gkbetween_space	init 1

	instr between_control

gkbetween_mod		init 1
gkbetween_ph		init 0
gkbetween_var	randomi 1.35, 3.25, gkbeatf/24, 3
gkbetween_var	*= gkbetween_mod

	endin
	alwayson("between_control")

	instr between

Sinstr		init "between"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

istat		init 3
iport		init .85+iamp

icps2		init icps+(iamp*4)

iphase		random 0, i(gkbetween_ph)

kfreq1		loopxseg gkbetween_var, 0, iphase, icps, istat, icps2, iport, icps2*(3/2), istat, icps*(3/2), iport, icps*2, istat, icps2*2, iport
a1		oscil3	$ampvar, kfreq1, gitri

kfreq2		loopxseg gkbetween_var, 0, iphase*2, icps, istat, icps2, iport, icps2*(3/2), istat, icps*(3/2), iport, icps*2, istat, icps2*2, iport
a2		oscil3	$ampvar, kfreq2, gisaw

kfreq3		loopxseg gkbetween_var, 0, iphase*2, icps, istat, icps2, iport, icps2*(3/2), istat, icps*(3/2), iport, icps*2, istat, icps2*2, iport
a3		oscil3	$ampvar, kfreq3*4, gisine
a3		/= 4

af1		flanger a1+a3, a(iport/8), (kfreq1/(icps*2.25))*gkbetween_space
af2		flanger a2+a3, a(iport/6), (kfreq2/(icps*2.25))*gkbetween_space

aout		sum a1, (a2/2)*scale(iamp*4, 0, 1), af1*cosseg:k(0, idur, 1), af2*cosseg:k(0, idur, 1)
;aout		/= 2

;aout		flanger aout, 10+a(kfreq1/1000), .5

;	ENVELOPE
ienvvar		init idur/10

		$death

	endin



;--- ||| --- ||| ---

gkbetweenmore_space	init 1
gkbetweenmore_ph		init 0
gkbetweenmore_freq		init 2


	instr betweenmore

Sinstr		init "betweenmore"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

istat		init 3
iport		init .85+iamp

icps2		init icps+(iamp*4)

iphase		random 0, i(gkbetweenmore_ph)



kfreq1		loopxseg gkbetweenmore_freq, 0, iphase,	icps, istat, icps2, iport, \
													icps2*(5/4), istat, icps*(5/4), iport, \
													icps2*(5/3), istat, icps*(5/3), iport, \
													icps2*(5/2), istat, icps*(5/2), iport, \													
													icps*2, istat, icps2*2, iport
a1		oscil3	$ampvar, kfreq1, gitri

kfreq2		loopxseg gkbetweenmore_freq, 0, iphase,	icps, istat, icps2, iport, \
													icps2*(5/4), istat, icps*(5/4), iport, \
													icps2*(5/3), istat, icps*(5/3), iport, \
													icps2*(5/2), istat, icps*(5/2), iport, \	
													icps*2, istat, icps2*2, iport
a2		oscil3	$ampvar, kfreq2, gisaw

kfreq3		loopxseg gkbetweenmore_freq, 0, iphase,	icps, istat, icps2, iport, \
													icps2*(5/4), istat, icps*(5/4), iport, \
													icps2*(5/3), istat, icps*(5/3), iport, \
													icps2*(5/2), istat, icps*(5/2), iport, \	
													icps*2, istat, icps2*2, iport
a3		oscil3	$ampvar, kfreq3*4, gisine
a3		/= 4

af1		flanger a1+a3, a(iport/8), (kfreq1/(icps*2.25))*gkbetweenmore_space
af2		flanger a2+a3, a(iport/6), (kfreq2/(icps*2.25))*gkbetweenmore_space

aout		sum a1, (a2/2)*scale(iamp*4, 0, 1), af1*cosseg:k(0, idur, 1), af2*cosseg:k(0, idur, 1)
;aout		/= 2

;aout		flanger aout, 10+a(kfreq1/1000), .5

;	ENVELOPE
ienvvar		init idur/10

		$death

	endin




;--- ||| --- ||| ---

    instr burd

Sinstr      init "burd"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7
ienvvar		init idur/10

icpsvar     init icps/100
iharm		init (ich%2)+1

a1		vco2 iamp*abs(lfo(1, (iharm*8)/random:i(55, 65))), (icps*iharm)+random:i(-icpsvar, icpsvar)
a2		vco2 iamp*abs(lfo(1, ((iharm+1)*8)/random:i(55, 65)))*.75, (icps*iharm)+random:i(-icpsvar, icpsvar)

apre    sum a1, a2

aout    moogladder2 apre, (20$k)*(iamp*2.75), random:i(.15, .25)
aout    balance2 aout, apre

    $death

    endin



;--- ||| --- ||| ---

	instr calin

Sinstr		init "calin"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

kharm		init 0
kline		linseg 1, idur*21/22, 11, idur/22, 7
ieach		init (ich%2)

if int(kline)%2 == ieach then

	kharm int kline

endif

if kharm == 0 then
	kharm = 1
endif

kbw 		= icps/expseg(500, idur, 75) 	;bandwidth in Hz

kcar	 	= kharm
amod	 	= 3+ich
kndx		= expseg:k(giexpzero, idur, 1+$ampvar)

ain		foscili $ampvar, icps+randomi:k(-.05, .05, 1/idur, 2, 0)+kbw, kcar, amod+randomi:a(-.015, .015, 1/idur, 2, 0), kndx+randomi:k(-.05, .05, 1/idur), gisine

ao1		oscili $ampvar, icps*(3/kharm), gitri
ao2		oscili $ampvar, icps*(3/int(line(11, idur*random:i(.85, 1.25), 1))), gitri

aosc		sum ao1, ao2

across 		cross2 ain, aosc, 1024, 8, gihan, .5

aout		sum across, ain*$ampvar, aosc*cosseg(0, idur, 1)

idiff		init 8

aout		*= 1/idiff+((abs(lfo(1/idiff, 4+random:i(-.15, .15))*cosseg(1, idur, .25)))*cosseg(0, idur/2, 1))

;	ENVELOPE
ienvvar		init idur/10

		$death
	endin



;--- ||| --- ||| ---

	instr calinin

Sinstr		init "calinin"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

kharm		init 0
kline		linseg 1, idur*21/22, 11, idur/22, 7
ieach		init (ich%2)

if int(kline)%2 == ieach then

	kharm int kline

endif

if kharm == 0 then
	kharm = 1
endif

kbw 		= icps/expseg(500, idur, 75) 	;bandwidth in Hz

kcar	 	= kharm
amod	 	= (3+ich)*$ampvar
kndx		= expseg:k(giexpzero, idur, 1+$ampvar)

ain		foscili $ampvar, icps+randomi:k(-.05, .05, 1/idur, 2, 0)+kbw, kcar, amod+randomi:a(-.015, .015, 1/idur, 2, 0), kndx+randomi:k(-.05, .05, 1/idur), gitri

ao1		oscili $ampvar, icps*(6/kharm), gisine
ao2		oscili $ampvar, icps*(6/int(line(11, idur*random:i(.85, 1.25), 1))), gitri
ao3		oscili $ampvar, limit(icps*(2/kharm), 20, 20$k), gisine

aosc		sum ao1, ao2, ao3

aout		sum ain*$ampvar, aosc*cosseg(0, idur, 1)

idiff		init 8

aout		*= 1/idiff+((abs(lfo(1/idiff, 4+random:i(-.15, .15))*cosseg(1, idur, .25)))*cosseg(0, idur/2, 1))

;	ENVELOPE
ienvvar		init idur/10

		$death
	endin



;--- ||| --- ||| ---

	instr careless

Sinstr		init "careless"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

anoi		fractalnoise $ampvar, 1

kbw 		= icps/expseg(500, idur, 75) 	;bandwidth in Hz

ain		resony anoi, icps, kbw, 16, 16
ain		balance2 ain, anoi

kharm		init 0
kline		line 1, idur, 11
ieach		init (ich%2)

if int(kline)%2 == ieach then

	kharm int kline

endif

if kharm == 0 then
	kharm = 1
endif

ao1		oscili $ampvar, icps*(3/kharm), gitri
ao2		oscili $ampvar, icps*(3/int(line(11, idur*random:i(.85, 1.25), 1))), gitri

aosc		sum ao1, ao2

across 		cross2 ain, aosc, 1024, 8, gihan, .65

aout		= across

idiff		init 2

aout		*= 1/idiff+((abs(lfo(1/idiff, 1.15+random:i(-.05, .05))))*cosseg(0, idur/2, 1))

;	ENVELOPE
ienvvar		init idur/10

		$death
	endin



;--- ||| --- ||| ---

	instr careless2

Sinstr		init "careless2"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

anoi		fractalnoise $ampvar, 1

kbw 		= icps/expseg(500, idur, 75) 	;bandwidth in Hz

ain		resony anoi, icps, kbw, 16, 16
ain		balance2 ain, anoi

kharm		init 0
kline		line 1, idur, 11
ieach		init (ich%2)

if int(kline)%2 == ieach then

	kharm int kline

endif

if kharm == 0 then
	kharm = 1
endif

ao1		oscili $ampvar, icps*(3/kharm), gitri
ao2		oscili $ampvar, icps*(3/int(line(11, idur*random:i(.85, 1.25), 1))), gitri

aosc		sum ao1, ao2

across 		cross2 ain, aosc, 1024, 8, gihan, .65

aout		sum across, ain, aosc*cosseg(0, idur, 1)

idiff		init 12

aout		*= 1/idiff+((abs(lfo(1/idiff, 1.15+random:i(-.05, .05))))*cosseg(0, idur/2, 1))

;	ENVELOPE
ienvvar		init idur/10

		$death
	endin



;--- ||| --- ||| ---

	instr cascade

Sinstr	= "cascade"
idur	init p3*2
iamp	init p4
iftenv	init p5
icps	init p6
ich	init p7
ipan	init icps/100

asquare 		poscil	1, expseg(icps, idur, icps+random:i(-ipan, ipan)), gisquare
asaw			poscil	$ampvar, icps*asquare, gisaw

adel			linseg idur/48, idur, idur*random:i(3.95, 4)

kfb			expseg random:i(.015, .075), idur, random:i(.5, .75)

aout			flanger asaw, adel, kfb
aout			/= 32


;	ENVELOPE
ienvvar			init idur/5

			$death

	endin



;--- ||| --- ||| ---

	instr cascadexp_instr

Sinstr	= "cascadexp"

idur	init p3
iamp	init p4
iftenv	init p5
icps	init p6
ich		init p7
ipan	init icps/95

iamp	init $ampvar

;			1st harmonic
asquare 		poscil	1, expseg(icps, idur, icps+random:i(-ipan, ipan)), gisquare
asaw			poscil	iamp, icps*asquare, gisine

;			2nd harmonic
aharm_mod		poscil	1, expseg(icps, idur, icps+random:i(-ipan, ipan)*4), gitri
aharm2_out		poscil	iamp/32, icps*aharm_mod*7, gisquare

;			3rd harmonic
i1multi3		init 2
a2multi3		cosseg 24, idur, 12
kharm3amp		expseg 12, idur, 32

aharm3_mod		poscil	1, expseg(icps, idur, icps+random:i(-ipan, ipan)*i1multi3), gisquare
aharm3_out		poscil	iamp/kharm3amp, icps*aharm_mod*a2multi3, gisquare

;			total
asyn			sum	asaw, aharm2_out, aharm3_out

adel			expseg random:i(.0015, .0075), idur, random:i(.075, .0075)

kfb				expseg random:i(.75, .705), idur, random:i(.15, .25)

aout			flanger asyn, adel, kfb	

aout			buthp aout, icps - icps/12

;	ENVELOPE
ienvvar		init idur/5

			$death

	endin

	instr cascadexp

Sinstr	= "cascadexp_instr"

iarp	init .0125
idur	init p3
iamp	init p4
iftenv	init p5
icps	init p6
ich		init p7

	schedule Sinstr, random:i(0, iarp),	idur, iamp, iftenv, icps, ich
	schedule Sinstr, random:i(0, iarp),	idur, iamp, iftenv, icps, ich
	schedule Sinstr, random:i(0, iarp),	idur, iamp, iftenv, icps, ich

	turnoff

	endin



;--- ||| --- ||| ---

	instr click

Sinstr		init "click"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6

ain		fractalnoise iamp*2, expseg(.95, idur, .05)

;a1		*= envgen(idur-random:i(0, ienvvar), iftenv)

#define click_krvt	#cosseg(idur, idur, idur/random:i(2, 12))#

ilpt		init 1/icps

a1		comb ain, $click_krvt, ilpt
a2		comb ain, $click_krvt, ilpt

a1		balance a1, ain*$ampvar
a2		balance a2, ain*$ampvar

;		ENVELOPE
ienvvar		init idur/10

$env1
$env2

;		ROUTING
S1		sprintf	"%s-1", Sinstr
S2		sprintf	"%s-2", Sinstr

		chnmix a1, S1
		chnmix a2, S2

	endin



;--- ||| --- ||| ---

	instr curij

Sinstr		init "curij"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

S1		init p8
itab		init p9
S2		init p10
idiv		init p11

aosc1		oscil3 $ampvar, fc(S1, itab, S2, idiv), gitri
aosc2		oscil3 $ampvar, fc(S1, itab, S2, idiv)*3/2, gisine

aosc		= aosc1+aosc2
ienvvar		init idur/10

aout		moogladder2 aosc/4, fc(S1, itab, S2, idiv)*(2*envgen(idur-random:i(0, ienvvar), iftenv)), .35

	$death

	endin



;--- ||| --- ||| ---

	instr curij2

Sinstr		init "curij2"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

S1		init p8
itab		init p9
S2		init p10
idiv		init p11

aosc		vco2 $ampvar, fc(S1, itab, S2, idiv)

ienvvar		init idur/10

aout		moogladder2 aosc/4, fc(S1, itab, S2, idiv)*(2*envgen(idur-random:i(0, ienvvar), iftenv)), .35

	$death

	endin



;--- ||| --- ||| ---

	instr dmitri

Sinstr		init "dmitri"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

anoi		fractalnoise cosseg(iamp, idur, 0), cosseg(0, idur, 2)

asub		resonx anoi, icps, icps/random:i(25, 10)

avco		vco2 cosseg(0, idur, iamp), icps*3/2, 10

asub		balance asub, anoi

apre		sum asub, avco/5

iq			init 5

alow, ahigh, aband	svfilter  apre, cosseg(icps*4, idur, icps), iq

ivibfilter1	random 5, 7
ivibfilter2	init ivibfilter1/2

kviblow		cosseg ivibfilter1, idur, ivibfilter1*random:i(.95, 1.05)
kvibhigh	cosseg ivibfilter2, idur, ivibfilter2*random:i(.95, 1.05)

kvibhigh	= kvibhigh * expseg(1, idur/3, 1, idur/3, 2, idur/3, 2)
kviblow		= kviblow * expseg(1, idur/3, 1, idur/3, 2, idur/3, 2)

alow		*= .5 + lfo(.5, kviblow)

ahigh		*= .5 + lfo(.5, kvibhigh)

aout		sum alow, ahigh, flanger(aband, expseg:a(giexpzero, idur, random:i(.065, .025)), random:i(.65, .85))

aout		/= 2

;		ENVELOPE
ienvvar		init idur/10

		$death

	endin



;--- ||| --- ||| ---

	instr dmitrif_control

gkdmitrif_time randomi gkbeatms, gkbeatms/4, gkbeatf/32

	endin

	instr dmitrif

Sinstr		init "dmitrif"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

anoi		fractalnoise cosseg(iamp, idur, 0), cosseg(0, idur, 2)

asub		resonx anoi, icps, icps/random:i(25, 10)

avco		vco2 cosseg(0, idur, iamp), icps*3/2, 10

asub		balance asub, anoi

apre		sum asub, avco/5

iq			init 5

alow, ahigh, aband	svfilter  apre, cosseg(icps*4, idur, icps), iq

ivibfilter1	random 5, 7
ivibfilter2	init ivibfilter1/2

kviblow		cosseg ivibfilter1, idur, ivibfilter1*random:i(.95, 1.05)
kvibhigh	cosseg ivibfilter2, idur, ivibfilter2*random:i(.95, 1.05)

kvibhigh	= kvibhigh * expseg(1, idur/3, 1, idur/3, 2, idur/3, 2)
kviblow		= kviblow * expseg(1, idur/3, 1, idur/3, 2, idur/3, 2)

alow		*= .5 + lfo(.5, kviblow)

ahigh		*= .5 + lfo(.5, kvibhigh)

asum		sum alow, ahigh, flanger(aband, expseg:a(giexpzero, idur, random:i(.065, .025)), random:i(.65, .85))

itime		i gkdmitrif_time/10
ist			init itime/4
iend		init ist+random(-itime/100, itime/100)

adel		cosseg ist, idur, iend*16

adel		samphold adel, metro(3/idur)

af1			flanger asum, adel+random(-itime/100, itime/100), .995
af1			*= oscil(1, (iamp*8)+random(-itime/100, itime/100), gisotrap)
af2			flanger af1, adel+random(-itime/100, itime/100), .995
af2			*= oscil(1, (iamp*8)+random(-itime/100, itime/100), gisotrap)
af3			flanger af2, adel+random(-itime/100, itime/100), .995
af3			*= oscil(1, (iamp*8)+random(-itime/100, itime/100), gisotrap)

aout		balance2 af3, asum

;		ENVELOPE
ienvvar		init idur/10

		$death

	endin



;--- ||| --- ||| ---

gkeuarm_onset init 11
gkeuarm_pulse init 32

	opcode	euarm_sched, 0, Siiiiiii
	Sinstr, idur, iamp, iftenv, icps, ich, ionset, ipulse xin

ilen	init ipulse
iprev	init -1
ieu[]	init ilen
indx	init 0

irot	init 0

while indx < ipulse do
	ival		=	int((ionset / ipulse) * indx)
	indxrot		=	(indx + irot) % ipulse
	ieu[indxrot]	=	(ival == iprev ? 0 : 1)
	iprev		=	ival
	indx		+=	1
od

inum	init 0

schedule Sinstr, 0, idur, iamp, iftenv, icps, ich, 1, ipulse

iharm init ionset

while inum < ilen do

	if ieu[inum] == 1 then
		
		if inum != 0 then
			schedule Sinstr, (idur/ionset)/inum, idur, iamp, iftenv, icps+((icps/ipulse)*(ipulse-inum)), ich, iharm, ipulse
			iharm -= 1
		endif

	endif		
	inum += 1
od

	endop

	instr euarm

Sinstr		init "euarm_instr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ionset		i gkeuarm_onset
ipulse		i gkeuarm_pulse

euarm_sched(Sinstr, idur, iamp, iftenv, icps, ich, ionset, ipulse)

	endin

	instr euarm_instr

Sinstr		init "euarm"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

iharm		init p8
ipulse		init p9

ipanfreq	init icps/250

aout		oscil3 ($ampvar/(ipulse/6))/(iharm/3), icps + randomi:k(-ipanfreq, ipanfreq, 1/idur), gitri

ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

gkeuarm2_onset init 11
gkeuarm2_pulse init 32

	opcode	euarm2_sched, 0, Siiiiiii
	Sinstr, idur, iamp, iftenv, icps, ich, ionset, ipulse xin

ilen	init ipulse
iprev	init -1
ieu[]	init ilen
indx	init 0

irot	init 0

while indx < ipulse do
	ival		=	int((ionset / ipulse) * indx)
	indxrot		=	(indx + irot) % ipulse
	ieu[indxrot]	=	(ival == iprev ? 0 : 1)
	iprev		=	ival
	indx		+=	1
od

inum	init 0

schedule Sinstr, 0, idur, iamp, iftenv, icps, ich, 1, ionset

iharm init ionset

while inum < ilen do

	if ieu[inum] == 1 then
		
		if inum != 0 then
			schedule Sinstr, (idur/ionset)/inum, idur, iamp, iftenv, icps+(((icps*2)/ipulse)*(ipulse-inum)), ich, iharm, ionset
			iharm -= 1
		endif

	endif		
	inum += 1
od

	endop

	instr euarm2

Sinstr		init "euarm2_instr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ionset		i gkeuarm2_onset
ipulse		i gkeuarm2_pulse

euarm2_sched(Sinstr, idur, iamp, iftenv, icps, ich, ionset, ipulse)

	endin

	instr euarm2_instr

Sinstr		init "euarm2"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

iharm		init p8
ionset		init p9

ipanfreq	init icps/250

aout		oscil3 ($ampvar/(ionset/6))/(iharm/3), icps + randomi:k(-ipanfreq, ipanfreq, 1/idur), gitri

ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

	instr fairest

Sinstr		init "fairest"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ivib		init $p
kvibfreq	= randomi:k(1.5, 5, .25, 3)
iamp		-= ivib

;	a1
atri1	oscil3	1, icps + random:i(-1, 1), gitri
asin1	oscil3	1/4, icps*3 + random:i(-1, 1), gisine
asqu1	oscil3	1/12, icps/2 + random:i(-1, 1), gisquare

aharm1	oscil3	1/8, icps*6/2 + random:i(-1, 1), gisquare


aout	sum	atri1, asin1, asqu1, aharm1
aout	/= 4

aout	distort aout, expseg:k(random:i(.85, .15), idur, .05), gitri
aout	moogladder aout, icps + expseg:k(icps*8 + random:i(-15, 15), idur, 0.05), expseg:k(.5, idur*9/10, random:i(.895, .65), idur/10, .25)
aout	K35_hpf aout, 25, 7.5

aout	*= iamp + (lfo:a(ivib, kvibfreq + random:i(-.15, .15)) * expsega(.0005, idur, 1))

ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

	instr fairest2

Sinstr		init "fairest2"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ivib		= $p
kvibfreq	= randomi:k(1.5, 5, .25, 3)
iamp		-= ivib

iport		init idur/50

kcps		cosseg icps/2, iport, icps, idur-(iport), icps

;	a1
atri1	oscil3	1, kcps + random:i(-1, 1), gitri
asin1	oscil3	1/4, kcps*3 + random:i(-1, 1), gisine
asqu1	oscil3	1/12, kcps/2 + random:i(-1, 1), gisquare

aharm1	oscil3	1/8, kcps*6/2 + random:i(-1, 1), gisquare


aout	sum	atri1, asin1, asqu1, aharm1
aout	/= 4

aout	distort aout, expseg:k(random:i(.85, .15), idur, .05), gitri
aout	moogladder aout, icps + expseg:k(icps*8 + random:i(-15, 15), idur, 0.05), expseg:k(.5, idur*9/10, random:i(.895, .65), idur/10, .25)
aout	K35_hpf aout, 25, 7.5

aout	*= iamp + (lfo:a(ivib, kvibfreq + random:i(-.15, .15)) * expsega(.0005, idur, 1))

ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

gkfim_detune	init 1.95
gkfim_var	init 1

	instr fim_control

gafim_var	= gkbeatf

	endin
	alwayson("fim_control")

	instr fim

Sinstr		init "fim"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

afreq		= icps*oscil3(1, icps*gkfim_detune, gisaw)

as		oscil3	$ampvar, afreq+(gafim_var*gkfim_var), gisine

iff		= limit(icps-(icps/9), 20, 20$k)

aout		atonex	as, iff
aout		balance aout, as

;	ENVELOPE
ienvvar		init idur/10

		$death

	endin



;--- ||| --- ||| ---

giflij_indx	init 1

	instr flij

Sinstr		init "flij_instr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

iharm[]		fillarray 1, 3/2, 4/5, 9/8, 7/8, 6/5
ilenharm	lenarray iharm

indx init 0
until indx >= giflij_indx do
	schedule Sinstr, 0, idur, iamp/(indx+1), iftenv, icps, icps*iharm[floor(indx)], ich
	indx += 1
od

giflij_indx += 1/ginchnls/ginchnls
if giflij_indx >= ilenharm then
	giflij_indx = 1
endif


	turnoff

	endin

	instr flij_instr

Sinstr		init "flij"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
icps_dest	init p7
ich		init p8

aosc		oscili $ampvar, icps+(table3:k(phasor:k(1/idur), iftenv, 1)*icps_dest), gitri

kfreq		init icps*3/2
kord		init 12*$ampvar
kfb		cosseg 0, idur, .95

aout		moogladder2 aosc, icps+(icps*($ampvar*32)), .35
aout		phaser1 aout, kfreq, kord, kfb

ienvvar		init idur/4

	$death

	endin




;--- ||| --- ||| ---

gkflou_p1 init 1

	instr flou

Sinstr		init "flou"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

icps		/= 2

iflou_p1	i gkflou_p1

ijet		init .075+((iamp/16)*iflou_p1)		;Values should be positive, and about 0.3. The useful range is approximately 0.08 to 0.56.
iatk		init .15
idec	 	init .15
inoise_gain	init iamp/3

ivib		init 1/24
;kvibf		= (idur/int(random:i(2, 12)))+cosseg(random:i(-ivib, ivib), idur, 0)

kvibf		= (idur/int(random:i(8, 12)))+cosseg(0, idur, random:i(-ivib, ivib))

kvamp		expseg iamp/6, idur, iamp/2

aorg		wgflute iamp, icps, ijet, iatk, idec, inoise_gain, kvibf, kvamp

af		moogladder2 aorg, icps*(2+(iamp*2)), iamp

asig		= aorg * cosseg:k(0, idur/2, 1, idur/2, 0)
asig		phaser1 asig, 2/icps, 8, .75 
aex		exciter asig, icps*2, icps*8, 3.5+(iamp*4), 3.5+(iamp*8)

aout		sum af, asig/8, aex/12

aout		balance2 aout, aorg

ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

	instr fuji_control

gkfuji_form	randomi $ppp, $fff, gkbeatf/4, 3
gkfuji_oct	randomi $pppp, $mf, gkbeatf/4, 3

	endin
	alwayson("fuji_control")

	instr fuji

Sinstr		init "fuji"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

kris 		init .0035
kdur 		init .0095
kdec 		init .0075

iolaps		init icps * idur

ifna		init gisine  ; Sine wave
ifnb		init iftenv  ; Straight line rise shape

itotdur		init idur

kphs		= 1  ; No phase modulation (constant kphs)

kfund		= icps+random:i(-icps/1000, icps/1000)
;kform		cosseg icps, idur, icps*(1+($ampvar)*idur)
kform		= icps+(table3(line:k(0, idur, 1), iftenv, 1)*gkfuji_form*idur)

koct		= gkfuji_oct*idur*(1-table3(line:k(0, idur, 1), iftenv, 1))
;koct		= idur*(table3(line:k(0, idur, 1), iftenv, 1))

kband		= (1-($ampvar))*(16+idur);line 60, idur, 25
kgliss		= $ampvar;line p16, p3, p17

aout    fof2    $ampvar, kfund, kform, \
		koct, kband, kris, kdur, \
		kdec, iolaps, ifna, \
		ifnb, itotdur, kphs, kgliss

kfreq		cosseg (icps*48)+(icps*$ampvar), idur, (icps*256)+(icps*$ampvar)
;kfreq		= (icps*(9*$ampvar))+(table3(cosseg:k(0, idur, 1), iftenv, 1)*((64*$ampvar*3.5)*icps))

;kfreq		= (icps*16)+((koct*icps)*16)

kfreq		limit kfreq, 7.5$k, 19.5$k

aout		moogladder2 aout, kfreq, $ampvar


ienvvar		init idur/25

	$death

	endin



;--- ||| --- ||| ---

gkgrind_p1	init 1

	instr grind

Sinstr		init "grind"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ienvvar		init idur/10

igrind		i gkgrind_p1

aex		fractalnoise $ampvar, cosseg(.95, idur, .05)
aex		*= envgen((idur/8)-random:i(0, ienvvar), iftenv)

iampred		init 2.75

af		flanger aex/iampred, expseg:a((divz(idur, igrind, gizero))$s, idur, idur*10*igrind)$ms, .95
af		flanger af/iampred, expseg:a((divz(idur, igrind, gizero))$s, idur, idur*5*igrind)$ms, .95

irvt		init 1/icps
aout		comb af/iampred, irvt, irvt

krvt		cosseg idur, idur, idur/32
aout		comb aout/iampred, krvt, irvt

aout		flanger pdhalf(aout/iampred, line(.95, idur/11, -.95)), expon:a((divz(idur, igrind, gizero))$s*.25, idur/12, idur*1.5*igrind)$ms, .75
aout		flanger pdhalf(aout/iampred, line(-.75, idur/4, .95)), expon:a((divz(idur, igrind, gizero))$s*.15, idur/24, idur*3.5*igrind)$ms, .5
aout		dcblock2 aout

	$death

	endin



;--- ||| --- ||| ---

gkgrind2_p1	init 1

	instr grind2

Sinstr		init "grind2"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ienvvar		init idur/10

igrind		i gkgrind_p1

aex		fractalnoise $ampvar, cosseg(1, idur, 0)
;aex		*= cosseg(0, 5$ms, $ampvar, 5$ms, 0)
aex		*= cosseg(0, idur/128, $ampvar, idur/256, 0)

af		flanger aex/3, idur/cosseg:a(64, idur, 96)*igrind, .35

irvt		init 1/icps
a1		comb af, line:k(idur/4, idur, idur/2)*4, irvt

a1		flanger pdhalf(a1, cosseg(.85, idur, -.85)), idur/(12+(2*table3:a(line:a(0, idur, 1), iftenv, 1)))*igrind, .85
a1		flanger pdhalf(a1, cosseg(-.85, idur/2, .35, idur/2, -.75)), idur/(48+(12*table3:a(line:a(1, idur, 0), iftenv, 1)))*igrind, .25

a2		comb a1, line:k(idur/2, idur, idur/24)*8, irvt*2
a3		comb a1, line:k(idur/4, idur, idur/12)*12, irvt*3

aout		sum a1, a2/2, a3/4
aout		*= (20/icps)*1.5
aout		*= .65 + abs(lfo(.35, 3/idur))

	$death

	endin



;--- ||| --- ||| ---

gkgrind3_p1	init 1

	instr grind3

Sinstr		init "grind3"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ienvvar		init idur/10

igrind		i gkgrind_p1

an		fractalnoise $ampvar, cosseg(.95, idur, .05)
ao		oscil3 $ampvar, lfo(icps/100, 4/idur)+(icps*4), gisaw
aex		sum an, ao

aex		*= envgen((idur/4)-random:i(0, ienvvar), iftenv)

iampred		init 8-($ampvar*6)

af		flanger aex/iampred, expseg:a((divz(idur, igrind, gizero)), idur/(2^igrind), idur*5*igrind)$ms, .65

irvt		init 1/icps
aout		comb af, irvt, irvt

krvt		cosseg icps, idur, icps/(2^igrind)
aout		comb aout, krvt, irvt

aout		flanger pdhalf(aout/iampred, line(.95, idur/12, -.95)), expon:a((divz(idur, igrind, gizero))$s*.25, idur/24, idur*1.5*igrind)$ms, .125
aout		flanger pdhalf(aout/iampred, line(-.75, idur/4, .95)), expon:a((divz(idur, igrind, gizero))$s*.15, 35$ms, idur*3.5*igrind)$ms, .95

	$death

	endin



;--- ||| --- ||| ---

	instr inkick

Sinstr		init "inkick"
ich		init p4

aout		inch ginkick_ch

	$mix	

	endin

indx	init 0
until	indx == nchnls do
	schedule nstrnum("inkick")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od




;--- ||| --- ||| ---

	instr insna

Sinstr		init "insna"
ich		init p4

aout		inch ginsna_ch

	$mix	

	endin

indx	init 0
until	indx == nchnls do
	schedule nstrnum("insna")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od





;--- ||| --- ||| ---

giperfactor		init 	11

giperout		ftgen	0, 0, giperfactor,  -2, 0

giperpos		ftgen	0, 0, giperfactor*2, -41, 2, .25, 3, .15, 11, .5, 5, .45     
gipersnap		ftgen	0, 0, giperfactor*4, -41, 5, .25, 3, .15, 11, .5, 15, .45      

gipercluster_linvar	init giperfactor-1

	instr ipercluster

Sinstr		init "ipercluster_instr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

	schedule Sinstr, 0, idur, iamp, iftenv, icps, ich
	schedule Sinstr, 0, idur, iamp, iftenv, limit(icps/8, 20, 20$k), ich
	turnoff

	endin

	instr ipercluster_control

gkipercluster_linvar	= giperfactor/2 + lfo((giperfactor-1)/2, gkbeatf/16)
gkipercluster_vibfreq	randomh 2, 9, .5, 3

	endin
	alwayson("ipercluster_control")

	instr ipercluster_instr

Sinstr		init "ipercluster"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

ift		init gisaw

kx		expseg 1, idur/random(1, 1.25), random(giexpzero, giexpzero*100)

;              		kx,   inumParms,  inumPointsX,  iOutTab,  iPosTab,  iSnapTab  [, iConfigTab] 
	        hvs1    kx, 3, giperfactor, giperout, giperpos, gipersnap

#define ipercluster_var #tab:k(linseg(giexpzero, idur, giperfactor-random(1, i(gkipercluster_linvar))), giperout)#

ain		oscil $ampvar, $ipercluster_var*icps, ift

krvt		cosseg 5/icps, idur, .05/icps
ilpt		init giexpzero*10 

aout		vcomb ain, krvt+(krvt/5), ilpt, 15

aout		*= vibr(.45, (gkipercluster_vibfreq+random(-.15, .15))/idur, gisine)

;		ENVELOPE
ienvvar		init idur/100

			$death

	endin



;--- ||| --- ||| ---

	instr ixland

Sinstr		init "ixland"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ipanfreq	random -.25, .25

ifn		init 0

ichoose[]	fillarray 1, 3
imeth		init ichoose[int(random(0, lenarray(ichoose)))]

ap		pluck $ampvar, icps + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

;		RESONANCE

ap_res1		pluck $ampvar, (icps*4) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth
ap_res2		pluck $ampvar, (icps*6) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth
ap_res3		pluck $ampvar, (icps*7) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

ap_resum	sum ap_res1, ap_res2, ap_res3

ao_res1		oscil3 $ampvar, icps, gitri
ao_res2		oscil3 $ampvar, icps*3, gisine
ao_res3		oscil3 $ampvar, icps*5, gitri
ao_res4		oscil3 $ampvar, icps+(icps*21/9), gitri

ao_resum	sum ao_res1, ao_res2, ao_res3/4, ao_res4/6

;		REVERB

irvt		init idur/24
arev		reverb (ap_resum/4)+(ao_resum/8), irvt

ivib[]		fillarray .5, 1, 2, 3
ivibt		init ivib[int(random(0, lenarray(ivib)))]

arev		*= 1-(oscil:k(1, gkbeatf*(ivibt+random:i(-.05, 05)), gilowasine)*cosseg(0, idur*.95, 1, idur*.05, 1))

aout		sum ap, arev	

ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

gimaij_indx	init 1

	instr maij

Sinstr		init "maij_instr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

iharm[]		fillarray 1, 3/2, 4/5, 9/8, 7/8, 6/5
ilenharm	lenarray iharm

indx init 0
until indx >= gimaij_indx do
	schedule Sinstr, 0, idur, iamp/(indx+1), iftenv, icps*iharm[floor(indx)], ich
	indx += 1
od

gimaij_indx += 1/ginchnls/ginchnls
if gimaij_indx >= ilenharm then
	gimaij_indx = 1
endif


	turnoff

	endin

	instr maij_instr

Sinstr		init "maij"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

aosc		vco2 $ampvar, icps

kfreq		init icps*3/2
kord		init 12*$ampvar
kfb		cosseg 0, idur, .95

aout		moogladder2 aosc, icps+(icps*($ampvar*24)), .35
aout		phaser1 aout, kfreq, kord, kfb

ienvvar		init idur/4

	$death

	endin




;--- ||| --- ||| ---

gimaij2_indx	init 1

	instr maij2

Sinstr		init "maij2_instr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

iharm[]		fillarray 1, 3/2, 4/5, 9/8, 7/8, 6/5
ilenharm	lenarray iharm

indx init 0
until indx >= gimaij2_indx do
	schedule Sinstr, 0, idur, iamp/(indx+1), iftenv, icps, icps*iharm[floor(indx)], ich
	indx += 1
od

gimaij2_indx += 1/ginchnls/ginchnls
if gimaij2_indx >= ilenharm then
	gimaij2_indx = 1
endif


	turnoff

	endin

	instr maij2_instr

Sinstr		init "maij2"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
icps_dest	init p7
ich		init p8

aosc		vco2 $ampvar, icps+(table3:k(phasor:k(1/idur), iftenv, 1)*icps_dest)

kfreq		init icps*3/2
kord		init 12*$ampvar
kfb		cosseg 0, idur, .95

aout		moogladder2 aosc, icps+(icps*($ampvar*24)), .35
aout		phaser1 aout, kfreq, kord, kfb

ienvvar		init idur/4

	$death

	endin




;--- ||| --- ||| ---

	instr meli2

Sinstr		init "meli2"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7


a1		vco2 iamp, icps
a2		vco2 iamp, icps*7

aout 		sum a1, a2

aout		moogladder2 aout, icps*(cosseg:k(12, idur/8, 2)), .5
aout		flanger aout, a(125), .85


ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

gkmhon_cps	init 20
gimhon_choose	init 0
gkmhon_start	init 0
gkmhon_port	init 1

	instr mhon

Sinstr		init "mhon_instr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

istart		init i(gkmhon_start)

if	istart!=0 then
	istart random 0, i(gkmhon_start)
endif

schedule Sinstr, istart,  idur, iamp, iftenv, icps, ich

if	gimhon_choose == 1 then
	gkmhon_cps	= icps
	gimhon_choose init 0
else
	gimhon_choose init 1 
endif

	turnoff

	endin

	instr mhon_instr

Sinstr		init "mhon"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

iport		init i(gkmhon_port)

a1		oscil3 $ampvar, cosseg(i(gkmhon_cps), (idur/8)*iport, icps), gisaw
a2		oscil3 $ampvar, cosseg(i(gkmhon_cps), (idur/6)*iport, icps)*3/2, gitri

aout		sum a1, a2/4

ifact		init 24
iamp_fact	init 8
iq		init $ampvar

amoog_freq	cosseg i(gkmhon_cps)*(ifact+2)*($ampvar*iamp_fact), idur/2, icps*ifact*($ampvar*(iamp_fact/6))
amoog_freq	limit amoog_freq, 25, 20$k

aq		cosseg iq, idur, iq*2
aq		limit a1, 0, .9995

aout		moogladder2 aout, amoog_freq, iq

ienvvar		init idur/10

	$death

	endin 



;--- ||| --- ||| ---

gkmhon2_cps	init 20
gimhon2_choose	init 1
gkmhon2_start	init 0
gkmhon2_ch	init 8

	instr mhon2

Sinstr		init "mhon2_instr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

istart		init i(gkmhon2_start)

schedule Sinstr, istart, idur, iamp, iftenv, icps, ich

gimhon2_choose	= gimhon2_choose%(nchnls*i(gkmhon2_ch))

if	gimhon2_choose == 1 then
	gkmhon2_cps	= icps
	gimhon2_choose += 1 
else
	gimhon2_choose += 1 
endif

	turnoff

	endin

	instr mhon2_instr

Sinstr		init "mhon2"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

a1		oscil3 $ampvar, cosseg(i(gkmhon2_cps), idur/8, icps), gisquare
a2		oscil3 $ampvar, cosseg(i(gkmhon2_cps), idur/6, icps)*3/2*1.975, gitri

aout		sum a1, a2/3

ifact		init 16
iamp_fact	init 8
iq		init $ampvar

amoog_freq	cosseg i(gkmhon_cps)*(ifact)*($ampvar*iamp_fact), idur/6, icps*ifact*($ampvar*iamp_fact)
amoog_freq	limit amoog_freq, 25, 20$k

aq		cosseg iq, idur, iq*2
aq		limit a1, 0, .9995

aout		moogladder2 aout, amoog_freq, iq

ienvvar		init idur/10


	$death

	endin 



;--- ||| --- ||| ---

gkmhon2q_cps	init 20
gimhon2q_choose	init 1
gkmhon2q_start	init 0
gkmhon2q_ch	init 8

	instr mhon2q

Sinstr		init "mhon2q_instr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

istart		init i(gkmhon2q_start)

schedule Sinstr, istart, idur, iamp, iftenv, icps, ich

gimhon2q_choose	= gimhon2_choose%(nchnls*i(gkmhon2_ch))

if	gimhon2q_choose == 1 then
	gkmhon2q_cps	= icps
	gimhon2q_choose += 1 
else
	gimhon2q_choose += 1 
endif

	turnoff

	endin

	instr mhon2q_instr

Sinstr		init "mhon2q"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

a1		oscil3 $ampvar, cosseg(i(gkmhon2q_cps), idur/8, icps), gisquare
a2		oscil3 $ampvar, cosseg(i(gkmhon2q_cps), idur/6, icps)*3/2*1.975, gitri

aout		sum a1, a2/3

ifact		init 16
iamp_fact	init 8
iq		init $ampvar

amoog_freq	cosseg i(gkmhon_cps)*(ifact)*($ampvar*iamp_fact), idur/6, icps*ifact*($ampvar*iamp_fact)
amoog_freq	limit amoog_freq, 25, 20$k

aq		cosseg iq, idur, iq*2
aq		limit a1, 0, .9995

aout		moogladder2 aout, amoog_freq, aq

ienvvar		init idur/10


	$death

	endin 



;--- ||| --- ||| ---

gkmhonq_cps	init 20
gimhonq_choose	init 0
gkmhonq_start	init 0
gkmhonq_port	init 1

	instr mhonq

Sinstr		init "mhonq_instr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

istart		init i(gkmhonq_start)

if	istart!=0 then
	istart random 0, i(gkmhonq_start)
endif

schedule Sinstr, istart,  idur, iamp, iftenv, icps, ich

if	gimhonq_choose == 1 then
	gkmhonq_cps	= icps
	gimhonq_choose init 0
else
	gimhonq_choose init 1 
endif

	turnoff

	endin

	instr mhonq_instr

Sinstr		init "mhonq"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

iport		init i(gkmhonq_port)

a1		oscil3 $ampvar, cosseg(i(gkmhonq_cps), (idur/8)*iport, icps), gisaw
a2		oscil3 $ampvar, cosseg(i(gkmhonq_cps), (idur/6)*iport, icps)*3/2, gitri

aout		sum a1, a2/4

ifact		init 24
iamp_fact	init 8
iq		init $ampvar

amoog_freq	cosseg i(gkmhonq_cps)*(ifact+2)*($ampvar*iamp_fact), idur/2, icps*ifact*($ampvar*(iamp_fact/6))
amoog_freq	limit amoog_freq, 25, 20$k

aq		cosseg iq, idur, iq*2
aq		limit a1, 0, .9995

aout		moogladder2 aout, amoog_freq, aq

ienvvar		init idur/10

	$death

	endin 



;--- ||| --- ||| ---

	instr noij

Sinstr		init "noij"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

i1div2pi	init 0.1592

kpeakdev		= $ampvar * 2 * i1div2pi
kpeakdev2		= $ampvar * cosseg(3, idur, 5) * i1div2pi

;STEREO "CHORUS" ENRICHMENT USING JITTER
kjitR			jitter cosseg(5, idur, .75), 1.5, 3.5

;MODULATORS
aModulator		oscili	kpeakdev*tablei(line(1, idur/2, 0), iftenv, 1), icps * 5, gisine
aModulator2		oscili	kpeakdev2*tablei(line(1, idur/3, 0), iftenv, 1), icps * 2, gitri

avib1			= lfo(icps/35, icps/250)*expseg(giexpzero, idur, 1)

aCarrierR		phasor	portk(icps + kjitR, idur/96, 20)+avib1
aCarrierR		table3	aCarrierR + aModulator + aModulator2, gisaw, 1, 0, 1
aSigR			= aCarrierR * $ampvar

aFilterR		bqrez	aSigR, icps+(icps*(16*$ampvar)), .75
aout			balance2 aFilterR, aSigR

ienvvar			init idur/10

	$death

	endin




;--- ||| --- ||| ---

giohohft	ftgen 0, 0, 2, -2, gisquare, gisine
giohohmorf	ftgen 0, 0, gioscildur, 10, 1

	instr ohoh

Sinstr		init "ohoh"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

ift			init 8
ifreqv		init icps/175

ai		vco2 $ampvar, icps+random(-ifreqv, ifreqv), ift

		ftmorf phasor:k(random(.95, 1)/idur), giohohft, giohohmorf

ivib		random 9.5*iamp, 13.5*iamp
ivar		init .05

ai			*= .5+(oscil:a(.5, ivib+random(-ivar, ivar), giohohmorf))

aout		moogladder ai, icps*(75*$ampvar), .65+random(-.15, .15)

aout		balance aout, ai

;		ENVELOPE
ienvvar		init idur/10

		$death

	endin



;--- ||| --- ||| ---

	instr orphans

Sinstr		init "orphans"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

icpsvar		init icps/100

if icps/2 > 23.5 then
	asub		oscil3 $ampvar, (icps + randomi:k(-icpsvar, icpsvar, 1/idur))/random:i(1.95, 2.15), gisine
	asub		*= .55 + lfo:a(.45, (icpsvar/4) + randomi:k(-icpsvar/8, icpsvar/8, 1/idur))
endif

a1		oscil3 $ampvar, icps + randomi:k(-icpsvar, icpsvar, 1/idur), gisine
a1		*= .75 + lfo:a(.25, (icpsvar/6) + randomi:k(-icpsvar/8, icpsvar/8, 1/idur))

k1     	   line           1.0,		p3, 0
k2         line           -0.5,		p3, 0
k3         line           -$M_PI,	p3, -$M_PI_2
k4         line           0,		p3, $M_PI
k5         line           0,		p3, 0.75
k6         line           0,		p3, -1

across1, across2	crossfm icpsvar/3, icpsvar*1.35*iamp, k4*random:i(1, 3), k5, cosseg(icps, p3, icps/random:i(.955, .995)), gisine, gisine
across3, across4	crossfm icpsvar*1.35*iamp, icpsvar/3, abs(k3), abs(k2)*random:i(1, 3), expseg(icps, p3, icps/random:i(1.025, 1.005)), gisine, gisine

across		sum across1, across2, across3, across4
across		*= iamp/48

aosc		sum asub/3, a1, across
aosc		/= 3

acheby		chebyshevpoly  aosc, 0, k1*iamp, k2, k3, k4, k5*iamp, k6

aout		balance2 acheby, aosc

ienvvar		init idur/5

	$death

	endin



;--- ||| --- ||| ---

	instr orphans2_control

gkorphans2_var lfse 50, 100, gkbeatf/64

	endin
	schedule("orphans2_control", 0, -1)

	instr orphans2

Sinstr		init "orphans2"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

icpsvar		init icps/i(gkorphans2_var)
ift		init gisine

a1		oscil3 $ampvar, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift
a1		*= .5 + lfo:a(.5, icpsvar + randomi:k(-icpsvar, icpsvar, 1/idur))

a2		oscil3 $ampvar, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift
a2		*= .5 + lfo:a(.5, icpsvar*3 + randomi:k(-icpsvar, icpsvar, 1/idur))

a3		oscil3 $ampvar, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift
a3		*= .5 + lfo:a(.5, icpsvar*4 + randomi:k(-icpsvar, icpsvar, 1/idur))

k1     	   line           1,		p3, 0
k2         line           -5.5,		p3, 0
k3         line           -$M_PI*2,	p3, -$M_PI_2
k4         expon           5,		p3, $M_PI*4
k5         expon           1.5,		p3, 0.75*8
k6         line           25*iamp,		p3, -1*2

aosc		sum a1, a2, a3
aosc		/= 3

acheby		chebyshevpoly  aosc, 25*iamp, k1*iamp, k2, k3, k4, k5*iamp, k6
aout		balance2 acheby, aosc

ienvvar		init idur/5

	$death

	endin



;--- ||| --- ||| ---

gkorphans3_vib init .25

	instr orphans3

Sinstr		init "orphans3"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

icpsvar		init icps/100
ift1		init gisine
ift2		init gitri

a1		oscil3 $ampvar, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift1
a1		*= .5 + lfo:a(.5, gkorphans3_vib)

a2		oscil3 $ampvar, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift1
a2		*= .5 + lfo:a(.5, gkorphans3_vib*2)

a3		oscil3 $ampvar, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift2
a3		*= .5 + lfo:a(.5, gkorphans3_vib*3)

a3		moogladder2 a3, icps*2+(cosseg(icps, idur/2, icps*24, idur/2, icps/2)*$ampvar), .5*cosseg(.25, p3, .85)

k1     	   line           1,		p3, 0
k2         line           -5.5,		p3, 0
k3         expon           -7,		p3, -3
k4         expon           5,		p3, 9
k5         expon           1.5,		p3, 0.75*8
k6         line           25*iamp,	p3, -1*2

aosc		sum a1, a2, a3
aosc		/= 2
aosc		dcblock2 aosc

acheby		chebyshevpoly  aosc, 25*iamp, k1*iamp, k2, k3, k4, k5*iamp, k6
aout		balance2 acheby, aosc

ienvvar		init idur/5

	$death

	endin



;--- ||| --- ||| ---

maxalloc	"pij_instr", 10	;maximum polyphony
;prealloc	1, 9 ;preallocate voices
gapij_inrev	init	0
gipij_adsr ftgen 0, 0, 256, -25, 0, 0.000006, 12, 0.000025, 24, 0.0001, 36, 0.000398, 48, 0.001584, 60, 0.006309, 72, 0.02511, 84, 0.1, 96, 0.398107, 108, 1.5848931, 120, 6.3095734, 132, 25.1188, 144, 100.0, 156, 398.10, 168, 1584.89, 256, 2000
gipij_ptof ftgen 0, 0, 512, -25, 0, 0.00012475, 12, 0.00024951, 24, 0.00049901, 36, 0.00099802, 48, 0.00199604, 60, 0.00399209, 72, 0.00798418, 84, 0.01596836, 96, 0.03193671, 108, 0.06387343, 120, 0.12774686, 132, 0.25549372, 144, 0.51098743, 156, 1.02197486, 168, 2.04394973, 180, 4.08789946, 192, 8.17579892, 204, 16.3515978, 216, 32.7031957, 228, 65.4063913, 240, 130.812783, 252, 261.625565, 264, 523.251131, 276, 1046.50226, 288, 2093.00452, 300, 4186.00904, 312, 8372.01809, 324, 16744.0362, 336, 33488.0724, 348, 66976.1447, 360, 133952.289, 372, 267904.579, 384, 535809.158, 396, 1071618.32, 512, 100

gipij_ftrev1 ftgen 0, 0, 128, -25, 0, 0.00227272727, 128, 3.69431518
gipij_ftrev2 ftgen 0, 0, 128, -25, 0, 8.17579892, 128, 13289.7503

opcode	pij_opinstr, a, iiiiiiikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk

iPitch,\			;midi pitch
\;AIR ENV
iAtt_ENV,\		;knob Att
iDec_ENV,\		;knob Dec
iSus_ENV,\		;knob Sus
iRel_ENV,\		;knob Rel
iVel_ENV,\		;knob Vel
iScaling_ENV,\		;knob Scaling
\;AIR GEN
kDC_Noise_GEN,\	;knob DC/Noise
kCut_GEN,\		;knob Cut
kRes_GEN,\		;knob Res
kK_Track_GEN,\		;knob K-Track
kV_Track_GEN,\		;knob V-Track
k1_Pole_GEN,\		;button 1-Pole
\;Pipe
kCtr_MW,\			;knob ModWheel
kPolarity,\		;button Polarity
\;Pipe DELTUNE
kTune_DT,\		;knob Tune
kFine_DT,\		;knob Fine
kSREC_DT,\		;knob Srec
kMW_DT,\			;knob MW
\;Pipe FEEDBACK
kRT_FB,\			;knob RT
kK_TrackFB,\		;knob K-Track
kDamp_FB,\		;knob Damp
\;Pipe ALLPASS TUNE
kTune_AP,\		;knob Tune
kFine_AP,\		;knob Fine
kSREC_AP,\		;knob Srec
kMW_AP,\			;knob MW
\;Pipe ALLPASS
kDffs_AP,\		;knob Dffs
kPower_AP,\		;button Power
\;Pipe PUSH PULL
kOffset,\			;knob Offset
kPush,\			;knob Push
\;Pipe SATURATION
kSoftHard,\		;knob Soft/Hard
kSym,\			;knob Sym
\;Pipe MW FILTER
kHP0,\			;knob HP0
kHP1,\			;knob HP1
kK_TrackH,\		;knob K-TrackH
kLP0,\			;knob LP0
kLP1,\			;knob LP1
kK_TrackL\		;knob K-TrackL
		xin

;		setksmps	1
;******************************************************************************************AIR SECTION
;Input iPitch
;Output aout_Air (to PIPE)
;************************************************************************************************ENV
;Output kout_ENV (to GEN)
iScaling_ENV	= iScaling_ENV * (iPitch - 60)
iAtt_ENV	= iAtt_ENV + iScaling_ENV
iDec_ENV	= iDec_ENV + iScaling_ENV
iRel_ENV	= iRel_ENV + iScaling_ENV
iGate_ENV	= 1 - 0.5 * iVel_ENV

iAtt_ENV	table	iAtt_ENV + 44, gipij_adsr		;exp table; add 44 for positive index
iDec_ENV	table	iDec_ENV + 44, gipij_adsr		;exp table; add 44 for positive index
iRel_ENV	table	iRel_ENV + 44, gipij_adsr		;exp table; add 44 for positive index

iRel_ENV	= iRel_ENV * 6

		xtratim	iRel_ENV + 0.1

krel_ENV	init	0

krel_ENV	release									;outputs release-stage flag
		if   (krel_ENV > .5)	kgoto	rel_ENV		;if in release-stage goto release section
;attack decay and sustain
kmp1_ENV	transeg	0.001, iAtt_ENV, 0, iGate_ENV, iDec_ENV*10,-10, iGate_ENV * iSus_ENV, 1, 0, iGate_ENV * iSus_ENV
kout_ENV	= kmp1_ENV
		kgoto	done_ENV
;release
rel_ENV:
kmp2_ENV	transeg	1, iRel_ENV, -6, 0.0024787521
kout_ENV	= kmp2_ENV * kmp1_ENV

done_ENV:
;kout_ENV is envelope
;************************************************************************************************GEN
;Input kout_ENV (output from ENV)
;Output aout_Air (to PIPE section)

;iPitch_GEN from -48 to +168
kPitch_GEN	= ((iPitch - 60) * kK_Track_GEN + kCut_GEN) * (1 - (0.5 * kV_Track_GEN))

kCut_GEN	table	kPitch_GEN + 192, gipij_ptof	;exp table; add 192 for positive index

anoise_GEN	noise	kout_ENV, 0

	if (k1_Pole_GEN < 0.5)	kgoto Deux_Pole_GEN

;One pole filter LPF1
i2Pisr		= 2*$M_PI/sr
kPhic_GEN	= (kCut_GEN < 6948.89 ? i2Pisr * kCut_GEN : 0.99005)

;LP
aout_LPF	biquad	anoise_GEN, kPhic_GEN, 0, 0, 1, kPhic_GEN-1, 0

		kgoto	Done_GEN
Deux_Pole_GEN:
;Two poles filter LPF2
kRes_GEN	= 0.5  / (1 - kRes_GEN)

aout_LPF	lowpass2	anoise_GEN, kCut_GEN, kRes_GEN

Done_GEN:
aout_Air	= aout_LPF * kDC_Noise_GEN + a(kout_ENV) *  (1 - kDC_Noise_GEN)

;*******************************************************************************************PIPE SECTION
;Input aout_Air (output from AIR)
;Output aout_Pipe (to AMPLI)
;*******************************************************************************************DEL TUNE
;Output idly_DT (to SINGLE DELAY and FEEDBACK)

;iPitch_DT from -27 to +147
kPitch_DT		= iPitch + kTune_DT + kFine_DT + kCtr_MW * kMW_DT
kFreq_DT		table	kPitch_DT + 192, gipij_ptof		;exp table; add 192 for positive index
kdly_DT		= (1/kFreq_DT)+( kSREC_DT/sr)

;************************************************************************************SINGLE DELAY
;Input idly_DT (output from DEL TUNE)
;Input aout_FeedBack (output from FEEDBACK)
;Output aout_SD  (to ALLPASS)

aout_FeedBack	init	0

amaxtime_SD	delayr	1			;set maximum delay
aout_SD		deltap3	 kdly_DT
			delayw	aout_FeedBack

;Send the signal aout_SD to Saturation (Allpass is bypassed) if iPower_AP = 0.

if kPower_AP > 0.5	kgoto	Allpasstune

aout_AP	= aout_SD
		kgoto Saturation
Allpasstune:
;************************************************************************************ALLPASS TUNE
;Output idly_APTune (to ALLPASS)

;iPitch_AP from -27 to +147
kPitch_AP		= iPitch + kTune_AP + kFine_AP + kCtr_MW * kMW_AP
kFreq_AP		table	kPitch_AP + 192, gipij_ptof			;exp table; add 192 for positive index
kdly_APTune	= (1/kFreq_AP)+( kSREC_AP/sr)

;******************************************************************************************ALLPASS
;Input aout_SD (from SINGLE DELAY)
;Input idly_APTune (from ALLPASS TUNE)
;Output aout_AP  (to SATURATION)

;Interp Diffusion	;atime mini=1/sr
adel1_APA	init	0

amaxtime_APA	delayr	0.2						;set maximum delay
aout_AP		= adel1_APA + kDffs_AP * aout_SD		;FEED FORWARD
adel1_APA		deltap3	kdly_APTune				;DELAY
			delayw	aout_SD - kDffs_AP * aout_AP	;FEEDBACK
Saturation:
;**************************************************************************************SATURATION
;Input aout_AP  (from ALLPASS)
;Output aout_Sat  (to MW FILTER)

;Event Clip
kSoftHard_Clip	= ( kSoftHard == 0 ? 0.00001 : kSoftHard)
kSoftHard_Clip = ( kSoftHard == 1 ? 0.99999 : kSoftHard)

kSHS		= kSoftHard_Clip * kSym
kMaxClipper	= kSHS +  kSoftHard_Clip
kMinClipper	= kSHS -  kSoftHard_Clip

aoutClip	limit	aout_AP, kMinClipper, kMaxClipper

;Positive signal
kSat_coefPlus	= 0.5 * (1 + kSym - kMaxClipper)
;Saturator
ain_SatPlus	= (aout_AP - aoutClip) / kSat_coefPlus
;Clipper (to limit output to +2, when input is > +4)
ain_SatPlus	limit	ain_SatPlus, 0, 4							;Positive clip and remove negative signal
aSat_outPlus	= (-0.125 * ain_SatPlus * ain_SatPlus) + ain_SatPlus		;Out=-0.125*In*In+In if In>0 ; In = 4 -> Out = 2

;Negative signal
kSat_coefMoins	= 0.5 * (1 - kSym + kMinClipper)
;Saturator
ain_SatMoins	= (aout_AP - aoutClip) / kSat_coefMoins
;Clipper (to limit output to -2, when input is <-4)
ain_SatMoins	limit	ain_SatMoins, -4, 0							;Negative clip and remove negative signal
aSat_outMoins	= (0.125 * ain_SatMoins * ain_SatMoins) + ain_SatMoins		;Out=0.125*In*In+In if In<0  ; In = -4 -> Out = -2

aout_Sat	= (aSat_outPlus * kSat_coefPlus) +  (aSat_outMoins * kSat_coefMoins) + aoutClip

;*****************************************************************************************MW FILTER
;Input aout_Sat  (from SATURATION)
;Output aout_Pipe (to AMPLI, FEEDBACK, PUSH PULL)

;HPF1
;iPitch_MWHP from -48 to +168
kPitch_MWHP	= (iPitch-60) * kK_TrackH + (1- kCtr_MW) * kHP0 + kCtr_MW * kHP1
kFreq_MWHP	table	kPitch_MWHP + 192, gipij_ptof						;exp table; add 192 for positive index
kPhic_MWHP	= (kFreq_MWHP < 6948.89 ? i2Pisr * kFreq_MWHP : 0.99005)

aout_HPF1	biquad	aout_Sat, 1, -1, 0, 1, kPhic_MWHP-1, 0

;LPF1
;iPitch_MWLP from -48 to +168
kPitch_MWLP	= (iPitch-60) * kK_TrackL + (1- kCtr_MW) * kLP0 + kCtr_MW * kLP1
kFreq_MWLP	table	kPitch_MWLP + 192, gipij_ptof						;exp table; add 192 for positive index
kPhic_MWLP	= (kFreq_MWLP < 6948.89 ? i2Pisr * kFreq_MWLP : 0.99005)

aout_Pipe	biquad	aout_HPF1, kPhic_MWLP, 0, 0, 1, kPhic_MWLP-1, 0

;******************************************************************************************PUSH PULL
;Input aout_Air (from AIR)
;Input aout_Pipe  (from MW FILTER)
;Output aout_PPull (to FEEDBACK)

aout_PPull	= (aout_Pipe * kPush + kPolarity * kOffset) * aout_Air

;******************************************************************************************FEEDBACK
;Input aout_Pipe  (from MW FILTER)
;entrée kdly_DelTune (from DEL TUNE)
;Output aout_FeedBack (to SINGLE DELAY)

;Midi to freq conversion (note 69 = 440Hz)
;Cannot use cpsoct (P/12 + 3) because P can go below -36
kPitch_FB	= (iPitch - 60) * kK_TrackFB  + kRT_FB
kFreq_FB	table	kPitch_FB + 192, gipij_ptof								;exp table; add 192 for positive index
kLevel_FB	= 60.0 * (1 - kdly_DT * kFreq_FB)
kLevel_FB	= 0.001 * ampdb(kLevel_FB)

kPitch_FB_Rel	= kPitch_FB + kDamp_FB
kFreq_FB_Rel	table	kPitch_FB_Rel + 192, gipij_ptof						;exp table; add 192 for positive index
kLevel_FB_Rel	= 60.0 * (1 - kdly_DT * kFreq_FB_Rel)
kLevel_FB_Rel	= 0.001 * ampdb(kLevel_FB_Rel)

		if   (krel_ENV > .5)	kgoto	Rel_FB
aout_FBack	= aout_Pipe * kLevel_FB
		kgoto	done_FB
Rel_FB:
aout_FBack	= aout_Pipe * kLevel_FB_Rel

done_FB:
aout_FeedBack	= (aout_FBack + aout_PPull) * kPolarity
;*****************************************************************************************PIPE SECTION END
		xout	aout_Pipe
endop


    opcode	pij_oprev, a, akkkkkkkkkkkk

aIn_Reverb,\	;audio input
\
kTime_Rev,\	;knob Time
kLR_Rev,\		;knob L/R
kSize_Rev,\	;knob Size
kRT_Rev,\		;knob RT
kLP_Rev,\		;knob LP
kLD_Rev,\		;knob LD
kHD_Rev,\		;knob HD
kFrq_Rev,\	;knob Frq,	LFO sinus frequency
kSpin_Rev,\	;knob Spin,	LFO sinus amplitude
kDizzy_Rev,\	;knob Dizzy,	Slow Random amplitude
kPos_Rev,\	;knob Pos	0 à 1
kMix_Rev\		;knob Mix	0 à 1
		xin

;		setksmps	128	

aoutL_Feed	init	0

;****************************************************************************************DEL SECTION
;***********************************************************************************************
;Inputs ainL_dry and ainR_dry (global stereo signal)
;Outputs aoutL_Del et aoutR_Del (to DIFFUSION)

;direct signal
ainL_dry	= aIn_Reverb

kdelL		=		kTime_Rev * (1 + kLR_Rev)

aoutL_Del		vdelay	ainL_dry, kdelL, 500

;*************************************************************************************DEL SECTION END

;**********************************************************************************DIFFUSION SECTION
;***********************************************************************************************
;Inputs aoutL_Del and aoutR_Del (from DEL)
;Outputs ainL_wet and ainR_wet (to OUT)

;**************************************************************************************EARLY DIFF
;Inputs aoutL_Del and aoutR_Del (from DEL)
;Outputs ainL_EDiff and ainR_EDiff (to LOPASS)

;Diffusion with variable Delay ;ktime mini=2/sr
kDffs		=		0.5 + (kSize_Rev * 0.0041666666)

ktime_1L_ED	table	kSize_Rev + 4, gipij_ftrev1	;exp table; in seconds
ktime_2L_ED	table	kSize_Rev + 8, gipij_ftrev1	;exp table; in seconds
ktime_3L_ED	table	kSize_Rev + 12, gipij_ftrev1	;exp table; in seconds

ktime_1R_ED	table	kSize_Rev + 6, gipij_ftrev1	;exp table; in seconds
ktime_2R_ED	table	kSize_Rev + gipij_adsr, gipij_ftrev1	;exp table; in seconds
ktime_3R_ED	table	kSize_Rev + 14, gipij_ftrev1	;exp table; in seconds

;Diffuser delay 1L
adel1L_ED		init		0
amaxtime1L_ED	delayr	0.2							; set maximum delay 200 ms
aEDiff_1L		=		adel1L_ED + kDffs * aoutL_Del		; FEED FORWARD
adel1L_ED		deltap	ktime_1L_ED					; DELAY
			delayw	aoutL_Del - kDffs * aEDiff_1L		; FEEDBACK
;Diffuser delay 2L
adel2L_ED		init	0
amaxtime2L_ED	delayr	0.2							; set maximum delay 200 ms
aEDiff_2L		=		adel2L_ED + kDffs * aEDiff_1L		; FEED FORWARD
adel2L_ED		deltap	ktime_2L_ED					; DELAY
			delayw	aEDiff_1L - kDffs * aEDiff_2L		; FEEDBACK
;Diffuser delay 3L
adel3L_ED		init	0
amaxtime3L_ED	delayr	0.2							; set maximum delay 200 ms
ainL_EDiff	=		adel3L_ED + kDffs * aEDiff_2L		; FEED FORWARD
adel3L_ED		deltap	ktime_3L_ED					; DELAY
			delayw	aEDiff_2L - kDffs * ainL_EDiff	; FEEDBACK

;*****************************************************************************************LOPASS
;Inputs ainL_EDiff and ainR_EDiff (from EARLY DIFF)
;Outputs aoutL_LP and aoutR_LP  (to DAMP L, POWER FADE L, DAMP R, POWER FADE R)

kfreq_LP		table	kLP_Rev, gipij_ftrev2			;exp2 table; Pitch to freq convertion in hertz

aoutL_LP		tone		ainL_EDiff, kfreq_LP

;**************************************************************************************DAMP L et R
;Inputs aoutL_LP (from LOPASS) and aoutR_Feed (from DIFF R)
;Inputs aoutR_LP (from LOPASS) and aoutL_Feed (from DIFF L)
;Outputs aoutL_Damp (to DIFF L) and aoutR_Damp (to DIFF R)

kvH			= ampdb(-kHD_Rev)
kvL			= ampdb(-kLD_Rev)

ainL_Damp		=		aoutL_LP
aH			pareq	ainL_Damp, 2093, kvH, 0.707 , 2	;L Damp HiShelfEQ
aoutL_Damp	pareq	aH, 262, kvL, 0.707 , 1			;L Damp LoShelfEQ


;***************************************************************************************16 PHASE
;Outputs kphase1,kphase2,kphase3,kphase4 (to DIFF L)
;Outputs kphase5,kphase6,kphase7,kphase8 (to DIFF R)

;LFO +Slow Random gen N1
iseed1		=		0
krand1		randh	kDizzy_Rev, 400, iseed1
krand1		tonek	krand1, kFrq_Rev * 0.7
klfo1		poscil	kSpin_Rev, kFrq_Rev, gisine, 0.9375	;phase=1-1/16
kphase1		=		klfo1 * 0.001 + krand1 * 0.004
kphase5		=		- kphase1
;LFO +Slow Random gen N2
iseed2		=		0.2
krand2		randh	kDizzy_Rev, 400, iseed2
krand2		tonek	krand2, kFrq_Rev * 0.7
klfo2		poscil	kSpin_Rev, kFrq_Rev, gisine, 0.875		;phase=1-2/16
kphase2		=		klfo2 * 0.001 + krand2 * 0.004
kphase6		=		- kphase2
;LFO +Slow Random gen N3
iseed3		=		0.4
krand3		randh	kDizzy_Rev, 400, iseed3
krand3		tonek	krand3, kFrq_Rev * 0.7
klfo3		poscil	kSpin_Rev, kFrq_Rev, gisine, 0.8125	;phase=1-3/16
kphase3		=		klfo3 * 0.001 + krand3 * 0.004
kphase7		=		- kphase3
;LFO +Slow Random gen N4
iseed4		=		0.6
krand4		randh	kDizzy_Rev, 400, iseed4
krand4		tonek	krand4, kFrq_Rev * 0.7
klfo4		poscil	kSpin_Rev, kFrq_Rev, gisine, 0.75		;phase=1-4/16
kphase4		=		klfo4 * 0.001 + krand4 * 0.004
kphase8		=		- kphase4

;******************************************************************************************DIFF L
;Input aoutL_Damp (from DAMP L)
;Outputs aoutL_Diff (to POWER FADE L) and aoutL_Feed (to DAMP R)

;Diffusion with variable Delay ;ktime mini=2/sr
;iDffs same value as in EARLY DIFF

ktime_1L_Diff	table	kSize_Rev + 31, gipij_ftrev1	;exp table; in seconds
ktime_2L_Diff	table	kSize_Rev + 35, gipij_ftrev1	;exp table; in seconds
ktime_3L_Diff	table	kSize_Rev + 39, gipij_ftrev1	;exp table; in seconds
ktime_4L_Diff	table	kSize_Rev + 46, gipij_ftrev1	;exp table; in seconds

ktime_1L_Diff	=		ktime_1L_Diff + kphase1
ktime_2L_Diff	=		ktime_2L_Diff + kphase2
ktime_3L_Diff	=		ktime_3L_Diff + kphase3
ktime_4L_DiffRT	=	ktime_4L_Diff + kphase4

ktime_1L_Diff	portk	ktime_1L_Diff, 0.1
ktime_2L_Diff	portk	ktime_2L_Diff, 0.1
ktime_3L_Diff	portk	ktime_3L_Diff, 0.1
ktime_4L_Diff	portk	ktime_4L_DiffRT, 0.1

;Diffuser delay 1L
adel1L_Diff	init	0
amaxtime1L_Diff	delayr	1.0					; set maximum delay 1000 ms
aDiff_1L		=	adel1L_Diff + kDffs * aoutL_Damp	; FEED FORWARD
adel1L_Diff	deltap3	ktime_1L_Diff				; DELAY
			delayw	aoutL_Damp - kDffs * aDiff_1L	; FEEDBACK

;Diffuser delay 2L
adel2L_Diff	init	0
amaxtime2L_Diff	delayr	1.0					; set maximum delay 1000 ms
aDiff_2L		=	adel2L_Diff + kDffs * aDiff_1L	; FEED FORWARD
adel2L_Diff	deltap3	ktime_2L_Diff				; DELAY
			delayw	aDiff_1L - kDffs * aDiff_2L	; FEEDBACK

;Diffuser delay 3L
adel3L_Diff	init	0
amaxtime3L_Diff	delayr	1.0					; set maximum delay 1000 ms
aoutL_Diff	=	adel3L_Diff + kDffs * aDiff_2L	; FEED FORWARD
adel3L_Diff	deltap3	ktime_3L_Diff				; DELAY
			delayw	aDiff_2L - kDffs * aoutL_Diff	; FEEDBACK

;Single delay 4L
aoutL_SD		vdelay	aoutL_Diff, a(ktime_4L_Diff), 1500

kFeed1		table	kRT_Rev, gipij_ftrev1				;exp table
kFeed2		=	-1.115 / kFeed1

aoutL_Feed	= aoutL_SD * ampdb( ktime_4L_DiffRT * kFeed2)

;*******************************************************************************POWER FADE L and R
;Inputs aoutL_LP (from LOPASS) and aoutL_Diff (from DIFF L)
;Inputs aoutR_LP (from LOPASS) and aoutR_Diff (from DIFF R)
;Outputs ainL_wet and ainR_wet (to OUT)

ksqrtPos_Rev0	= sqrt(1 - kPos_Rev)
ksqrtPos_Rev1	= sqrt(kPos_Rev)

ainL_wet		= ksqrtPos_Rev0 * aoutL_LP + ksqrtPos_Rev1 * aoutL_Diff

;*******************************************************************************DIFFUSION SECTION END

;****************************************************************************************OUT SECTION
;***********************************************************************************************
;Inputs ainL_dry and ainR_dry (global inputs of stereo signal)
;Inputs ainL_wet and ainR_wet (from DIFFUSION)
;Outputs audio aoutL and aoutR

ksqrtMix_Rev0	= sqrt(1 - kMix_Rev)
ksqrtMix_Rev1	= sqrt(kMix_Rev)

aoutL		= ksqrtMix_Rev0 * ainL_dry + ksqrtMix_Rev1 * ainL_wet

;*************************************************************************************OUT SECTION END

		xout		aoutL
endop


    instr	pij	;Pipe (physical waveguide)

Sinstr		init "pij_instr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		ftom p6
ich			init p7

;ctrl reading
;ENV

itot            init 20+29+28
iAtt_ENV		init idur/(20/itot)
iDec_ENV		init idur/(29/itot)
iSus_ENV		init 0
iRel_ENV		init idur/(28/itot)
iVel_ENV		init .45
iScaling_ENV	init 0
;GEN
kDC_Noise_GEN	init .795
kCut_GEN		init 91.25
kRes_GEN		init 0
kK_Track_GEN	init 1.35
kV_Track_GEN	init .35
k1_Pole_GEN     init 0
;Pipe
kCtr_MW		    init 0
iPolarity		init 1
;Pipe DELTUNE
kTune_DT		init 26.45
kFine_DT		init -.245
kSREC_DT		init -1.65
kMW_DT		init 2
;Pipe FEEDBACK
kRT_FB		init -7.25
kK_TrackFB	init 1.265
kDamp_FB	init 0
;Pipe ALLPASS TUNE
kTune_AP	init 1.25
kFine_AP	init .145
kSREC_AP	init -1.25
kMW_AP		init 2
;Pipe ALLPASS
kDffs_AP	init .425
kPower_AP	init 1
;Pipe PUSH PULL
kOffset		init .85
kPush		init 1.245
;Pipe SATURATION
kSoftHard		init .65
kSym			init .125
;Pipe MW FILTER
kHP0			init 0
kHP1			init 0
kK_TrackH		init 1.425
kLP0			init 109.25
kLP1			init 102
kK_TrackL		init .325

kMain_Vol		init $ampvar

iPitch          init icps

kPolarity		= 1 - 2*iPolarity

aout_Pipe		pij_opinstr	iPitch, iAtt_ENV, iDec_ENV, iSus_ENV, iRel_ENV, iVel_ENV, iScaling_ENV, kDC_Noise_GEN, kCut_GEN, kRes_GEN, kK_Track_GEN, kV_Track_GEN, k1_Pole_GEN, kCtr_MW, kPolarity, kTune_DT, kFine_DT, kSREC_DT, kMW_DT, kRT_FB, kK_TrackFB, kDamp_FB, kTune_AP, kFine_AP, kSREC_AP, kMW_AP, kDffs_AP, kPower_AP, kOffset, kPush, kSoftHard, kSym, kHP0, kHP1, kK_TrackH, kLP0, kLP1, kK_TrackL

aout	= gapij_inrev + aout_Pipe * kMain_Vol

    $mix
    
    endin

    instr	pij_rev		;Reverb unit

Sinstr		init "pij"
Sin         init "pij_instr"
ich         init p4
ain         chnget sprintf("%s_%i", Sin, ich)

kTime_Rev		= gkbeats
kLR_Rev		    init -1
kSize_Rev		init 7.25
kRT_Rev		    init 26.45
kLP_Rev		    init 145
kLD_Rev         init 1.25
kHD_Rev         init 1.25
kFrq_Rev		init .75
kSpin_Rev		init .5
kDizzy_Rev	    init .25
kPos_Rev		init .5
kMix_Rev		init .65

			denorm			ain

aout	pij_oprev	ain, kTime_Rev, kLR_Rev, kSize_Rev, kRT_Rev, kLP_Rev, kLD_Rev, kHD_Rev, kFrq_Rev, kSpin_Rev, kDizzy_Rev, kPos_Rev, kMix_Rev

	$mix
    chnclear sprintf("%s_%i", Sin, ich)
    endin

gSpij_instr[]			init ginchnls

indx	init 0
until	indx == nchnls do
	schedule nstrnum("pij_rev")+(indx/1000), 0, -1, indx+1
    gSpij_instr[indx]			sprintf	"pij_instr_%i", indx+1
	indx	+= 1
od



;--- ||| --- ||| ---

maxalloc	"pijnor_instr", 10	;maximum polyphony
;prealloc	1, 9 ;preallocate voices
gapijnor_inrev	init	0
gipijnor_adsr ftgen 0, 0, 256, -25, 0, 0.000006, 12, 0.000025, 24, 0.0001, 36, 0.000398, 48, 0.001584, 60, 0.006309, 72, 0.02511, 84, 0.1, 96, 0.398107, 108, 1.5848931, 120, 6.3095734, 132, 25.1188, 144, 100.0, 156, 398.10, 168, 1584.89, 256, 2000
gipijnor_ptof ftgen 0, 0, 512, -25, 0, 0.00012475, 12, 0.00024951, 24, 0.00049901, 36, 0.00099802, 48, 0.00199604, 60, 0.00399209, 72, 0.00798418, 84, 0.01596836, 96, 0.03193671, 108, 0.06387343, 120, 0.12774686, 132, 0.25549372, 144, 0.51098743, 156, 1.02197486, 168, 2.04394973, 180, 4.08789946, 192, 8.17579892, 204, 16.3515978, 216, 32.7031957, 228, 65.4063913, 240, 130.812783, 252, 261.625565, 264, 523.251131, 276, 1046.50226, 288, 2093.00452, 300, 4186.00904, 312, 8372.01809, 324, 16744.0362, 336, 33488.0724, 348, 66976.1447, 360, 133952.289, 372, 267904.579, 384, 535809.158, 396, 1071618.32, 512, 100

gipijnor_ftrev1 ftgen 0, 0, 128, -25, 0, 0.00227272727, 128, 3.69431518
gipijnor_ftrev2 ftgen 0, 0, 128, -25, 0, 8.17579892, 128, 13289.7503

opcode	pijnor_opinstr, a, iiiiiiikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk

iPitch,\			;midi pitch
\;AIR ENV
iAtt_ENV,\		;knob Att
iDec_ENV,\		;knob Dec
iSus_ENV,\		;knob Sus
iRel_ENV,\		;knob Rel
iVel_ENV,\		;knob Vel
iScaling_ENV,\		;knob Scaling
\;AIR GEN
kDC_Noise_GEN,\	;knob DC/Noise
kCut_GEN,\		;knob Cut
kRes_GEN,\		;knob Res
kK_Track_GEN,\		;knob K-Track
kV_Track_GEN,\		;knob V-Track
k1_Pole_GEN,\		;button 1-Pole
\;Pipe
kCtr_MW,\			;knob ModWheel
kPolarity,\		;button Polarity
\;Pipe DELTUNE
kTune_DT,\		;knob Tune
kFine_DT,\		;knob Fine
kSREC_DT,\		;knob Srec
kMW_DT,\			;knob MW
\;Pipe FEEDBACK
kRT_FB,\			;knob RT
kK_TrackFB,\		;knob K-Track
kDamp_FB,\		;knob Damp
\;Pipe ALLPASS TUNE
kTune_AP,\		;knob Tune
kFine_AP,\		;knob Fine
kSREC_AP,\		;knob Srec
kMW_AP,\			;knob MW
\;Pipe ALLPASS
kDffs_AP,\		;knob Dffs
kPower_AP,\		;button Power
\;Pipe PUSH PULL
kOffset,\			;knob Offset
kPush,\			;knob Push
\;Pipe SATURATION
kSoftHard,\		;knob Soft/Hard
kSym,\			;knob Sym
\;Pipe MW FILTER
kHP0,\			;knob HP0
kHP1,\			;knob HP1
kK_TrackH,\		;knob K-TrackH
kLP0,\			;knob LP0
kLP1,\			;knob LP1
kK_TrackL\		;knob K-TrackL
		xin

;		setksmps	1
;******************************************************************************************AIR SECTION
;Input iPitch
;Output aout_Air (to PIPE)
;************************************************************************************************ENV
;Output kout_ENV (to GEN)
iScaling_ENV	= iScaling_ENV * (iPitch - 60)
iAtt_ENV	= iAtt_ENV + iScaling_ENV
iDec_ENV	= iDec_ENV + iScaling_ENV
iRel_ENV	= iRel_ENV + iScaling_ENV
iGate_ENV	= 1 - 0.5 * iVel_ENV

iAtt_ENV	table	iAtt_ENV + 44, gipijnor_adsr		;exp table; add 44 for positive index
iDec_ENV	table	iDec_ENV + 44, gipijnor_adsr		;exp table; add 44 for positive index
iRel_ENV	table	iRel_ENV + 44, gipijnor_adsr		;exp table; add 44 for positive index

iRel_ENV	= iRel_ENV * 6

		xtratim	iRel_ENV + 0.1

krel_ENV	init	0

krel_ENV	release									;outputs release-stage flag
		if   (krel_ENV > .5)	kgoto	rel_ENV		;if in release-stage goto release section
;attack decay and sustain
kmp1_ENV	transeg	0.001, iAtt_ENV, 0, iGate_ENV, iDec_ENV*10,-10, iGate_ENV * iSus_ENV, 1, 0, iGate_ENV * iSus_ENV
kout_ENV	= kmp1_ENV
		kgoto	done_ENV
;release
rel_ENV:
kmp2_ENV	transeg	1, iRel_ENV, -6, 0.0024787521
kout_ENV	= kmp2_ENV * kmp1_ENV

done_ENV:
;kout_ENV is envelope
;************************************************************************************************GEN
;Input kout_ENV (output from ENV)
;Output aout_Air (to PIPE section)

;iPitch_GEN from -48 to +168
kPitch_GEN	= ((iPitch - 60) * kK_Track_GEN + kCut_GEN) * (1 - (0.5 * kV_Track_GEN))

kCut_GEN	table	kPitch_GEN + 192, gipijnor_ptof	;exp table; add 192 for positive index

anoise_GEN	noise	kout_ENV, 0

	if (k1_Pole_GEN < 0.5)	kgoto Deux_Pole_GEN

;One pole filter LPF1
i2Pisr		= 2*$M_PI/sr
kPhic_GEN	= (kCut_GEN < 6948.89 ? i2Pisr * kCut_GEN : 0.99005)

;LP
aout_LPF	biquad	anoise_GEN, kPhic_GEN, 0, 0, 1, kPhic_GEN-1, 0

		kgoto	Done_GEN
Deux_Pole_GEN:
;Two poles filter LPF2
kRes_GEN	= 0.5  / (1 - kRes_GEN)

aout_LPF	lowpass2	anoise_GEN, kCut_GEN, kRes_GEN

Done_GEN:
aout_Air	= aout_LPF * kDC_Noise_GEN + a(kout_ENV) *  (1 - kDC_Noise_GEN)

;*******************************************************************************************PIPE SECTION
;Input aout_Air (output from AIR)
;Output aout_Pipe (to AMPLI)
;*******************************************************************************************DEL TUNE
;Output idly_DT (to SINGLE DELAY and FEEDBACK)

;iPitch_DT from -27 to +147
kPitch_DT		= iPitch + kTune_DT + kFine_DT + kCtr_MW * kMW_DT
kFreq_DT		table	kPitch_DT + 192, gipijnor_ptof		;exp table; add 192 for positive index
kdly_DT		= (1/kFreq_DT)+( kSREC_DT/sr)

;************************************************************************************SINGLE DELAY
;Input idly_DT (output from DEL TUNE)
;Input aout_FeedBack (output from FEEDBACK)
;Output aout_SD  (to ALLPASS)

aout_FeedBack	init	0

amaxtime_SD	delayr	1			;set maximum delay
aout_SD		deltap3	 kdly_DT
			delayw	aout_FeedBack

;Send the signal aout_SD to Saturation (Allpass is bypassed) if iPower_AP = 0.

if kPower_AP > 0.5	kgoto	Allpasstune

aout_AP	= aout_SD
		kgoto Saturation
Allpasstune:
;************************************************************************************ALLPASS TUNE
;Output idly_APTune (to ALLPASS)

;iPitch_AP from -27 to +147
kPitch_AP		= iPitch + kTune_AP + kFine_AP + kCtr_MW * kMW_AP
kFreq_AP		table	kPitch_AP + 192, gipijnor_ptof			;exp table; add 192 for positive index
kdly_APTune	= (1/kFreq_AP)+( kSREC_AP/sr)

;******************************************************************************************ALLPASS
;Input aout_SD (from SINGLE DELAY)
;Input idly_APTune (from ALLPASS TUNE)
;Output aout_AP  (to SATURATION)

;Interp Diffusion	;atime mini=1/sr
adel1_APA	init	0

amaxtime_APA	delayr	0.2						;set maximum delay
aout_AP		= adel1_APA + kDffs_AP * aout_SD		;FEED FORWARD
adel1_APA		deltap3	kdly_APTune				;DELAY
			delayw	aout_SD - kDffs_AP * aout_AP	;FEEDBACK
Saturation:
;**************************************************************************************SATURATION
;Input aout_AP  (from ALLPASS)
;Output aout_Sat  (to MW FILTER)

;Event Clip
kSoftHard_Clip	= ( kSoftHard == 0 ? 0.00001 : kSoftHard)
kSoftHard_Clip = ( kSoftHard == 1 ? 0.99999 : kSoftHard)

kSHS		= kSoftHard_Clip * kSym
kMaxClipper	= kSHS +  kSoftHard_Clip
kMinClipper	= kSHS -  kSoftHard_Clip

aoutClip	limit	aout_AP, kMinClipper, kMaxClipper

;Positive signal
kSat_coefPlus	= 0.5 * (1 + kSym - kMaxClipper)
;Saturator
ain_SatPlus	= (aout_AP - aoutClip) / kSat_coefPlus
;Clipper (to limit output to +2, when input is > +4)
ain_SatPlus	limit	ain_SatPlus, 0, 4							;Positive clip and remove negative signal
aSat_outPlus	= (-0.125 * ain_SatPlus * ain_SatPlus) + ain_SatPlus		;Out=-0.125*In*In+In if In>0 ; In = 4 -> Out = 2

;Negative signal
kSat_coefMoins	= 0.5 * (1 - kSym + kMinClipper)
;Saturator
ain_SatMoins	= (aout_AP - aoutClip) / kSat_coefMoins
;Clipper (to limit output to -2, when input is <-4)
ain_SatMoins	limit	ain_SatMoins, -4, 0							;Negative clip and remove negative signal
aSat_outMoins	= (0.125 * ain_SatMoins * ain_SatMoins) + ain_SatMoins		;Out=0.125*In*In+In if In<0  ; In = -4 -> Out = -2

aout_Sat	= (aSat_outPlus * kSat_coefPlus) +  (aSat_outMoins * kSat_coefMoins) + aoutClip

;*****************************************************************************************MW FILTER
;Input aout_Sat  (from SATURATION)
;Output aout_Pipe (to AMPLI, FEEDBACK, PUSH PULL)

;HPF1
;iPitch_MWHP from -48 to +168
kPitch_MWHP	= (iPitch-60) * kK_TrackH + (1- kCtr_MW) * kHP0 + kCtr_MW * kHP1
kFreq_MWHP	table	kPitch_MWHP + 192, gipijnor_ptof						;exp table; add 192 for positive index
kPhic_MWHP	= (kFreq_MWHP < 6948.89 ? i2Pisr * kFreq_MWHP : 0.99005)

aout_HPF1	biquad	aout_Sat, 1, -1, 0, 1, kPhic_MWHP-1, 0

;LPF1
;iPitch_MWLP from -48 to +168
kPitch_MWLP	= (iPitch-60) * kK_TrackL + (1- kCtr_MW) * kLP0 + kCtr_MW * kLP1
kFreq_MWLP	table	kPitch_MWLP + 192, gipijnor_ptof						;exp table; add 192 for positive index
kPhic_MWLP	= (kFreq_MWLP < 6948.89 ? i2Pisr * kFreq_MWLP : 0.99005)

aout_Pipe	biquad	aout_HPF1, kPhic_MWLP, 0, 0, 1, kPhic_MWLP-1, 0

;******************************************************************************************PUSH PULL
;Input aout_Air (from AIR)
;Input aout_Pipe  (from MW FILTER)
;Output aout_PPull (to FEEDBACK)

aout_PPull	= (aout_Pipe * kPush + kPolarity * kOffset) * aout_Air

;******************************************************************************************FEEDBACK
;Input aout_Pipe  (from MW FILTER)
;entrée kdly_DelTune (from DEL TUNE)
;Output aout_FeedBack (to SINGLE DELAY)

;Midi to freq conversion (note 69 = 440Hz)
;Cannot use cpsoct (P/12 + 3) because P can go below -36
kPitch_FB	= (iPitch - 60) * kK_TrackFB  + kRT_FB
kFreq_FB	table	kPitch_FB + 192, gipijnor_ptof								;exp table; add 192 for positive index
kLevel_FB	= 60.0 * (1 - kdly_DT * kFreq_FB)
kLevel_FB	= 0.001 * ampdb(kLevel_FB)

kPitch_FB_Rel	= kPitch_FB + kDamp_FB
kFreq_FB_Rel	table	kPitch_FB_Rel + 192, gipijnor_ptof						;exp table; add 192 for positive index
kLevel_FB_Rel	= 60.0 * (1 - kdly_DT * kFreq_FB_Rel)
kLevel_FB_Rel	= 0.001 * ampdb(kLevel_FB_Rel)

		if   (krel_ENV > .5)	kgoto	Rel_FB
aout_FBack	= aout_Pipe * kLevel_FB
		kgoto	done_FB
Rel_FB:
aout_FBack	= aout_Pipe * kLevel_FB_Rel

done_FB:
aout_FeedBack	= (aout_FBack + aout_PPull) * kPolarity
;*****************************************************************************************PIPE SECTION END
		xout	aout_Pipe
endop

    instr	pijnor	;Pipe (physical waveguide)

Sinstr		init "pijnor"
idur		init p3
iamp		init p4
iftenv		init p5
icps		ftom p6
ich			init p7

;ctrl reading
;ENV

itot            init 20+29+28
iAtt_ENV		init idur/(20/itot)
iDec_ENV		init idur/(29/itot)
iSus_ENV		init 0
iRel_ENV		init idur/(28/itot)
iVel_ENV		init .45
iScaling_ENV	init 0
;GEN
kDC_Noise_GEN	init .795
kCut_GEN		init 91.25
kRes_GEN		init 0
kK_Track_GEN	init 1.35
kV_Track_GEN	init .35
k1_Pole_GEN     init 0
;Pipe
kCtr_MW		    init 0
iPolarity		init 1
;Pipe DELTUNE
kTune_DT		init 26.45
kFine_DT		init -.245
kSREC_DT		init -1.65
kMW_DT		init 2
;Pipe FEEDBACK
kRT_FB		init -7.25
kK_TrackFB	init 1.265
kDamp_FB	init 0
;Pipe ALLPASS TUNE
kTune_AP	init 1.25
kFine_AP	init .145
kSREC_AP	init -1.25
kMW_AP		init 2
;Pipe ALLPASS
kDffs_AP	init .425
kPower_AP	init 1
;Pipe PUSH PULL
kOffset		init .85
kPush		init 1.245
;Pipe SATURATION
kSoftHard		init .65
kSym			init .125
;Pipe MW FILTER
kHP0			init 0
kHP1			init 0
kK_TrackH		init 1.425
kLP0			init 109.25
kLP1			init 102
kK_TrackL		init .325

kMain_Vol		init $ampvar

iPitch          init icps

kPolarity		= 1 - 2*iPolarity

aout_Pipe		pijnor_opinstr	iPitch, iAtt_ENV, iDec_ENV, iSus_ENV, iRel_ENV, iVel_ENV, iScaling_ENV, kDC_Noise_GEN, kCut_GEN, kRes_GEN, kK_Track_GEN, kV_Track_GEN, k1_Pole_GEN, kCtr_MW, kPolarity, kTune_DT, kFine_DT, kSREC_DT, kMW_DT, kRT_FB, kK_TrackFB, kDamp_FB, kTune_AP, kFine_AP, kSREC_AP, kMW_AP, kDffs_AP, kPower_AP, kOffset, kPush, kSoftHard, kSym, kHP0, kHP1, kK_TrackH, kLP0, kLP1, kK_TrackL

aout	= gapijnor_inrev + aout_Pipe * kMain_Vol

    $mix
    
    endin





;--- ||| --- ||| ---

	instr puck

Sinstr		init "puck"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

ipanfreq	random -.25, .25

ifn			init 0
imeth		init 6

iharm		init (ich%2)+1

aout		pluck $ampvar, (icps*iharm) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

		instr qb_control

gkqb_freq	abs lfo(gkbeatf*2, gkbeatf/24, 1)
gkqb_q		lfo .235, gkqb_freq/2, 1

gkqb_freq	samphold gkqb_freq, metro($M_PI*(1+(gkqb_q/4)))

		endin
		alwayson("qb_control")

		instr qb

Sinstr		init "qb"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7
ienvvar		init idur/10

;kfreq		init icps/50;expseg icps/random:i(25, 50), p3, icps/random:i(25, 50)

;		OSCIL
ain1		oscil3 $ampvar, icps, gitri
ain2		oscil3 $ampvar, icps*(3/2), gitri
ain3		oscil3 $ampvar, icps*(9/8), gitri
ain4		oscil3 $ampvar, icps*(9/4), gitri

a1		= ain1 * oscil:a(1, gkqb_freq, gisotrap)
a2		= ain2 * oscil:a(1, gkqb_freq/3, gisotrap)
a3		= ain3 * oscil:a(1, $M_PI, gisotrap)

apre		sum a1, a2/2, a3/2, ain4*expseg:a(1, idur/6, gizero) 
apre		/= 4

;		FXs
aph		phaser1 apre, gkqb_freq*2, 50, .75+gkqb_q

afl		flanger apre, a(gkqb_freq)*4, .75+gkqb_q

alast		sum apre/2, aph, afl*2

aout		moogladder2 alast, (20$k)*(iamp*2.75), random:i(.5, .75)
aout		balance2 aout, apre

		$death

		endin



;--- ||| --- ||| ---

	instr repuck

Sinstr		init "repuck"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

ipanfreq	init random:i(-.25, .25)

aout	repluck random:i(.015, .35), $ampvar, icps + random:i(-ipanfreq, ipanfreq), randomh:k(.25, .95, random:i(.05, .15)), random:i(.05, .65), poscil(1, random:i(.05, .25),  gisine)
aout	dcblock2 aout
;	ENVELOPE
ienvvar		init idur/10

aout	buthp aout, icps - icps/12

		$death
	endin



;--- ||| --- ||| ---

	instr skij

Sinstr		init "skij"
idur		init p3
iamp		init p4/2
iftenv		init p5
icps		init p6
ich		init p7

kharm		init 9+($ampvar*3)
klowh		init 5
kmul		expseg 1, idur/3, 1, idur/3, 7, idur/3, 1
iphs		random 0, 1

aout		gbuzz $ampvar/kharm, limit(cosseg(icps/2, idur/64, icps), 20, 20$k)+(lfo(icps/96, 3/idur)*cosseg(0, idur/2, .005, idur/2, 1)), kharm, klowh, kmul, gisine, iphs		

aout		/= cosseg(32, p3, 1)

ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

gksufij_p1	init 64
gksufij_p2	init 1
gksufij_p3	init 32

	instr sufij

Sinstr		init "sufij"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

idiv1		i gksufij_p3
idiv2		init idiv1/5

anoi		fractalnoise $ampvar*cosseg(1, idur, 0)*metro:k(idiv1/idur), cosseg:k(0, idur, 2)
aback		fractalnoise $ampvar*metro:k(idiv2/idur), cosseg:k(2, idur, 0)		
abackagain	fractalnoise $ampvar*linseg(1, idur, 0), cosseg:k(0, idur, 2)		

anoibacksum	sum anoi, aback, abackagain/8

anoif		flanger anoibacksum, a(idur/expseg(12, idur, i(gksufij_p3))), .95

anoisum		sum anoi, anoif

inum		i gksufij_p1				;num of filters
kbf 		cosseg icps*2, idur/24, icps*.5, idur/24, icps, idur*(22/24), icps+random:i(-icps/100, icps/100)				;base frequency, i.e. center frequency of lowest filter in Hz
kbw 		= icps/expseg(95, idur, 350) 	;bandwidth in Hz
ksep 		int cosseg(14, idur, 16)+i(gksufij_p2)				;separation of the center frequency of filters in octaves

idiff		i gksufij_p3

aout		resony anoisum, kbf, kbw, inum+random:i(-inum/idiff, inum/idiff), ksep
aout		balance2 aout, anoi

;aout		*= .5 + (tablei:a(phasor:a(gkbeatf*2), gihsine, 1)*cosseg(0, idur/8, .5))

ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

gksufij2_p1	init 64
gksufij2_p2	init 1
gksufij2_p3	init 32

	instr sufij2

Sinstr		init "sufij2"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

kdiv1		= gksufij2_p3
kdiv2		= kdiv1/5

anoi		fractalnoise $ampvar*cosseg(1, idur, 0)*metro:k(kdiv1/idur), cosseg:k(0, idur, 2)
aback		fractalnoise $ampvar*metro:k(kdiv2/idur), cosseg:k(2, idur, 0)		
abackagain	fractalnoise $ampvar*linseg(1, idur, 0), cosseg:k(0, idur, 2)		

anoibacksum	sum anoi, aback, abackagain/8

anoif		flanger anoibacksum, a(idur/expseg(12, idur, i(gksufij2_p3))), .95

anoisum		sum anoi, anoif

inum		i gksufij2_p1				;num of filters
kbf 		cosseg icps*2, idur/24, icps*.5, idur/24, icps, idur*(22/24), icps+random:i(-icps/100, icps/100)				;base frequency, i.e. center frequency of lowest filter in Hz
kbw 		= icps/expseg(95, idur, 350) 	;bandwidth in Hz
ksep 		int cosseg(14, idur, 16)+i(gksufij2_p2)				;separation of the center frequency of filters in octaves

idiff		i gksufij2_p3

aout		resony anoisum, kbf, kbw, inum+random:i(-inum/idiff, inum/idiff), ksep
aout		balance2 aout, anoi

;aout		*= .5 + (tablei:a(phasor:a(gkbeatf*2), gihsine, 1)*cosseg(0, idur/8, .5))

ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

	instr sunij

Sinstr		init "sunij"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

kcps		= icps+fractalnoise(icps/($M_PI*100), $M_PI_2)

kramp		expseg 64, idur/2, 48 

avco		vco2 $ampvar, kcps

aosc		oscil3 $ampvar, kcps*(1+samphold(kramp/$M_PI, metro:k(gkbeatf*cosseg($M_PI, idur, $M_PI*2)))), gitri

amoog		moogladder2 avco, icps*($M_PI*kramp*$ampvar)+fractalnoise(icps/$M_PI, $M_PI_4), $M_PI_4
amoog		balance2 amoog, avco

aout		sum avco*cosseg(0, idur, 1)*abs(lfo(.5, icps/($M_PI*100))), amoog, aosc*cosseg(2, idur, 1)
aout		/= 3

ienvvar		init idur/$M_PI

	$death

	endin



;--- ||| --- ||| ---

maxalloc "toomuchalone", nchnls

gktoomuchalone_dur		init 1

gitoomuchalone_morf		ftgen 0, 0, 3, -2, gisaw, gitri, gisquare
gitoomuchalone_dummy	ftgen 0, 0, gioscildur, 10, 1

gktoomuchalone_env		init 0

	instr toomuchalone

gktoomuchalone_dur		= p3
gktoomuchalone_amp		= p4
gktoomuchalone_cps		= p6

ich						init p7

kph						portk abs(active:k("toomuchalone")), gktoomuchalone_dur
gktoomuchalone_env		table3 kph, int(abs(p5)), 1

	endin

	instr toomuchalone_instr

Sinstr		init "toomuchalone"
ich			init p4

kport_amp	= gktoomuchalone_dur/8
kport_cps	= gktoomuchalone_dur/4
;kport_env	= gktoomuchalone_dur/4

kamp		= portk(gktoomuchalone_amp, kport_amp)
kcps		= portk(gktoomuchalone_cps, kport_cps)

kranfreq	= kamp/(gktoomuchalone_dur*8) ;.05

acar		oscil3 1, (kcps/2)+oscil3(kcps/100, kcps/randomi:k(95, 105, kranfreq, 3), gisine), gisine

kmorf		table3	phasor:k(kamp/gktoomuchalone_dur), gieclassicr, 1

			ftmorf(kmorf, gitoomuchalone_morf, gitoomuchalone_dummy)

kmod		= kcps/randomi:k(35, 45, .05, 3)
kndx		= randomi:k(.25, .5, .05, 3)

ai			foscil kamp, kcps+oscil3:k(kcps/100, kcps/randomi:k(95, 105, kranfreq, 3), gisine), acar, kmod, kndx, gitoomuchalone_dummy

kcf			table3	phasor:k(kamp/gktoomuchalone_dur), giclassic, 1
kres		= .95 * table3(phasor:k(kamp/gktoomuchalone_dur), gifade, 1)

af			moogladder2 ai, (kcps/2)+(kcps*(kcf*randomi:k(16, 24, kranfreq, 3))), kres

;kenv		portk limit(abs(active:k("toomuchalone")), 0, 1), kport_env

kenv		portk abs(active:k("toomuchalone")), 35$ms

gktoomuchalone_env	*= kenv

aout		= af+ai

aout		*= gktoomuchalone_env

aout		buthp aout, 21.5

	$mix

	endin

indx	init 0
until	indx == nchnls do
	schedule nstrnum("toomuchalone_instr")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od



;--- ||| --- ||| ---

		instr uni

Sinstr		init "uni"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6

;		foscil xamp, kcps, xcar, xmod, kndx, ifn [, iphs]
ivar		init .05
kcar		expon 1, idur, 1+random(-ivar, ivar)
kmod		expon .5, idur, .505
kndx		expon 3.5, idur, iamp
ai1		foscil 	$ampvar, icps, kcar, kmod, kndx, gisaw
ai2		foscil 	$ampvar, icps+random(-ivar, ivar), kcar+random(-ivar, ivar), kmod+random(-ivar, ivar), kndx+random(-ivar, ivar), gisaw

;		buzz xamp, xcps, knh, ifn [, iphs]
kbuzzswap	expon   50*iamp, idur, iamp
ai3		buzz   	$ampvar, icps*1.05, kbuzzswap+random(-iamp, iamp), gisine
ai4		buzz   	$ampvar, icps*1.05+random(-ivar, ivar), kbuzzswap+random(-iamp, iamp), gisine

a1		sum ai1, ai3
a2		sum ai2, ai4

;		ENVELOPE
ienvvar		init idur/10

$env1
$env2

;		ROUTING
S1		sprintf	"%s-1", Sinstr
S2		sprintf	"%s-2", Sinstr

		chnmix a1, S1
		chnmix a2, S2

		endin



;--- ||| --- ||| ---

	instr wendi

Sinstr		init "wendi"
idur		init p3
iamp		init p4*.85
iftenv		init p5
icps		init p6
ich			init p7

kampdist	linseg 5, idur, 0
kdurdist	init 2

kadpar		init .995 ;parameter for the kampdist distribution. Should be in the range of 0.0001 to 1
kddpar		init .75 ;parameter for the kdurdist distribution. Should be in the range of 0.0001 to 1

kvar		cosseg 1, idur, icps/15

kminfreq	= icps-kvar
kmaxfreq	= icps+kvar

;multiplier for the distribution's delta value for amplitude (1.0 is full range)
kampscl		cosseg .05, idur, 1

;multiplier for the distribution's delta value for duration
kdurscl		cosseg 0, idur, iamp

initcps		init 8+(iamp*48)
knum		cosseg initcps, idur, initcps*.75

;	instr
ai1		gendy $ampvar, kampdist, kdurdist, kadpar, kddpar, kminfreq, kmaxfreq, kampscl, kdurscl, initcps, knum

ai2		oscil $ampvar, icps*3/random(1.995, 2.005), gisine

ai2		*= expseg(1, idur*.75, giexpzero)

aout	sum ai1, ai2/2

;	ENVELOPE
ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

	instr wendj

Sinstr		init "wendj"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

;	gendy kamp, kampdist, kdurdist, kadpar, kddpar, kminfreq, kmaxfreq, kampscl, kdurscl [, initcps] [, knum]

kampdist	init 1
kdurdist	init 0

kadpar		init .995 ;parameter for the kampdist distribution. Should be in the range of 0.0001 to 1
kddpar		init .45 ;parameter for the kdurdist distribution. Should be in the range of 0.0001 to 1

kvar		expseg icps/75, idur, icps/15

kminfreq	= icps-kvar
kmaxfreq	= icps+kvar

kampscl		init .95 ;multiplier for the distribution's delta value for amplitude (1.0 is full range)
kdurscl		init .15 ;multiplier for the distribution's delta value for duration

initcps		init 16+(iamp*32)

;		INSTR
ainstr1_out			gendy $ampvar, kampdist, kdurdist, kadpar, kddpar, kminfreq, kmaxfreq, kampscl, kdurscl, initcps

;		INSTR 2
ainstr2_1		oscil $ampvar, icps*random:i(1.995, 2.005)*2, gisaw
ainstr2_2		oscil $ampvar, icps*random:i(1.995, 2.005)*4, gisaw

ainstr2_out		sum ainstr2_1, ainstr2_2/1.75

iatk		init idur*.05
idec		init idur*.45
isus		init random(.35, .45)
irel		init idur*.5

#define 	wendjvib2 #abs(oscil(1, cosseg(random(.5, 1)/iatk, idur, random(5, 45)/irel), gisine))#

ainstr2_out		= ainstr2_out * linseg(0, iatk, 1, idec, isus, irel, 0) * $wendjvib2

;		INSTR 3
ainstr3_out		oscil $ampvar, icps*random:i(1.995, 2.005)/2, gitri
ainstr3_out		*= cosseg(1, idur/(3+gauss(.25)), 0)

;		MIX
aout		sum ainstr1_out, ainstr2_out*.65, ainstr3_out*1.35

;		ENVELOPE
ienvvar		init idur/10

		$death

	endin



;--- ||| --- ||| ---

	instr wendy

Sinstr		init "wendy"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

;	gendy kamp, kampdist, kdurdist, kadpar, kddpar, kminfreq, kmaxfreq, kampscl, kdurscl [, initcps] [, knum]

kampdist	init .075
kdurdist	init .5

kadpar		init .35 ;parameter for the kampdist distribution. Should be in the range of 0.0001 to 1
kddpar		init .45 ;parameter for the kdurdist distribution. Should be in the range of 0.0001 to 1

kminfreq	init icps-2.5
kmaxfreq	init icps+2.5

kampscl		init .5 ;multiplier for the distribution's delta value for amplitude (1.0 is full range)
kdurscl		init .45 ;multiplier for the distribution's delta value for duration

initcps		init 16

;	instr
aout	gendy $ampvar, kampdist, kdurdist, kadpar, kddpar, kminfreq, kmaxfreq, kampscl, kdurscl, initcps

;	ENVELOPE
ienvvar		init idur/10

		$death

	endin



;--- ||| --- ||| ---

gkwitches_mod		init 1 ;mod parameter for witches instr
gkwitches_ndx		init 3 ;index parameter for witches instr
gkwitches_detune	init 0 ;detune parameter for witches instr


	instr witches

Sinstr		init "witches_instr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

indx	= i(gkwitches_ndx)
idetune = i(gkwitches_detune)

	schedule Sinstr, 0, 								p3, iamp, 		iftenv,		icps,					indx, ich
	schedule Sinstr, random:i(p3/16, (p3/16)*2),		p3, iamp/3,		iftenv,		(icps*2)+idetune, 		indx, ich
	schedule Sinstr, random:i(p3/12, (p3/12)*2),		p3, iamp/5,		iftenv, 	(icps*3)+(idetune*2), 	indx, ich

	schedule Sinstr, random:i(p3/5, (p3/5)*2),			p3, iamp/12,	iftenv, 	(icps*7)+(idetune*2), 	indx, ich
	schedule Sinstr, random:i(p3/3, (p3/3)*2),			p3, iamp/16,	iftenv, 	(icps*11)+(idetune*3),	indx, ich

	turnoff

	endin

	instr witches_instr

Sinstr		init "witches"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
indx		init p7
ich			init p8

kcar 	= int(expseg:k(1, idur, limit(idur, 1, 7)))
amod 	a gkwitches_mod
kndx	= expseg:k(.05, idur, indx)

aout	foscili $ampvar, icps+randomi:k(-.05, .05, 1/idur, 2, 0), kcar, amod+randomi:a(-.0015, .0015, 1/idur, 2, 0), kndx+randomi:k(-.05, .05, 1/idur), gisine

;	ENVELOPE
ienvvar		init idur/10

		$death

	endin



;--- ||| --- ||| ---

gkwutang_vib init 0

	instr wutang

Sinstr		init "wutang"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

ival		init iamp*2

kcps	= icps + vibr(cosseg(.05, idur, icps/4), random:i(idur*2.5, idur*5), gisaw)

kcx1		expseg	iamp, idur, ival
kcx2		cosseg	iamp, idur, ival*iamp

krx1		expseg	iamp, idur/2, ival
krx2		cosseg	ival*iamp, idur, iamp

;		FOND
asig		wterrain    $ampvar, icps+(lfo:k(gkwutang_vib, random:i(3, 5))), kcx1, kcx2, krx1, krx2, gitri, gisine

;		HARMs
ifact		init 3
ah1		wterrain    $ampvar, (kcps*3), kcx1/ifact, kcx2/ifact, krx1/ifact, krx2/ifact, gisaw, gisquare

kamp		= abs(lfo($ampvar, cosseg(icps/85, idur, 1/idur)))
ah2		wterrain    kamp, (icps*4), kcx1/ifact, kcx2/ifact, krx1/ifact, krx2/ifact, gisaw, gisquare

aharms		sum ah1, ah2

aharms		*= cosseg:k(1, idur/2, iamp/4, idur/2, 1)

;		FILTRE
aharms		moogladder2 aharms, 7500+((13.5$k)*iamp), limit(kcx1, 0, .95)

aout		sum asig, aharms
aout		/= 2

ienvvar		init idur/10

	$death

	endin



;--- ||| --- ||| ---

;gixylo[]  fillarray 1, 3.932, 9.538, 16.688, 24.566, 31.147
;givibes[] fillarray 1, 3.997, 9.469, 15.566, 20.863, 29.440

gixylo		ftgen		0, 0, 6, -2, 1, 3.932, 9.538, 16.688, 24.566, 31.147
givibes		ftgen		0, 0, 6, -2, 1, 3.997, 9.469, 15.566, 20.863, 29.440

gixylomorf	ftgen		0, 0, 2, -2, gixylo, givibes
gixylodummy	ftgen		0, 0, 6, 10, 1

    instr xylo

Sinstr		init "xylo"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

ienvvar		init idur/5

      		ftmorf limit(idur, 0, 12)/2, gixylomorf, gixylodummy

aenv    envgen	(idur*(1/tab_i(0, gixylodummy)))-random:i(0, ienvvar), iftenv
a1      oscil3  iamp*aenv, icps*tab_i(0, gixylodummy), gisine

aenv    envgen	(idur*(1/tab_i(1, gixylodummy)))-random:i(0, ienvvar), iftenv
a2      oscil3  iamp*aenv, icps*tab_i(1, gixylodummy), gisine

ir3     init icps*tab_i(2, gixylodummy)
if      ir3<20$k then
    iamp		= p4/2

    aenv    envgen	(idur*(1/ir3))-random:i(0, ienvvar), iftenv
    a3      oscil3  iamp*aenv, icps*ir3, gisine
    imax    init ir3

    ir4     init icps*tab_i(3, gixylodummy)
    if      ir4<20$k then
        iamp		= p4/2

        aenv    envgen	(idur*(1/ir4))-random:i(0, ienvvar), iftenv
        a4      oscil3  iamp*aenv, icps*ir4, gisine
        imax    init ir4

        ir5     init icps*tab_i(4, gixylodummy)
        if      ir5<20$k then
            iamp		= p4/2

            aenv    envgen	(idur*(1/ir5))-random:i(0, ienvvar), iftenv
            a5      oscil3  iamp*aenv, icps*ir5, gisine
            imax    init ir5

            ir6     init icps*tab_i(5, gixylodummy)
            if      ir6<20$k then
                iamp		= p4/2

                aenv    envgen	(idur*(1/ir6))-random:i(0, ienvvar), iftenv
                a6      oscil3  iamp*aenv, icps*ir6, gisine
                imax    init ir6
            endif
        endif
    endif
endif

aout    sum     a1, a2, a3, a4, a5, a6

;aout	exciter aout, icps*tab_i(0, gixylodummy)/2, imax, random:i(.5, 1)*7, random:i(5.5, 9.5)

	$death

    endin



;--- ||| --- ||| ---

giflingjm_ft	init gihsaw

giringj7_arr[]	genarray 1, ginchnls

gkringj6_port	init 0
gkringj5_port	init 0
gkringhj5_port	init 0

;   1 PARAM OPCODEs

    opcode  abj, 0, SJPo
Sinstr, kp1, kgain, ich xin

if  ich==ginchnls-1 goto next
		abj Sinstr, kp1, kgain, ich+1

next:

;   INIT
if  kp1 ==-1 then
        kp1 = .5
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---OP1
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kp1, kgain, ich xin

kfreq	= kp1

afx	abs ain
afx	balance2 afx, ain

amod	abs lfo:a(1, kfreq/2)

afx	*= (1-amod)
ain	*= amod

aout	sum afx, ain


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  combj, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		combj Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

;krvt -- the reverberation time (defined as the time in seconds for a signal to decay to 1/1000, or 60dB down from its original amplitude).
;xlpt -- variable loop time in seconds, same as ilpt in comb. Loop time can be as large as imaxlpt.
;imaxlpt -- maximum loop time for klpt

imaxlpt	init 5

krvt	= ktime
klpt	= kfb*(imaxlpt/1000)

aout	vcomb ain, krvt/1000, klpt, imaxlpt


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  combj2, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		combj2 Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich

;krvt -- the reverberation time (defined as the time in seconds for a signal to decay to 1/1000, or 60dB down from its original amplitude).
;xlpt -- variable loop time in seconds, same as ilpt in comb. Loop time can be as large as imaxlpt.
;imaxlpt -- maximum loop time for klpt

imaxlpt	init 5

krvt	= ktime/1000
klpt	= kfb*(imaxlpt/1000)

aout	vcomb ain, krvt, klpt, imaxlpt
aout    flanger aout, a(ktime), kfb

	chnmix aout, gSmouth[ich]

    endop


;   2 STRINGS OPCODEs

    opcode  convj, 0, SSJPo
Sin, Sout, kp1, kgain, ich xin

if      ich==ginchnls-1 goto next
		convj Sin, Sout, kp1, kgain, ich+1

next:


;   INPUT
ain		chnget sprintf("%s_%i", Sin, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin, Sout, kp1, kgain, ich

if  kp1==-1 then
        kp1 = 1
endif

aout    cross2 ain, chnget:a(sprintf("%s_%i", Sout, ich+1)), 4096, 8, gihan, kp1



		chnmix aout, gSmouth[ich]

    endop


;   2 STRINGS OPCODEs

    opcode  convj2, 0, SSJPo
Sin, Sout, kp1, kgain, ich xin

if      ich==ginchnls-1 goto next
		convj2 Sin, Sout, kp1, kgain, ich+1

next:


;   INPUT
ain		chnget sprintf("%s_%i", Sin, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin, Sout, kp1, kgain, ich

if  kp1==-1 then
        kp1 = 1
endif

aout    cross2 ain, chnget:a(sprintf("%s_%i", Sout, ich+1)), 4096, 8, gihan, kp1
aout    pdhalf aout/16, -.85
aout    pdhalf aout/16, -.95


		chnmix aout, gSmouth[ich]

    endop


;   2 STRINGS OPCODEs

    opcode  convj3, 0, SSJPo
Sin, Sout, kp1, kgain, ich xin

if      ich==ginchnls-1 goto next
		convj3 Sin, Sout, kp1, kgain, ich+1

next:


;   INPUT
ain		chnget sprintf("%s_%i", Sin, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin, Sout, kp1, kgain, ich

aplus init 0

if  kp1==-1 then
        kp1 = 1
endif

aplus	= ain + (aplus*.85)

aout    cross2 ain, chnget:a(sprintf("%s_%i", Sout, ich+1)), 4096, 8, gihan, kp1
aout    pdhalf aout/16, -.85
aout    pdhalf aout/16, -.95

aplus	= aout


		chnmix aout, gSmouth[ich]

    endop


;   1 PARAM OPCODEs

    opcode  distj1, 0, SJPo
Sinstr, kp1, kgain, ich xin

if  ich==ginchnls-1 goto next
		distj1 Sinstr, kp1, kgain, ich+1

next:

;   INIT
if  kp1 ==-1 then
        kp1 = .5
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---OP1
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kp1, kgain, ich xin

ift     init gisigm1
kdist	= kp1

aout    distort ain, kdist, ift;[, ihp, istor]
aout	balance2 aout, ain


	chnmix aout, gSmouth[ich]

    endop


;   1 PARAM OPCODEs

    opcode  distj2, 0, SJPo
Sinstr, kp1, kgain, ich xin

if  ich==ginchnls-1 goto next
		distj2 Sinstr, kp1, kgain, ich+1

next:

;   INIT
if  kp1 ==-1 then
        kp1 = .5
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---OP1
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kp1, kgain, ich xin

ift     init gisigm2
kdist	= kp1

aout    distort ain, kdist, ift;[, ihp, istor]
aout	balance2 aout, ain


	chnmix aout, gSmouth[ich]

    endop


;   2 STRINGS OPCODEs

    opcode  envfrj, 0, SSJPo
Sin, Sout, kp1, kgain, ich xin

if      ich==ginchnls-1 goto next
		envfrj Sin, Sout, kp1, kgain, ich+1

next:


;   INPUT
ain		chnget sprintf("%s_%i", Sin, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin (ain), Sout, kp1, kgain, ich

idepth  init 512
ires    init .75

if  kp1==-1 then
        kp1 = .5
endif

aflow    follow ain, (ksmps / sr) * 128
aflow    butterlp aflow, 35

avcf    moogvcf ain, aflow*idepth, ires
aenv    balance2 aflow, avcf

kenv    k aenv

idiv    init 32
kchange init (sr / idiv)+1

if kenv>kp1 && kchange > (sr / idiv) then

	kfreq		once fillarray(.5, 2) ;probability of freezing freqs: 1/4
	kamp		once fillarray(0, 1)	
	kchange = 0

	printks2 "envfrj--change %f\n", kfreq

endif

ifftsize       	init 4096
ioverlap	init ifftsize / 4
iwinsize	init ifftsize
iwinshape	init 0

aout   		chnget sprintf("%s_%i", Sout, ich+1)

fftin		pvsanal	aout, ifftsize, ioverlap, iwinsize, iwinshape ;fft-analysis of file
freeze		pvsfreeze fftin, portk(.95+kamp, gkbeats), kfreq ;freeze amps or freqs independently
aout		pvsynth	freeze ;resynthesize

aout   		balance2 aout, aenv

kchange		+= 1




		chnmix aout, gSmouth[ich]

    endop


;   2 STRINGS OPCODEs

    opcode  envj, 0, SSJPo
Sin, Sout, kp1, kgain, ich xin

if      ich==ginchnls-1 goto next
		envj Sin, Sout, kp1, kgain, ich+1

next:


;   INPUT
ain		chnget sprintf("%s_%i", Sin, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin (ain), Sout, kp1, kgain, ich

idepth  init 512
ires    init .75

if  kp1==-1 then
        kp1 = .5
endif

aflow    follow ain, (ksmps / sr) * 128
aflow    butterlp aflow, 35

avcf    moogvcf ain, aflow*idepth, ires
aenv    balance2 aflow, avcf

;aout    oscili 1, kfreq, gitri
aout    chnget sprintf("%s_%i", Sout, ich+1)
aout    balance2 aout, aenv


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingj, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingj Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    = ktime

aout	flanger ain, a(kdel)/1000, kfb


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingj2, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingj2 Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

imaxfb		init .995
kdel        = ktime

a1		flanger ain, a(kdel)/1000, kfb%imaxfb

kdel	*= 2
kfb		*= 2
a2		flanger a1, a(kdel)/1000, kfb%imaxfb

kdel	*= 3
kfb		*= 3
a3		flanger a2, a(kdel)/1000, kfb%imaxfb

aout		= a3


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingj3, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingj3 Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

imaxfb	init .995
kdel        = ktime

a1		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)

kdel	*= 2
kfb		*= 2
a2		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)

kdel	*= 3
kfb		*= 3
a3		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)

aout		sum a1, a2, a3


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingj4, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingj4 Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

imaxfb		init .995
kdel        = ktime

a1		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)
kdel		*= 2
a2		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)
kdel		*= 3
a3		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)
aout		sum a1, a2, a3


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingjagm, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingjagm Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    = ktime
adel	= a(kdel)/1000

aout	flanger ain, adel, kfb, 15

aout	*= kgain


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingjm, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingjm Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    = ktime

aoutf	flanger ain, a(kdel)/1000, kfb

kfreq	= 1/(ktime/1000)
kfreq	limit kfreq, gizero, gkbeatf*4

aoutm	moogladder2 aoutf, 25+oscili:a(7.5$k*kfb, kfreq, giflingjm_ft), limit(.995-kfb, 0, .995)
aoutm	flanger aoutm, a(kdel)/500, kfb

aout	sum aoutf, balance2(aoutm, aoutf)
aout	/= 2




	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingjs, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingjs Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    	= ktime
kdel		+= randomi:k(0, kdel/4, .25/kdel)

aout		flanger ain, a(kdel)/1000, kfb


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  flingjs2, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		flingjs2 Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    	= ktime
kdel		+= randomi:k(0, kdel/4, .25/kdel)

aout		flanger ain, a(kdel)/1000/(ich+1), kfb


	chnmix aout, gSmouth[ich]

    endop


;   FREQ DOMAIN OPCODEs

    opcode  foj, 0, SJJPo
Sinstr, kfreq, kq, kgain, ich xin

if      ich==ginchnls-1 goto next
                foj Sinstr, kfreq, kq, kgain, ich+1

next:

;       INIT
if      kfreq==-1 then
                kfreq = ntof("3B")
endif

if  kq==-1 then
        kq = .65
endif

;       LIMIT
kfreq   limit kfreq, 10, 21$k
kq      limit kq, 0, .95

;       INPUT
ain     chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

;xris -- impulse response attack time (secs).
;xdec -- impulse response decay time (secs).

kfreq_var	init 5

kris	= kq
kdec	= 1-kq

kdec	limit kdec, 0, kris*2

aout	fofilter ain, kfreq+randomi:k(-kfreq_var, kfreq_var, .05), kris/1000, kdec/1000


        chnmix aout, gSmouth[ich]

    endop


;   FREQ DOMAIN OPCODEs

    opcode  foj2, 0, SJJPo
Sinstr, kfreq, kq, kgain, ich xin

if      ich==ginchnls-1 goto next
                foj2 Sinstr, kfreq, kq, kgain, ich+1

next:

;       INIT
if      kfreq==-1 then
                kfreq = ntof("3B")
endif

if  kq==-1 then
        kq = .65
endif

;       LIMIT
kfreq   limit kfreq, 10, 21$k
kq      limit kq, 0, .95

;       INPUT
ain     chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

;xris -- impulse response attack time (secs).
;xdec -- impulse response decay time (secs).

ifreq_var	init 5

kris	= kq
kdec	= 1-kq

kdec	limit kdec, 0, kris*2

aout	fofilter ain, kfreq+randomi:k(-ifreq_var, ifreq_var, .05), kris/1000, kdec/1000
aout	fofilter aout, kfreq+randomi:k(-ifreq_var, ifreq_var, .05)*2, kris/500, kdec/500


        chnmix aout, gSmouth[ich]

    endop


;   2 STRINGS OPCODEs

    opcode  folj, 0, SSJPo
Sin, Sout, kp1, kgain, ich xin

if      ich==ginchnls-1 goto next
		folj Sin, Sout, kp1, kgain, ich+1

next:


;   INPUT
ain		chnget sprintf("%s_%i", Sin, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---2STRINGS
;opcode  ---NAME---, 0, SSJPo
;Sin, Sout, kp1, kgain, ich

if  kp1==-1 then
        kp1 = 0
endif

kp1	/= 1000

aenv    follow2 chnget:a(sprintf("%s_%i", Sout, ich+1)), 5$ms, 25$ms+kp1
aout	balance2 ain, aenv


		chnmix aout, gSmouth[ich]

    endop


;   ANALYSIS DOMAIN OPCODEs

    opcode  frj, 0, SJJjjPo
Sinstr, kpitch, kfb, iwin, ift, kgain, ich xin

if		ich==ginchnls-1 goto next
		frj Sinstr, kpitch, kfb, iwin, ift, kgain, ich+1

next:

;   INIT
if  kpitch==-1 then
        kpitch = 1
endif

if  kfb==-1 then
        kfb = .65
endif

if  iwin==-1 then
        iwin init 11
endif

if  ift==-1 then
        ift init gisine
endif

;   LIMIT
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .95
#end

iwin    limit iwin, 0, 13
iwin    = 2^iwin

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain             *= kgain

;---INSTRUMENT---
;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

kdel        = gkbeats/12

if	kfb!=0 then
	aout	flanger ain, a(kdel)/1000, kfb
else
	aout = ain
endif

ifftsize       	init iwin
ioverlap	init ifftsize / 4
iwinsize	init ifftsize

kamp		= kpitch
kamp		limit kamp, 0, 1
kfreq		= kpitch

fftin		pvsanal	ain, ifftsize, ioverlap, iwinsize, 0
freeze		pvsfreeze fftin, kamp, .5+kfreq ;freeze amps or freqs independently
aout		pvsynth	freeze ;resynthesize

aout 		*= kamp	


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  haasj, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		haasj Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

aout    init 0
kdel	= ktime

aout		vdelay3	ain + (aout*a(kfb)), a(kdel*ich), 5$k


	chnmix aout, gSmouth[ich]

    endop


;   FREQ DOMAIN OPCODEs

    opcode  k35h, 0, SJJPo
Sinstr, kfreq, kq, kgain, ich xin

if      ich==ginchnls-1 goto next
                k35h Sinstr, kfreq, kq, kgain, ich+1

next:

;       INIT
if      kfreq==-1 then
                kfreq = ntof("3B")
endif

if  kq==-1 then
        kq = .65
endif

;       LIMIT
kfreq   limit kfreq, 10, 21$k
kq      limit kq, 0, .95

;       INPUT
ain     chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

;knlp (optional, default=0) -- Non-linear processing method. 0 = no processing, 1 = non-linear processing. Method 1 uses tanh(ksaturation * input). Enabling NLP may increase the overall output of filter above unity and should be compensated for outside of the filter.
;ksaturation (optional, default=1) -- saturation amount to use for non-linear processing. Values > 1 increase the steepness of the NLP curve.

ifreq_var	init 5
inlp        init 1

ksaturn     = kq*1.5

aout	K35_hpf ain, kfreq+randomi:k(-ifreq_var, ifreq_var, .05), kq*10, inlp, ksaturn
aout	balance2 aout, ain


        chnmix aout, gSmouth[ich]

    endop


;   ANALYSIS DOMAIN OPCODEs

    opcode  lofj, 0, SJJjjPo
Sinstr, kpitch, kfb, iwin, ift, kgain, ich xin

if		ich==ginchnls-1 goto next
		lofj Sinstr, kpitch, kfb, iwin, ift, kgain, ich+1

next:

;   INIT
if  kpitch==-1 then
        kpitch = 1
endif

if  kfb==-1 then
        kfb = .65
endif

if  iwin==-1 then
        iwin init 11
endif

if  ift==-1 then
        ift init gisine
endif

;   LIMIT
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .95
#end

iwin    limit iwin, 0, 13
iwin    = 2^iwin

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain             *= kgain

;---INSTRUMENT---
;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

fs1, fsi2	pvsifd		ain, iwin, iwin/4, 1			;ifd analysis
fst		partials	fs1, fsi2, 0.035, 1, 3, 500		;partial tracking
fscl		trshift		fst, kpitch						;frequency shift
aout		tradsyn		fscl, 1, 1, 500, ift			;resynthesis

if kfb > 0 then
	aout	flanger aout, a(gkbeats/12), kfb
endif


		chnmix aout, gSmouth[ich]

    endop


;   FREQ DOMAIN OPCODEs

    opcode  moogj, 0, SJJPo
Sinstr, kfreq, kq, kgain, ich xin

if      ich==ginchnls-1 goto next
                moogj Sinstr, kfreq, kq, kgain, ich+1

next:

;       INIT
if      kfreq==-1 then
                kfreq = ntof("3B")
endif

if  kq==-1 then
        kq = .65
endif

;       LIMIT
kfreq   limit kfreq, 10, 21$k
kq      limit kq, 0, .95

;       INPUT
ain     chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

ifreq_var	init 5

aout	moogladder2 ain, kfreq+randomi:k(-ifreq_var, ifreq_var, .05), kq
aout	balance2 aout, ain


        chnmix aout, gSmouth[ich]

    endop


;   ANALYSIS DOMAIN OPCODEs

    opcode  pitchj, 0, SJJjjPo
Sinstr, kpitch, kfb, iwin, ift, kgain, ich xin

if		ich==ginchnls-1 goto next
		pitchj Sinstr, kpitch, kfb, iwin, ift, kgain, ich+1

next:

;   INIT
if  kpitch==-1 then
        kpitch = 1
endif

if  kfb==-1 then
        kfb = .65
endif

if  iwin==-1 then
        iwin init 11
endif

if  ift==-1 then
        ift init gisine
endif

;   LIMIT
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .95
#end

iwin    limit iwin, 0, 13
iwin    = 2^iwin

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain             *= kgain

;---INSTRUMENT---
;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

kdel        = gkbeats/12

if	kfb!=0 then
	aout	flanger ain, a(kdel)/1000, kfb
else
	aout = ain
endif

fs1, fsi2	pvsifd		aout, iwin, iwin/8, 1			;ifd analysis
fst		partials	fs1, fsi2, 0.035, 1, 3, 256		;partial tracking
aout		resyn		fst, 1, kpitch, 256, ift		;resynthesis (up a 5th)


		chnmix aout, gSmouth[ich]

    endop


;   ANALYSIS DOMAIN OPCODEs

    opcode  pitchj2, 0, SJJjjPo
Sinstr, kpitch, kfb, iwin, ift, kgain, ich xin

if		ich==ginchnls-1 goto next
		pitchj2 Sinstr, kpitch, kfb, iwin, ift, kgain, ich+1

next:

;   INIT
if  kpitch==-1 then
        kpitch = 1
endif

if  kfb==-1 then
        kfb = .65
endif

if  iwin==-1 then
        iwin init 11
endif

if  ift==-1 then
        ift init gisine
endif

;   LIMIT
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .95
#end

iwin    limit iwin, 0, 13
iwin    = 2^iwin

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain             *= kgain

;---INSTRUMENT---
;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

kdel		= gkbeatms/12

aout		vdelay3 ain + (a(kdel)*kfb), a(kdel)/1000, 5000

fs1, fsi2	pvsifd		aout, iwin, iwin/8, 1			; ifd analysis
fst			partials	fs1, fsi2, 0.035, 1, 3, 512		; partial tracking
aout		resyn		fst, 1, kpitch, 512, ift		; resynthesis (up a 5th)


		chnmix aout, gSmouth[ich]

    endop


;   ANALYSIS DOMAIN OPCODEs

    opcode  pitchjdc, 0, SJJjjPo
Sinstr, kpitch, kfb, iwin, ift, kgain, ich xin

if		ich==ginchnls-1 goto next
		pitchjdc Sinstr, kpitch, kfb, iwin, ift, kgain, ich+1

next:

;   INIT
if  kpitch==-1 then
        kpitch = 1
endif

if  kfb==-1 then
        kfb = .65
endif

if  iwin==-1 then
        iwin init 11
endif

if  ift==-1 then
        ift init gisine
endif

;   LIMIT
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .95
#end

iwin    limit iwin, 0, 13
iwin    = 2^iwin

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain             *= kgain

;---INSTRUMENT---
;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

kdel        = gkbeats/12

if	kfb!=0 then
	aout	flanger ain, a(kdel)/1000, kfb
else
	aout = ain
endif

fs1, fsi2	pvsifd		aout, iwin, iwin/8, 1			;ifd analysis
fst		partials	fs1, fsi2, 0.035, 1, 3, 256		;partial tracking
aout		resyn		fst, 1, kpitch, 256, ift		;resynthesis (up a 5th)

aout		dcblock2 aout


		chnmix aout, gSmouth[ich]

    endop


;   1 PARAM OPCODEs

    opcode  powerranger, 0, SJPo
Sinstr, kp1, kgain, ich xin

if  ich==ginchnls-1 goto next
		powerranger Sinstr, kp1, kgain, ich+1

next:

;   INIT
if  kp1 ==-1 then
        kp1 = .5
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---OP1
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kp1, kgain, ich xin

kshape	= kp1

aout	powershape ain, kshape
aout	balance2 aout, ain


	chnmix aout, gSmouth[ich]

    endop


;   ANALYSIS DOMAIN OPCODEs

    opcode  resj, 0, SJJjjPo
Sinstr, kpitch, kfb, iwin, ift, kgain, ich xin

if		ich==ginchnls-1 goto next
		resj Sinstr, kpitch, kfb, iwin, ift, kgain, ich+1

next:

;   INIT
if  kpitch==-1 then
        kpitch = 1
endif

if  kfb==-1 then
        kfb = .65
endif

if  iwin==-1 then
        iwin init 11
endif

if  ift==-1 then
        ift init gisine
endif

;   LIMIT
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .95
#end

iwin    limit iwin, 0, 13
iwin    = 2^iwin

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain             *= kgain

;---INSTRUMENT---
;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

fs1, fsi2	pvsifd		ain, iwin, iwin/4, 1			;ifd analysis
fst			partials	fs1, fsi2, 0.035, 1, 3, 500		;partial tracking
aout		resyn		fst, 1, kpitch, 500, ift		;resynthesis (up a 5th)


		chnmix aout, gSmouth[ich]

    endop


;   FREQ DOMAIN OPCODEs

    opcode  rezj, 0, SJJPo
Sinstr, kfreq, kq, kgain, ich xin

if      ich==ginchnls-1 goto next
                rezj Sinstr, kfreq, kq, kgain, ich+1

next:

;       INIT
if      kfreq==-1 then
                kfreq = ntof("3B")
endif

if  kq==-1 then
        kq = .65
endif

;       LIMIT
kfreq   limit kfreq, 10, 21$k
kq      limit kq, 0, .95

;       INPUT
ain     chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

ifreq_var	init 5

aout	rezzy ain, kfreq+randomi:k(-ifreq_var, ifreq_var, .05), kq*100
aout	balance2 aout, ain


        chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringhj, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringhj Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = gihsine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

;		OUT
aout	= ain * tablei:a(andx, ift, 1)


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringhj2, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringhj2 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = gihsine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

;	INSTRUMENT
aout	= ain * tablei:a(andx, ift, 1)

;	DELAY
adel    a gkbeats/12 ; it must be in second
aout	flanger aout, adel, kfb


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringhj3, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringhj3 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = gihsine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

;	INSTRUMENT
ar_out	= ain * tablei:a(andx, ift, 1)

;	DELAY
adel    a gkbeats/12 ; it must be in second
af_out	flanger ar_out, adel, kfb

aout	sum ar_out, af_out


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringhj4, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringhj4 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = gihsine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

ar_out	= ain * tablei:a(andx, ift, 1)

;	DELAY
af_out	flanger ar_out, a(gkbeats/kdiv), kfb

aout	sum ar_out, af_out


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringhj5, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringhj5 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = gihsine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

;	INSTRUMENT
ar_out	= ain * tablei:a(andx, ift, 1)

;	DELAY
if gkringhj5_port==0 then
	adel	a gkbeats/kdiv
else
	adel	a portk(gkbeats/kdiv, gkringhj5_port)
endif

af_out	flanger ar_out, adel, kfb

aout	= af_out * tablei:a(andx, ift, 1)


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringhjs, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringhjs Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = gihsine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime/pow(2, int(ich/2))
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

;		OUT
aout	= ain * tablei:a(andx, ift, 1)


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringj, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringj Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = gihsine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime

aout	= ain * oscili:a(1, kfreq, ift)


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringj2, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringj2 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = gihsine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms			= (1/ktime)*(gkbeats/12)

aout	= ain * oscili:a(1, kfreq, ift)

;	DELAY
aout	flanger aout, a(kms), kfb


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringj3, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringj3 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = gihsine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms		= (1/ktime)*(gkbeats/12)

ar_out	= ain * oscili:a(1, kfreq, ift)

;	DELAY
af_out	flanger ar_out, a(kms), kfb

igain	init 2

aout	sum ar_out/igain, af_out/igain


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringj5, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringj5 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = gihsine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms			= (1/ktime)*(gkbeats/12)

ar_out	= ain * oscili:a(1, kfreq, ift)

if gkringj5_port==0 then
	adel	a kms
else
	adel	a portk(kms, gkringj5_port)
endif

;	DELAY
af_out	flanger ar_out, adel, kfb

aout	= af_out * oscili:a(1, kfreq, ift)


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringj6, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringj6 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = gihsine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms			= (1/ktime)*(gkbeats/12)

ar_out	= ain * oscili:a(1, kfreq, ift)

if gkringj6_port==0 then
	adel	a kms
else
	adel	a portk(kms, gkringj6_port)
endif

adel	*= ich

;	DELAY
af_out	flanger ar_out, adel, kfb

aout	= af_out * oscili:a(1, kfreq, ift)


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN WITH FT OPCODEs

    opcode  ringj7, 0, SJJjPo
Sinstr, ktime, kfb, ift, kgain, ich xin

if      ich==ginchnls-1 goto next
		ringj7 Sinstr, ktime, kfb, ift, kgain, ich+1

next:

;   INIT
if  ktime==-1 then
        ktime = gkbeatms/12
endif

if  kfb==-1 then
        kfb = .15
endif

if  ift==-1 then
        ift = gihsine
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
    kfb        limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain		chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms			= (1/ktime)*(gkbeats/12)

kndx	= ((chnget:k("heart")*gkdiv/ginchnls))%1
kndx	= (int(kndx*ginchnls)+ich)%ginchnls

;	INSTRUMENT
ar_out	= ain * oscili:a(1, kfreq*giringj7_arr[kndx], ift)

;	DELAY
af_out	flanger ar_out, a(kms), kfb

aout	sum ar_out, af_out


		chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  shj, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		shj Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

afb     init 0
kdel	= ktime
imaxdel init 5000

;		pre-DELAY
;		vdelay3 works with ms
ad		vdelay3 ain, a(kdel), imaxdel
ad		balance2 ad, ain

afb	 	= ad + (afb * kfb) 

;		REVERB
;		reverb works with s
aout		nreverb ad, kdel$ms, kfb

;		ANAL
kratio		=	kfb*randomi:k(2.25, 2.35, .25)	

ideltime 	=	imaxdel/2

ifftsize 	=	2048
ioverlap 	=	ifftsize / 4 
iwinsize 	=	ifftsize 
iwinshape 	=	1; von-Hann window 

fftin		pvsanal	ad, ifftsize, ioverlap, iwinsize, iwinshape 
fftscale 	pvscale	fftin, kratio, 0, 1 
atrans	 	pvsynth	fftscale 

;		FB
afb 	=	vdelay3(atrans, a(kdel), imaxdel)


	chnmix aout, gSmouth[ich]

    endop


;   TIME DOMAIN OPCODEs

    opcode  shjnot, 0, SJJPo
Sinstr, ktime, kfb, kgain, ich xin

if	ich==ginchnls-1 goto next
		shjnot Sinstr, ktime, kfb, kgain, ich+1

next:

;   INIT
if	ktime==-1 then
		ktime = gkbeatms/12
endif

if	kfb==-1 then
		kfb = .15
endif

;   LIMIT
ktime      abs ktime
#ifdef opcode_kfb_limit
	kfb	limit kfb, 0, .9995
#end

;	IF
if	ktime==0 then
		ktime = gizero
endif

;   INPUT
ain	chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

afb     init 0
kdel	= ktime
imaxdel init 5000

;		pre-DELAY
;		vdelay3 works with ms
ad		vdelay3 ain, a(kdel), imaxdel
aout		balance2 ad, ain

afb	 	= aout + (afb * kfb) 


;		ANAL
kratio		=	kfb*randomi:k(2.25, 2.35, .25)	

ideltime 	=	imaxdel/2

ifftsize 	=	1024
ioverlap 	=	ifftsize / 4 
iwinsize 	=	ifftsize 
iwinshape 	=	1; von-Hann window 

fftin		pvsanal	ad, ifftsize, ioverlap, iwinsize, iwinshape 
fftscale 	pvscale	fftin, kratio, 0, 1 
atrans	 	pvsynth	fftscale 

;		FB
afb 	=	vdelay3(atrans, a(kdel), imaxdel)


	chnmix aout, gSmouth[ich]

    endop


;   FREQ DOMAIN OPCODEs

    opcode  stringj, 0, SJJPo
Sinstr, kfreq, kq, kgain, ich xin

if      ich==ginchnls-1 goto next
                stringj Sinstr, kfreq, kq, kgain, ich+1

next:

;       INIT
if      kfreq==-1 then
                kfreq = ntof("3B")
endif

if  kq==-1 then
        kq = .65
endif

;       LIMIT
kfreq   limit kfreq, 10, 21$k
kq      limit kq, 0, .95

;       INPUT
ain     chnget sprintf("%s_%i", Sinstr, ich+1)
ain     *= kgain

;---INSTRUMENT---
;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

aguid	wguide1 ain, 1/kfreq, kfreq/2, kq

astr1	streson ain, kfreq, kq
astr2	streson ain, kfreq*1.25, kq

aout	sum aguid, astr1, astr2

aout	phaser1 aout, kfreq, 12, kq


        chnmix aout, gSmouth[ich]

    endop





;--- ||| --- ||| ---

gi3semitone			ftgen		0, 0, 5, -2, 0, 3, 6, 9, 12 
gi4semitone			ftgen		0, 0, 4, -2, 0, 4, 8, 12 
giaeolian			ftgen		0, 0, 7, -2, 0, 2, 3, 5, 7, 8, 10 
giaeolian			ftgen		0, 0, 8, -2, 0, 2, 3, 5, 7, 8, 10, 12 
gialgerian			ftgen		0, 0, 8, -2, 0, 2, 3, 6, 7, 8, 11, 12 
gialgerian1			ftgen		0, 0, 8, -2, 0, 2, 3, 6, 7, 8, 11, 12 
gialgerian2			ftgen		0, 0, 8, -2, 0, 2, 3, 5, 7, 8, 10, 12 
gialtered			ftgen		0, 0, 8, -2, 0, 1, 3, 4, 6, 8, 10, 12 
giarabian			ftgen		0, 0, 8, -2, 0, 1, 4, 5, 7, 8, 11, 12 
giaugmented			ftgen		0, 0, 7, -2, 0, 3, 4, 7, 8, 11, 12 
gibalinese			ftgen		0, 0, 6, -2, 0, 1, 3, 7, 8, 12 
gibebopdominant			ftgen		0, 0, 9, -2, 0, 2, 4, 5, 7, 9, 10, 11, 12 
gibebopdominantflatnine		ftgen		0, 0, 9, -2, 0, 1, 4, 5, 7, 9, 10, 11, 12 
gibebopmajor			ftgen		0, 0, 9, -2, 0, 2, 4, 5, 7, 8, 9, 11, 12 
gibebopminor			ftgen		0, 0, 9, -2, 0, 2, 3, 5, 7, 8, 9, 10, 12 
gibeboptonicminor		ftgen		0, 0, 9, -2, 0, 2, 3, 5, 7, 8, 9, 11, 12 
giblues				ftgen		0, 0, 7, -2, 0, 3, 5, 6, 7, 10, 12 
gibyzantine			ftgen		0, 0, 8, -2, 0, 1, 4, 5, 7, 8, 11, 12 
gichahargah			ftgen		0, 0, 8, -2, 0, 1, 4, 5, 7, 8, 11, 12 
gichinese			ftgen		0, 0, 6, -2, 0, 2, 4, 7, 9, 12 
gichinese2			ftgen		0, 0, 6, -2, 0, 4, 6, 7, 11, 12 
gichroma			ftgen		0, 0, 12, -2, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 
gichromatic			ftgen		0, 0, 13, -2, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 
gidim				ftgen		0, 0, 4, -2, 0, 3, 6, 9 
gidiminished			ftgen		0, 0, 9, -2, 0, 2, 3, 5, 6, 8, 9, 11, 12 
gidorian			ftgen		0, 0, 7, -2, 0, 2, 3, 5, 7, 9, 10 
gidorian			ftgen		0, 0, 8, -2, 0, 2, 3, 5, 7, 9, 10, 12 
gidoubleharmonic		ftgen		0, 0, 8, -2, 0, 1, 4, 5, 7, 8, 11, 12 
giegyptian			ftgen		0, 0, 8, -2, 0, 2, 3, 6, 7, 8, 11, 12 
gienigmatic			ftgen		0, 0, 8, -2, 0, 1, 4, 6, 8, 10, 11, 12 
giethiopian			ftgen		0, 0, 8, -2, 0, 2, 4, 5, 7, 8, 11, 12 
giflamenco			ftgen		0, 0, 9, -2, 0, 1, 3, 4, 5, 7, 8, 10, 12 
gigypsy				ftgen		0, 0, 8, -2, 0, 1, 4, 5, 7, 8, 11, 12 
giharmonic			ftgen		0, 0, 7, -2, 0, 2, 4, 5, 7, 9, 11 
giharmonicmajor			ftgen		0, 0, 8, -2, 0, 2, 4, 5, 8, 9, 11, 12 
giharmonicminor			ftgen		0, 0, 7, -2, 0, 2, 3, 5, 7, 8, 11 
giharmonicminor			ftgen		0, 0, 8, -2, 0, 2, 3, 5, 7, 8, 11, 12 
gihindu				ftgen		0, 0, 8, -2, 0, 2, 4, 5, 7, 8, 10, 12 
gihirajoshi			ftgen		0, 0, 6, -2, 0, 2, 3, 7, 8, 12 
gihungariangypsy		ftgen		0, 0, 8, -2, 0, 2, 3, 6, 7, 8, 11, 12 
gihungarianmajor		ftgen		0, 0, 8, -2, 0, 3, 4, 6, 7, 9, 10, 12 
gihungarianminor		ftgen		0, 0, 8, -2, 0, 2, 3, 6, 7, 8, 11, 12 
giindian			ftgen		0, 0, 8, -2, 0, 1, 3, 4, 7, 8, 10, 12 
giinverteddiminished		ftgen		0, 0, 9, -2, 0, 1, 3, 4, 6, 7, 9, 10, 12 
giionian			ftgen		0, 0, 7, -2, 0, 2, 4, 5, 7, 9, 11 
giionian			ftgen		0, 0, 8, -2, 0, 2, 4, 5, 7, 9, 11, 12 
giiwato				ftgen		0, 0, 6, -2, 0, 1, 5, 6, 10, 12 
gijapanese			ftgen		0, 0, 6, -2, 0, 1, 5, 7, 8, 12 
gijavanese			ftgen		0, 0, 8, -2, 0, 1, 3, 5, 7, 9, 10, 12 
gijewish			ftgen		0, 0, 8, -2, 0, 1, 4, 5, 7, 8, 10, 12 
gikumoi				ftgen		0, 0, 6, -2, 0, 1, 5, 7, 8, 12 
gileadingwholetone		ftgen		0, 0, 8, -2, 0, 2, 4, 6, 8, 10, 11, 12 
gilocrian			ftgen		0, 0, 7, -2, 0, 1, 3, 5, 6, 8, 10 
gilocrian			ftgen		0, 0, 8, -2, 0, 1, 3, 5, 6, 8, 10, 12 
gilocrianmajor			ftgen		0, 0, 8, -2, 0, 2, 4, 5, 6, 8, 10, 12 
gilocriannatural		ftgen		0, 0, 8, -2, 0, 2, 3, 5, 6, 8, 10, 12 
gilocriansuper			ftgen		0, 0, 8, -2, 0, 1, 3, 4, 6, 8, 10, 12 
gilocrianultra			ftgen		0, 0, 8, -2, 0, 1, 3, 4, 6, 8, 9, 12 
gilydian			ftgen		0, 0, 7, -2, 0, 2, 4, 6, 7, 9, 11 
gilydian			ftgen		0, 0, 8, -2, 0, 2, 4, 6, 7, 9, 11, 12 
gilydianaugmented		ftgen		0, 0, 8, -2, 0, 2, 4, 6, 8, 9, 10, 12 
gilydiandominant		ftgen		0, 0, 8, -2, 0, 2, 4, 6, 7, 9, 10, 12 
gilydianminor			ftgen		0, 0, 8, -2, 0, 2, 4, 6, 7, 8, 10, 12 
gim7				ftgen		0, 0, 19, -2, 0, 3, 7, 10, 14, 17, 21, 24, 27, 31, 34, 38, 41, 45, 48, 51, 55, 58, 62 
gimajor				ftgen		0, 0, 7, -2, 0, 2, 4, 5, 7, 9, 11 
gimarva				ftgen		0, 0, 8, -2, 0, 1, 4, 6, 7, 9, 11, 12 
gimelodicminor			ftgen		0, 0, 8, -2, 0, 2, 3, 5, 7, 9, 11, 12 
gimelodicminorascending		ftgen		0, 0, 7, -2, 0, 2, 3, 5, 7, 9, 11 
gimelodicminordescending	ftgen		0, 0, 7, -2, 0, 2, 3, 5, 7, 8, 10 
giminor				ftgen		0, 0, 7, -2, 0, 2, 3, 5, 7, 8, 10 
giminor3			ftgen		0, 0, 7, -2, 0, 2, 2.75, 5, 7.15, 8, 10
gimjnor				ftgen		0, 0, 7, -2, 0, 1.75, 2.75, 5.35, 7.35, 8, 10
giminor2v5			ftgen		0, 0, 7, -2, 0, 2, 2.5, 5, 7, 8, 10
gimixolydian			ftgen		0, 0, 7, -2, 0, 2, 4, 5, 7, 9, 10 
gimixolydian			ftgen		0, 0, 8, -2, 0, 2, 4, 5, 7, 9, 10, 12 
gimixolydianaugmented		ftgen		0, 0, 8, -2, 0, 2, 4, 5, 8, 9, 10, 12 
gimohammedan			ftgen		0, 0, 8, -2, 0, 2, 3, 5, 7, 8, 11, 12 
gimongolian			ftgen		0, 0, 6, -2, 0, 2, 4, 7, 9, 12 
gimonotone			ftgen		0, 0, 1, -2, 0 
ginaturalminor			ftgen		0, 0, 7, -2, 9, 11, 0, 2, 4, 5, 7 
ginaturalminor			ftgen		0, 0, 8, -2, 0, 2, 3, 5, 7, 8, 10, 12 
gineapolitanmajor		ftgen		0, 0, 8, -2, 0, 1, 3, 5, 7, 9, 11, 12 
gineapolitanminor		ftgen		0, 0, 8, -2, 0, 1, 3, 5, 7, 8, 11, 12 
giocta1				ftgen		0, 0, 8, -2, 0, 1, 3, 4, 6, 7, 9, 10 
giocta2				ftgen		0, 0, 8, -2, 0, 2, 3, 5, 6, 8, 9, 11 
gioriental			ftgen		0, 0, 8, -2, 0, 1, 4, 5, 6, 9, 10, 12 
giovertone			ftgen		0, 0, 8, -2, 0, 2, 4, 6, 7, 9, 10, 12 
gipa				ftgen		0, 0, 6, -2, 0, 2, 3, 7, 8, 12 
gipb				ftgen		0, 0, 6, -2, 0, 1, 3, 6, 8, 12 
gipd				ftgen		0, 0, 6, -2, 0, 2, 3, 7, 9, 12 
gipe				ftgen		0, 0, 6, -2, 0, 1, 3, 7, 8, 12 
gipelog				ftgen		0, 0, 6, -2, 0, 1, 3, 7, 10, 12 
gipentamaj			ftgen		0, 0, 5, -2, 0, 2, 4, 7, 9 
gipentamin			ftgen		0, 0, 5, -2, 0, 3, 5, 7, 10 
gipentatonicmajor		ftgen		0, 0, 6, -2, 0, 2, 4, 7, 9, 12 
gipentatonicminor		ftgen		0, 0, 6, -2, 0, 3, 5, 7, 10, 12 
gipersian			ftgen		0, 0, 8, -2, 0, 1, 4, 5, 6, 8, 11, 12 
gipfcg				ftgen		0, 0, 6, -2, 0, 2, 4, 7, 9, 12 
giphrygian			ftgen		0, 0, 7, -2, 0, 1, 3, 5, 7, 8, 10 
giphrygian			ftgen		0, 0, 8, -2, 0, 1, 3, 5, 7, 8, 10, 12 
giphrygianmajor			ftgen		0, 0, 8, -2, 0, 1, 4, 5, 7, 8, 10, 12 
giquarter			ftgen		0, 0, 22, -2, 0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5
giromanian			ftgen		0, 0, 8, -2, 0, 2, 3, 6, 7, 9, 10, 12 
gispanish			ftgen		0, 0, 8, -2, 0, 1, 4, 5, 7, 8, 10, 12 
gispanish8tone			ftgen		0, 0, 9, -2, 0, 1, 3, 4, 5, 6, 8, 10, 12 
gisymmetrical			ftgen		0, 0, 9, -2, 0, 1, 3, 4, 6, 7, 9, 10, 12 
gitodi				ftgen		0, 0, 8, -2, 0, 1, 3, 6, 7, 8, 11, 12 
giwhole				ftgen		0, 0, 6, -2, 0, 2, 4, 6, 8, 10 
giwhole				ftgen		0, 0, 7, -2, 0, 2, 4, 6, 8, 10, 12 
gibp				ftgen		0, 0, 12, -2, 0, 1.3324, 3.0185, 4.3508, 5.8251, 7.3693, 8.8436, 10.1760, 11.6502, 13.1944, 14.6687, 16.0011, 17.6872, 19.0196
giolympos			ftgen		0, 0, 6, -2, 1, 9/8, 6/5, 3/2, 8/5
giarchytas			ftgen		0, 0, 7, -2, 1, 21/20, 16/15, 4/3, 3/2, 14/9, 8/5
giacropolis			ftgen		0, 0, 6, -2, 1, 11/10, 7/6, 6/5, 11/8
gigi				ftgen		0, 0, 8, -2, -.3, .7, -1.5, 2.15, -3, 6, -5, 7

gikal				ftgen		0, 0, 11, -2, 1, 2, 3, 3.675, 5.35, 5.85, 6.15, 8, 9.95, 10.5, 11, 12




;--- ||| --- ||| ---

gk3semitone[]			fillarray		0, 3, 6, 9, 12 
gk4semitone[]			fillarray		0, 4, 8, 12 
gkaeolian[]			fillarray		0, 2, 3, 5, 7, 8, 10 
gkaeolian[]			fillarray		0, 2, 3, 5, 7, 8, 10, 12 
gkalgerian[]			fillarray		0, 2, 3, 6, 7, 8, 11, 12 
gkalgerian1[]			fillarray		0, 2, 3, 6, 7, 8, 11, 12 
gkalgerian2[]			fillarray		0, 2, 3, 5, 7, 8, 10, 12 
gkaltered[]			fillarray		0, 1, 3, 4, 6, 8, 10, 12 
gkarabian[]			fillarray		0, 1, 4, 5, 7, 8, 11, 12 
gkaugmented[]			fillarray		0, 3, 4, 7, 8, 11, 12 
gkbalinese[]			fillarray		0, 1, 3, 7, 8, 12 
gkbebopdominant[]			fillarray		0, 2, 4, 5, 7, 9, 10, 11, 12 
gkbebopdominantflatnine[]		fillarray		0, 1, 4, 5, 7, 9, 10, 11, 12 
gkbebopmajor[]			fillarray		0, 2, 4, 5, 7, 8, 9, 11, 12 
gkbebopminor[]			fillarray		0, 2, 3, 5, 7, 8, 9, 10, 12 
gkbeboptonicminor[]		fillarray		0, 2, 3, 5, 7, 8, 9, 11, 12 
gkblues[]				fillarray		0, 3, 5, 6, 7, 10, 12 
gkbyzantine[]			fillarray		0, 1, 4, 5, 7, 8, 11, 12 
gkchahargah[]			fillarray		0, 1, 4, 5, 7, 8, 11, 12 
gkchinese[]			fillarray		0, 2, 4, 7, 9, 12 
gkchinese2[]			fillarray		0, 4, 6, 7, 11, 12 
gkchroma[]			fillarray		0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 
gkchromatic[]			fillarray		0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 
gkdim[]				fillarray		0, 3, 6, 9 
gkdiminished[]			fillarray		0, 2, 3, 5, 6, 8, 9, 11, 12 
gkdorian[]			fillarray		0, 2, 3, 5, 7, 9, 10 
gkdorian[]			fillarray		0, 2, 3, 5, 7, 9, 10, 12 
gkdoubleharmonic[]		fillarray		0, 1, 4, 5, 7, 8, 11, 12 
gkegyptian[]			fillarray		0, 2, 3, 6, 7, 8, 11, 12 
gkenigmatic[]			fillarray		0, 1, 4, 6, 8, 10, 11, 12 
gkethiopian[]			fillarray		0, 2, 4, 5, 7, 8, 11, 12 
gkflamenco[]			fillarray		0, 1, 3, 4, 5, 7, 8, 10, 12 
gkgypsy[]				fillarray		0, 1, 4, 5, 7, 8, 11, 12 
gkharmonic[]			fillarray		0, 2, 4, 5, 7, 9, 11 
gkharmonicmajor[]			fillarray		0, 2, 4, 5, 8, 9, 11, 12 
gkharmonicminor[]			fillarray		0, 2, 3, 5, 7, 8, 11 
gkharmonicminor[]			fillarray		0, 2, 3, 5, 7, 8, 11, 12 
gkhindu[]				fillarray		0, 2, 4, 5, 7, 8, 10, 12 
gkhirajoshi[]			fillarray		0, 2, 3, 7, 8, 12 
gkhungariangypsy[]		fillarray		0, 2, 3, 6, 7, 8, 11, 12 
gkhungarianmajor[]		fillarray		0, 3, 4, 6, 7, 9, 10, 12 
gkhungarianminor[]		fillarray		0, 2, 3, 6, 7, 8, 11, 12 
gkindian[]			fillarray		0, 1, 3, 4, 7, 8, 10, 12 
gkinverteddiminished[]		fillarray		0, 1, 3, 4, 6, 7, 9, 10, 12 
gkionian[]			fillarray		0, 2, 4, 5, 7, 9, 11 
gkionian[]			fillarray		0, 2, 4, 5, 7, 9, 11, 12 
gkiwato[]				fillarray		0, 1, 5, 6, 10, 12 
gkjapanese[]			fillarray		0, 1, 5, 7, 8, 12 
gkjavanese[]			fillarray		0, 1, 3, 5, 7, 9, 10, 12 
gkjewish[]			fillarray		0, 1, 4, 5, 7, 8, 10, 12 
gkkumoi[]				fillarray		0, 1, 5, 7, 8, 12 
gkleadingwholetone[]		fillarray		0, 2, 4, 6, 8, 10, 11, 12 
gklocrian[]			fillarray		0, 1, 3, 5, 6, 8, 10 
gklocrian[]			fillarray		0, 1, 3, 5, 6, 8, 10, 12 
gklocrianmajor[]			fillarray		0, 2, 4, 5, 6, 8, 10, 12 
gklocriannatural[]		fillarray		0, 2, 3, 5, 6, 8, 10, 12 
gklocriansuper[]			fillarray		0, 1, 3, 4, 6, 8, 10, 12 
gklocrianultra[]			fillarray		0, 1, 3, 4, 6, 8, 9, 12 
gklydian[]			fillarray		0, 2, 4, 6, 7, 9, 11 
gklydian[]			fillarray		0, 2, 4, 6, 7, 9, 11, 12 
gklydianaugmented[]		fillarray		0, 2, 4, 6, 8, 9, 10, 12 
gklydiandominant[]		fillarray		0, 2, 4, 6, 7, 9, 10, 12 
gklydianminor[]			fillarray		0, 2, 4, 6, 7, 8, 10, 12 
gkm7[]				fillarray		0, 3, 7, 10, 14, 17, 21, 24, 27, 31, 34, 38, 41, 45, 48, 51, 55, 58, 62 
gkmajor[]				fillarray		0, 2, 4, 5, 7, 9, 11 
gkmarva[]				fillarray		0, 1, 4, 6, 7, 9, 11, 12 
gkmelodicminor[]			fillarray		0, 2, 3, 5, 7, 9, 11, 12 
gkmelodicminorascending[]		fillarray		0, 2, 3, 5, 7, 9, 11 
gkmelodicminordescending[]	fillarray		0, 2, 3, 5, 7, 8, 10 
gkminor[]				fillarray		0, 2, 3, 5, 7, 8, 10 
gkminor3[]			fillarray		0, 2, 2.75, 5, 7.15, 8, 10
gkmjnor[]				fillarray		0, 1.75, 2.75, 5.35, 7.35, 8, 10
gkminor2v5[]			fillarray		0, 2, 2.5, 5, 7, 8, 10
gkmixolydian[]			fillarray		0, 2, 4, 5, 7, 9, 10 
gkmixolydian[]			fillarray		0, 2, 4, 5, 7, 9, 10, 12 
gkmixolydianaugmented[]		fillarray		0, 2, 4, 5, 8, 9, 10, 12 
gkmohammedan[]			fillarray		0, 2, 3, 5, 7, 8, 11, 12 
gkmongolian[]			fillarray		0, 2, 4, 7, 9, 12 
gkmonotone[]			fillarray		0 
gknaturalminor[]			fillarray		9, 11, 0, 2, 4, 5, 7 
gknaturalminor[]			fillarray		0, 2, 3, 5, 7, 8, 10, 12 
gkneapolitanmajor[]		fillarray		0, 1, 3, 5, 7, 9, 11, 12 
gkneapolitanminor[]		fillarray		0, 1, 3, 5, 7, 8, 11, 12 
gkocta_1_2[]			fillarray		0, 1, 3, 4, 6, 7, 9, 10 
gkocta_2_1[]			fillarray		0, 2, 3, 5, 6, 8, 9, 11 
gkoriental[]			fillarray		0, 1, 4, 5, 6, 9, 10, 12 
gkovertone[]			fillarray		0, 2, 4, 6, 7, 9, 10, 12 
gkpa[]				fillarray		0, 2, 3, 7, 8, 12 
gkpb[]				fillarray		0, 1, 3, 6, 8, 12 
gkpd[]				fillarray		0, 2, 3, 7, 9, 12 
gkpe[]				fillarray		0, 1, 3, 7, 8, 12 
gkpelog[]				fillarray		0, 1, 3, 7, 10, 12 
gkpentamaj[]			fillarray		0, 2, 4, 7, 9 
gkpentamin[]			fillarray		0, 3, 5, 7, 10 
gkpentatonicmajor[]		fillarray		0, 2, 4, 7, 9, 12 
gkpentatonicminor[]		fillarray		0, 3, 5, 7, 10, 12 
gkpersian[]			fillarray		0, 1, 4, 5, 6, 8, 11, 12 
gkpfcg[]				fillarray		0, 2, 4, 7, 9, 12 
gkphrygkan[]			fillarray		0, 1, 3, 5, 7, 8, 10 
gkphrygkan[]			fillarray		0, 1, 3, 5, 7, 8, 10, 12 
gkphrygkanmajor[]			fillarray		0, 1, 4, 5, 7, 8, 10, 12 
gkquarter[]			fillarray		0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5
gkromanian[]			fillarray		0, 2, 3, 6, 7, 9, 10, 12 
gkspanish[]			fillarray		0, 1, 4, 5, 7, 8, 10, 12 
gkspanish8tone[]			fillarray		0, 1, 3, 4, 5, 6, 8, 10, 12 
gksymmetrical[]			fillarray		0, 1, 3, 4, 6, 7, 9, 10, 12 
gktodi[]				fillarray		0, 1, 3, 6, 7, 8, 11, 12 
gkwhole[]				fillarray		0, 2, 4, 6, 8, 10 
gkwhole[]				fillarray		0, 2, 4, 6, 8, 10, 12 
gkbp[]				fillarray		0, 1.3324, 3.0185, 4.3508, 5.8251, 7.3693, 8.8436, 10.1760, 11.6502, 13.1944, 14.6687, 16.0011, 17.6872, 19.0196
gkolympos[]			fillarray		1, 9/8, 6/5, 3/2, 8/5
gkarchytas[]			fillarray		1, 21/20, 16/15, 4/3, 3/2, 14/9, 8/5
gkacropolis[]			fillarray		1, 11/10, 7/6, 6/5, 11/8
gkgk[]				fillarray		-.3, .7, -1.5, 2.15,  6,  7



;--- ||| --- ||| ---

gkdifferenza[]	fillarray 0, 1, 0.390625, 0.390625, 1, 0.375000, 0.765625, 1, 0.125000, 0.890625, 1, 0.109375

gkbach[]	fillarray 0, 0, 0.031250, 1, 0.031250, 7, 0.031250, 1, 0.062500, 16, 0.031250, 1, 0.093750, 14, 0.031250, 1, 0.125000, 16, 0.031250, 1, 0.156250, 7, 0.031250, 1, 0.187500, 16, 0.031250, 1, 0.218750, 7, 0.031250, 1, 0.250000, 0, 0.031250, 1, 0.281250, 7, 0.031250, 1, 0.312500, 16, 0.031250, 1, 0.343750, 14, 0.031250, 1, 0.375000, 16, 0.031250, 1, 0.406250, 7, 0.031250, 1, 0.437500, 16, 0.031250, 1, 0.468750, 7, 0.031250, 1, 0.500000, 0, 0.031250, 1, 0.531250, 9, 0.031250, 1, 0.562500, 17, 0.031250, 1, 0.593750, 16, 0.031250, 1, 0.625000, 17, 0.031250, 1, 0.656250, 9, 0.031250, 1, 0.687500, 17, 0.031250, 1, 0.718750, 9, 0.031250, 1, 0.750000, 0, 0.031250, 1, 0.781250, 9, 0.031250, 1, 0.812500, 17, 0.031250, 1, 0.843750, 16, 0.031250, 1, 0.875000, 17, 0.031250, 1, 0.906250, 9, 0.031250, 1, 0.937500, 17, 0.031250, 1, 0.968750, 9, 0.031250, 1 

gkciaij4[]	fillarray 0, 0, 0.078125, 1, 0.078125, 0, 0, 1, 0.093750, 0, 0, 1, 0.109375, 0, 0.015625, 0.897638, 0.109375, 0, 0.031250, 1, 0.140625, 0, 0.031250, 1, 0.171875, 0, 0.078125, 1, 0.250000, 0, 0, 1, 0.250000, 0, 0, 1, 0.265625, 0, 0.015625, 0.897638, 0.281250, 0, 0.031250, 1, 0.312500, 0, 0.031250, 1, 0.328125, -3, 0.015625, 1, 0.359375, -1, 0.031250, 1, 0.390625, 0, 0, 1, 0.390625, 0, 0.078125, 1, 0.468750, -3, 0.031250, 0.795276, 0.500000, 2, 0.015625, 1, 0.515625, 0, 0.031250, 1, 0.546875, -1, 0, 1, 0.562500, 0, 0.078125, 1, 0.640625, -3, 0.031250, 1, 0.671875, 4, 0.062500, 1, 0.718750, 0, 0.031250, 1, 0.750000, -1, 0.031250, 1, 0.781250, -3, 0.031250, 1, 0.812500, -5, 0.031250, 1, 0.828125, -7, 0.031250, 1, 0.859375, -8, 0.031250, 1, 0.890625, -10, 0.031250, 1, 0.921875, -12, 0.031250, 1, 0.937500, -13, 0.031250, 1, 0.968750, -15, 0.031250, 0.385827 

gklafille[]	fillarray 0, 10, 0.046875, 0.503937, 0.046875, 7, 0.015625, 0.488189, 0.062500, 3, 0.015625, 0.511811, 0.062500, 0, 0.015625, 0.433071, 0.078125, 3, 0.015625, 0.488189, 0.093750, 7, 0.015625, 0.464567, 0.093750, 10, 0.046875, 0.464567, 0.140625, 7, 0.015625, 0.448819, 0.156250, 3, 0.015625, 0.496063, 0.187500, 0, 0.046875, 0.448819, 0.234375, 3, 0.015625, 0.448819, 0.250000, 7, 0.015625, 0.480315, 0.281250, 3, 0.046875, 0.456693, 0.328125, 3, 0.031250, 0.456693, 0.343750, 0, 0.031250, 0.456693, 0.375000, 3, 0.046875, 0.503937, 0.421875, 2, 0.031250, 0.503937, 0.453125, 0, 0.031250, 0.511811, 0.468750, -2, 0.421875, 0.488189, 0.890625, 0, 0.046875, 0.464567, 0.953125, 3, 0.046875, 0.456693 

gkbleu[]	fillarray 0, 7, 0.015625, 0.582677, 0.015625, -1, 0.031250, 0.622047, 0.093750, 9, 0.046875, 0.740157, 0.140625, 0, 0.171875, 0.582677, 0.328125, 2, 0.156250, 0.582677, 0.484375, 9, 0.453125, 0.614173, 0.578125, 0, 0.359375, 0.322835

gkdifferenza[]	fillarray 0, 0, 0.390625, 1, 0.390625, 0, 0.375000, 0.897638, 0.765625, 0, 0.125000, 1, 0.890625, 0, 0.109375, 1 

gkclairedelune[] fillarray 0, 0, 0.139162, 0.307087, 0.020141, 3, 0.139162, 0.307087, 0.089067, 12, 0.068894, 0.480315, 0.139194, 15, 0.070013, 0.480315, 0.156155, 8, 0.063611, 0.362205, 0.171143, 12, 0.063611, 0.362205, 0.186132, 1, 0.121270, 0.433071, 0.260497, 4, 0.121270, 0.433071, 0.273924, 7, 0.015190, 0.354331, 0.287351, 10, 0.015190, 0.354331, 0.300778, 8, 0.015150, 0.385827, 0.320919, 12, 0.015150, 0.385827, 0.361200, 7, 0.083039, 0.401575, 0.381340, 10, 0.083039, 0.401575, 0.393977, 0, 0.120811, 0.401575, 0.406615, 3, 0.120811, 0.401575, 0.419252, 5, 0.013605, 0.362205, 0.494346, 8, 0.013605, 0.362205, 0.506740, 7, 0.013605, 0.354331, 0.519134, 10, 0.013605, 0.354331, 0.531529, 5, 0.080530, 0.338583, 0.543923, 8, 0.020423, 0.362205, 0.555858, 12, 0.040983, 0.417323, 0.567793, 8, 0.033338, 0.362205, 0.579728, -2, 0.112974, 0.377953, 0.591663, 1, 0.112974, 0.377953, 0.603599, 5, 0.014283, 0.338583, 0.615534, 3, 0.012802, 0.362205, 0.627469, 7, 0.012802, 0.362205, 0.639863, 5, 0.012802, 0.377953, 0.677046, 8, 0.012802, 0.377953, 0.729302, 3, 0.071286, 0.370079, 0.742192, 7, 0.083099, 0.338583, 0.755082, -4, 0.073415, 0.314961, 0.767719, -2, 0.073415, 0.362205, 0.780357, 1, 0.000742, 0.377953, 0.792994, 5, 0.012556, 0.393701, 0.805631, 7, 0.012556, 0.456693, 0.818025, 5, 0.012548, 0.393701, 0.830420, 10, 0.012089, 0.456693, 0.842814, 5, 0.012089, 0.377953, 0.854974, -5, 0.035773, 0.393701, 0.867135, -2, 0.035773, 0.393701, 0.879295, 1, 0.035773, 0.417323, 0.915776, 3, 0.012089, 0.322835, 0.938794, 5, 0.012089, 0.385827, 0.964922, 3, 0.024304, 0.362205, 0.982341, -7, 0.073415, 0.393701

gkshostaA[] fillarray 0, 0, 0.013949, 0.598425, 0.014086, -1, 0.013949, 0.598425, 0.028173, 0, 0.013949, 0.598425, 0.042259, 2, 0.013949, 0.598425, 0.056346, 4, 0.028036, 0.598425, 0.084519, 0, 0.028036, 0.598425, 0.112692, 12, 0.028036, 0.598425, 0.140864, 2, 0.028036, 0.598425, 0.169037, 0, 0.028036, 0.598425, 0.197210, 11, 0.028036, 0.598425, 0.225383, 5, 0.028036, 0.598425, 0.253556, 0, 0.028036, 0.598425, 0.281729, 14, 0.028036, 0.598425, 0.309902, 4, 0.028036, 0.598425, 0.338075, 0, 0.028036, 0.598425, 0.366247, 16, 0.028036, 0.598425, 0.394420, 12, 0.028036, 0.598425, 0.422593, 16, 0.028036, 0.598425, 0.450766, 12, 0.028036, 0.598425, 0.478939, 11, 0.028036, 0.598425, 0.507112, 4, 0.028036, 0.598425, 0.535285, 16, 0.028036, 0.598425, 0.563458, 9, 0.028036, 0.598425, 0.591630, 14, 0.028036, 0.598425, 0.619803, 11, 0.028036, 0.598425, 0.647976, 7, 0.013949, 0.598425, 0.662063, 5, 0.013949, 0.598425, 0.676149, 4, 0.013949, 0.598425, 0.690235, 2, 0.013949, 0.598425, 0.704322, 0, 0.098468, 0.598425, 0.732495, 4, 0.070295, 0.598425, 0.817013, 7, 0.070295, 0.598425, 0.901532, 0, 0.070295, 0.598425 

gkjac[] fillarray 0, 0, 0.029767, 0.929134, 0.031908, 12, 0.059902, 0.889764, 0.093951, 10, 0.013294, 0.866142, 0.109386, 3, 0.013355, 0.858268, 0.125003, 8, 0.029950, 0.858268, 0.157095, 7, 0.056693, 0.826772, 0.219138, 8, 0.013294, 0.866142, 0.234572, 7, 0.013355, 0.858268, 0.250190, 0, 0.029950, 0.921260, 0.282282, 10, 0.059902, 0.889764, 0.344325, 8, 0.013294, 0.866142, 0.359759, 7, 0.013355, 0.858268, 0.375377, 5, 0.029950, 0.897638, 0.407468, 3, 0.028881, 0.866142, 0.438490, -2, 0.029039, 0.842520, 0.469690, 7, 0.029253, 0.826772, 0.501210, 0, 0.029950, 0.929134, 0.533302, 14, 0.059902, 0.905512, 0.595345, 10, 0.013294, 0.889764, 0.610779, 15, 0.013355, 0.881890, 0.626397, 10, 0.029950, 0.897638, 0.658488, 7, 0.059902, 0.866142, 0.720532, 12, 0.013294, 0.866142, 0.735966, 7, 0.013355, 0.858268, 0.751584, 2, 0.029950, 0.858268, 0.783675, 7, 0.056693, 0.826772, 0.845719, 8, 0.013294, 0.866142, 0.861153, 7, 0.013355, 0.858268, 0.876771, 5, 0.029950, 0.897638, 0.908862, 3, 0.090832, 0.858268 

gksentimental[] fillarray 0, 0, 0.016066, 0.748031, 0.016130, 2, 0.016066, 0.748031, 0.032260, 4, 0.016066, 0.748031, 0.048390, 7, 0.016066, 0.748031, 0.064520, 9, 0.016066, 0.748031, 0.080650, 12, 0.016066, 0.748031, 0.096780, 14, 0.161236, 0.748031, 0.258081, 12, 0.016066, 0.748031, 0.274211, 14, 0.016066, 0.748031, 0.290341, 12, 0.016066, 0.748031, 0.306471, 11, 0.016066, 0.748031, 0.322601, 9, 0.016066, 0.748031, 0.338732, 7, 0.016066, 0.748031, 0.354862, 4, 0.032196, 0.748031, 0.387122, 9, 0.016066, 0.748031, 0.403252, 4, 0.112846, 0.748031, 0.516162, 4, 0.016066, 0.748031, 0.532292, 7, 0.016066, 0.748031, 0.548422, 9, 0.016066, 0.748031, 0.564553, 3, 0.016066, 0.748031, 0.580683, 2, 0.016066, 0.748031, 0.596813, 0, 0.016066, 0.748031, 0.612943, -3, 0.080586, 0.748031, 0.693593, 0, 0.016066, 0.748031, 0.709723, 4, 0.016066, 0.748031, 0.725853, 7, 0.016066, 0.748031, 0.741983, 11, 0.096716, 0.748031, 0.838764, 9, 0.032196, 0.748031, 0.871024, 5, 0.064456, 0.748031, 0.935544, -1, 0.064456, 0.748031

gkspongebob[] fillarray 0, 34, 0.022940, 0.543307, 0.023070, 34, 0.018641, 0.503937, 0.044692, 36, 0.018513, 0.511811, 0.066187, 34, 0.018726, 0.503937, 0.087895, 31, 0.018726, 0.527559, 0.109603, 27, 0.018513, 0.503937, 0.131098, 31, 0.018513, 0.511811, 0.152592, 34, 0.018598, 0.503937, 0.174343, 36, 0.020088, 0.543307, 0.197413, 34, 0.018641, 0.503937, 0.219035, 31, 0.083424, 0.511811, 0.523028, 34, 0.020088, 0.543307, 0.546098, 39, 0.021493, 0.503937, 0.567721, 39, 0.021365, 0.511811, 0.589215, 39, 0.018726, 0.503937, 0.610923, 36, 0.043073, 0.527559, 0.654126, 36, 0.018513, 0.511811, 0.675621, 39, 0.018598, 0.503937, 0.697371, 41, 0.020088, 0.543307, 0.720441, 39, 0.018641, 0.503937, 0.742063, 36, 0.083424, 0.511811 

gklostwoods[] fillarray 0, 17, 0.006414, 0.669291, 0.007378, 21, 0.006029, 0.629921, 0.014371, 23, 0.013008, 0.637795, 0.028343, 17, 0.006056, 0.653543, 0.035363, 21, 0.005987, 0.629921, 0.042315, 23, 0.012966, 0.637795, 0.056300, 17, 0.006497, 0.669291, 0.063761, 21, 0.006029, 0.629921, 0.070754, 23, 0.005987, 0.637795, 0.077706, 28, 0.006056, 0.629921, 0.084726, 26, 0.013008, 0.653543, 0.098698, 23, 0.005987, 0.637795, 0.105649, 24, 0.006015, 0.629921, 0.112683, 23, 0.006497, 0.669291, 0.120144, 19, 0.006029, 0.629921, 0.127137, 16, 0.033931, 0.637795, 0.162032, 14, 0.006015, 0.629921, 0.169067, 16, 0.006497, 0.669291, 0.176527, 19, 0.006029, 0.629921, 0.183520, 16, 0.040910, 0.629921, 0.225450, 17, 0.006497, 0.669291, 0.232910, 21, 0.006029, 0.629921, 0.239903, 23, 0.013008, 0.637795, 0.253875, 17, 0.006056, 0.653543, 0.260895, 21, 0.005987, 0.629921, 0.267847, 23, 0.012966, 0.637795, 0.281833, 17, 0.006497, 0.669291, 0.289293, 21, 0.006029, 0.629921, 0.296286, 23, 0.005987, 0.637795, 0.303238, 28, 0.006056, 0.629921, 0.310258, 26, 0.013008, 0.653543, 0.324230, 23, 0.005987, 0.637795, 0.331182, 24, 0.006015, 0.629921, 0.338216, 28, 0.006497, 0.669291, 0.345677, 23, 0.006029, 0.629921, 0.352669, 19, 0.033931, 0.637795, 0.387565, 23, 0.006015, 0.629921, 0.394599, 19, 0.006497, 0.669291, 0.402060, 14, 0.006029, 0.629921, 0.409052, 16, 0.040910, 0.629921, 0.450982, 14, 0.006497, 0.669291, 0.458443, 16, 0.006029, 0.629921, 0.465435, 17, 0.013008, 0.637795, 0.479407, 19, 0.006056, 0.653543, 0.486428, 21, 0.005987, 0.629921, 0.493379, 23, 0.012966, 0.637795, 0.507365, 24, 0.006497, 0.669291, 0.514826, 23, 0.006029, 0.629921, 0.521818, 16, 0.040910, 0.629921, 0.563748, 14, 0.006497, 0.669291, 0.571209, 16, 0.006029, 0.629921, 0.578202, 17, 0.013008, 0.637795, 0.592173, 19, 0.006056, 0.653543, 0.599194, 21, 0.005987, 0.629921, 0.606145, 23, 0.012966, 0.637795, 0.620131, 24, 0.006497, 0.669291, 0.627592, 26, 0.006029, 0.629921, 0.634585, 28, 0.040910, 0.629921, 0.676514, 14, 0.006497, 0.669291, 0.683975, 16, 0.006029, 0.629921, 0.690968, 17, 0.013008, 0.637795, 0.704939, 19, 0.006056, 0.653543, 0.711960, 21, 0.005987, 0.629921, 0.718911, 23, 0.012966, 0.637795, 0.732897, 24, 0.006497, 0.669291, 0.740358, 23, 0.006029, 0.629921, 0.747351, 16, 0.040910, 0.629921, 0.789280, 17, 0.006497, 0.669291, 0.796741, 16, 0.006029, 0.629921, 0.803734, 21, 0.005987, 0.637795, 0.810685, 19, 0.006056, 0.629921, 0.817706, 23, 0.006056, 0.653543, 0.824726, 21, 0.005987, 0.629921, 0.831677, 24, 0.005987, 0.637795, 0.838629, 23, 0.006015, 0.629921, 0.845663, 26, 0.006497, 0.669291, 0.853124, 24, 0.006029, 0.629921, 0.860117, 28, 0.005987, 0.637795, 0.867068, 26, 0.006056, 0.629921, 0.874089, 29, 0.006056, 0.653543, 0.881109, 28, 0.006910, 0.629921, 0.888060, 28, 0.002725, 0.637795, 0.891598, 29, 0.005863, 0.629921, 0.898426, 26, 0.002752, 0.629921, 0.902046, 28, 0.097816, 0.629921 



;--- ||| --- ||| ---

;	instr 900, mouth
;	instr 950, clearer
;	instr 955, checker
;-----------------------------------------

#ifdef midi

	instr metrj_control

$if	eu(8, 16, 16, "heart") $then
	schedulek "metrj", 0, 25$ms
endif

	endin
	alwayson("metrj_control")


	instr metrj

	noteondur2	1, 48, 120, p3

	endin
#end

;-----------------------------------------

	instr 895

indx		init 0
until	indx == ginchnls do
	isend	init 900+((indx+1)/100)
	schedule isend, 0, -1, indx

	/*
	prints "\n\n\n!!!"
	print isend
	print indx
	prints "\n\n\n!!!"
	*/

	indx += 1
od
	turnoff

	endin
	schedule(895, 0, 1)
;-----------------------------------------
	instr 900; MOUTH

ich		init p4

		prints("👅---%f\n", p1)

aout		chnget gSmouth[ich]

;	DCBLOCK2
aout	dcblock2 aout

aout		*= gkgain

	outch gioffch+ich+1, aout

;	SEND AUDIO to OSC
kwhen		metro 5

	OSCsend kwhen, gShost, giport, sprintfk("/out%i", ich+1), "s", sprintfk("%f", k(aout))

;	CLEAR
	chnclear gSmouth[ich]

	endin
;-----------------------------------------
;	generate for each instrument a clear instrument
	instr 915

indx1	init 0
while	indx1 < ginstrslen do
		indx2	init 1
		;print indx1
		prints "%s | %i\n", gSinstrs[indx1], nstrnum(gSinstrs[indx1])
	until indx2 > ginchnls do
			isend	= 950 + (nstrnum(gSinstrs[indx1])/1000) + indx2/100000
			schedule isend, 0, -1, gSinstrs[indx1], indx2
			;print indx2
			indx2	+= 1
	od
		indx1	+= 1
od
	turnoff
	endin
	schedule(915, 0, 1)

	instr 950; CLEARER

Sinstr	strget	p4
ich		init p5

	;prints("---%s(%f) is digested\n", Sinstr, p1)
	
	chnclear sprintf("%s_%i", Sinstr, ich)

	endin

;-----------------------------------------
/*

	instr 955; CHECKER

ieach		= 2.5
ilen		lenarray gSinstrs

ihowmany	init 75

ktrig		init 1
ktrig		metro 1/ieach

kndx		init 0

kabstime	times
kmin		= int(kabstime/60)
ksec		= kabstime%60

if		ktrig == 1 then

		kndx	= 0

		until kndx == ilen do
			kactive	active gSinstrs[kndx]
			if (kactive > ihowmany) then
				printks("🧨 Watch out! %i instaces of %s\n", 0, kactive, gSinstrs[kndx])
			endif
			kndx	+= 1
		od

		printks("\n-------checking instances-------\n", 0)
		printks("--------- %.2d'  |  %.2d'' ---------\n", 0, kmin, ksec)

endif

	endin
	alwayson(955)

	instr 956

idiv 	init 1/96
kstart	init 1

if kstart == 1 then
	midiout 176, 1, 1, 2
endif

kstart = 0

;idiv 	init 1/96
;idiv	*= 64
kph	chnget	"heart"
kph	= (kph * 64 * 24) % 1

klast init -1
	
if (kph < klast) then
	midiout 176, 1, 1, 1
endif

klast = kph

	endin
	alwayson(956)
*/



;--- ||| --- ||| ---

