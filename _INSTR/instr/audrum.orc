giaudrum_len					init 16
gkaudrum_hh_1[]					fillarray 	0, 1, 1, 1, 	1, 1, 1, 2, 	0, 1, 1, 2, 	0, 1, 1, 2
gkaudrum_kick_1[]				fillarray 	0, 0, 0, 1, 	0, 0, 0, 0, 	1, 0, 0, 0, 	0, 0, 1, 0
gkaudrum_kick_2[]				fillarray 	2, 0, 0, 0, 	0, 1, 0, 0, 	0, 0, 0, 0, 	0, 0, 0, 0
gkaudrum_kick_3[]				fillarray 	0, 0, 1, 0, 	0, 0, 0, 1, 	0, 0, 0, 0, 	0, 0, 0, 0

gkaudrum_jit init 0

#define if_audrum(instr'dur'dyn) #
kdyn_$instr = gkaudrum_$instr[kdiv%giaudrum_len]
if kdyn_$instr > 0 then
	kdur		= $dur
	schedulek "audrum_$instr", 0, (2/idiv)/2+kdur*kdyn_$instr/2, kdyn_$instr*idyn/$dyn, ich
	if gkaudrum_jit > (8-$dur) then
		schedulek "audrum_$instr", gkbeats/floor(gkaudrum_jit)*gkaudrum_jit, (2/idiv)/2+kdur/gkaudrum_jit, kdyn_$instr*idyn/$dyn, ich
	endif
	if gkaudrum_jit > (8-$dur) then
		kndx = 0
		until kndx > gkaudrum_jit*2 do
			schedulek "audrum_$instr", gkbeats/floor(gkaudrum_jit/16)*kndx, (2/idiv)/2+kdur/(gkaudrum_jit*8), kdyn_$instr*idyn/$dyn, ich
			kndx += 1
		od
	endif

endif
#

$start_instr(audrum)

	idiv			init icps%i(giaudrum_len)

	; divide the main 64 quarter notes into a subdivision of 8 quarter notes
	; so from 0 to 1 now the cycle is from 0 to (64 / 8) = 8
	; representing the 8 bars
	kcycle			chnget "heart"
	kdiv			floor kcycle*gkdiv*idiv

	if changed2(kdiv) == 1 then
		$if_audrum(hh_1'.05'16)
		$if_audrum(kick_1'.15'1)
		$if_audrum(kick_2'random:k(.15, .25)'1)
		$if_audrum(kick_3'.5'1)
	endif
	
	if active:i(nstrnum("audrum_jit")+ich/1000) == 0 then
		schedule "audrum_jit", 0, -idur, ich
	endif

	if active:k("audrum_global_jit") == 0 then
		schedule "audrum_global_jit", 0, -idur
	endif


endin

instr audrum_global_jit
	idur			abs p3
	gkaudrum_jit 	abs jitter(9, gkbeatf/8, gkbeatf)
	if timeinsts() > idur+3.5 then
		turnoff
	endif 
endin


instr audrum_jit
	idur		abs p3
	ich			init p4
	kjit		jitter 1, .05, .15
	Sinstr		sprintf "%s_%i", nstrstr(p1), ich
	chnset	kjit, Sinstr
	if timeinsts() > idur+3.5 then
		turnoff
	endif 
endin

giaudrum_kick_1_dur		init 8192
giaudrum_kick_1_atk		init 4
giaudrum_kick_1_01_wet	init 0
giaudrum_kick_1_ft		ftgen 0, 0, giaudrum_kick_1_dur, -16, \
						0, giaudrum_kick_1_atk, 0, \
						3, giaudrum_kick_1_dur-giaudrum_kick_1_atk, -5.45+giaudrum_kick_1_01_wet*2.5, \
						0

instr audrum_kick_1
	Sinstr init "audrum"

	;setksmps 1

	idyn		init p4
	ich			init p5
	aenv		table3 linseg:a(0, p3, giaudrum_kick_1_dur), giaudrum_kick_1_ft

	afreq		= aenv*50+25
	aout		oscil3 aenv, afreq
	aout		tanh aout
	aout		*= idyn

	$channel_mix

endin

giaudrum_kick_2_dur		init 8192
giaudrum_kick_2_atk		init 64
giaudrum_kick_2_01_wet	init 0
giaudrum_kick_2_ft		ftgen 0, 0, giaudrum_kick_2_dur, -16, \
						0, giaudrum_kick_2_atk, 0, \
						1, giaudrum_kick_2_dur-giaudrum_kick_2_atk, .45+giaudrum_kick_2_01_wet*2.5, \
						0

instr audrum_kick_2
	Sinstr init "audrum"

	;setksmps 1

	idyn		init p4
	ich			init p5
	aenv		table3 linseg:a(0, p3, giaudrum_kick_2_dur), giaudrum_kick_2_ft

	afreq		= aenv*50+5
	aout		oscil3 aenv, afreq
	aout		*= 2
	aout		lowpass2 aout, 20, 0
	aout		tanh aout
	;aout		*= linseg(1, p3-.005, 1, .005, 0)
	aout		*= idyn

	$channel_mix

endin

giaudrum_kick_3_dur		init 8192
giaudrum_kick_3_atk		init 64
giaudrum_kick_3_01_wet	init 0

giaudrum_kick_3_ft_freq	ftgen 0, 0, giaudrum_kick_3_dur, -16, \
						475, 	giaudrum_kick_3_dur * 1/16,	-.25, \
						142.5, 	giaudrum_kick_3_dur * 3/16,	-.25,\
						95, 	giaudrum_kick_3_dur * 2/16, 	0,\
						47.5, 	giaudrum_kick_3_dur * 7/16,	0,\
						47.5, 	giaudrum_kick_3_dur * 3/16,	.5,\
						0

instr audrum_kick_3
	Sinstr init "audrum"

	;setksmps 1
	idyn		init p4
	ich			init p5
	Sjit_instr	sprintf "audrum_jit_%i", ich
	kjit		chnget Sjit_instr
	p3			init p3 * random:i(.65, .75)


	;p3			+= random(0, 100)/1000
	afreq		table3 linseg:a(0, p3, giaudrum_kick_3_dur), giaudrum_kick_3_ft_freq
	aenv		linseg 1, p3, 0
	aosc		oscil3 aenv, afreq+kjit

    aimp		fractalnoise 1, 1
    aimp		*= linseg:a(1, .0025, 0)  ; Short envelope to shape the click

	aout		= aosc + aimp

	aout		lowpass2 aout, 20, 0
	aout		tanh aout
	aout		*= idyn

	$channel_mix

endin


instr audrum_hh_1
	Sinstr init "audrum"
	;setksmps 1

	idyn		init p4
	ich			init p5
	kjit		jitter 1, 3.5, 5.5

	icps		ntof "8B"
	aosc		oscil3 1, icps+kjit*((icps*11/10)-icps)

    anoi		fractalnoise 1, 1

	ahh			butterhp anoi*cosseg(1, .005*random:i(2, 3), .85, .005*random:i(2, 3), 0), icps/2, .85

	aimp		resonx anoi, icps, icps / cosseg(50, p3, 5)
	aimp		balance2 aimp, anoi

	aout		= (aimp + aosc + ahh)/6
	aout		*= cosseg:a(0, .005, 1, p3-.05, 0)
	aout		*= idyn

	$channel_mix

endin
