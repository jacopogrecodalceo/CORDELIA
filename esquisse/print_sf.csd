<CsoundSynthesizer>
<CsOptions>
;--port=10000
;--format=float
-3
-m0
-D
;-+msg_color=1
--messagelevel=96
--m-amps=1
--env:SSDIR+=../
-odac
</CsOptions>
<CsInstruments>

;sr		=	192000
sr		=	48000

ksmps		=	1	;leave it at 64 for real-time
;nchnls_i	=	12
nchnls		=	2
0dbfs		=	1
;A4		=	438	;only for ancient music	

#include "../soundfont"
gibass   sfload "/Users/j/Documents/PROJECTs/CORDELIA/soundfont/bass.sf2"
	sfpassign 0, gibass 

gichoir   sfload "/Users/j/Documents/PROJECTs/CORDELIA/soundfont/choir.sf2"
	sfpassign 17, gichoir 

giharps   sfload "/Users/j/Documents/PROJECTs/CORDELIA/soundfont/harps.sf2"
	sfpassign 25, giharps 

giphantom   sfload "/Users/j/Documents/PROJECTs/CORDELIA/soundfont/phantom.sf2"
	sfpassign 50, giphantom 

girhodes   sfload "/Users/j/Documents/PROJECTs/CORDELIA/soundfont/rhodes.sf2"
	sfpassign 109, girhodes 

gispirit   sfload "/Users/j/Documents/PROJECTs/CORDELIA/soundfont/spirit.sf2"
	sfpassign 129, gispirit 

gisteinway   sfload "/Users/j/Documents/PROJECTs/CORDELIA/soundfont/steinway.sf2"
	sfpassign 327, gisteinway 

gitimp   sfload "/Users/j/Documents/PROJECTs/CORDELIA/soundfont/timp.sf2"
	sfpassign 328, gitimp 

	instr 1

Sinstr init p4

if strcmp(Sinstr, "fingered_bass") == 0 then
    ipre = 0

elseif strcmp(Sinstr, "picked_bass") == 0 then
    ipre = 1

elseif strcmp(Sinstr, "acoustic_bass") == 0 then
    ipre = 2

elseif strcmp(Sinstr, "-8_fingered_bass") == 0 then
    ipre = 3

elseif strcmp(Sinstr, "-8_picked_bass") == 0 then
    ipre = 4

elseif strcmp(Sinstr, "-8_acoustic_bass") == 0 then
    ipre = 5

elseif strcmp(Sinstr, "pns_acoustic_drums") == 0 then
    ipre = 6

elseif strcmp(Sinstr, "timpani_1") == 0 then
    ipre = 7

elseif strcmp(Sinstr, "timpani_2") == 0 then
    ipre = 8

elseif strcmp(Sinstr, "timpani_3") == 0 then
    ipre = 9

elseif strcmp(Sinstr, "acoustic_bass") == 0 then
    ipre = 10

elseif strcmp(Sinstr, "fingered_bass") == 0 then
    ipre = 11

elseif strcmp(Sinstr, "picked_bass") == 0 then
    ipre = 12

elseif strcmp(Sinstr, "timpani_1-1") == 0 then
    ipre = 13

elseif strcmp(Sinstr, "timpani_2-1") == 0 then
    ipre = 14

elseif strcmp(Sinstr, "timpani_3-1") == 0 then
    ipre = 15

elseif strcmp(Sinstr, "pns_acoustic_drums-1") == 0 then
    ipre = 16

elseif strcmp(Sinstr, "vocal_oooh") == 0 then
    ipre = 17

elseif strcmp(Sinstr, "vocal_aaah") == 0 then
    ipre = 18

elseif strcmp(Sinstr, "mix_-_choir") == 0 then
    ipre = 19

elseif strcmp(Sinstr, "oooh_to_aaah_vel") == 0 then
    ipre = 20

elseif strcmp(Sinstr, "irina_brochin") == 0 then
    ipre = 21

elseif strcmp(Sinstr, "irina_plus_ooohs") == 0 then
    ipre = 22

elseif strcmp(Sinstr, "irina_plus_aaahs") == 0 then
    ipre = 23

