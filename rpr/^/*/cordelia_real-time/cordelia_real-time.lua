
function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function extract_elements(str)
	local elements = {}
	local paren_count = 0
	local start = 1
	for i = 1, #str do
		local c = str:sub(i,i)
		if c == '(' then
			paren_count = paren_count + 1
		elseif c == ')' then
			paren_count = paren_count - 1
		elseif c == ',' and paren_count == 0 then
			table.insert(elements, str:sub(start, i-1))
			start = i + 1
		end
	end
	table.insert(elements, str:sub(start))
	local result = {}
	for _, elem in ipairs(elements) do
		elem = elem:match("^%s*(.-)%s*$") -- remove leading/trailing whitespace
		if elem ~= "" then
			table.insert(result, elem)
		end
	end
	return result
end

function extract_elements(string)
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
	for i, elem in ipairs(elements) do
		elem = elem:match("^%s*(.-)%s*$") -- trim whitespace
		if #elem > 0 then
			table.insert(result, elem)
		end
	end
	return result
end

function get_all_midi_items(ids, index)

	local instr_name, track, item, take = table.unpack(ids)

	local retval, selected, muted, startppqpos, endppqpos, note_chn, note_pitch, note_velocity = reaper.MIDI_GetNote(take, index)
	
	local item_start_pos = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
	local item_end_pos = item_start_pos + reaper.GetMediaItemInfo_Value(item, 'D_LENGTH')

	local retval, track_name = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', 0, 0)
	
	local start_pos = reaper.MIDI_GetProjTimeFromPPQPos(take, startppqpos)
	if start_pos < 0 then
		start_pos = 0
	end

	local end_pos = reaper.MIDI_GetProjTimeFromPPQPos(take, endppqpos)

	if start_pos <= item_end_pos and start_pos >= item_start_pos then
		
		local dur = end_pos - start_pos
		local dyn = note_velocity / MIDI_CORRECTION
		local env = 'classic'

		local freq = reaper.GetTrackMIDINoteNameEx(0, track, note_pitch, note_chn)
		freq = string.match(freq, 'c%s+(.*)')
		if not freq then
			log('You probably forgot to commit your tuning, dumbass')
			return
		end

		for _, word in pairs(extract_elements(track_name)) do
			if word:find("^dur") then
				local val = word:match("dur%s*(.-)$")
				dur = load("return " .. dur .. val)()
			elseif word:find("^dyn") then
				local val = word:match("dyn%s*(.-)$")
				dyn = load("return " .. dyn .. val)()
			elseif word:find("^env%.") then
				local val = word:match("env%.(%S+)$")
				env = val
				--env = if_atk(env)
			elseif word:find("^freq") then
				local val = word:match("freq%s*(.-)$")
				freq = load("return " .. freq .. val)()
			end
		end


		local retval_text, selected, muted, ppqpos_text, type, note_local_env = reaper.MIDI_GetTextSysexEvt(take, 0)

		local epsilon = 15 -- Adjust the epsilon value based on your desired precision
		local difference = math.abs(startppqpos - ppqpos_text)

		if note_local_env ~= '' and difference < epsilon then 
			env = note_local_env
		end


		local params = {
			start_pos,
			end_pos,
			instr_name,
			dur,
			dyn,
			env,
			freq
		}

		return params
	else
		return nil
	end
end

function get_all_text_items(ids)

	local instr_name, track, item, take = table.unpack(ids)

	local start_pos = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
	local dur = reaper.GetMediaItemInfo_Value(item, 'D_LENGTH')
	local end_pos = start_pos+dur
	local retval, text = reaper.GetSetMediaItemInfo_String(item, 'P_NOTES', 0, 0)

	text = string.gsub(text, "p3", tostring(dur))
	
	local params = {
		start_pos,
		end_pos,
		instr_name,
		dur,
		text
	}

	return params

end

local midi_items = {}
local text_items = {}
local text_items_off = {}

function get_all_items()

	local index = 0
	local instr_name = ''
	local code = ''

	local is_mute = false
	local is_solo = false

	for i = 0, reaper.CountTracks(0)-1 do

		local track = reaper.GetTrack(0, i)
		local track_depth = reaper.GetMediaTrackInfo_Value(track, 'I_FOLDERDEPTH')

		if track_depth == 1 then -- it's a parent
			local retval, parent_name = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', 0, 0)
			instr_name = string.match(parent_name, '@.*')

			is_mute = reaper.GetMediaTrackInfo_Value(track, 'B_MUTE') == 1
			if reaper.AnyTrackSolo(0) then
				is_solo = reaper.GetMediaTrackInfo_Value(track, 'I_SOLO') > 0				
			else
				is_solo = true
			end
		else
			local parent_track = reaper.GetParentTrack(track)
			if instr_name ~= '' and parent_track ~= nil then
				local retval, parent_name = reaper.GetSetMediaTrackInfo_String(parent_track, 'P_NAME', 0, 0)
				instr_name = string.match(parent_name, '@.*')
				local is_parent_mute = reaper.GetMediaTrackInfo_Value(parent_track, 'B_MUTE') == 1

				if not is_parent_mute then 
					is_mute = reaper.GetMediaTrackInfo_Value(track, 'B_MUTE') == 1
				end
			end
		end

		if not is_mute and is_solo then
			for j = 0, reaper.GetTrackNumMediaItems(track)-1 do
				local item = reaper.GetTrackMediaItem(track, j)
				local take = reaper.GetMediaItemTake(item, 0)
				local ids = {instr_name, track, item, take}

				if take ~= nil and reaper.TakeIsMIDI(take)then -- if ==, it will work on "empty"/text items only
					local retval, notecnt, ccevtcnt, textsyxevtcnt = reaper.MIDI_CountEvts(take)
					for index = 0, notecnt-1 do
						local midi_note = get_all_midi_items(ids, index)
						if midi_note ~= nil then
							table.insert(midi_items, midi_note)
						end
					end
				elseif take == nil then
					local text_item = get_all_text_items(ids)
					table.insert(text_item, index)
					table.insert(text_items, text_item)
					index = index + 1

				end
			end
		end
	end
end

function remove_at_play()

	local play_pos = reaper.GetCursorPosition()

	local index = 1
	while index <= #midi_items do

		local item = midi_items[index]
		local start_pos = item[1]

		if start_pos < play_pos then
			table.remove(midi_items, index)
		else
			index = index + 1
		end
	end

	index = 1
	while index <= #text_items do

		local item = text_items[index]

		local start_pos = item[1]
		local end_pos = item[2]

		if start_pos < play_pos and end_pos < play_pos then
			table.remove(text_items, index)
		else
			index = index + 1
		end
	end

end


