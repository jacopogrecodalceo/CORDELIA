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

dofile( reaper.GetResourcePath() ..
   "/Scripts/Mavriq ReaScript Repository/Various/Mavriq-Lua-Batteries/batteries_header.lua")

local json = require('dkjson')

-- CORDELIA path
local CORDELIA_DIR = '/Users/j/Documents/PROJECTs/CORDELIA'

-- =====================
-- =====================
-- =====================
local function load_json(json_path)
	-- Specify the file path
	-- Open the file for reading
	local file = io.open(json_path, 'r')

	-- Check if the file was successfully opened
	if file then
		-- Read the content of the file
		local file_content = file:read("*all")
		-- Decode the JSON content
		local success, json_table = pcall(json.decode, file_content)
		-- Close the file
		file:close()
		if success then
			return json_table
		else
			-- Handle the case where decoding fails
			reaper.ShowConsoleMsg("Error: Unable to decode JSON in file " .. json_path)
			return
		end
	else
		-- Handle the case where the file could not be opened
		reaper.ShowConsoleMsg("Error: Unable to open file " .. json_path)
		return
	end
end


local scala_path = CORDELIA_DIR .. '/cordelia/config/SCALA.json'
SCALA_json = load_json(scala_path)

local midi_name_path = CORDELIA_DIR .. '/rpr/cordelia_releted/midi_name_freq.json'
MIDI_NAME_json = load_json(midi_name_path)

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


function parse_scala_name(scala_name)

	if string.find(scala_name, 'edo12') then
		scala_name = '_' .. scala_name
	end

	if string.find(scala_name, '@') then
		local name = string.match(scala_name, '([^@]+)')
		local base_freq = string.match(scala_name, '@([^,]+)')
		base_freq = string.match(base_freq, '[^,]+')
		return name, base_freq
	else
		return scala_name, 'a4'
	end
end

function string2midi_note(str)
	local note_name = str:gsub("^%l", string.upper)
	--local note_name = str:match('^(.*)%a$'):gsub("^%l", string.upper)
	--local octave = str:match('(%a)$')
	for i, k in ipairs(MIDI_NAME_json['note_name']) do
		if k == note_name then
			return i-1
		end
	end
	log('Error: Note name is not found')
	return false
end