elseif strcmp(Sinstr, "irina_ooh-aah_vel") == 0 then
    ipre = 24

elseif strcmp(Sinstr, "harpssplt_8'_-pnrma") == 0 then
    ipre = 25

elseif strcmp(Sinstr, "harpsuppr_8'_-pnrma") == 0 then
    ipre = 26

elseif strcmp(Sinstr, "harpsmain_8'_-pnrma") == 0 then
    ipre = 27

elseif strcmp(Sinstr, "harpslute_8'_-pnrma") == 0 then
    ipre = 28

elseif strcmp(Sinstr, "<-_una_corda_main->") == 0 then
    ipre = 29

elseif strcmp(Sinstr, "harpssplit_8'_-mono") == 0 then
    ipre = 30

elseif strcmp(Sinstr, "harps.uppr_8'_-m") == 0 then
    ipre = 31

elseif strcmp(Sinstr, "harps.main_8'_-m") == 0 then
    ipre = 32

elseif strcmp(Sinstr, "harps.lute_8'_[z]_-m^f") == 0 then
    ipre = 33

elseif strcmp(Sinstr, "<---uc_4'_-_16'--->") == 0 then
    ipre = 34

elseif strcmp(Sinstr, "harps.uppr_4'_-m") == 0 then
    ipre = 35

elseif strcmp(Sinstr, "harps.main_4'_-m") == 0 then
    ipre = 36

elseif strcmp(Sinstr, "harps.uppr16'_-m") == 0 then
    ipre = 37

elseif strcmp(Sinstr, "harps.main16'_-m") == 0 then
    ipre = 38

elseif strcmp(Sinstr, "<-----coupled----->") == 0 then
    ipre = 39

elseif strcmp(Sinstr, "hrps_upr_8'4'_-m") == 0 then
    ipre = 40

elseif strcmp(Sinstr, "hrps_mn__8'4'_-m") == 0 then
    ipre = 41

elseif strcmp(Sinstr, "hrps_upr16'4'_-m") == 0 then
    ipre = 42

elseif strcmp(Sinstr, "hrps_mn_16'4'_-m") == 0 then
    ipre = 43

elseif strcmp(Sinstr, "hrps_upr16'8'_-m") == 0 then
    ipre = 44

elseif strcmp(Sinstr, "hrps_mn_16'8'_-m") == 0 then
    ipre = 45

elseif strcmp(Sinstr, "<-------full------->^f") == 0 then
    ipre = 46

elseif strcmp(Sinstr, "hrps_upr16'8'4'_-m") == 0 then
    ipre = 47

elseif strcmp(Sinstr, "hrps_mn16'8'4'_-m") == 0 then
    ipre = 48

elseif strcmp(Sinstr, "^-------eosf------^") == 0 then
    ipre = 49

elseif strcmp(Sinstr, "piano") == 0 then
    ipre = 50

elseif strcmp(Sinstr, "harpsichord") == 0 then
    ipre = 51

elseif strcmp(Sinstr, "log_drum") == 0 then
    ipre = 52

elseif strcmp(Sinstr, "glockenspiel") == 0 then
    ipre = 53

elseif strcmp(Sinstr, "gamelan") == 0 then
    ipre = 54

elseif strcmp(Sinstr, "marimba") == 0 then
    ipre = 55

elseif strcmp(Sinstr, "tubular_bells") == 0 then
    ipre = 56

elseif strcmp(Sinstr, "nylon_string_guitar") == 0 then
    ipre = 57

elseif strcmp(Sinstr, "jazz_guitar") == 0 then
    ipre = 58

elseif strcmp(Sinstr, "contrabass") == 0 then
    ipre = 59

elseif strcmp(Sinstr, "tremolo_strings") == 0 then
    ipre = 60

elseif strcmp(Sinstr, "pizzicato_strings") == 0 then
    ipre = 61

elseif strcmp(Sinstr, "orchestral_harp") == 0 then
    ipre = 62

elseif strcmp(Sinstr, "timpani") == 0 then
    ipre = 63

elseif strcmp(Sinstr, "strings_ensemble_1") == 0 then
    ipre = 64

