-- If you want to ship the sockets files within your script uncomment these lines (it is recommended to use Mavriq repository with his dll and so files this way user will have the latest version without you needing to update. Also will avoid confusion with multiple binaries files.)
--[=[ local info = debug.getinfo(1, 'S');
local script_path = info.source:match[[^@?(.*[\/])[^\/]-$]];
package.cpath = package.cpath .. ";" .. script_path .. "/socket module/?.dll"  -- Add current folder/socket module for looking at .dll (need for loading basic luasocket)
package.cpath = package.cpath .. ";" .. script_path .. "/socket module/?.so"  -- Add current folder/socket module for looking at .so (need for loading basic luasocket)
package.path = package.path .. ";" .. script_path .. "/socket module/?.lua" -- Add current folder/socket module for looking at .lua ( Only need for loading the other functions packages lua osc.lua, url.lua etc... You can change those files path and update this line) ]=]

-- if you want to load the sockets from Mavriq repository:
-- package.cpath = package.cpath .. ";" .. reaper.GetResourcePath() ..'/Scripts/Mavriq ReaScript Repository/Various/Mavriq-Lua-Sockets/?.dll'    -- Add current folder/socket module for looking at .dll
package.cpath = package.cpath .. ";" .. reaper.GetResourcePath() ..'/Scripts/Mavriq ReaScript Repository/Various/Mavriq-Lua-Sockets/?.so'    -- Add current folder/socket module for looking at .so
-- package.path = package.path .. ";" .. reaper.GetResourcePath() ..'/Scripts/Mavriq ReaScript Repository/Various/Mavriq-Lua-Sockets/?.lua'    -- Add current folder/socket module for looking at .so

-- dofile(reaper.GetResourcePath() .. "/Scripts/Mavriq ReaScript Repository/Various/Mavriq-Lua-Batteries/batteries_header.lua")
-- dofile(reaper.GetResourcePath() .. "/Scripts/Mavriq ReaScript Repository/Various/Mavriq-Lua-Sockets/headers.lua")
-- =================================================================
-- =================================================================
-- =================================================================

MIDI_CORRECTION = 512
MAIN_TRACK_NAME = '_main'

-- =================================================================
-- =================================================================
-- =================================================================

STATE = true
PLAY_POS_LAST = 0

NOTEs = {}
SCOREs = {}
SCOREs_off = {}

-- =================================================================
-- =================================================================
-- =================================================================

local socket = require('socket.core')
local s = socket.udp()

function send_to_cordelia(message)
	-- log(message)
	-- Encode the message as a byte string before sending
	s:sendto(message, socket.dns.toip('localhost'), 10025)
end

-- =================================================================
-- =================================================================
-- =================================================================

function log(e)
	if type(e) == 'table' then
		local indent = indent or 0
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

function profile(func, name)
	local start_time = os.clock() -- Record the start time in seconds

	-- Call the provided function with its arguments
	local result = func()

	local end_time = os.clock() -- Record the end time in seconds

	local elapsed_time = end_time - start_time -- Calculate elapsed time

	log(string.format("Elapsed time: %.4f seconds -- %s", elapsed_time, name))
end

-- =================================================================
-- =================================================================
-- =================================================================

function extract_csv(string)
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

function insert_after_pattern(input, pattern, insertion)
	local result = input:gsub(pattern, function(match)
		return match .. insertion
	end)
	return result
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
				table.insert(tracks, sub_track)
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

function get_item_info(track, j)
	local id = reaper.GetTrackMediaItem(track, j)
	local item = {
		id = id,
		take = reaper.GetMediaItemTake(id, 0),
		start_pos = reaper.GetMediaItemInfo_Value(id, 'D_POSITION'),
		dur = reaper.GetMediaItemInfo_Value(id, 'D_LENGTH')
	}
	
	item.end_pos = item.start_pos + item.dur

	return item
end

function get_track_name_info(track_name)

	local info = {
		dur = nil,
		dyn = nil,
		env = 'classic',
		freq = nil
	}

	for _, word in pairs(extract_csv(track_name)) do
		if word:find("^dur") then
			local val = word:match("dur%s*(.-)$")
			info.dur = val
		elseif word:find("^dyn") then
			local val = word:match("dyn%s*(.-)$")
			info.dyn = val
		elseif word:find("^env%.") then
			local val = word:match("env%.(%S+)$")
			info.env = val
		elseif word:find("^freq") then
			local val = word:match("freq%s*(.-)$")
			info.freq = val
		end
	end

	return info
end

function get_freqs_by_tuning(track)
	local freqs_by_tuning = {}
	for i = 0, 127 do
		local freq = reaper.GetTrackMIDINoteNameEx(0, track, i, 0)
		freq = string.match(freq, 'c%s+(.*)')
		if not freq then
			log('You need to commit the tuning system')
			return
		end
		table.insert(freqs_by_tuning, freq)
	end
	return freqs_by_tuning
end

-- =================================================================
-- =================================================================
-- =================================================================

