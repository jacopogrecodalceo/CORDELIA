package.path = reaper.GetResourcePath() .. '/Scripts/sockmonkey72 Scripts/MIDI/?.lua'
local mu = require 'MIDIUtils'
mu.CORRECT_OVERLAPS = false

function log(string)
	reaper.ShowConsoleMsg(string .. '\n')
end

function get_tuning_list(take)
	local track = reaper.GetMediaItemTake_Track(take)
	local names, cent_diffs, freqs = {}, {}, {}

	for i = 0, 127 do
		local name, cent_diff, freq = reaper.GetTrackMIDINoteNameEx(0, track, i, 0):match("(%S+)%s+(%S+)%s+(%S+)")
		names[i] = name
		cent_diffs[i] = cent_diff
		freqs[i] = freq
	end

	return names, cent_diffs, freqs
end

function find_index_of_nearest(array, value)
	local min_index = 0
	local min_diff = math.huge

	for i, v in ipairs(array) do
		local diff = math.abs(v - value)
		if diff < min_diff then
			min_diff = diff
			min_index = i
		end
	end

	return array[min_index], min_index
end

function insert_midi_note(take, time, duration, midi_note_num, velocity)
	local ppq_start = reaper.MIDI_GetPPQPosFromProjTime(take, time)
	local ppq_end = reaper.MIDI_GetPPQPosFromProjTime(take, time + duration)

	mu.MIDI_InsertNote(take, true, false, ppq_start, ppq_end, 0, midi_note_num, velocity)

	--reaper.MIDI_InsertNote(take, true, false, ppq_start, ppq_end, 0, midi_note_num, velocity, true)
end



function process_file(file_path, take)
	local names, cent_diffs, freqs = get_tuning_list(take)
	local first_time = nil

	local last_starting_time = 0

	local file = io.open(file_path, 'r')
	if not file then return end

	mu.MIDI_OpenWriteTransaction(take)

	for line in file:lines() do
		
		local values = {}
		for value in line:gmatch('([^,]+)') do
			value = string.gsub(value, "^%s*(.-)%s*$", "%1") -- Remove leading and trailing spaces
			table.insert(values, value)
		end

		--cordelia, 1.342667, 1.000000, 0.090537, 0, 97.945637
		local name, time, dur, dyn, env, freq = table.unpack(values)

		if time ~= last_starting_time then
			if first_time == nil then
				first_time = tonumber(time)
			end
			local nearest_value, midi_note_num = find_index_of_nearest(freqs, tonumber(freq))

			local velocity = math.floor(tonumber(dyn) * 127)

	--[[ 		-- Create the MIDI buffer string for the note event
			local note_on_event = string.pack("BBB", 0x90, midi_note_num, velocity)
			local note_off_event = string.pack("BBB", 0x80, midi_note_num, 0)
			
			-- Calculate the MIDI offset in the buffer
			local offset = math.floor((reaper.MIDI_GetPPQPosFromProjTime(take, tonumber(time))))
			local dur_ppq = math.floor((reaper.MIDI_GetPPQPosFromProjTime(take, tonumber(dur))))
			
			-- Build the MIDI events for note-on and note-off
			local note_on = string.pack("IBs4", offset, 0, note_on_event)
			local note_off = string.pack("IBs4", offset + dur_ppq, 0, note_off_event)
			
			-- Append the events to the buffer
			midi_buffer = midi_buffer .. note_on .. note_off ]]

			insert_midi_note(take, tonumber(time), tonumber(dur), midi_note_num, velocity)
		end
		last_starting_time = time
	end

	mu.MIDI_CommitWriteTransaction(take)

	file:close()
end

function main(file_path)
	local midieditor = reaper.MIDIEditor_GetActive()
	if midieditor ~= nil then
		local take = reaper.MIDIEditor_GetTake(midieditor)
		if take ~= nil then
			process_file(file_path, take)
			reaper.MIDIEditor_OnCommand(midieditor, reaper.NamedCommandLookup('_BR_ME_REFRESH'))
		end
	end
end

local retval, file_path = reaper.GetUserFileNameForRead('', 'Path', 'txt')
if retval then
	--local start_time = reaper.time_precise()
	main(file_path)
	--local end_time = reaper.time_precise()
	--log('Processing time: ' .. tostring(end_time - start_time) .. ' seconds')
end