elseif strcmp(Sinstr, "strings_ensemble_2") == 0 then
    ipre = 65

elseif strcmp(Sinstr, "choir_aahs") == 0 then
    ipre = 66

elseif strcmp(Sinstr, "choir_ooh") == 0 then
    ipre = 67

elseif strcmp(Sinstr, "creepy_voice") == 0 then
    ipre = 68

elseif strcmp(Sinstr, "trumpet") == 0 then
    ipre = 69

elseif strcmp(Sinstr, "trombone") == 0 then
    ipre = 70

elseif strcmp(Sinstr, "tuba") == 0 then
    ipre = 71

elseif strcmp(Sinstr, "french_horns") == 0 then
    ipre = 72

elseif strcmp(Sinstr, "brass_section") == 0 then
    ipre = 73

elseif strcmp(Sinstr, "saxophone") == 0 then
    ipre = 74

elseif strcmp(Sinstr, "oboe") == 0 then
    ipre = 75

elseif strcmp(Sinstr, "english_horn") == 0 then
    ipre = 76

elseif strcmp(Sinstr, "bassoon") == 0 then
    ipre = 77

elseif strcmp(Sinstr, "clarinet") == 0 then
    ipre = 78

elseif strcmp(Sinstr, "piccolo") == 0 then
    ipre = 79

elseif strcmp(Sinstr, "flute") == 0 then
    ipre = 80

elseif strcmp(Sinstr, "recorder") == 0 then
    ipre = 81

elseif strcmp(Sinstr, "pan_flute") == 0 then
    ipre = 82

elseif strcmp(Sinstr, "ocarina") == 0 then
    ipre = 83

elseif strcmp(Sinstr, "square_wave") == 0 then
    ipre = 84

elseif strcmp(Sinstr, "bowed_pad") == 0 then
    ipre = 85

elseif strcmp(Sinstr, "sitar") == 0 then
    ipre = 86

elseif strcmp(Sinstr, "banjo") == 0 then
    ipre = 87

elseif strcmp(Sinstr, "kalimba") == 0 then
    ipre = 88

elseif strcmp(Sinstr, "breath_noise") == 0 then
    ipre = 89

elseif strcmp(Sinstr, "piano_2") == 0 then
    ipre = 90

elseif strcmp(Sinstr, "marimba_2") == 0 then
    ipre = 91

elseif strcmp(Sinstr, "timpani_2") == 0 then
    ipre = 92

elseif strcmp(Sinstr, "choir_aahs_2") == 0 then
    ipre = 93

elseif strcmp(Sinstr, "creepy_voice_2") == 0 then
    ipre = 94

elseif strcmp(Sinstr, "trumpet_2") == 0 then
    ipre = 95

elseif strcmp(Sinstr, "tuba_2") == 0 then
    ipre = 96

elseif strcmp(Sinstr, "brass_section_2") == 0 then
    ipre = 97

elseif strcmp(Sinstr, "clarinet_2") == 0 then
    ipre = 98

elseif strcmp(Sinstr, "flute_2") == 0 then
    ipre = 99

elseif strcmp(Sinstr, "marimba_3") == 0 then
    ipre = 100

elseif strcmp(Sinstr, "timpani_3") == 0 then
    ipre = 101

elseif strcmp(Sinstr, "tuba_3") == 0 then
    ipre = 102

elseif strcmp(Sinstr, "brass_section_3") == 0 then
    ipre = 103

elseif strcmp(Sinstr, "clarinet_3") == 0 then
    ipre = 104

elseif strcmp(Sinstr, "timpani_4") == 0 then
    ipre = 105

elseif strcmp(Sinstr, "tuba_4") == 0 then
    ipre = 106

elseif strcmp(Sinstr, "drums") == 0 then
    ipre = 107

elseif strcmp(Sinstr, "orchestra_drums") == 0 then
    ipre = 108

elseif strcmp(Sinstr, "rhodes_ep") == 0 then
    ipre = 109

elseif strcmp(Sinstr, "rhodes_bright") == 0 then
    ipre = 110

