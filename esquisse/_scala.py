import os, json
import ctcsound, subprocess

SAMPLE_RATE = 48000
KSMPS = 32
CHANNELs = 2

CSFLAGs = [
	'-odac',
	f'-r={SAMPLE_RATE}',
	f'--ksmps={KSMPS}',
	'--0dbfs=1',
	f'--nchnls={CHANNELs}'
]

# PATHs
CORDELIA_DIR = '/Users/j/Documents/PROJECTs/CORDELIA/'
SCALA_JSON_PATH = os.path.join(CORDELIA_DIR, '_cordelia/config/SCALA.json')
with open(SCALA_JSON_PATH, 'r') as f:
	SCALA_JSON = json.load(f)

def load_scala(scala_name):
	try:
		return SCALA_JSON[scala_name]
	except ValueError:
		print('Scala name is not valuable')

def main(scala_name):
	scala = load_scala(scala_name)
	csound_gen = f'gi{scala_name}'

	orc = f'''
{scala['default_ftgen']}
	instr 1
icps	cpstuni 69+p4, {csound_gen}
print icps
aout	oscili .25, icps
aout	*= cosseg:a(0, .025, 1, p3-.025, 0)
	outall aout
	endin
	'''

	print(orc)

	sco = '\n'.join([f'i1 {i} 3 {i}' for i in range(int(scala['degrees']))])

	cs = ctcsound.Csound()
	for option in CSFLAGs:
		cs.setOption(option)
	cs.compileOrc(orc)
	cs.readScore(sco)

	cs.start()
	cs.perform()

	cs.cleanup()
	cs.reset()
	del cs

main('arch_enht5')