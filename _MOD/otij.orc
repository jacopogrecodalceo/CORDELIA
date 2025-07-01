;START CORE
PARAM_1    init ntof("3B")
PARAM_2    init .35
PARAM_3    init .5

PARAM_OUT cordelia_OTT_comp PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

	opcode cordelia_OTT_comp, a, akkk
	ain, kfreq_high, kthresh, kwet xin

	;setksmps 512

ifreq_low		init 95

;=== SPLIT INTO 3 BANDS ===;
alow        	butlp ain, ifreq_low
apre_mid       	buthp ain, ifreq_low
amid        	butlp apre_mid, kfreq_high
ahigh       	buthp ain, kfreq_high

;=== COMPRESSOR SETTINGS ===;

kl_thresh   = kthresh * 3
km_thresh   = kthresh / 2
kh_thresh   = kthresh * 2

kup_ratio   = 3
kdown_ratio = 9

;	=== ENVELOPES ===;

kl_env		rms alow
km_env		rms amid
kh_env		rms ahigh

;      === LOW BAND GAIN ===;
kl_gain     = (kl_env > kl_thresh) ? (kl_thresh + (kl_env - kl_thresh) / kdown_ratio) / kl_env \
								   : (kl_env < kl_thresh) ? (kl_thresh - (kl_thresh - kl_env) / kup_ratio) / kl_env : 1
alow_comp   = alow * kl_gain

;	=== MID BAND GAIN ===;
km_gain     = (km_env > km_thresh) ? (km_thresh + (km_env - km_thresh) / kdown_ratio) / km_env \
								   : (km_env < km_thresh) ? (km_thresh - (km_thresh - km_env) / kup_ratio) / km_env : 1
amid_comp   = amid * km_gain

;	=== HIGH BAND GAIN ===;
kh_gain     = (kh_env > kh_thresh) ? (kh_thresh + (kh_env - kh_thresh) / kdown_ratio) / kh_env \
								   : (kh_env < kh_thresh) ? (kh_thresh - (kh_thresh - kh_env) / kup_ratio) / kh_env : 1
ahigh_comp  = ahigh * kh_gain

;	=== RECOMBINE BANDS ===
acomp       = alow_comp + amid_comp + ahigh_comp
acomp		/= 12

;   === DRY/WET MIX ===
aout        = (ain * (1 - kwet)) + (acomp * kwet)

	xout aout
	endop
;END OPCODE

