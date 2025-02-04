
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

function raise_error(string)
	cleanup()
	reaper.CSurf_OnStop()
	local fill = "\n" .. string.rep("=", #string) .. "\n"
	reaper.ReaScriptError("!" .. fill .. string)
end

function round(x, exp)
    local multiplier = 10^exp
    return math.floor(x * multiplier + 0.5) / multiplier
end
-- =================================================================
-- =================================================================
-- =================================================================

local function extract_csv(string)
	local elements = {}
	local paren_count = 0
	local start = 0
	for i = 1, #string do
		local c = string:sub(i, i)
		if c == '(' then
			paren_count = paren_count + 1
		elseif c == ')' then
			paren_count = paren_count - 1
		elseif c == ',' and paren_count == 0 then
			table.insert(elements, string:sub(start + 1, i - 1))
			start = i
		end
	end
	table.insert(elements, string:sub(start + 1))
	local result = {}
	for _, elem in ipairs(elements) do
		elem = elem:match("^%s*(.-)%s*$") -- trim whitespace
		if #elem > 0 then
			table.insert(result, elem)
		end
	end
	return result
end

function insert_after_pattern(input, pattern, insertion)
	local result = input:gsub(pattern, function(match)
		return match .. insertion
	end)
	return result
end

local function exec_lua_string(value, lua_string)
	if lua_string then
		local expr = load("return " .. value .. lua_string)
		if type(expr) == "function" then
			return expr()
		end
	end
	return value
end

local function convert_table_to_strings(tbl)
    -- Create a new table to hold the string values
    local new_table = {}

    -- Iterate over each element in the original table
    for i, v in ipairs(tbl) do
        -- Convert the element to a string and store it in the new table
        new_table[i] = tostring(v or "")
    end

    return new_table
end
-- =================================================================
-- =================================================================
-- =================================================================


local function get_freqs_on_track(item)
	item.freqs_by_tuning = {}
	for i = 0, 127 do
		local freq = reaper.GetTrackMIDINoteNameEx(0, item.track, i, 0)
		freq = string.match(freq, 'c%s+(.*)')
		if not freq then
			raise_error('Commit tuning system first')
		end
		item.freqs_by_tuning[i] = freq
	end
	return item
end

local function process_track_string(item)

	item.global = {
		dur = nil,
		dyn = nil,
		env = 'classic',
		freq = nil
	}

	if item.track_string then
		for _, word in pairs(extract_csv(item.track_string)) do
			if word:find("^dur") then
				local val = word:match("dur%s*(.-)$")
				item.global.dur = val
			elseif word:find("^dyn") then
				local val = word:match("dyn%s*(.-)$")
				item.global.dyn = val
			elseif word:find("^env%.") then
				local val = word:match("env%.(%S+)$")
				item.global.env = val
			elseif word:find("^freq") then
				local val = word:match("freq%s*(.-)$")
				item.global.freq = val
			end
		end
	end

	return item
end

-- =================================================================
-- =================================================================
-- =================================================================

local function process_midi_item(item)

	item = get_freqs_on_track(item)
	item = process_track_string(item)

	item.events = {}
	local _, notes_count, _, _ = reaper.MIDI_CountEvts(item.take)
	for index_note = 0, notes_count - 1 do
		local _, _, is_muted, start_ppqpos, end_ppqpos, chan, pitch, vel, _ = reaper.MIDI_GetNote(item.take, index_note)

		if not is_muted then
			local onset = reaper.MIDI_GetProjTimeFromPPQPos(item.take, start_ppqpos)

			if onset <= item.end_pos and onset >= item.start_pos and onset >= PLAY_POS then

				local end_note = reaper.MIDI_GetProjTimeFromPPQPos(item.take, end_ppqpos)
				local dur = end_note - onset
				dur = exec_lua_string(dur, item.global.dur)

				if PLAY_POS <= item.end_pos and PLAY_POS >= item.start_pos then
					onset = onset - PLAY_POS + item.start_pos
				end

				if dur > 0 then
					local dyn = exec_lua_string(vel / MIDI_CORRECTION, item.global.dyn)
					local env = item.global.env
					local freq = exec_lua_string(item.freqs_by_tuning[pitch], item.global.freq)

					local event = {
						item.instrument_name,
						onset-item.start_pos,
						dur,
						dyn,
						env,
						tonumber(freq)
					}

					for i, v in pairs(event) do
						if type(v) == "number" then
							event[i] = round(v, 3)
						end
					end

					local score
					if chan == 0 then
						local opcode = 'eva_midi' .. ' '
						score = opcode  .. table.concat(convert_table_to_strings(event), ', ')
					else
						local opcode = 'eva_midi_ch' .. ' '
						score = opcode .. table.concat(convert_table_to_strings(event), ', ') .. ', ' .. chan
						--reaper.ShowConsoleMsg(score)
					end
					--reaper.ShowConsoleMsg(score)
					table.insert(item.events, score)
				end
			end
		end
	end

	return item
end

local function process_text_item(item)
	local _, text = reaper.GetSetMediaItemInfo_String(item.id, 'P_NOTES', '', false)
	item.text = text:gsub('p3', tostring(item.dur))
	return item
end

-- =================================================================
-- =================================================================
-- =================================================================


local function get_item_info(item)

	item.take = reaper.GetMediaItemTake(item.id, 0)
	item.start_pos = reaper.GetMediaItemInfo_Value(item.id, 'D_POSITION')
	item.dur = reaper.GetMediaItemInfo_Value(item.id, 'D_LENGTH')
	item.is_muted = reaper.GetMediaItemInfo_Value(item.id, 'B_MUTE') == 1
	item.end_pos = item.start_pos + item.dur
	item.type = (item.take and reaper.TakeIsMIDI(item.take)) and 'MIDI' or 'TEXT'

	return item
end

-- =================================================================
-- =================================================================
-- =================================================================

local function get_track_string(track)
	local _, track_string = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)
	return track_string
