dofile( reaper.GetResourcePath() ..
   "/Scripts/Mavriq ReaScript Repository/Various/Mavriq-Lua-Batteries/batteries_header.lua")

function log(message)
	reaper.ShowConsoleMsg(tostring(message) .. "\n")
end

function log_table(tab)
	reaper.ShowConsoleMsg(table.concat(tab, ', ') .. "\n")
end

function midi2freq_edo12(note)
	local A4 = 440 -- frequency of A4 note
	return (2^((note-69)/12)) * A4
end

local socket = require('socket')
-- Create a new UDP socket using AF_INET as the address family and SOCK_DGRAM as the socket type
local s = socket.udp()

function send_to_csound(message)
	-- Encode the message as a byte string before sending
	s:sendto(message, socket.dns.toip('localhost'), 10025)
	log(message)
end

function show_pitches()
    midi_table = {}
	
	local unique_index = 1

	for i = 0, reaper.CountTracks(0)-1 do
		local track_id = reaper.GetTrack(0, i)
	
		for j = 0, reaper.GetTrackNumMediaItems(track_id)-1 do
			local item_id = reaper.GetTrackMediaItem(track_id, j)
			local take_id = reaper.GetMediaItemTake(item_id, 0)

			if take_id then
				if reaper.TakeIsMIDI(take_id) then
		
					local retval, notecnt, ccevtcnt, textsyxevtcnt = reaper.MIDI_CountEvts(take_id)
					for note_index = 0, notecnt-1 do
						local retval, selected, muted, startppqpos, endppqpos, note_chn, note_pitch, note_vel = reaper.MIDI_GetNote(take_id, note_index)
						local retval, selected, muted, ppqpos, type, env = reaper.MIDI_GetTextSysexEvt(take_id, note_index)

						local start_pos = reaper.MIDI_GetProjTimeFromPPQPos(take_id, startppqpos)
						local end_pos = reaper.MIDI_GetProjTimeFromPPQPos(take_id, endppqpos)

						local freq = reaper.GetTrackMIDINoteNameEx(0, track_id, note_pitch, note_chn)
						if freq then
							freq = string.match(freq, 'c%s+(.*)')
						else
							freq = midi2freq_edo12(note_pitch)
						end
						
						local instr_name = 'esquisse'
						local dur = ''
						local dyn = ''

						local params = {}
						params[start_pos] = {
							unique_index,
							instr_name,
							dur,
							dyn,
							env,
							freq
						}

						table.insert(midi_table, params)
						unique_index = unique_index + 1
					end
				end
			end
		end
	end
	--log_table(midi_table)
end



ctx = reaper.ImGui_CreateContext('Console')
show_pitches()

store_tab = {}

function contains_value(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function loop()
	reaper.ImGui_SetNextWindowSize(ctx, 500, 500)
	local visible, open = reaper.ImGui_Begin(ctx, 'CORDELIA control', true)
	if visible then

		if reaper.GetPlayState() == 1 then
			local play_pos = reaper.GetPlayPosition()
			reaper.ImGui_Text(ctx, tostring(play_pos))
			reaper.ImGui_Text(ctx, '---')
			for _, tab in pairs(midi_table) do
				for start_pos, tab_params in pairs(tab) do
					if start_pos <= play_pos and not contains_value(store_tab, tab) then
						for _, params in pairs(tab_params) do
							reaper.ImGui_Text(ctx, params)
							log(params)
						end
						table.insert(store_tab, tab)
					end
				end
			end
		end

		reaper.ImGui_End(ctx)
		
	end

	if open then
		reaper.defer(loop)
	end

end

reaper.defer(loop)
