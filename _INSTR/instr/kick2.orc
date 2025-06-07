; Csound mailing list nice kick made with Claude	
; 2 june 2025

	$start_instr(kick2)

idyn = p4/128

; MAIN CONTROLS - Edit these values directly (all 0-1 range)
ihead_material 			init 0.33     ; 0=coated, 0.33=clear, 0.66=kevlar, 1=vintage
ibeater_material 		init random:i(0, .5);0.33   ; 0=felt, 0.33=wood, 0.66=plastic, 1=metal
ishell_depth 			init 1/6        ; 0=shallow(12"), 0.5=medium(16"), 1=deep(20")
ishell_wood 			init 0.33        ; 0=birch, 0.33=maple, 0.66=mahogany, 1=oak
itune_pitch 			init 3         ; 0=low(45Hz), 0.5=mid(60Hz), 1=high(75Hz)
ihead_tension 			init .17       ; 0=loose, 1=tight (affects sustain and pitch)
ihit_force 				init 100          ; 0=soft, 1=hard (main dynamics control)
iroom_size 				init 0.3          ; 0=close-mic, 1=large room
imodulation_rate 		init 0.5    ; 0=slow, 1=fast - TRIANGLE WAVE MODULATION RATE


; KICK DRUM FREQUENCY SETUP
ifund_freq = icps + (itune_pitch * 30)  ; 45-75Hz fundamental

; HIT ENVELOPE
khit_env expseg 1, 0.002, 0.8, 0.008, 0.4, 0.02, 0.15, 0.08, 0.05, 0.15, 0.01, idur-0.285, 0.001

; TRIANGLE WAVE MODULATION SOURCE (a-rate)
imod_freq = 0.5 + imodulation_rate * 4.5  ; 0.5Hz to 5Hz modulation rate
amod_triangle oscili 0.1, imod_freq, gitri  ; Triangle wave modulation

; 2-OPERATOR FM SYNTHESIS AS IMPULSE GENERATOR
imod_freq_base = ifund_freq * (2 + ibeater_material * 6)
kmod_freq = imod_freq_base * (1 + khit_env * 0.5)

; ihit_force controls FM modulation depth (how much modulator modulates carrier)
imod_index_max = ihit_force * 15                  ; Hit force = FM modulation amount
kmod_index = imod_index_max * khit_env * khit_env

icar_freq = ifund_freq
kcar_freq = icar_freq * (1 + khit_env * 0.1)

; FEEDBACK SYSTEM (also affected by hit force)
ifeedback_amount = 0.1 + ihit_force * 0.4        ; Hit force affects feedback too
amod_fb_env expseg 1, 0.001, 0.8, 0.005, 0.3, 0.01, 0.1, 0.02, 0.05, idur-0.038, 0.001
kfeedback = ifeedback_amount * amod_fb_env

; FM synthesis with feedback
amod_osc oscili kmod_index, kmod_freq, -1
amod_delayed delay amod_osc, 1/sr
amod_with_fb = amod_osc + amod_delayed * kfeedback

acarrier oscili khit_env, kcar_freq + amod_with_fb, -1
aharm_gen = acarrier * amod_with_fb * 0.1

; BEATER ATTACK ENHANCEMENT
ibeater_click_freq = 2500 + ibeater_material * 1500
kclick_env expseg 1, 0.001, 0.6, 0.003, 0.2, 0.006, 0.05, 0.02, 0.001, idur-0.03, 0.001
aclick_osc oscili kclick_env * ibeater_material, ibeater_click_freq, -1

; Combine FM synthesis output - PRIMARY EXCITATION
afm_impulse = acarrier + aharm_gen + aclick_osc * 0.3

; ===== SEPARATE ACOUSTIC SPACES APPROACH =====
; Based on research: Each space (membrane, shell, room) needs its own reverb system
; All sounds mixed to simulate listening from the FRONT of the kick drum

; SPACE 1: MEMBRANE RESONANCE (8-comb reverb system)
; Material characteristics
ihead_damping = (ihead_material < 0.25) ? 0.8 : \
				(ihead_material < 0.5) ? 0.3 : \
				(ihead_material < 0.75) ? 0.15 : 0.9

; Initialize membrane reverb filter variables
amemb_filt1 init 0
amemb_filt2 init 0  
amemb_filt3 init 0
amemb_filt4 init 0
amemb_filt5 init 0
amemb_filt6 init 0
amemb_filt7 init 0
amemb_filt8 init 0

; Membrane-specific delay times (based on membrane modes)
imemb_del1 = 1 / ifund_freq                    ; Fundamental
imemb_del2 = 1 / (ifund_freq * 2.295)         ; First overtone
imemb_del3 = 1 / (ifund_freq * 3.598)         ; Second overtone  
imemb_del4 = 1 / (ifund_freq * 4.888)         ; Third overtone
imemb_del5 = imemb_del1 * 0.8                 ; Coupling mode 1
imemb_del6 = imemb_del2 * 0.9                 ; Coupling mode 2
imemb_del7 = imemb_del3 * 0.7                 ; Coupling mode 3
imemb_del8 = imemb_del4 * 0.85                ; Coupling mode 4

; Membrane reverb parameters
kmemb_feedback = (0.4 + ihead_tension * 0.4) * (1 - ihead_damping * 0.4)
kmemb_lpfreq = 1200 + ihead_material * 2000

; Convert triangle wave to k-rate for membrane modulation
kmod_triangle downsamp amod_triangle

; Membrane space random modulation
kmemb1 randi 0.0008, 2.1, 0.1
kmemb1 = kmemb1 + kmod_triangle * 0.0006
kmemb2 randi 0.0009, 2.7, 0.3
kmemb2 = kmemb2 + kmod_triangle * 0.0004
kmemb3 randi 0.0011, 3.2, 0.5
kmemb3 = kmemb3 + kmod_triangle * 0.0007
kmemb4 randi 0.0007, 1.8, 0.7
kmemb4 = kmemb4 + kmod_triangle * 0.0005
kmemb5 randi 0.0006, 2.9, 0.2
kmemb5 = kmemb5 + kmod_triangle * 0.0008
kmemb6 randi 0.0012, 1.5, 0.6
kmemb6 = kmemb6 + kmod_triangle * 0.0003
kmemb7 randi 0.0010, 3.5, 0.4
kmemb7 = kmemb7 + kmod_triangle * 0.0006
kmemb8 randi 0.0005, 2.3, 0.8
kmemb8 = kmemb8 + kmod_triangle * 0.0009

; Membrane scattering junction
amemb_pj = 0.25 * (amemb_filt1 + amemb_filt2 + amemb_filt3 + amemb_filt4 + amemb_filt5 + amemb_filt6 + amemb_filt7 + amemb_filt8)

; Membrane reverb delay lines
adum1 delayr 1
amemb_del1 deltap3 imemb_del1 + kmemb1  
delayw afm_impulse * 0.8 + amemb_pj - amemb_filt1

adum2 delayr 1
amemb_del2 deltap3 imemb_del2 + kmemb2
delayw afm_impulse * 0.6 + amemb_pj - amemb_filt2

adum3 delayr 1  
amemb_del3 deltap3 imemb_del3 + kmemb3
delayw afm_impulse * 0.4 + amemb_pj - amemb_filt3

adum4 delayr 1
amemb_del4 deltap3 imemb_del4 + kmemb4
delayw afm_impulse * 0.3 + amemb_pj - amemb_filt4

adum5 delayr 1
amemb_del5 deltap3 imemb_del5 + kmemb5  
delayw afm_impulse * 0.25 + amemb_pj - amemb_filt5

adum6 delayr 1
amemb_del6 deltap3 imemb_del6 + kmemb6
delayw afm_impulse * 0.2 + amemb_pj - amemb_filt6

adum7 delayr 1
amemb_del7 deltap3 imemb_del7 + kmemb7
delayw afm_impulse * 0.15 + amemb_pj - amemb_filt7

adum8 delayr 1
amemb_del8 deltap3 imemb_del8 + kmemb8
delayw afm_impulse * 0.1 + amemb_pj - amemb_filt8

; Membrane lowpass filters
amemb_filt1 tone amemb_del1 * kmemb_feedback, kmemb_lpfreq
amemb_filt2 tone amemb_del2 * kmemb_feedback, kmemb_lpfreq  
amemb_filt3 tone amemb_del3 * kmemb_feedback, kmemb_lpfreq
amemb_filt4 tone amemb_del4 * kmemb_feedback, kmemb_lpfreq
amemb_filt5 tone amemb_del5 * kmemb_feedback, kmemb_lpfreq
amemb_filt6 tone amemb_del6 * kmemb_feedback, kmemb_lpfreq
amemb_filt7 tone amemb_del7 * kmemb_feedback, kmemb_lpfreq
amemb_filt8 tone amemb_del8 * kmemb_feedback, kmemb_lpfreq

; Membrane space output (mix odd/even for stereo)
amembrane = 0.4 * (amemb_filt1 + amemb_filt3 + amemb_filt5 + amemb_filt7)

; SPACE 2: SHELL CAVITY RESONANCE (8-comb reverb system)
; Shell material characteristics
ishell_damping_factor = (ishell_wood < 0.25) ? 0.02 : \
						(ishell_wood < 0.5) ? 0.025 : \
						(ishell_wood < 0.75) ? 0.035 : 0.028
ishell_depth_m = (12 + ishell_depth * 8) * 0.0254

; Initialize shell reverb filter variables
ashell_filt1 init 0
ashell_filt2 init 0  
ashell_filt3 init 0
ashell_filt4 init 0
ashell_filt5 init 0
ashell_filt6 init 0
ashell_filt7 init 0
ashell_filt8 init 0

; Shell-specific delay times (based on air cavity modes)
iair_fund = 343 / (2 * ishell_depth_m)
ishell_del1 = 1 / iair_fund                   ; Air cavity fundamental
ishell_del2 = 1 / (iair_fund * 2)            ; Air cavity 2nd harmonic
ishell_del3 = 1 / (iair_fund * 3)            ; Air cavity 3rd harmonic
ishell_del4 = 1 / (iair_fund * 4)            ; Air cavity 4th harmonic
ishell_del5 = ishell_del1 * 1.3              ; Shell coupling mode 1
ishell_del6 = ishell_del2 * 1.4              ; Shell coupling mode 2
ishell_del7 = ishell_del3 * 1.2              ; Shell coupling mode 3
ishell_del8 = ishell_del4 * 1.5              ; Shell coupling mode 4

; Shell reverb parameters (ishell_depth controls decay time in seconds)
ishell_decay_time = 0.2 + ishell_depth * 1.8  ; 0.2 to 2.0 seconds decay
kshell_feedback = exp(-2.2 / (ishell_decay_time * sr / ksmps))  ; RT60 calculation
kshell_lpfreq = 800 + ishell_wood * 1500

; Shell space random modulation
kshell1 randi 0.0006, 1.9, 0.15
kshell1 = kshell1 + kmod_triangle * 0.0004
kshell2 randi 0.0008, 2.4, 0.35
kshell2 = kshell2 + kmod_triangle * 0.0007
kshell3 randi 0.0007, 3.1, 0.55
kshell3 = kshell3 + kmod_triangle * 0.0005
kshell4 randi 0.0009, 1.7, 0.75
kshell4 = kshell4 + kmod_triangle * 0.0008
kshell5 randi 0.0005, 2.8, 0.25
kshell5 = kshell5 + kmod_triangle * 0.0003
kshell6 randi 0.0011, 1.3, 0.65
kshell6 = kshell6 + kmod_triangle * 0.0006
kshell7 randi 0.0008, 3.6, 0.45
kshell7 = kshell7 + kmod_triangle * 0.0009
kshell8 randi 0.0004, 2.2, 0.85
kshell8 = kshell8 + kmod_triangle * 0.0007

; Shell input (fed by membrane output)
ashell_input = amembrane * 0.6

; Shell scattering junction
ashell_pj = 0.25 * (ashell_filt1 + ashell_filt2 + ashell_filt3 + ashell_filt4 + ashell_filt5 + ashell_filt6 + ashell_filt7 + ashell_filt8)

; Shell reverb delay lines
adum9 delayr 1
ashell_del1 deltap3 ishell_del1 + kshell1  
delayw ashell_input + ashell_pj - ashell_filt1

adum10 delayr 1
ashell_del2 deltap3 ishell_del2 + kshell2
delayw ashell_input + ashell_pj - ashell_filt2

adum11 delayr 1  
ashell_del3 deltap3 ishell_del3 + kshell3
delayw ashell_input + ashell_pj - ashell_filt3

adum12 delayr 1
ashell_del4 deltap3 ishell_del4 + kshell4
delayw ashell_input + ashell_pj - ashell_filt4

adum13 delayr 1
ashell_del5 deltap3 ishell_del5 + kshell5  
delayw ashell_input + ashell_pj - ashell_filt5

adum14 delayr 1
ashell_del6 deltap3 ishell_del6 + kshell6
delayw ashell_input + ashell_pj - ashell_filt6

adum15 delayr 1
ashell_del7 deltap3 ishell_del7 + kshell7
delayw ashell_input + ashell_pj - ashell_filt7

adum16 delayr 1
ashell_del8 deltap3 ishell_del8 + kshell8
delayw ashell_input + ashell_pj - ashell_filt8

; Shell lowpass filters
ashell_filt1 tone ashell_del1 * kshell_feedback, kshell_lpfreq
ashell_filt2 tone ashell_del2 * kshell_feedback, kshell_lpfreq  
ashell_filt3 tone ashell_del3 * kshell_feedback, kshell_lpfreq
ashell_filt4 tone ashell_del4 * kshell_feedback, kshell_lpfreq
ashell_filt5 tone ashell_del5 * kshell_feedback, kshell_lpfreq
ashell_filt6 tone ashell_del6 * kshell_feedback, kshell_lpfreq
ashell_filt7 tone ashell_del7 * kshell_feedback, kshell_lpfreq
ashell_filt8 tone ashell_del8 * kshell_feedback, kshell_lpfreq

; Shell space output
ashell = 0.35 * (ashell_filt1 + ashell_filt3 + ashell_filt5 + ashell_filt7)

; SPACE 3: ROOM ACOUSTICS (8-comb reverb system)
; Initialize room reverb filter variables
aroom_filt1 init 0
aroom_filt2 init 0  
aroom_filt3 init 0
aroom_filt4 init 0
aroom_filt5 init 0
aroom_filt6 init 0
aroom_filt7 init 0
aroom_filt8 init 0

; Room-specific delay times (based on room dimensions)
iroom_factor = 1 + iroom_size * 4
iroom_del1 = 0.019 * iroom_factor             ; Room length mode
iroom_del2 = 0.025 * iroom_factor             ; Room width mode
iroom_del3 = 0.013 * iroom_factor             ; Room height mode
iroom_del4 = 0.031 * iroom_factor             ; Room diagonal mode
iroom_del5 = 0.022 * iroom_factor             ; Room coupling mode 1
iroom_del6 = 0.028 * iroom_factor             ; Room coupling mode 2
iroom_del7 = 0.016 * iroom_factor             ; Room coupling mode 3
iroom_del8 = 0.034 * iroom_factor             ; Room coupling mode 4

; Room reverb parameters (iroom_size controls decay time in seconds)
iroom_decay_time = 0.5 + iroom_size * 4.5     ; 0.5 to 5.0 seconds decay
kroom_feedback = exp(-2.2 / (iroom_decay_time * sr / ksmps))  ; RT60 calculation
kroom_lpfreq = 1500 + iroom_size * 2000

; Room space random modulation
kroom1 randi 0.0003, 0.8, 0.1
kroom1 = kroom1 + kmod_triangle * 0.0002
kroom2 randi 0.0004, 1.2, 0.3
kroom2 = kroom2 + kmod_triangle * 0.0003
kroom3 randi 0.0005, 0.9, 0.5
kroom3 = kroom3 + kmod_triangle * 0.0004
kroom4 randi 0.0002, 1.5, 0.7
kroom4 = kroom4 + kmod_triangle * 0.0001
kroom5 randi 0.0006, 0.7, 0.2
kroom5 = kroom5 + kmod_triangle * 0.0005
kroom6 randi 0.0003, 1.1, 0.6
kroom6 = kroom6 + kmod_triangle * 0.0002
kroom7 randi 0.0004, 1.3, 0.4
kroom7 = kroom7 + kmod_triangle * 0.0003
kroom8 randi 0.0005, 0.6, 0.8
kroom8 = kroom8 + kmod_triangle * 0.0004

; Room input (combined membrane and shell output)
aroom_input = (amembrane + ashell) * 0.25

; Room scattering junction
aroom_pj = 0.25 * (aroom_filt1 + aroom_filt2 + aroom_filt3 + aroom_filt4 + aroom_filt5 + aroom_filt6 + aroom_filt7 + aroom_filt8)

; Room reverb delay lines
adum17 delayr 1
aroom_del1 deltap3 iroom_del1 + kroom1  
delayw aroom_input + aroom_pj - aroom_filt1

adum18 delayr 1
aroom_del2 deltap3 iroom_del2 + kroom2
delayw aroom_input + aroom_pj - aroom_filt2

adum19 delayr 1  
aroom_del3 deltap3 iroom_del3 + kroom3
delayw aroom_input + aroom_pj - aroom_filt3

adum20 delayr 1
aroom_del4 deltap3 iroom_del4 + kroom4
delayw aroom_input + aroom_pj - aroom_filt4

adum21 delayr 1
aroom_del5 deltap3 iroom_del5 + kroom5  
delayw aroom_input + aroom_pj - aroom_filt5

adum22 delayr 1
aroom_del6 deltap3 iroom_del6 + kroom6
delayw aroom_input + aroom_pj - aroom_filt6

adum23 delayr 1
aroom_del7 deltap3 iroom_del7 + kroom7
delayw aroom_input + aroom_pj - aroom_filt7

adum24 delayr 1
aroom_del8 deltap3 iroom_del8 + kroom8
delayw aroom_input + aroom_pj - aroom_filt8

; Room lowpass filters
aroom_filt1 tone aroom_del1 * kroom_feedback, kroom_lpfreq
aroom_filt2 tone aroom_del2 * kroom_feedback, kroom_lpfreq  
aroom_filt3 tone aroom_del3 * kroom_feedback, kroom_lpfreq
aroom_filt4 tone aroom_del4 * kroom_feedback, kroom_lpfreq
aroom_filt5 tone aroom_del5 * kroom_feedback, kroom_lpfreq
aroom_filt6 tone aroom_del6 * kroom_feedback, kroom_lpfreq
aroom_filt7 tone aroom_del7 * kroom_feedback, kroom_lpfreq
aroom_filt8 tone aroom_del8 * kroom_feedback, kroom_lpfreq

; Room space output
aroom = 0.25 * (aroom_filt1 + aroom_filt3 + aroom_filt5 + aroom_filt7)

; FRONT-OF-KICK MIXING - All sounds positioned as heard from kick drum front
; Membrane: Direct sound from front of drum
; Shell: Sound emanating from shell + port hole
; Room: Ambient space around entire drum

kdry_level = 0.7 - iroom_size * 0.3
kwet_level = 0.2 + iroom_size * 0.4

afinal = (amembrane * 1.0 + ashell * 0.8) * kdry_level + aroom * kwet_level

; FINAL FREQUENCY SHAPING
afinal butterhp afinal, 25

; Gentle boost in fundamental range
alow_boost = afinal + butterlp(afinal, 80) * 0.2

; FINAL OUTPUT with hit envelope
aout = alow_boost * khit_env * idyn

	$dur_var(10)
	$end_instr


	