end

-- =================================================================
-- =================================================================
-- =================================================================

function get_tracks()

	local i = 0
	local tracks = {}
	local any_solo = reaper.AnyTrackSolo(0)
	local count_tracks = reaper.CountTracks(0)

	while i < count_tracks do

		local track = reaper.GetTrack(0, i)
		local is_parent = reaper.GetMediaTrackInfo_Value(track, 'I_FOLDERDEPTH') == 1
		local is_solo = reaper.GetMediaTrackInfo_Value(track, 'I_SOLO') > 0
		local is_mute = reaper.GetMediaTrackInfo_Value(track, 'B_MUTE') == 1

		if any_solo and is_parent and is_solo then
			table.insert(tracks, track)
			local j = i + 1
			while j < count_tracks do
				local sub_track = reaper.GetTrack(0, j)
				local track_depth = reaper.GetMediaTrackInfo_Value(sub_track, 'I_FOLDERDEPTH')
				if track_depth == 1 then
					break
				end

				if reaper.GetMediaTrackInfo_Value(sub_track, 'B_MUTE') ~= 1 then
					table.insert(tracks, sub_track)
				end
				j = j + 1
			end
			i = j - 1
		elseif is_parent and is_mute then
			local j = i + 1
			while j < count_tracks do
				local sub_track = reaper.GetTrack(0, j)
				local track_depth = reaper.GetMediaTrackInfo_Value(sub_track, 'I_FOLDERDEPTH')
				if track_depth == 1 then
					break
				end
				j = j + 1
			end
			i = j - 1
		elseif not is_mute and not any_solo then
			table.insert(tracks, track)
		end
		i = i + 1
	end
	return tracks
end


function get_items(tracks)

	local items = {}
	local unique_index = 1
	local instrument_name

	for _, track in pairs(tracks) do

		if reaper.GetMediaTrackInfo_Value(track, 'I_FOLDERDEPTH') == 1 then
			_, instrument_name = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)
			if not instrument_name then
				raise_error("No instrument name")
			elseif not string.match(instrument_name, '@') then
				raise_error("No '@' in instrument name")
			end
		end	

		local track_string = get_track_string(track)

		for j = 0, reaper.GetTrackNumMediaItems(track)-1 do

			local item = {
				id = reaper.GetTrackMediaItem(track, j),
				instrument_name = instrument_name,
				track_string = track_string,
				track = track,
				index = unique_index
			}

			item = get_item_info(item)
			if item.type == 'MIDI' then
				item = process_midi_item(item)

			elseif item.type == 'TEXT' then
				item = process_text_item(item)
			end

			table.insert(items, item)
			unique_index = unique_index + 1

		end
	end
	return items
end


-- =================================================================
-- =================================================================
-- =================================================================

function safety_play()
	if PLAY_POS - PLAY_POS_LAST > 1 then
		reaper.CSurf_OnStop()
	end
end

function remove_items_before_play_pos()

	for i = #ITEMs, 1, -1 do
		local item = ITEMs[i]
		if item.start_pos < PLAY_POS and item.end_pos < PLAY_POS then
			table.remove(ITEMs, i)
		end
	end

end

function sort_by_position(a, b)
	return a.start_pos < b.start_pos
end


local LAST_NOTE_PLAYED_PITCH = {}
local last_activation_time = nil
local cooldown_period = 0
local function_initialized = false -- Initialize the guard flag