elseif strcmp(Sinstr, "slow,_light,tremolo") == 0 then
    ipre = 111

elseif strcmp(Sinstr, "slt_bright") == 0 then
    ipre = 112

elseif strcmp(Sinstr, "slow,_heavy,tremolo") == 0 then
    ipre = 113

elseif strcmp(Sinstr, "fast,_light,tremolo") == 0 then
    ipre = 114

elseif strcmp(Sinstr, "flt_bright") == 0 then
    ipre = 115

elseif strcmp(Sinstr, "fast,_heavy,tremolo") == 0 then
    ipre = 116

elseif strcmp(Sinstr, "dx7_ep") == 0 then
    ipre = 117

elseif strcmp(Sinstr, "rhodes_bell_ep") == 0 then
    ipre = 118

elseif strcmp(Sinstr, "rhodes_bell_bright") == 0 then
    ipre = 119

elseif strcmp(Sinstr, "rhodes_bell_slow_trm^k") == 0 then
    ipre = 120

elseif strcmp(Sinstr, "rhodes_bell_fast_trm^l") == 0 then
    ipre = 121

elseif strcmp(Sinstr, "fm_electric_piano") == 0 then
    ipre = 122

elseif strcmp(Sinstr, "clavinet") == 0 then
    ipre = 123

elseif strcmp(Sinstr, "clavinet_velocity") == 0 then
    ipre = 124

elseif strcmp(Sinstr, "wurlitzer_4_layer") == 0 then
    ipre = 125

elseif strcmp(Sinstr, "wurlitzer_2_layer") == 0 then
    ipre = 126

elseif strcmp(Sinstr, "electric_grand") == 0 then
    ipre = 127

elseif strcmp(Sinstr, "harpsichord") == 0 then
    ipre = 128

elseif strcmp(Sinstr, "piano") == 0 then
    ipre = 129

elseif strcmp(Sinstr, "honky_piano") == 0 then
    ipre = 130

elseif strcmp(Sinstr, "electric_piano") == 0 then
    ipre = 131

elseif strcmp(Sinstr, "electric_piano_2") == 0 then
    ipre = 132

elseif strcmp(Sinstr, "harpsichord") == 0 then
    ipre = 133

elseif strcmp(Sinstr, "celesta") == 0 then
    ipre = 134

elseif strcmp(Sinstr, "glockenspiel") == 0 then
    ipre = 135

elseif strcmp(Sinstr, "music_box") == 0 then
    ipre = 136

elseif strcmp(Sinstr, "vibraphone") == 0 then
    ipre = 137

elseif strcmp(Sinstr, "marimba") == 0 then
    ipre = 138

elseif strcmp(Sinstr, "xylophone") == 0 then
    ipre = 139

elseif strcmp(Sinstr, "tubular_bells") == 0 then
    ipre = 140

elseif strcmp(Sinstr, "dulcimer") == 0 then
    ipre = 141

elseif strcmp(Sinstr, "drawbar_organ") == 0 then
    ipre = 142

elseif strcmp(Sinstr, "church_organ") == 0 then
    ipre = 143

elseif strcmp(Sinstr, "reed_organ") == 0 then
    ipre = 144

elseif strcmp(Sinstr, "accordion") == 0 then
    ipre = 145

elseif strcmp(Sinstr, "harmonica") == 0 then
    ipre = 146

elseif strcmp(Sinstr, "tango_accordion") == 0 then
    ipre = 147

elseif strcmp(Sinstr, "nylon_string_guitar") == 0 then
    ipre = 148

elseif strcmp(Sinstr, "steel_string_guitar") == 0 then
    ipre = 149

elseif strcmp(Sinstr, "jazz_guitar") == 0 then
    ipre = 150

elseif strcmp(Sinstr, "clean_guitar") == 0 then
    ipre = 151

elseif strcmp(Sinstr, "acoustic_bass") == 0 then
    ipre = 152

elseif strcmp(Sinstr, "violin") == 0 then
    ipre = 153

elseif strcmp(Sinstr, "viola") == 0 then
    ipre = 154

elseif strcmp(Sinstr, "cello") == 0 then
    ipre = 155

