<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr      = 48000
ksmps   = 32
nchnls  = 2
0dbfs   = 1


gSfile   init "/Users/j/Documents/PROJECTs/_utils/stereo.wav"

gihanning   ftgen   0, 0, 8192, 20, 2
ich     filenchnls gSfile
indx    init 0
until indx == ich do
    inum init indx + 1
    itab ftgen inum, 0, 0, 1, gSfile, 0, 0, inum
    event_i "i", 1, 0, 1, inum
    indx += 1
od

/*     instr 5
    
    print p4

icps    init 1/(ftlen(p4)/sr)
aout    table phasor:a(icps), p4, 1
    outch p4, aout*.25

    endin */


        instr 1

isize   init 1024
kport   = .05
kspeed  = 1
iord    init ksmps

ich init p4

kis_samphold_freq   init 0
kbpm_samphold       = 120

p3      init ftlen(ich)/sr

kread   init 0
iord    init ksmps

kcfs[], krms, kerr, kf0 lpcanal kread, 1, ich, isize, iord, gihanning

if kis_samphold_freq == 1 then
    ;kflag init 1
    ;kflag_var jitter 1, 1/12, 1/3
    kflag       metro (kbpm_samphold/60)*4
    kf0         samphold kf0, kflag
endif

ibandwidth init 1000

if (kf0 > ibandwidth * 8) then
    kf0 /= 64
elseif (kf0 > ibandwidth * 4) then
    kf0 /= 32
elseif (kf0 > ibandwidth * 2) then
    kf0 /= 16
elseif (kf0 > ibandwidth) then
    kf0 /= 8
; Add more conditions as needed
; elseif (kf0 > ibandwidth * 16) then
;     kf0 /= 32
; elseif (kf0 > ibandwidth * 32) then
;     kf0 /= 64
; ...
endif

kf0     init 0
kf_temp  init 0
kf0_last  init 0

if kf0 != kf_temp then
    kf0_last = kf_temp
endif
kf_temp = kf0
;ain, ano diskin gSfile, 1/8, 0, 1
;kcfs[], krms, kerr, kcps lpcanal ain, 1, ksmps, isize, iord, iwin

;printk2 kf0
;printk2 kf0_last
kn_harm             = sr/(kf0*4)

a1      buzz 0dbfs, portk(kf0, abs(jitter(kport, 1/12, 1))), kn_harm, -1

;a2      vco2 4*(krms*kerr), kf0_last
;a2      buzz 0dbfs, portk(kf0_last, $port_lpcanal), kn_harm, -1

asum    = a1; + a2

;a1      fractalnoise 1, .5
;a1, ano      diskin "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm2.wav", 1, 0, 1
a3      allpole asum*krms*kerr, kcfs

kread      += ksmps*kspeed  

if kread > ftlen(ich) then
    kread = 0
endif 

        outch ich, a3

        endin

</CsInstruments>
</CsoundSynthesizer>