function send_notes_if_selected()

	local midi_editor = reaper.MIDIEditor_GetActive()
    if not midi_editor then return end

	-- Get the active take within the MIDI editor
    local take = reaper.MIDIEditor_GetTake(midi_editor)
	if not take then return end

	local track = reaper.GetMediaItemTake_Track(take)
    if not track then return end

	local selected_notes = {}
	local _, notes_count, _, _ = reaper.MIDI_CountEvts(take)
	for index_note = 0, notes_count - 1 do
		local _, is_selected, is_muted, start_ppqpos, end_ppqpos, chan, pitch, vel, _ = reaper.MIDI_GetNote(take, index_note)
		if is_selected and not is_muted then
			local note = {
				chan = chan,
				pitch = pitch,
				vel = vel,
				onset = reaper.MIDI_GetProjTimeFromPPQPos(take, start_ppqpos)
			}
			note.dur = reaper.MIDI_GetProjTimeFromPPQPos(take, end_ppqpos) - note.onset
			table.insert(selected_notes, note)
		end
	end

	-- Initialize variables
	local earliest_onset = math.huge  -- Start with the largest possible value
	local note_to_play = {}            -- Table to hold notes with the smallest start_ppqpos

	-- Find the smallest start_ppqpos and the notes with this value
	for _, note in pairs(selected_notes) do
		if note.onset < earliest_onset then
			-- If a new smallest value is found, reset the note_to_play table
			earliest_onset = note.onset
			note_to_play = {note}  -- Start a new table with the current note
		elseif note.onset == earliest_onset then
			-- If this note has the same start_ppqpos as the current smallest, add it to the table
			table.insert(note_to_play, note)
		end
	end

    for _, note in ipairs(note_to_play) do
		local selected_notes_pitch = note.pitch
		for _, last_note in ipairs(LAST_NOTE_PLAYED_PITCH) do
			if selected_notes_pitch == last_note.pitch then
				return false
			end
		end
    end

	local selected_instrument_num = 95
	
	local parent = reaper.GetParentTrack(track)
	local _, instrument_name = reaper.GetSetMediaTrackInfo_String(parent, 'P_NAME', '', false)
	local track_string = get_track_string(track)

	local globals = {
		dur = nil,
		dyn = nil,
		env = 'classic',
		freq = nil
	}

	if track_string then
		for _, word in pairs(extract_csv(track_string)) do
			if word:find("^dur") then
				local val = word:match("dur%s*(.-)$")
				globals.dur = val
			elseif word:find("^dyn") then
				local val = word:match("dyn%s*(.-)$")
				globals.dyn = val
			elseif word:find("^env%.") then
				local val = word:match("env%.(%S+)$")
				globals.env = val
			elseif word:find("^freq") then
				local val = word:match("freq%s*(.-)$")
				globals.freq = val
			end
		end
	end

	local freqs_by_tuning = {}
	for i = 0, 127 do
		local freq = reaper.GetTrackMIDINoteNameEx(0, track, i, 0)
		freq = string.match(freq, 'c%s+(.*)')
		if not freq then
			raise_error('Commit tuning system first')
		end
		freqs_by_tuning[i] = freq
	end

    local current_time = os.clock()

	for _, note in ipairs(note_to_play) do

		local dur = exec_lua_string(note.dur, globals.dur)
		if dur > 5 then dur = 5 end
		if dur < 0 then dur = .5 end
		cooldown_period = dur + .05

		local dyn = exec_lua_string(note.vel / MIDI_CORRECTION, globals.dyn)
		local env = globals.env
		local freq = exec_lua_string(freqs_by_tuning[note.pitch], globals.freq)

		while dyn > .25 do
			dyn = dyn / 2
		end

		-- dyn = dyn / #note_to_play

		-- Check if the function has been called before
		if not function_initialized then
			-- Skip the first execution by setting the flag to true
			function_initialized = true
			LAST_NOTE_PLAYED_PITCH = {}
			table.insert(LAST_NOTE_PLAYED_PITCH, note)	
			return
		else

			local opcode = 'eva_midi'
			local string = opcode .. ' ' .. instrument_name .. ', 0, ' .. dur .. ', ' .. dyn .. ', ' .. env .. ', ' .. freq
			send_to_cordelia(string)
			-- Check if the function was recently activated
			if last_activation_time == nil or current_time - last_activation_time >= cooldown_period then
				string = insert_after_pattern(".getmeout(1)", "%.%w+%(", 'num=' .. selected_instrument_num .. ', ' .. instrument_name .. ', ')
				send_to_cordelia(string)
				-- Function logic goes here
				local mode = 1 -- turnoff only oldest
				string = 'turnoff_everything ' .. mode .. ', ' .. selected_instrument_num .. ', ' .. dur
				send_to_cordelia(string)

				-- Update the last activation time
				last_activation_time = current_time
			end
		end

		LAST_NOTE_PLAYED_PITCH = {}
		table.insert(LAST_NOTE_PLAYED_PITCH, note)
	end
end