elseif strcmp(Sinstr, "contrabass") == 0 then
    ipre = 156

elseif strcmp(Sinstr, "tremolo_strings") == 0 then
    ipre = 157

elseif strcmp(Sinstr, "pizzicato_strings") == 0 then
    ipre = 158

elseif strcmp(Sinstr, "orchestral_harp") == 0 then
    ipre = 159

elseif strcmp(Sinstr, "timpani") == 0 then
    ipre = 160

elseif strcmp(Sinstr, "strings_ensemble_1") == 0 then
    ipre = 161

elseif strcmp(Sinstr, "strings_ensemble_2") == 0 then
    ipre = 162

elseif strcmp(Sinstr, "synth_strings") == 0 then
    ipre = 163

elseif strcmp(Sinstr, "synth_strings_2") == 0 then
    ipre = 164

elseif strcmp(Sinstr, "choir_aahs") == 0 then
    ipre = 165

elseif strcmp(Sinstr, "voice_oohs") == 0 then
    ipre = 166

elseif strcmp(Sinstr, "synth_voice") == 0 then
    ipre = 167

elseif strcmp(Sinstr, "trumpet") == 0 then
    ipre = 168

elseif strcmp(Sinstr, "trombone") == 0 then
    ipre = 169

elseif strcmp(Sinstr, "tuba") == 0 then
    ipre = 170

elseif strcmp(Sinstr, "french_horns") == 0 then
    ipre = 171

elseif strcmp(Sinstr, "brass_section") == 0 then
    ipre = 172

elseif strcmp(Sinstr, "soprano_sax") == 0 then
    ipre = 173

elseif strcmp(Sinstr, "saxophone") == 0 then
    ipre = 174

elseif strcmp(Sinstr, "baritone_sax") == 0 then
    ipre = 175

elseif strcmp(Sinstr, "oboe") == 0 then
    ipre = 176

elseif strcmp(Sinstr, "english_horn") == 0 then
    ipre = 177

elseif strcmp(Sinstr, "clarinet") == 0 then
    ipre = 178

elseif strcmp(Sinstr, "piccolo") == 0 then
    ipre = 179

elseif strcmp(Sinstr, "flute") == 0 then
    ipre = 180

elseif strcmp(Sinstr, "recorder") == 0 then
    ipre = 181

elseif strcmp(Sinstr, "pan_flute") == 0 then
    ipre = 182

elseif strcmp(Sinstr, "blown_bottle") == 0 then
    ipre = 183

elseif strcmp(Sinstr, "shakuhachi") == 0 then
    ipre = 184

elseif strcmp(Sinstr, "whistle") == 0 then
    ipre = 185

elseif strcmp(Sinstr, "ocarina") == 0 then
    ipre = 186

elseif strcmp(Sinstr, "square_wave") == 0 then
    ipre = 187

elseif strcmp(Sinstr, "space_voice") == 0 then
    ipre = 188

elseif strcmp(Sinstr, "creepy_pad") == 0 then
    ipre = 189

elseif strcmp(Sinstr, "bass_lead") == 0 then
    ipre = 190

elseif strcmp(Sinstr, "fantasia") == 0 then
    ipre = 191

elseif strcmp(Sinstr, "warm_pad") == 0 then
    ipre = 192

elseif strcmp(Sinstr, "polysynth") == 0 then
    ipre = 193

elseif strcmp(Sinstr, "bowed_pad") == 0 then
    ipre = 194

elseif strcmp(Sinstr, "metallic_pad") == 0 then
    ipre = 195

elseif strcmp(Sinstr, "sweep_pad") == 0 then
    ipre = 196

elseif strcmp(Sinstr, "ice_rain") == 0 then
    ipre = 197

elseif strcmp(Sinstr, "soundtrack_pad") == 0 then
    ipre = 198

elseif strcmp(Sinstr, "crystal") == 0 then
    ipre = 199

elseif strcmp(Sinstr, "goblin_pad") == 0 then
    ipre = 200

elseif strcmp(Sinstr, "sitar") == 0 then
    ipre = 201

elseif strcmp(Sinstr, "banjo") == 0 then
    ipre = 202

