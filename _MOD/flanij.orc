;START CORE

PARAM_1		init i(gkbeats)
PARAM_2		init .5

PARAM_OUT	flanger PARAM_IN, a(portk(PARAM_1, gkbeats/24)), portk(PARAM_2, .025), 15
;END CORE
;START INPUT
kk
;END INPUT
