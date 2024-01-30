--[[
	Description: Select note and note row under mouse cursor
	Version: 1.0.0
	Author: Cordelia
	Changelog:
		Initial Release
	Links:
		Lokasenna's Website http://forum.cockos.com/member.php?u=10417
]]--

--[[
	1. get selected notes
	2. take the first one
	3. transpose to the most similar note
]]

function log(e, indent)
	if type(e) == 'table' then
		indent = indent or 0
		for k, v in pairs(e) do
			local formatting = string.rep(' ', indent) .. k .. ": "
			if type(v) == 'table' then
				reaper.ShowConsoleMsg(formatting .. '\n')
				log(v, indent + 4)
			else
				reaper.ShowConsoleMsg(formatting .. tostring(v) .. '\n')
			end
		end
	else
		reaper.ShowConsoleMsg(tostring(e) .. '\n')
	end
end

function extract_freq_from_name(str)
	local result = ''
	local has_decimal = false
	for i = #str, 1, -1 do
		local char = str:sub(i, i)
		if char == '.' then
			if not has_decimal then
				result = char .. result
				has_decimal = true
			else
				break
			end
		elseif tonumber(char) then
			result = char .. result
		else
			break
		end
	end

	return result
end

function get_tuning_list(track)
	local tuning = {}

	for i = 0, 127 do
		local string_note_name = reaper.GetTrackMIDINoteNameEx(0, track, i, 0)--:match("(%S+)%s+(%S+)%s+(%S+)")
		local freq = extract_freq_from_name(string_note_name)
		tuning[i] = freq
	end

	return tuning
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

function get_selected_notes(take)

	local retval, notes_count, ccs, sysex = reaper.MIDI_CountEvts(take)
	local notes = {}
	for i = notes_count, 1, -1  do
		local note = {}
		note.retval, note.sel, note.muted, note.startppqpos, note.endppqpos, note.chan, note.pitch, note.vel = reaper.MIDI_GetNote(take, i-1)

		if note.retval and note.sel then
			table.insert(notes, note)
			reaper.MIDI_DeleteNote(take, i-1)
		end
	end

	return notes
end

function find_transposition_down(tuning, note)
	local freq = tonumber(note.freq) / 2
	local nearest_value, midi_note_num = find_index_of_nearest(tuning, freq)
	return midi_note_num - note.pitch
end

function find_transposition_up(tuning, note)
	local freq = tonumber(note.freq) * 2
	local nearest_value, midi_note_num = find_index_of_nearest(tuning, freq)
	return midi_note_num - note.pitch
end
