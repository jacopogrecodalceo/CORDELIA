import ctcsound as csound
from matplotlib import pyplot as plt
from matplotlib import animation
import numpy as np

def animate(i, fftArray, line, f_axis):
    cs.tableCopyOut(1, fftArray)
    amp_vals = fftArray[0::2]  # fft amplitude values
    line.set_ydata(amp_vals)

def main():
    fftSize = 4096
    fs = 48000

    orc = '''
    0dbfs = 1
    ksmps = 1

    gifftsiz  =         4096
    gioverlap =         gifftsiz/4
    giwintyp  =         1

    giTable ftgen   1, 0, -(gifftsiz+2), 2, 0

    instr 1
        aout	fractalnoise 1, 1
        aout	*= linseg(0, 1, 1, p3-1, 0)

        kArr[] init gifftsiz+2

        fsig	pvsanal aout, gifftsiz, gioverlap, gifftsiz, giwintyp
        kflag   pvs2array kArr, fsig
        copya2ftab kArr, giTable
    endin
    '''
    sco = "i1 0 50\n"

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

    f_axis_delta = fs / fftSize
    f_axis = np.arange(0, fs / 2 + f_axis_delta, f_axis_delta)
    fftArray = np.zeros(fftSize + 2)

    anim = animation.FuncAnimation(fig, animate, fargs=(fftArray, line, f_axis), interval=30)
    plt.show()

if __name__ == "__main__":
    main()
