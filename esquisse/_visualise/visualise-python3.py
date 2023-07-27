import ctcsound as csound
from matplotlib import pyplot as plt
from matplotlib import animation
import numpy as np

orc = '''
0dbfs = 1
ksmps = 1

;general values for fourier transform
gifftsiz  =         4096   ; this needs to match above defined fftSize
gioverlap =         gifftsiz/4
giwintyp  =         1 ;von hann window

;an 'empty' function table
giTable ftgen   1, 0, -(gifftsiz+2), 2, 0

instr 1
    aout	fractalnoise 1, 1
	aout	*= linseg(0, 1, 1, p3-1, 0)

    ;out aout

    kArr[] init gifftsiz+2

    fsig	pvsanal aout, gifftsiz, gioverlap, gifftsiz, giwintyp
    kflag   pvs2array kArr, fsig
	        copya2ftab kArr, giTable
endin
'''
sco = "i1 0 50\n"


fftSize = 4096 # this needs to match gifftsiz in orc
fs = 48000 # sample rate
cs = csound.Csound()
cs.setOption('-odac')
cs.compileOrc(orc)
cs.readScore(sco)
cs.start()

pt = csound.CsoundPerformanceThread(cs.csound())
pt.play()

fig, ax = plt.subplots()
ax.set(xlim=(0, fs/2), ylim=(0, 1))
line, = ax.plot([], [], lw=2)

	chs = int(2)
	sig = np.reshape(cs.spout(), (-1, chs))  # Reshape the array

def animate(i, f_axis_cs=[], amp_vals=[]):
    cs.tableCopyOut(1, fftArray)
    #f_axis_cs = fftArray[1::2] # theoretically this should be the same as f_axis above defined but it's not
    amp_vals = fftArray[0::2] # fft amplitude values
    line.set_data(f_axis, amp_vals)

anim = animation.FuncAnimation(fig, animate, interval=30)
plt.show()