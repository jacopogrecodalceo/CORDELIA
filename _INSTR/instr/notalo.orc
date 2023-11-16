;		============
;		*** INIT ***
;		============
ganotalo_env init 0

;		============
;		*** PARM ***
;		============
ginotalo_rel	init 1/9
gknotalo_channel_var init 1 ; [0-1]

;		============
;		*** CTRL ***
;		============
		instr notalo
		$params(notalo_instr)
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
		instr notalo_instr
		$params(notalo)
;		============

iskip 	tival

igliss init idur/2
iport	init idur/4

tigoto SKIP_INIT
	ilast_cps	init icps

SKIP_INIT:
kcps_env	cosseg ilast_cps, igliss, icps;, idur - .05, inewpch
ilast_cps	= icps

klast_env			k ganotalo_env
ganotalo_env		cosseg i(klast_env), iport, idyn, idur - iport, 0

aout			vco2 1, kcps_env, iskip
aout			moogladder aout, icps*9, .5, iskip

aout			*= ganotalo_env
;		============
		$channel_mix
		endin

/* indx	init 0
until	indx == nchnls do
	schedule nstrnum("notalo_instr")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od */
