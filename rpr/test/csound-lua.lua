require "luaCsnd6"

-- Defining our Csound ORC code within a multiline String
orc = [[
sr=44100
ksmps=32
nchnls=2
0dbfs=1
instr 1
aout oscili .05, 340
outs aout, aout
endin
]]

-- Defining our Csound SCO code
sco = "i1 0 10"

local c = luaCsnd6.Csound()
c:SetOption("-odac")  -- Using SetOption() to configure Csound
c:SetOption("-+rtaudio=PortAudio")  -- Using SetOption() to configure Csound

c:CompileOrc(orc)     -- Compile the Csound Orchestra string
c:ReadScore(sco)      -- Compile the Csound SCO String
c:Start()  -- When compiling from strings, call Start() prior to Perform()
c:Perform()  -- Run Csound to completion
c:Stop()