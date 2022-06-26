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