function get_tuning_freqs_from_scala_file(scala_name)

	local base_frequency = 440.0

	local name, base_freq_string = parse_scala_name(scala_name)

	local decimal_values = {1}
	if SCALA_json[name] then
		-- Split the tuning values string into individual values
		for value in SCALA_json[name]['tuning_values']:gmatch("[^,%s]+") do
			if value:find('/') then
				value = load('return ' .. value)()
			end
			table.insert(decimal_values, tonumber(value))
		end
	end

	local tuning_values = {}
	local midi_note = string2midi_note(base_freq_string)
	local length = #decimal_values - 1
	local period = decimal_values[#decimal_values]
	for i = 1, 127 do
		local offset = i - midi_note
		local quotient = math.floor(offset / length)
		local remainder = offset % length
		if remainder < 0 then
			remainder = remainder + length
		end
		remainder = remainder + 1
		local decimal = decimal_values[remainder] * period^quotient
		local freq = base_frequency * decimal
		tuning_values[i] = freq
	end

	return tuning_values
end

function find_index_of_nearest(array, value)
	if #array == 0 then
		return nil, nil  -- Handle empty array
	end

	local min_index = 1
	local min_diff = math.abs(array[1] - value)
	for i = 2, #array do
		local diff = math.abs(array[i] - value)
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

function get_notes(take)

	local _, notes_count, _, _ = reaper.MIDI_CountEvts(take)
	local notes = {}
	for i = notes_count, 1, -1  do
		local note = {}
		note.retval, note.sel, note.muted, note.startppqpos, note.endppqpos, note.chan, note.pitch, note.vel = reaper.MIDI_GetNote(take, i-1)

		if note.retval then
			table.insert(notes, note)
			reaper.MIDI_DeleteNote(take, i-1)
		end
	end

	return notes
end


MIDI_NOTEs = {}
SUFFIXes = {",,,,", ",,,", ",,", ",", "", "'", "''", "'''", "''''", "'''''"}

-- Starting MIDI note number for A
local start_midi_note = 69

for _, x in ipairs(SUFFIXes) do
    local names = {'c', 'cis', 'd', 'ees', 'e', 'f', 'fis', 'g', 'gis', 'a', 'bes', 'b'}
    for _, c in ipairs(names) do
        table.insert(MIDI_NOTEs, c .. x)
        start_midi_note = start_midi_note + 1
    end
end

function convert_to_ly(measures)

	local lilypond_code = ''
	for _, measure in ipairs(measures) do
		lilypond_code = lilypond_code .. '% Measure ' .. measure.num .. '\n'
		lilypond_code = lilypond_code .. '{\n'

		-- Set time signature and tempo
		lilypond_code = lilypond_code .. '\\time ' .. measure.timesig_num .. '/' .. measure.timesig_denom .. '\n'
		lilypond_code = lilypond_code .. '\\tempo ' .. measure.timesig_denom .. ' = ' .. math.floor(measure.tempo) .. '\n'

		table.sort(measure.notes, function(a, b) return a.qn_onset_quant < b.qn_onset_quant end)

--[[ 	local chords = {}
		local seen = {}
		for i, note in ipairs(measure.notes) do
			local value = note.qn_onset_quant
			if not seen[value] then
				seen[value] = true
				local group = {note}
				for j = i + 1, #measure.notes do
					if measure.notes[j].qn_onset_quant == value then
						table.insert(group, note)
					end
				end
				table.insert(chords, group)
			end
		end ]]

		local chords = {}
		while #measure.notes > 0 do
			local note = table.remove(measure.notes, 1)
			local added_to_chord = false
			for _, chord in ipairs(chords) do
				if note.qn_onset_quant == chord[1].qn_onset_quant then
					table.insert(chord, note)
					added_to_chord = true
					break
				end
			end
			if not added_to_chord then
				table.insert(chords, {note})
			end
		end
		

		-- Iterate over notes
		for _, chord in ipairs(chords) do
			table.sort(chord, function(a, b) return a.pitch < b.pitch end)
			lilypond_code = lilypond_code .. '<'
			local dur = 0
			for _, note in ipairs(chord) do
				lilypond_code = lilypond_code .. MIDI_NOTEs[note.pitch+1] .. ' '
				dur = note.qn_dur_quant
			end
			lilypond_code = lilypond_code .. '>' .. math.floor(dur*8) .. '\n'
		end

		lilypond_code = lilypond_code .. '}\n'
	end

	return lilypond_code
end

function round(number, decimals)
	local factor = 10 ^ decimals
	return math.floor(number * factor + 0.5) / factor
end

function get_measures(take)
	local _, notes_count, _, _ = reaper.MIDI_CountEvts(take)

	local measures = {}
	local measure_count_last = -1

	local item = reaper.GetMediaItemTake_Item(take)
	local pos = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
	local init_timesig_num, init_timesig_denum, _ = reaper.TimeMap_GetTimeSigAtTime(0, pos)

	for i = notes_count, 1, -1 do
		local note = {}
		note.retval, note.sel, note.muted, note.startppqpos, note.endppqpos, note.chan, note.pitch, note.vel = reaper.MIDI_GetNote(take, i - 1)

		note.qn_onset = reaper.MIDI_GetProjQNFromPPQPos(take, note.startppqpos)
		note.qn_onset_quant = round(note.qn_onset, 2)

		note.qn_dur = reaper.MIDI_GetProjQNFromPPQPos(take, note.endppqpos - note.startppqpos)
		note.qn_dur_quant = round(note.qn_dur, 2)

		local qn_num = note.qn_onset / (init_timesig_num * init_timesig_denum)
		local measure_num = math.floor(qn_num) + 1

		local measure_retval, measure_qn_start, measure_qn_end, measure_timesig_num, measure_timesig_denom, measure_tempo = reaper.TimeMap_GetMeasureInfo(0, measure_num)

		if measure_retval and measure_count_last ~= measure_num then
			local measure = {
				notes = {},
				qn_start = measure_qn_start,
				qn_end = measure_qn_end,
				timesig_num = measure_timesig_num,
				timesig_denom = measure_timesig_denom,
				tempo = measure_tempo,
				num = measure_num
			}

			table.insert(measures, measure)
			measure_count_last = measure.num
		end

		if note.retval and not note.muted then
			for _, measure in pairs(measures) do
				if measure.num == measure_num then
					table.insert(measure.notes, note)
				end
			end
		end
	end

	return measures
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
