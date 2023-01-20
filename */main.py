#import from file
from path import cordelia_dir
#import constants

import udp
udp.open_ports()

import ctcsound
cs = ctcsound.Csound()

#######################################
# CSOUND OPTIONs
#######################################
#put everything inside a list
opt =[]

with open(f'{cordelia_dir}/_core/option.orc') as f:
	for line in f:
		line = line.strip()
		if not line.startswith(';') and line:
			opt.append(line)


from init_csound import query_devices
opt.extend(query_devices('adc'))
opt.extend(query_devices('dac'))

#and then iterate it!
for o in opt:
	cs.setOption(o)
	print(o)

#######################################
# CSOUND SETTING
#######################################

with open(f'{cordelia_dir}/_core/setting.orc') as f:
	cs.compileOrcAsync(f.read())

with open(f'{cordelia_dir}/_core/cordelia.orc') as f:
	cs.compileOrcAsync(f.read())

#######################################
# CSOUND START
#######################################

from threading import Thread
 
if __name__ == '__main__':

    t = Thread(target=udp.receive_messages, daemon=True)

    cs_return = cs.start()
    pt = ctcsound.CsoundPerformanceThread(cs.csound())

    #filename = '/Users/j/Desktop/con.wav'
    #bits = 24
    #numbufs = 4096

    if cs_return == ctcsound.CSOUND_SUCCESS:

        print('CSOUND is ON!')
        pt.play()
        t.start()

        #print('Record ON') 
        #pt.record(filename, bits, numbufs)

        while pt.status() == 0:
            #out_stream = cs.outputBuffer()
            #print(out_stream)
            pass
        
        #pt.stopRecord()
        #print('Record OFF')

        cs.cleanup()
        print('CSOUND is OFF!')

        del cs
	