function get_items()
	
	local tracks = get_tracks()
	local item_index = 0
	local instrument_name 
	for _, track in pairs(tracks) do

		if reaper.GetMediaTrackInfo_Value(track, 'I_FOLDERDEPTH') == 1 then
			_, instrument_name = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)
		end 

		local _, track_name = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)

		if instrument_name and string.match(instrument_name, '@') then
			for j = 0, reaper.GetTrackNumMediaItems(track)-1 do
				local item = get_item_info(track, j)

				-- ITEM INFO
				local item_type = item.take and reaper.TakeIsMIDI(item.take) and 'MIDI' or 'SCORE'

				if item_type == 'MIDI' then
					local info = get_track_name_info(track_name)
					info.freqs_by_tuning = get_freqs_by_tuning(track)

					local item_notes = get_notes_from_item(info, item)

					for _, note in pairs(item_notes) do
						note.instrument_name = instrument_name
						table.insert(NOTEs, note)
					end
				elseif item_type == 'SCORE' then
					item.index = item_index
					local score = get_scores_item(item)
					score.instrument_name = instrument_name
					table.insert(SCOREs, score)
					item_index = item_index + 1
				end
			end
		end
	end
end

function get_notes_from_item(info, item)

	local function apply_dynamic_change(value, info)
		if info then
			local expr = load("return " .. value .. info)
			if type(expr) == "function" then
				return expr()
			end
		end
		return value
	end

	local notes = {}
	local _, notes_count, _, _ = reaper.MIDI_CountEvts(item.take)
	for index_note = 0, notes_count - 1 do
		local _, _, is_muted, start_ppqpos, end_ppqpos, chan, pitch, vel, _ = reaper.MIDI_GetNote(item.take, index_note)

		if not is_muted then
			local onset = reaper.MIDI_GetProjTimeFromPPQPos(item.take, start_ppqpos)
			-- onset = onset < 0 and 0 or onset

			if onset <= item.end_pos and onset >= item.start_pos then
				
				local end_note = reaper.MIDI_GetProjTimeFromPPQPos(item.take, end_ppqpos)

				local dur = apply_dynamic_change(end_note - onset, info.dur)
				local dyn = apply_dynamic_change(vel / MIDI_CORRECTION, info.dyn)
				local env = info.env
				local freq = apply_dynamic_change(info.freqs_by_tuning[pitch], info.freq)

				table.insert(notes, {
					onset = onset,
					end_note = end_note,
					dur = dur,
					dyn = dyn,
					env = env,
					freq = freq
				})
			end
		end
	end
	return notes
end

function get_scores_item(item)
	local _, code = reaper.GetSetMediaItemInfo_String(item.id, 'P_NOTES', '', false)
	code = code:gsub('%bp3%b', tostring(item.dur))

	local score = {
		onset = item.start_pos,
		end_pos = item.end_pos,
		dur = item.dur,
		code = code,
		index = item.index
	}

	return score
end

-- =================================================================
-- =================================================================
-- =================================================================

function cordelia_store()

	local score_file = io.open(file_path, 'w')
	score_file:write(score_string)  -- Write the text to the file
	score_file:close() -- Close the file when done

	get_all_items()

end

function get_project_paths()

	local project_path = reaper.GetProjectPath() .. '/'
	local project_name, ext = reaper.GetProjectName(0):match("(.+)%.(.*)")

	local tracks_directory = project_path .. project_name .. '-cordelia_renders/'
	local main_track_dir = tracks_directory .. MAIN_TRACK_NAME

	log(project_path)
	log('---')
	log(project_name)
	log('---')
	log(tracks_directory)
	log('---')
	log(main_track_dir)

end

-- =================================================================
-- =================================================================
-- =================================================================

function safety_play(play_pos)
	if play_pos - PLAY_POS_LAST > 1 then
		reaper.CSurf_OnStop()
	end
end

function remove_at_play(play_pos)

	for i = #NOTEs, 1, -1 do
		if NOTEs[i].onset < play_pos then
			table.remove(NOTEs, i)
		end
	end

	for i = #SCOREs, 1, -1 do
		if SCOREs[i].onset < play_pos and SCOREs[i].end_pos < play_pos then
			table.remove(SCOREs, i)
		end
	end

end

function sort_by_onset(a, b)
	return a.onset < b.onset
end

function on_play(play_pos)
	if STATE then
		PLAY_POS_LAST = reaper.GetPlayPosition()
		get_items()
		
		table.sort(NOTEs, sort_by_onset)
		table.sort(SCOREs, sort_by_onset)

		if #NOTEs > 15000 then
			reaper.CSurf_OnStop()
			log('Items are more than 150000')
		end
		remove_at_play(play_pos)
		send_to_cordelia('schedule "heart", 0, -1')

		STATE = false
	end
end

