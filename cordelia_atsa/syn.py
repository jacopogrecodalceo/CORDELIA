import ctcsound
import sox
import os

cs = ctcsound.Csound()

file = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/ciel.wav'
basename = os.path.splitext(os.path.basename(file))[0]

ksmps = 2
channels = sox.file_info.channels(file)
sample_rate = sox.file_info.sample_rate(file)

#output_dir = os.path.dirname(file)
output_dir = '/Users/j/Desktop'

ats_files = []

def main():

	for f in os.listdir(output_dir):
		if f.endswith('.ats') and basename in f:
			ats_files.append(os.path.join(output_dir, f))

	code = f'''
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
	afreq       a  kfreq

	ain 		oscili iamp*kamp, afreq*ifreq

	gibeatf = p3/64
	
	k1 = 1 - jitter(2, gibeatf/8, gibeatf)
	k2 = 1 - jitter(2, gibeatf/8, gibeatf)
	k3 = 1 - jitter(2, gibeatf/8, gibeatf)
	k4 = 1 - jitter(2, gibeatf/8, gibeatf)
	k5 = 1 - jitter(2, gibeatf/8, gibeatf)
	k6 = 1 - jitter(2, gibeatf/8, gibeatf)
	k7 = 1 - jitter(2, gibeatf/8, gibeatf)

aout		chebyshevpoly  ain, 0, k1, k2, k3, k4, k5, k6, k7
aout		balance2 aout, ain
aout		dcblock2 aout
			outch ich, aout
	endin

	instr 2

aout[]		init nchnls

idur		filelen "{file}"
aout		diskin "{file}", idur/p3
aout		*= .5
	out aout

	endin
	
	'''

	cs.setOption('-odac')
	cs.setOption(f'--sample-rate=={sample_rate}')
	cs.setOption(f'--ksmps={ksmps}')
	cs.setOption(f'--0dbfs=1')
	cs.setOption(f'--nchnls={channels}')
	
	cs.compileOrc(code)
	print(code)

	dur = 75

	sco = []
	for ch, file_ats in enumerate(ats_files):
		freq = 1
		for _ in range(35):
			sco.append(f'i1 0 {dur} {freq} "{file_ats}" {ch+1}')
	sco.append(f'i2 0 {dur}')
	sco.append('e')
	score = '\n'.join(sco)
	print(score)
	cs.readScore(score)

	cs.start()
	while cs.performKsmps() == 0:
		pass
	cs.cleanup()

main()