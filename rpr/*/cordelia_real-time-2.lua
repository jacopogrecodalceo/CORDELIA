local prev_idx = 0
 
function Notify(events)
	local pattern = '%02x %02x %02x\n'
	for _, evt in ipairs(events) do
		reaper.ShowConsoleMsg(pattern:format(evt.msg[1], evt.msg[2], evt.msg[3]))
	end
end
 
function Monitor()
	local idx, buf, ts, dev_id, projPos, projLoopCnt = reaper.MIDI_GetRecentInputEvent(0)
	reaper.ShowConsoleMsg(tostring(idx))
	if idx > prev_idx then
		local events = {}
		local new_idx = idx
		local i = 0
		repeat
			local msg = {}
			for n = 1, #buf do msg[n] = buf:byte(n) end
			events[#events + 1] = {msg = msg, ts = ts, dev_id = dev_id}
			i = i + 1
			idx, buf, _, dev_id, projPos, projLoopCnt = reaper.MIDI_GetRecentInputEvent(i)
		until idx == prev_idx
			prev_idx = new_idx
			Notify(events)
	end
end
 
 
function Main()
	Monitor()
	reaper.defer(Main)
end

reaper.ShowConsoleMsg('hello')
Main()