elseif strcmp(Sinstr, "shamisen") == 0 then
    ipre = 203

elseif strcmp(Sinstr, "koto") == 0 then
    ipre = 204

elseif strcmp(Sinstr, "kalimba") == 0 then
    ipre = 205

elseif strcmp(Sinstr, "bagpipe") == 0 then
    ipre = 206

elseif strcmp(Sinstr, "fiddle") == 0 then
    ipre = 207

elseif strcmp(Sinstr, "tinkle_bell") == 0 then
    ipre = 208

elseif strcmp(Sinstr, "agogo") == 0 then
    ipre = 209

elseif strcmp(Sinstr, "steel_drums") == 0 then
    ipre = 210

elseif strcmp(Sinstr, "gong") == 0 then
    ipre = 211

elseif strcmp(Sinstr, "guitar_choir") == 0 then
    ipre = 212

elseif strcmp(Sinstr, "breath_noise") == 0 then
    ipre = 213

elseif strcmp(Sinstr, "winds") == 0 then
    ipre = 214

elseif strcmp(Sinstr, "synth_sfx") == 0 then
    ipre = 215

elseif strcmp(Sinstr, "harpsichord_2") == 0 then
    ipre = 216

elseif strcmp(Sinstr, "celesta_2") == 0 then
    ipre = 217

elseif strcmp(Sinstr, "glockenspiel_2") == 0 then
    ipre = 218

elseif strcmp(Sinstr, "music_box_2") == 0 then
    ipre = 219

elseif strcmp(Sinstr, "vibraphone_2") == 0 then
    ipre = 220

elseif strcmp(Sinstr, "marimba_2") == 0 then
    ipre = 221

elseif strcmp(Sinstr, "xylophone_2") == 0 then
    ipre = 222

elseif strcmp(Sinstr, "tubular_bells_2") == 0 then
    ipre = 223

elseif strcmp(Sinstr, "dulcimer_2") == 0 then
    ipre = 224

elseif strcmp(Sinstr, "drawbar_organ_2") == 0 then
    ipre = 225

elseif strcmp(Sinstr, "reed_organ_2") == 0 then
    ipre = 226

elseif strcmp(Sinstr, "accordion_2") == 0 then
    ipre = 227

elseif strcmp(Sinstr, "acoustic_guitar") == 0 then
    ipre = 228

elseif strcmp(Sinstr, "acoustic_bass_2") == 0 then
    ipre = 229

elseif strcmp(Sinstr, "slow_violin") == 0 then
    ipre = 230

elseif strcmp(Sinstr, "viola_2") == 0 then
    ipre = 231

elseif strcmp(Sinstr, "cello_2") == 0 then
    ipre = 232

elseif strcmp(Sinstr, "tremolo_strings_2") == 0 then
    ipre = 233

elseif strcmp(Sinstr, "pizzicato_strings_2") == 0 then
    ipre = 234

elseif strcmp(Sinstr, "orchestral_harp_2") == 0 then
    ipre = 235

elseif strcmp(Sinstr, "timpani_2") == 0 then
    ipre = 236

elseif strcmp(Sinstr, "strings_ensemble_3") == 0 then
    ipre = 237

elseif strcmp(Sinstr, "synth_strings_3") == 0 then
    ipre = 238

elseif strcmp(Sinstr, "choir_hit") == 0 then
    ipre = 239

elseif strcmp(Sinstr, "african_voice") == 0 then
    ipre = 240

elseif strcmp(Sinstr, "wah_trumpet") == 0 then
    ipre = 241

elseif strcmp(Sinstr, "tuba_2") == 0 then
    ipre = 242

elseif strcmp(Sinstr, "french_horns_2") == 0 then
    ipre = 243

elseif strcmp(Sinstr, "brass_section_2") == 0 then
    ipre = 244

elseif strcmp(Sinstr, "clarinet_2") == 0 then
    ipre = 245

elseif strcmp(Sinstr, "recorder_2") == 0 then
    ipre = 246

elseif strcmp(Sinstr, "pan_flute_2") == 0 then
    ipre = 247

