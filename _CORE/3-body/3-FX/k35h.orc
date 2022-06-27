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
