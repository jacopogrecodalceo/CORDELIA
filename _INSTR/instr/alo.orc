;		============
;		*** INIT ***
;		============
; maxalloc "alo_instr", nchnls

;		============
;		*** PARM ***
;		============
gialo_rel	init 1/9
gkalo_channel_var init 1 ; [0-1]
gaalo_env init 0
gaalo_ffreq init 0
;		============
;		*** CTRL ***
;		============
		instr alo
		$params(alo_instr)
;		============
inum_instr	init nstrnum(Sinstr)+(ich/1000)
;if active(inum_instr) == 0 then
;	event_i "i", inum_instr, 0, -idur, idyn, ienv, icps, ich
	schedule inum_instr, 0, -idur, idyn, ienv, icps, ich
;endif
;		============
/* 		chnset idyn, sprintf("%s_dyn_%i", Sinstr, ich)
		chnset ienv, sprintf("%s_env_%i", Sinstr, ich)
		chnset icps, sprintf("%s_cps_%i", Sinstr, ich) */
;		============
		turnoff
		endin

;		============
;		*** INST ***
;		============
		instr alo_instr
		$params(alo)
;		============

iskip 	tival

igliss init idur/2
iport	init idur/4

tigoto SKIP_INIT
	ilast_cps	init icps

SKIP_INIT:
kcps_env	cosseg ilast_cps, igliss, icps;, idur - .05, inewpch
ilast_cps	= icps

klast_env		k gaalo_env
gaalo_env		cosseg i(klast_env), iport, idyn, idur - iport, 0

klast_ffreq		k gaalo_ffreq
gaalo_ffreq		cosseg i(klast_ffreq), .035, 35, iport, icps*12

aout			vco2 1, kcps_env, iskip
aout			moogladder aout, gaalo_ffreq, .5, iskip

aout			*= gaalo_env
;		============
		$channel_mix
		endin

/* indx	init 0
until	indx == nchnls do
	schedule nstrnum("alo_instr")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od */