elseif strcmp(Sinstr, "whistle_2") == 0 then
    ipre = 248

elseif strcmp(Sinstr, "space_voice_2") == 0 then
    ipre = 249

elseif strcmp(Sinstr, "creepy_pad_2") == 0 then
    ipre = 250

elseif strcmp(Sinstr, "bowed_pad_2") == 0 then
    ipre = 251

elseif strcmp(Sinstr, "crystal_2") == 0 then
    ipre = 252

elseif strcmp(Sinstr, "sitar_2") == 0 then
    ipre = 253

elseif strcmp(Sinstr, "kalimba_2") == 0 then
    ipre = 254

elseif strcmp(Sinstr, "fiddle_2") == 0 then
    ipre = 255

elseif strcmp(Sinstr, "tinkle_bell_2") == 0 then
    ipre = 256

elseif strcmp(Sinstr, "celesta_3") == 0 then
    ipre = 257

elseif strcmp(Sinstr, "glockenspiel_3") == 0 then
    ipre = 258

elseif strcmp(Sinstr, "marimba_3") == 0 then
    ipre = 259

elseif strcmp(Sinstr, "tubular_bells_3") == 0 then
    ipre = 260

elseif strcmp(Sinstr, "dulcimer_3") == 0 then
    ipre = 261

elseif strcmp(Sinstr, "mandolin") == 0 then
    ipre = 262

elseif strcmp(Sinstr, "slow_violin_2") == 0 then
    ipre = 263

elseif strcmp(Sinstr, "pizzicato_strings_3") == 0 then
    ipre = 264

elseif strcmp(Sinstr, "orchestral_harp_3") == 0 then
    ipre = 265

elseif strcmp(Sinstr, "timpani_3") == 0 then
    ipre = 266

elseif strcmp(Sinstr, "synth_strings_4") == 0 then
    ipre = 267

elseif strcmp(Sinstr, "choir_aahs_2") == 0 then
    ipre = 268

elseif strcmp(Sinstr, "malon_voice") == 0 then
    ipre = 269

elseif strcmp(Sinstr, "trumpet_2") == 0 then
    ipre = 270

elseif strcmp(Sinstr, "tuba_hit") == 0 then
    ipre = 271

elseif strcmp(Sinstr, "french_horns_3") == 0 then
    ipre = 272

elseif strcmp(Sinstr, "clarinet_3") == 0 then
    ipre = 273

elseif strcmp(Sinstr, "whistle_3") == 0 then
    ipre = 274

elseif strcmp(Sinstr, "creepy_pad_3") == 0 then
    ipre = 275

elseif strcmp(Sinstr, "sitar_3") == 0 then
    ipre = 276

elseif strcmp(Sinstr, "fiddle_3") == 0 then
    ipre = 277

elseif strcmp(Sinstr, "celesta_4") == 0 then
    ipre = 278

elseif strcmp(Sinstr, "dulcimer_4") == 0 then
    ipre = 279

elseif strcmp(Sinstr, "acoustic_guitar_2") == 0 then
    ipre = 280

elseif strcmp(Sinstr, "slow_violin_3") == 0 then
    ipre = 281

elseif strcmp(Sinstr, "pizzicato_strings_4") == 0 then
    ipre = 282

elseif strcmp(Sinstr, "orchestral_harp_4") == 0 then
    ipre = 283

elseif strcmp(Sinstr, "timpani_4") == 0 then
    ipre = 284

elseif strcmp(Sinstr, "synth_strings_5") == 0 then
    ipre = 285

elseif strcmp(Sinstr, "choir_aahs_3") == 0 then
    ipre = 286

elseif strcmp(Sinstr, "malon_voice_2") == 0 then
    ipre = 287

elseif strcmp(Sinstr, "tuba_hit_2") == 0 then
    ipre = 288

elseif strcmp(Sinstr, "french_horns_4") == 0 then
    ipre = 289

elseif strcmp(Sinstr, "clarinet_hit") == 0 then
    ipre = 290

elseif strcmp(Sinstr, "creepy_pad_4") == 0 then
    ipre = 291

elseif strcmp(Sinstr, "sitar_4") == 0 then
    ipre = 292