function on_stop()
	if not STATE then
		send_to_cordelia('turnoff2_i "heart", 0, 0')

		if next(SCOREs_off) ~= nil then
			for _, score in pairs(SCOREs_off) do
				send_to_cordelia('turnoff2_i ' .. score.instrument_num .. ', 0, 0')
			end
		end
		
		NOTEs = {}
		SCOREs = {}
		SCOREs_off = {}
		
		STATE = true

	end
end

-- =================================================================
-- =================================================================
-- =================================================================

function cordelia_realtime(play_pos)
	
	if reaper.GetPlayState() == 1 then

		local play_pos = reaper.GetPlayPosition()

		on_play(play_pos)
		safety_play(play_pos)

		PLAY_POS_LAST = play_pos

		local index = 1
		while index <= #NOTEs do
			local note = NOTEs[index]
			if note.onset <= play_pos then
			
				local csound_string = 'eva_midi ' .. note.instrument_name .. ', 0, ' .. note.dur .. ', ' .. note.dyn .. ', ' .. note.env .. ', ' .. note.freq
				send_to_cordelia(csound_string)
				table.remove(NOTEs, index)
			else
				index = index + 1
			end
		end

		index = 1
		while index <= #SCOREs do
			local score = SCOREs[index]
			if score.onset <= play_pos then
				score.instrument_num = tostring(score.index + 300)

				if score.instrument_name == '@cordelia' then
					local csound_parts = {
						'REAPER_INSTR_START ' .. score.instrument_num,
						score.code,
						'REAPER_INSTR_END'
					}
					local csound_string = table.concat(csound_parts, '\n')
					--csound_string = csound_string .. '\nschedule ' .. score.instrument_num .. ', 0, -1'
					
					send_to_cordelia(csound_string)

					table.insert(SCOREs_off, score)
					table.remove(SCOREs, index)

				else
					local csound_string = insert_after_pattern(score.code, "%.%w+%(", score.instrument_num .. ', ' .. score.instrument_name .. ', ')
					
					send_to_cordelia(csound_string)

					table.insert(SCOREs_off, score)
					table.remove(SCOREs, index)
				end
			else
				index = index + 1
			end
		end

		if next(SCOREs_off) ~= nil then
			index = 1
			while index <= #SCOREs_off do
				local score = SCOREs_off[index]
				if score.end_pos <= play_pos then
					local csound_string = 'turnoff2_i ' .. score.instrument_num .. ', 0, 0'
					send_to_cordelia(csound_string)
					table.remove(SCOREs_off, index)
				else
					index = index + 1
				end
			end
		end
		
	elseif reaper.GetPlayState() == 0 then
		on_stop()
	end
	
end


--[[ local temp_log_file = '/Users/j/Desktop/pipie/temp_log.txt'
local cmd = '/opt/homebrew/bin/python3 "' .. CORDELIA_CORE .. '/_server/cordelia.py" > ' .. temp_log_file
--os.execute(cmd)
--local cordelia_handle = 
--io.popen(cmd)
--log(cmd)
--os.execute(cmd)

local dump = reaper.ExecProcess(cmd, -1)
local show_size = 1024
 ]]
local _, _, section_id, cmd_id, _, _, _ = reaper.get_action_context()

-- set toggle state to off
reaper.SetToggleCommandState(section_id, cmd_id, 1);
reaper.RefreshToolbar2(section_id, cmd_id);

function in_the_end()
	-- set toggle state to off
	reaper.SetToggleCommandState(section_id, cmd_id, 0);
	--send_to_cordelia('event_i "e", 0, .25')
	reaper.RefreshToolbar2(section_id, cmd_id);
end

function main_without_gui()
	cordelia_realtime()
	reaper.defer(main_without_gui)
end

--[[ local ctx = reaper.ImGui_CreateContext('Console')

local last_size = 0
local last_time = reaper.time_precise()
local data = ''

function main()

	reaper.ImGui_SetNextWindowSize(ctx, 500, 500)
	local visible, open = reaper.ImGui_Begin(ctx, 'CORDELIA control', true)

	if visible then

		cordelia_realtime()

		local time_elapsed = reaper.time_precise()

		if (time_elapsed - last_time) >= .5 then
			local file = assert(io.open(temp_log_file, "rb")) -- open the file in binary mode
			local current_size = file:seek("end") -- get the current size of the file
			if current_size > last_size then -- check if there is new data to read
			  file:seek("set", current_size - show_size) -- seek to the position of the new data
			  data = file:read(show_size) -- read the new data
			  --log(data)
			end
			file:close() -- close the file when done
			last_time = time_elapsed -- update the last time the function was called
			last_size = current_size -- update the last size of the file
		end
		--os.execute('sleep 1')
		reaper.ImGui_Text(ctx, data)

		reaper.ImGui_End(ctx)
	end

	if open then
		reaper.defer(main)
	else
		send_to_cordelia('event_i "e", 0, .25')
		-- close the pipe file, the child process, and the log file
	end

end ]]


reaper.defer(main_without_gui())
--reaper.defer(main)

reaper.atexit(in_the_end)
