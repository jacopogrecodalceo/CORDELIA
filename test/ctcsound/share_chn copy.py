from random import randint, random
import ctcsound
c = ctcsound.Csound() 

class RandomLine(object):
    def __init__(self, base, range):
        self.curVal = 0.0
        self.reset()
        self.base = base
        self.range = range

    def reset(self):
        self.dur = randint(256,512) 
        self.end = random() 
        self.slope = (self.end - self.curVal) / self.dur

    def getValue(self):
        self.dur -= 1
        if(self.dur < 0):
            self.reset()
        retVal = self.curVal
        self.curVal += self.slope
        return self.base + (self.range * retVal)

# Our Orchestra for our project
orc = """
sr=48000
ksmps=32
nchnls=2
0dbfs=1

instr 1 
aamp chnget "amp"
kfreq chnget "freq"
;printk 0.5, kamp
;printk 0.5, kfreq
aout vco2 aamp, kfreq
aout moogladder aout, 2000, 0.25
outs aout, aout
endin"""

#c = ctcsound.Csound()    # create an instance of Csound
c.setOption("-odac")  # Set option for Csound
c.setOption("-m7")  # Set option for Csound
c.compileOrc(orc)     # Compile Orchestra from String

sco = "i1 0 60"

c.readScore(sco)     # Read in Score generated from notes 

c.start()             # When compiling from strings, this call is necessary before doing any performing

# The following calls return a tuple. The first value of the tuple is a numpy array
# encapsulating the Channel Pointer retrieved from Csound and the second
# value is an error message, if an error happened (here it is discarded with _).
ampChannel, _ = c.channelPtr("amp", ctcsound.CSOUND_CONTROL_CHANNEL | ctcsound.CSOUND_INPUT_CHANNEL)
freqChannel, _ = c.channelPtr("freq", ctcsound.CSOUND_CONTROL_CHANNEL | ctcsound.CSOUND_INPUT_CHANNEL)

amp = RandomLine(.4, .2)
freq = RandomLine(400, 80)

ampChannel[0] = amp.getValue()    # note we are now setting values in the ndarrays
freqChannel[0] = freq.getValue()

print('Initial amp value is: ' + str(amp.getValue()))
print('Initial freq value is: ' + str(freq.getValue()))

while (c.performKsmps() == 0):
    ampChannel[0] = amp.getValue()
    freqChannel[0] = freq.getValue()

c.reset()