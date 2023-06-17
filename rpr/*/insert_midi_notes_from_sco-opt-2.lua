function log(string)
	reaper.ShowConsoleMsg(tostring(string) .. '\n')
end

function get_tuning_list(take)
	local track = reaper.GetMediaItemTake_Track(take)
	local note_data = {}
	for i = 0, 127 do
	local noteName = reaper.GetTrackMIDINoteNameEx(0, track, i, 0)
	local name, cent_diff, freq = string.match(noteName, '([^%s]+)%s+([^%s]+)%s+([^%s]+)')
	table.insert(note_data, { name = name, cent_diff = cent_diff, freq = freq })
	end
	local names, cent_diffs, freqs = {}, {}, {}
	for i = 1, #note_data do
	table.insert(names, note_data[i].name)
	table.insert(cent_diffs, note_data[i].cent_diff)
	table.insert(freqs, note_data[i].freq)
	end
	return names, cent_diffs, freqs
end

function find_index_of_nearest(array, value)
	local index = 1
	local minDiff = math.abs(array[1] - value)
	for i = 2, #array do
	local diff = math.abs(array[i] - value)
	if diff < minDiff then
		index = i
		minDiff = diff
	end
	end
	return array[index], index
end

function insert_midi_note(take, time, duration, pitch, velocity)
	local note = {}
	note.selected = true
	note.mute = false
	note.ppq_start = reaper.MIDI_GetPPQPosFromProjTime(take, time)
	note.ppq_end = reaper.MIDI_GetPPQPosFromProjTime(take, time + duration)
	note.pitch = pitch
	note.vel = velocity
	reaper.MIDI_InsertNote(take, true, false, note.ppq_start, note.ppq_end, 0, note.pitch, note.vel, true)
end

function main(file_path)
	local midieditor = reaper.MIDIEditor_GetActive()
	if midieditor ~= nil then
		local take = reaper.MIDIEditor_GetTake(midieditor)
		if take ~= nil then
			local names, cent_diffs, freqs = get_tuning_list(take)
			local first_time = nil

			local file = io.open(file_path, 'r')
			if file then
				local lines = {}
				for line in file:lines() do
					table.insert(lines, line)
				end
				file:close()

				for i, line in ipairs(lines) do
					local name, time, dur, dyn, env, freq = string.match(line, '([^,]+), ([^,]+), ([^,]+), ([^,]+), ([^,]+), ([^,]+)')
					if first_time == nil then
						first_time = tonumber(time)
					end
					local nearest_value, midi_note_num = find_index_of_nearest(freqs, tonumber(freq))
					insert_midi_note(take, tonumber(time), tonumber(dur), midi_note_num, math.floor(tonumber(dyn) * 127))
				end
			end
		end
	end
	reaper.MIDIEditor_OnCommand(midieditor, reaper.NamedCommandLookup('_BR_ME_REFRESH'))
end

local retval, file_path = reaper.GetUserFileNameForRead('', 'Path', 'txt')
if retval then
	local start_time = reaper.time_precise()
	main(file_path)
	local end_time = reaper.time_precise()
	log('Processing time: ' .. tostring(end_time - start_time) .. ' seconds')
end
