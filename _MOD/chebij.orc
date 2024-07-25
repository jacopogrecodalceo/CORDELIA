;START CORE
PARAM_1    init 64

PARAM_OUT cordelia_chebyshev PARAM_IN, PARAM_1
;END CORE

;START INPUT
k
;END INPUT

;START OPCODE
    opcode cordelia_chebyshev, a, ak
    ain, kfreq xin

k0      jitter 1, gkbeatf/kfreq, gkbeatf/kfreq/2
k1		jitter 1, gkbeatf/kfreq, gkbeatf/kfreq/2
k2		jitter 1, gkbeatf/kfreq, gkbeatf/kfreq/2
k3		jitter 1, gkbeatf/kfreq, gkbeatf/kfreq/2
k4		jitter 1, gkbeatf/kfreq, gkbeatf/kfreq/2
k5		jitter 1, gkbeatf/kfreq, gkbeatf/kfreq/2
k6		jitter 1, gkbeatf/kfreq, gkbeatf/kfreq/2

aout        chebyshevpoly  ain, k0, k1, k2, k3, k4, k5, k6
aout        chebyshevpoly  aout, k6, k5, k4, k3, k2, k1, k0

aout        balance aout, ain

    xout aout
    endop
;END OPCODE

