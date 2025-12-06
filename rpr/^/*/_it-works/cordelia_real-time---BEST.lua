 dofile( reaper.GetResourcePath() ..
   "/Scripts/Mavriq ReaScript Repository/Various/Mavriq-Lua-Batteries/batteries_header.lua")

local MIDI_CORRECTION = 1024

function log(e)
	if type(e) == 'table' then
		indent = indent or 0
		for k, v in pairs(e) do
			local formatting = string.rep(' ', indent) .. k .. ": "
			if type(v) == 'table' then
				reaper.ShowConsoleMsg(formatting .. '\n')
				log(v, indent + 2)
			else
				reaper.ShowConsoleMsg(formatting .. tostring(v) .. '\n')
			end
		end
	else
		reaper.ShowConsoleMsg(tostring(e) .. '\n')
	end
end

local socket = require('socket')
-- Create a new UDP socket using AF_INET as the address family and SOCK_DGRAM as the socket type
local s = socket.udp()

function send_to_cordelia(message)
	-- Encode the message as a byte string before sending
	s:sendto(message, socket.dns.toip('localhost'), 10025)
end

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
  

function get_all_midi_items(ids, index)

	local instr_name, track, item, take = table.unpack(ids)
	local retval, selected, muted, startppqpos, endppqpos, note_chn, note_pitch, note_velocity = reaper.MIDI_GetNote(take, index)
	local retval, selected, muted, ppqpos, type, env = reaper.MIDI_GetTextSysexEvt(take, index)

	local start_pos = reaper.MIDI_GetProjTimeFromPPQPos(take, startppqpos)
	if start_pos < 0 then
		start_pos = 0
	end

	local end_pos = reaper.MIDI_GetProjTimeFromPPQPos(take, endppqpos)
	
	local dur = end_pos - start_pos
	local dyn = note_velocity / MIDI_CORRECTION
	local env = 'classic'
	local freq = reaper.GetTrackMIDINoteNameEx(0, track, note_pitch, note_chn)
	freq = string.match(freq, 'c%s+(.*)')

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
end

function get_all_text_items(ids)

	local instr_name, track, item, take = table.unpack(ids)
	local start_pos = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
	local dur = reaper.GetMediaItemInfo_Value(item, 'D_LENGTH')
	local end_pos = start_pos+dur
	local retval, text = reaper.GetSetMediaItemInfo_String(item, 'P_NOTES', 0, 0)
	
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

	for i = 0, reaper.CountTracks(0)-1 do

		local track = reaper.GetTrack(0, i)
		local track_depth = reaper.GetMediaTrackInfo_Value(track, 'I_FOLDERDEPTH')

		if track_depth == 1 then -- it's a parent
			local retval, parent_name = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', 0, 0)
			instr_name = string.match(parent_name, '@%w+')
		else
			local retval, parent_name = reaper.GetSetMediaTrackInfo_String(reaper.GetParentTrack(track), 'P_NAME', 0, 0)
			instr_name = string.match(parent_name, '@%w+')
		end
	
		for j = 0, reaper.GetTrackNumMediaItems(track)-1 do
			local item = reaper.GetTrackMediaItem(track, j)
			local take = reaper.GetMediaItemTake(item, 0)
			local ids = {instr_name, track, item, take}

			if take ~= nil and reaper.TakeIsMIDI(take)then -- if ==, it will work on "empty"/text items only
				local retval, notecnt, ccevtcnt, textsyxevtcnt = reaper.MIDI_CountEvts(take)
				for index = 0, notecnt-1 do
					table.insert(midi_items, get_all_midi_items(ids, index))
				end
			else
				local text_item = get_all_text_items(ids)
				table.insert(text_item, index)
				table.insert(text_items, text_item)
				index = index + 1

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

local STATE = true

function on_play()
	if STATE then
		get_all_items()
		remove_at_play()
		send_to_cordelia('schedule "heart", 0, -1')

		STATE = false
	end
end

function on_stop()
	if not STATE then
		send_to_cordelia('turnoff2_i "heart", 0, 0')

		if next(text_items_off) ~= nil then
			for _, item in pairs(text_items_off) do
				local instr_num = tostring(item[6] + 300)
				send_to_cordelia('turnoff2_i ' .. instr_num .. ', 0, 0')
			end
		end
		
		midi_items = {}
		text_items = {}
		text_items_off = {}
		
		STATE = true

	end
end

function cordelia_realtime(play_pos)

	if reaper.GetPlayState() == 1 then

		on_play()

		local index = 1
		while index <= #midi_items do

			local item = midi_items[index]
			local start_pos = item[1]

			if start_pos <= play_pos then
			
				local instr_name = item[3]
				local dur = item[4]
				local dyn = item[5]
				local env = item[6]
				local freq = item[7]

				local csound_string = 'eva_midi "' .. instr_name .. '", 0, ' .. dur .. ', ' .. dyn .. ', ' .. env .. ', ' .. freq
				send_to_cordelia(csound_string)
				table.remove(midi_items, index)
			else
				index = index + 1
			end
		end

		index = 1
		while index <= #text_items do

			local item = text_items[index]

			local start_pos = item[1]
			local instr_num = tostring(item[6] + 300)

			if start_pos <= play_pos then

				local instr_name = item[3]
				local text = item[5]
				local code = extract_elements(text)

				table.insert(code, 2, '"' .. instr_name .. '"')

				local csound_string = 'instr ' .. instr_num .. '\n' .. table.concat(code, ", ") .. '\nendin\n'
				csound_string = csound_string .. 'schedule ' .. instr_num .. ', 0, -1'
				
				send_to_cordelia(csound_string)

				table.insert(text_items_off, item)
				table.remove(text_items, index)

			else
				index = index + 1
			end
		end

		if next(text_items_off) ~= nil then
			index = 1
			while index <= #text_items_off do

				local item = text_items_off[index]

				local end_pos = item[2]
				local instr_num = tostring(item[6] + 300)

				if end_pos <= play_pos then

					local csound_string = 'turnoff2_i ' .. instr_num .. ', 0, 0'

					send_to_cordelia(csound_string)
					
					table.remove(text_items_off, index)

				else
					index = index + 1
				end
			end
		end
		
	elseif reaper.GetPlayState() == 0 then
		on_stop()

	end
	
end

local ctx = reaper.ImGui_CreateContext('Console')

function main()

	reaper.ImGui_SetNextWindowSize(ctx, 500, 500)
	local visible, open = reaper.ImGui_Begin(ctx, 'CORDELIA control', true)

	if visible then

		local play_pos = reaper.GetPlayPosition()

		reaper.ImGui_Text(ctx, tostring(play_pos))
		reaper.ImGui_Text(ctx, '---')	

		cordelia_realtime(round(play_pos, 3))

		reaper.ImGui_End(ctx)
	end

	if open then
		reaper.defer(main)
	end

end

reaper.defer(main)
