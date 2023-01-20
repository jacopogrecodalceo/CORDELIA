;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime

aout	= ain * oscili:a(1, kfreq, ift)
