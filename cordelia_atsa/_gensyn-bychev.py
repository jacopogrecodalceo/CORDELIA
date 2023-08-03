
import ctcsound
import sox
import os, sys
import subprocess
import time

cs = ctcsound.Csound()

file = sys.argv[1]

basename = os.path.splitext(os.path.basename(file))[0]

ksmps = 2
channels = sox.file_info.channels(file)
sample_rate = sox.file_info.sample_rate(file)

#output_tempdir = os.path.dirname(file)
output_tempdir = '/Users/j/Documents/PROJECTs/_temp'
 
ats_files = []
mono_files = []

channels = sox.file_info.channels(file)
for i in range(1, channels+1):
	tfm = sox.Transformer()
	output_file = os.path.join(output_tempdir, basename + f'-{i}ch.wav')
	print(f'Writing {i} channel of {basename} to {output_file}')
	tfm.remix(remix_dictionary={1: [i]}, num_output_channels=1)
	tfm.build(input_filepath=file, output_filepath=output_file)
	mono_files.append(output_file)

for f in mono_files:
	input_file = f
	output_file = os.path.join(output_tempdir, f'{os.path.splitext(os.path.basename(input_file))[0]}.ats')
	csound_command = ['atsa', input_file, output_file]
	process = subprocess.Popen(csound_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	stdout, stderr = process.communicate()
	if process.returncode != 0:
		print(f"An error occurred: {stderr.decode('utf-8')}")
	else:
		print(f'Csound processing {input_file} completed successfully.')

for f in os.listdir(output_tempdir):
	if f.endswith('.ats') and basename in f:
		ats_files.append(os.path.join(output_tempdir, f))

code = f'''
gioscildur init 8192

gisaw			ftgen	0, 0, gioscildur, 7, 1, gioscildur, -1				; sawtooth wave, downward slope

	instr 1

iamp		init 1
ifreq		init p4
iatsfile	init p5
ich			init p6

idur		ATSinfo iatsfile, 7
;p3			init idur
imax_par 	ATSinfo iatsfile, 3
ipar		int random:i(1, imax_par)

ktime 		line 0, p3, idur

kfreq, kamp ATSread ktime, iatsfile, ipar

aamp        a  kamp
afreq       a  kfreq*ifreq

i1div2pi		init 1/24

kpeakdev		= aamp * 2 * i1div2pi
kpeakdev2		= aamp * cosseg(3, idur, 5) * i1div2pi

;STEREO "CHORUS" ENRICHMENT USING JITTER
kjitR			jitter cosseg(5, idur, .75), 1.5, 3.5

;MODULATORS
aModulator		oscili	kpeakdev*linseg(0, idur, 1), afreq * 5
aModulator2		oscili	kpeakdev2*cosseg(0, idur, 1), afreq * 2, gisaw

avib1			= lfo(kfreq/32, kfreq/250)*abs(jitter(1, 1/p3, 100/p3))

aCarrierR		phasor	portk(kfreq + kjitR, idur/96, 20)+avib1
aCarrierR		table3	aCarrierR + aModulator + aModulator2, gisaw, 1, 0, 1
aSigR			= aCarrierR * aamp

aFilterR		bqrez	aSigR, afreq+(afreq*(16*aamp)), .75
aout			balance2 aFilterR, aSigR

		outch ich, aout

	endin
'''
dur = sys.argv[3]

if sys.argv[4]:
	notes = sys.argv[4]
else:
	notes = 15

output_file = sys.argv[2]
cs.setOption(f'-o{output_file}')
cs.setOption(f'--sample-rate=48000')
cs.setOption(f'-3')
cs.setOption(f'--ksmps={ksmps}')
cs.setOption(f'--0dbfs=1')
cs.setOption(f'--nchnls={channels}')

cs.compileOrc(code)
print(code)


sco = []
for ch, file_ats in enumerate(ats_files):
	freq = 1
	for _ in range(int(notes)):
		sco.append(f'i1 0 {dur} {freq} "{file_ats}" {ch+1}')

#sco.append(f'i2 0 {dur}')
sco.append('e')
score = '\n'.join(sco)
print(score)
cs.readScore(score)

cs.start()
cs.perform()
cs.cleanup()

time.sleep(1/8)

with open(output_file + '--finished', 'w') as f:
	f.write('I EXIST')

del cs
