;START CORE

PARAM_1 init i(gkbeats)
PARAM_2	init .5
PARAM_3	init .5

PARAM_OUT    cordelia_delay2 PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

opcode cordelia_delay2, a, akkk
	ain, kdel_time, kfb, kwet xin

	imax init 15
	iwindow_size init ksmps
	aout vdelayx ain*kwet, a(kdel_time), imax, iwindow_size

	adel_out =  ain*(1-kwet) + adel

		xout adel_out
	
endop
;END OPCODE