
gi---NAME---_len		init lenarray(gi---NAME---_list)/gi---NAME---_ch
gi---NAME---_where		init 0

gk---NAME---_off		init .005
gk---NAME---_freq		init 1
gk---NAME---_sonvs		init 1

	$start_instr(---NAME---)

isonvs		i gk---NAME---_sonvs-1
isonvs		init isonvs%(gi---NAME---_len-1)
imod		init gi---NAME---_ch-1

index		init (isonvs*gi---NAME---_ch)+imod

itab_sonvs	init gi---NAME---_list[index]

kport		= .025
;kspeed		= 1 / (icps % 64)

isize		init 1024

iord		init ksmps

kis_samphold_freq   init 0
itab_dur	init ftlen(itab_sonvs)/sr

if icps < 1 then

	if icps == 0 then
		icps = .8
	endif
	
	ifreq		init 1/itab_dur
	kread		phasor ifreq
	kread		= (kread+(i(gkbeatn)/dec_to_int(icps)))%1

else

	idiv		init icps%i(gkdiv)
	ioff		i gk---NAME---_off

	if ioff!=0 then
		ioff		random 0, ioff
	endif

	kcycle		= (chnget:k("heart") * divz(gkdiv, idiv, 1))+ioff
	kread		= kcycle % 1

endif

iord    init ksmps

kcfs[], krms, kerr, kf0 lpcanal kread*ftlen(itab_sonvs), 1, itab_sonvs, isize, iord, gihanning

ibandwidth ntof "5B"

if kis_samphold_freq == 1 then
    ;kflag init 1
    ;kflag_var jitter 1, 1/12, 1/3
	kcycle		= (chnget:k("heart") * divz(gkdiv, idiv, 1)*8)+ioff
    kf0         samphold kf0, changed2(kcycle)
endif


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
a2      buzz 0dbfs, portk(kf0_last, abs(jitter(kport, 1/12, 1))), kn_harm, -1

asum    = a1 + a2

;a1      fractalnoise 1, .5
;a1, ano      diskin "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm2.wav", 1, 0, 1
aout      allpole asum*krms*kerr, kcfs
aout        *= 2
if kread > ftlen(itab_sonvs) then
    kread = 0
endif

    $dur_var(10)
	$end_instr
