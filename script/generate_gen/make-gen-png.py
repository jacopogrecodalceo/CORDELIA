import ctcsound
from pathlib import Path

dir_path = '/Users/j/Documents/PROJECTs/CORDELIA/_GEN/_books/hybrid'

cs = ctcsound.Csound()


files = Path(dir_path).glob('*.orc')
for file in files:
	print(file)
	basename = Path(file).stem

	with open(file) as f:
		string = f.read()


	csd_text = f'''
	<CsoundSynthesizer>
	<CsOptions>
	--i-only

	</CsOptions>
	<CsInstruments>

	gienvdur init 8192
	giexpzero init .005

	{string}

	// Arguments after path are optional
	// is_waveform (0 or 1) default to 0
	// fill (0 or 1) default to 1
	// draw_grid (0 or 1) default to 1
	// invert_color (0 or 1) default to 0
	hc_write_as_png(gi{basename}, "{dir_path + '/' + basename}.png", 0, 1, 0, 1)

	</CsInstruments>
	<CsScore>
	e
	</CsScore>
	</CsoundSynthesizer>'''


	result = cs.compileCsdText(csd_text)
	result = cs.start()
	try:
		while True:
			result = cs.performKsmps()
			if result != 0:
				break
		result = cs.cleanup()
		cs.reset()
	except:
		result = cs.cleanup()
		cs.reset()


del cs