elseif strcmp(Sinstr, "fiddle_4") == 0 then
    ipre = 293

elseif strcmp(Sinstr, "creepy_celesta") == 0 then
    ipre = 294

elseif strcmp(Sinstr, "dulcimer_5") == 0 then
    ipre = 295

elseif strcmp(Sinstr, "acoustic_guitar_2") == 0 then
    ipre = 296

elseif strcmp(Sinstr, "violin_2") == 0 then
    ipre = 297

elseif strcmp(Sinstr, "pizzicato_strings_5") == 0 then
    ipre = 298

elseif strcmp(Sinstr, "orchestral_harp_5") == 0 then
    ipre = 299

elseif strcmp(Sinstr, "synth_strings_6") == 0 then
    ipre = 300

elseif strcmp(Sinstr, "choir_aahs_4") == 0 then
    ipre = 301

elseif strcmp(Sinstr, "ethnic_voice") == 0 then
    ipre = 302

elseif strcmp(Sinstr, "tuba_3") == 0 then
    ipre = 303

elseif strcmp(Sinstr, "french_horns_5") == 0 then
    ipre = 304

elseif strcmp(Sinstr, "dulcimer_6") == 0 then
    ipre = 305

elseif strcmp(Sinstr, "acoustic_guitar_3") == 0 then
    ipre = 306

elseif strcmp(Sinstr, "violin_3") == 0 then
    ipre = 307

elseif strcmp(Sinstr, "pizzicato_strings_6") == 0 then
    ipre = 308

elseif strcmp(Sinstr, "synth_strings_7") == 0 then
    ipre = 309

elseif strcmp(Sinstr, "choir_aahs_5") == 0 then
    ipre = 310

elseif strcmp(Sinstr, "french_horns_hit") == 0 then
    ipre = 311

elseif strcmp(Sinstr, "dulcimer_7") == 0 then
    ipre = 312

elseif strcmp(Sinstr, "steel_guitar_2") == 0 then
    ipre = 313

elseif strcmp(Sinstr, "strings_staccato") == 0 then
    ipre = 314

elseif strcmp(Sinstr, "synth_strings_8") == 0 then
    ipre = 315

elseif strcmp(Sinstr, "choir_aahs_6") == 0 then
    ipre = 316

elseif strcmp(Sinstr, "strings_staccato_2") == 0 then
    ipre = 317

elseif strcmp(Sinstr, "choir_aahs_7") == 0 then
    ipre = 318

elseif strcmp(Sinstr, "pizzicato_strings_7") == 0 then
    ipre = 319

elseif strcmp(Sinstr, "choir_aahs_8") == 0 then
    ipre = 320

elseif strcmp(Sinstr, "choir_aahs_9") == 0 then
    ipre = 321

elseif strcmp(Sinstr, "drums") == 0 then
    ipre = 322

elseif strcmp(Sinstr, "drums_2") == 0 then
    ipre = 323

elseif strcmp(Sinstr, "orchestra_drums") == 0 then
    ipre = 324

elseif strcmp(Sinstr, "ethnic_drums") == 0 then
    ipre = 325

elseif strcmp(Sinstr, "ethnic_drums_2") == 0 then
    ipre = 326

elseif strcmp(Sinstr, "steinway-d") == 0 then
    ipre = 327

elseif strcmp(Sinstr, "timpani_1") == 0 then
    ipre = 328

elseif strcmp(Sinstr, "timpani_2") == 0 then
    ipre = 329

elseif strcmp(Sinstr, "timpani_3") == 0 then
    ipre = 330
endif

print ipre 

                    ;ivel,  inotenum,       xamp,       xfreq,      ipreindex       [, iflag] [, ioffset] [, ienv]
aout	sfplay3m    1,      ftom:i(A4),     .05/4096,   A4/2,       ipre,              1	   ;preset index = 0, set flag to frequency instead of midi pitch
aout    *=          linseg(0, .05, 1, p3-.05, 0)
        outall aout

	endin



</CsInstruments>
<CsScore>
i 1 0 9 "steinway-d"
</CsScore>
</CsoundSynthesizer>