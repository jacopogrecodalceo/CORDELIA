
CORDELIA_SON = '/Users/j/Documents/script/OOT_Get_Heart.wav'
CORDELIA_PATH = '/Users/j/Documents/PROJECTs/CORDELIA/cordelia'

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

function get_item_info(track, index_per_track)
	local id = reaper.GetTrackMediaItem(track, index_per_track)
	local item = {
		id = id,
		take = reaper.GetMediaItemTake(id, 0),
		start_pos = reaper.GetMediaItemInfo_Value(id, 'D_POSITION'),
		dur = reaper.GetMediaItemInfo_Value(id, 'D_LENGTH'),
		is_muted = reaper.GetMediaItemInfo_Value(id, 'B_MUTE') == 1
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
	if track_name then
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
		freqs_by_tuning[i] = freq
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
				local item_type = not item.is_muted and (item.take and reaper.TakeIsMIDI(item.take) and 'MIDI' or 'SCORE') or nil

				if not item.is_muted and item_type == 'MIDI' then
					local info = get_track_name_info(track_name)
					info.freqs_by_tuning = get_freqs_by_tuning(track)

					local item_notes = get_notes_from_item(info, item)

					for _, note in pairs(item_notes) do
						note.instrument_name = instrument_name
						table.insert(NOTEs, note)
					end
				elseif not item.is_muted and item_type == 'SCORE' then
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

function apply_dynamic_change(value, lua_string)
	if lua_string then
		local expr = load("return " .. value .. lua_string)
		if type(expr) == "function" then
			return expr()
		end
	end
	return value
end

function get_notes_from_item(info, item)

	local notes = {}
	local _, notes_count, _, _ = reaper.MIDI_CountEvts(item.take)
	for index_note = 0, notes_count - 1 do
		local _, _, is_muted, start_ppqpos, end_ppqpos, chan, pitch, vel, _ = reaper.MIDI_GetNote(item.take, index_note)
		-- Lua: retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(MediaItem_Take take, integer ccidx)

		if not is_muted then
			local onset = reaper.MIDI_GetProjTimeFromPPQPos(item.take, start_ppqpos)
			-- onset = onset < 0 and 0 or onset

			if onset <= item.end_pos and onset >= item.start_pos then

				local end_note = reaper.MIDI_GetProjTimeFromPPQPos(item.take, end_ppqpos)

				local dur = apply_dynamic_change(end_note - onset, info.dur)

				if dur > 0 then
					local dyn = apply_dynamic_change(vel / MIDI_CORRECTION, info.dyn)
					local env = info.env
					local freq = apply_dynamic_change(info.freqs_by_tuning[pitch], info.freq)

					table.insert(notes, {
						onset = onset,
						end_note = end_note,
						dur = dur,
						dyn = dyn,
						env = env,
						freq = freq,
						chan = chan,
					})
				end
			end
		end
	end
	return notes
end

function get_scores_item(item)
	local _, code = reaper.GetSetMediaItemInfo_String(item.id, 'P_NOTES', '', false)
	code = code:gsub('p3', tostring(item.dur))

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

function create_folder_if_not_exists(dir_path)
    local command = 'mkdir "' .. dir_path .. '"'

    -- Check if the directory exists
    if os.execute('[ -d "' .. dir_path .. '" ]') then
        -- If it exists, remove it
        command = 'rm -r "' .. dir_path .. '" && ' .. command
    end

    os.execute(command)
end

function get_project_info()

	local project_path = reaper.GetProjectPath() .. '/'
	local project_name, ext = reaper.GetProjectName(0):match("(.+)%.(.*)")
	local retval, title = reaper.GetSetProjectInfo_String(0, 'PROJECT_TITLE', '', false)

	local tracks_directory = project_path  .. project_name  .. '-cordelia_render'
	create_folder_if_not_exists(tracks_directory)
	local main_track_dir = tracks_directory .. MAIN_TRACK_NAME

	title = title == '' and project_name or title

	return title, tracks_directory
end

function get_tracks_info(tracks)
	local instrument_name
	local parent_tracks = {}
	for parent_track_index, parent_track_id in pairs(tracks) do
		local is_parent = reaper.GetMediaTrackInfo_Value(parent_track_id, 'I_FOLDERDEPTH') == 1
		if is_parent then
			_, instrument_name = reaper.GetSetMediaTrackInfo_String(parent_track_id, 'P_NAME', '', false)
			if instrument_name and string.match(instrument_name, '@') then
				local parent_track = {
					id = parent_track_id,
					name = instrument_name,
					index = parent_track_index,
					tracks = {}
				}
				for track_index = parent_track_index + 1, #tracks do
					track_id = tracks[track_index]
					if reaper.GetMediaTrackInfo_Value(track_id, 'I_FOLDERDEPTH') == 1 then
						break
					else
						local _, track_name = reaper.GetSetMediaTrackInfo_String(track_id, 'P_NAME', '', false)
						track = {
							id = track_id,
							name = track_name
						}
						table.insert(parent_track.tracks, track)
					end
				end
				table.insert(parent_tracks, parent_track)
			end
		else
			_, instrument_name = reaper.GetSetMediaTrackInfo_String(parent_track_id, 'P_NAME', '', false)
			if instrument_name == '@cordelia' then
				local parent_track = {
					id = parent_track_id,
					name = instrument_name,
					index = parent_track_index,
					tracks = {}
				}
				table.insert(parent_tracks, parent_track)
			end
		end
	end
	return parent_tracks
end

--[[ function check_cordelia_tracks(tracks)
	for _, parent_track in pairs(tracks) do
		if parent_track.name == 'cordelia' then
			for j = 0, reaper.GetTrackNumMediaItems(track.id)-1 do
				local item = get_item_info(track.id, j)
				local score = get_scores_item(item)
			end
		end
	end
end
 ]]
 
function store_tracks(channels, sr, ksmps)

	local play_pos = 0 --reaper.GetPlayPosition()
	local project_len = reaper.GetProjectLength(0)

	local title, tracks_directory = get_project_info()

	local tracks = get_tracks()
	tracks = get_tracks_info(tracks)

	local item_index  = 0

	--check_cordelia_tracks(tracks)

	for _, parent_track in pairs(tracks) do

		local instrument_name = parent_track.name
		local formatted_index = string.format("%02d", parent_track.index)
		local track_dir = tracks_directory .. '/' .. formatted_index .. '-' .. instrument_name:sub(2) ..  '/'
		create_folder_if_not_exists(track_dir)

		local track_path = track_dir .. title .. '-' .. formatted_index .. '-' .. instrument_name:sub(2)
		local score_path = track_path .. '.sco'
		local orc_cordelia_path = track_path .. '-cordelia.orc'
		local wav_path = track_path .. '.wav'
		local cmd_path = track_dir .. '_.command'
		local score_file = assert(io.open(score_path, 'w'), 'Error opening file')

		for _, track in pairs(parent_track.tracks) do

			local NOTEs = {}
			local SCOREs = {}

			for j = 0, reaper.GetTrackNumMediaItems(track.id)-1 do
				local item = get_item_info(track.id, j)

				-- ITEM INFO
				local item_type = not item.is_muted and (item.take and reaper.TakeIsMIDI(item.take) and 'MIDI' or 'SCORE') or nil

				if item_type == 'MIDI' then
					local info = get_track_name_info(track.name)
					info.freqs_by_tuning = get_freqs_by_tuning(track.id)

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

			table.sort(NOTEs, sort_by_onset)
			table.sort(SCOREs, sort_by_onset)

			for _, note in pairs(NOTEs) do
				if note.onset >= play_pos then

					local csound_string
					if note.chan == 0 then
						local opcode = 'eva_midi' .. ' '
						csound_string = opcode .. note.instrument_name .. ', ' .. note.onset .. ', ' .. note.dur .. ', ' .. note.dyn .. ', ' .. note.env .. ', ' .. note.freq
					else
						local opcode = 'eva_midi_ch' .. ' '
						csound_string = opcode .. note.instrument_name .. ', ' .. note.onset .. ', ' .. note.dur .. ', ' .. note.dyn .. ', ' .. note.env .. ', ' .. note.freq .. ', ' .. note.chan
					end
					score_file:write(csound_string .. '\n\n')  -- Write the text to the file
				end
			end

			for _, score in pairs(SCOREs) do
				if score.onset >= play_pos then
					score.instrument_num = tostring(score.index + 300)

					if score.instrument_name == 'cordelia' then
						local csound_parts = {
							'instr ' .. score.instrument_num,
							score.code,
							'endin',
							'schedule ' .. score.onset .. ', ' .. score.duration
						}
						local csound_string = table.concat(csound_parts, '\n\n')
						--csound_string = csound_string .. '\nschedule ' .. score.instrument_num .. ', 0, -1'

						score_file:write(csound_string)  -- Write the text to the file
						score_file:write('\n;' .. string.rep('*', 32) .. '\n')

					else
						local csound_string = insert_after_pattern(score.code, "%.%w+%(",
							'sched_onset=' .. score.onset .. ', ' ..
							'sched_dur=' .. score.dur .. ', ' ..
							score.instrument_name .. ', '
						)

						score_file:write(csound_string)  -- Write the text to the file
						score_file:write('\n;' .. string.rep('*', 32) .. '\n')

					end
				end
			end
		end
		score_file:write('\n\nevent_i "e", 0, ' .. project_len + 5)
		score_file:close()

		local execute_cordelia = 'cd ' .. CORDELIA_PATH .. ' && ' .. '/opt/homebrew/bin/python3.11 cordelia.py -s "' .. score_path .. '"'
		--log(execute_cordelia)
		os.execute(execute_cordelia)

		local cmd_string = 'csound' 		.. ' ' ..
								'-3' .. ' ' ..
								'--0dbfs=1' .. ' ' ..
								'--orc ' 		.. '"' .. orc_cordelia_path .. '"' .. ' ' ..
								'--nchnls=' 	.. channels .. ' ' ..
								'--sample-rate=' .. sr .. ' ' ..
								'--ksmps=' 		.. ksmps .. ' ' ..
								'-+id_artist=' .. '"' .. "jacopo greco d'alceo" ..'"' .. ' ' ..
								'-+id_title=' .. '"' ..  instrument_name:sub(2) .. '"' .. ' ' ..
								'--output='		.. '"' .. wav_path .. '"'

		cmd_string = cmd_string .. '\n' .. 'afplay -v 0.25 "' .. CORDELIA_SON .. '"'
		cmd_string = cmd_string .. '\n' .. 'osascript -e \'tell application "Terminal" to close\''

		local cmd_file = assert(io.open(cmd_path, 'w'), 'Error opening file')
		cmd_file:write(cmd_string)
		cmd_file:close()
		local script = 'sh \\\"' .. cmd_path .. '\\\";exit'
		local osa_command = "osascript -e 'tell application \"Terminal\" to do script \"" .. script .. "\"'"
		--log(osa_command)
		os.execute(osa_command)
	end
	--local main_command = 'find ' .. tracks_directory .. ' -type f -name \'*.command\' -print | parallel sh && afplay ' .. CORDELIA_SON
	--io.popen(main_command)
	--os.execute('open -a Terminal.app "' .. main_command .. '" &')
	--local osa_command = "osascript -e 'tell application \"Terminal\" to do script \"find " .. tracks_directory .. " -type f -name \\\"*.command\\\" -print | parallel --jobs 10 sh && exit\"'"
	--os.execute(osa_command)

end

-- =================================================================
-- =================================================================
-- =================================================================

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


local LAST_NOTE_PLAYED_PITCH = {}

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
		if is_selected then
			if #selected_notes > 5 then break end
			local note = {
				pitch = pitch,
				vel = vel,
				start_ppqpos = start_ppqpos,
				end_ppqpos = end_ppqpos
			}
			table.insert(selected_notes, note)
		end
	end

    for _, note in ipairs(selected_notes) do
		local selected_notes_pitch = note.pitch
		for _, last_note in ipairs(LAST_NOTE_PLAYED_PITCH) do
			local last_pitch = last_note.pitch
			if selected_notes_pitch == last_pitch then
				return false
			end
		end
    end

	for _, note in ipairs(selected_notes) do
		local parent = reaper.GetParentTrack(track)
		local _, instrument_name = reaper.GetSetMediaTrackInfo_String(parent, 'P_NAME', '', false)
		local _, track_name = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)
		local info = get_track_name_info(track_name)

		local freqs_by_tuning = get_freqs_by_tuning(track)

		if not is_muted then
			local onset = reaper.MIDI_GetProjTimeFromPPQPos(take, note.start_ppqpos)
			-- onset = onset < 0 and 0 or onset
			local end_note = reaper.MIDI_GetProjTimeFromPPQPos(take, note.end_ppqpos)

			local dur = apply_dynamic_change(end_note - onset, info.dur)
			if dur > 1.5 then dur = 1.5 end
			if dur > 0 then
				local dyn = apply_dynamic_change(note.vel / MIDI_CORRECTION, info.dyn)

				while dyn > .25 do
					dyn = dyn / 2
				end
				dyn = dyn / #selected_notes

				local env = info.env
				local freq = apply_dynamic_change(freqs_by_tuning[note.pitch], info.freq)

				local instrument_num = 95

				local csound_string = insert_after_pattern('.getmeout(1)', "%.%w+%(", 'num=' .. instrument_num .. ', ' .. instrument_name .. ', ')
				send_to_cordelia(csound_string)
				csound_string = 'eva_midi ' .. instrument_name .. ', 0, ' .. dur .. ', ' .. dyn .. ', ' .. env .. ', ' .. freq
				send_to_cordelia(csound_string)
				local mode = 1 -- turnoff only oldest
				csound_string = 'turnoff_everything ' .. mode .. ', ' .. instrument_num .. ', 1'
				send_to_cordelia(csound_string)
				csound_string = 'turnoff_everything ' .. mode .. ', ' .. instrument_num .. ', 1'
				send_to_cordelia(csound_string)
				LAST_NOTE_PLAYED_PITCH = {}
				table.insert(LAST_NOTE_PLAYED_PITCH, note)
		
			end
		end
	end

end
-- =================================================================
-- =================================================================
-- =================================================================
local epsilon = .005

function cordelia_realtime()

	local function on_play(play_pos)
		if STATE then
			PLAY_POS_LAST = reaper.GetPlayPosition()
			get_items()

			table.sort(NOTEs, sort_by_onset)
			table.sort(SCOREs, sort_by_onset)

			if #NOTEs > 35000 then
				reaper.CSurf_OnStop()
				log('Items are more than 35000')
			end
			remove_at_play(play_pos)
			send_to_cordelia('schedule "heart", 0, -1')

			STATE = false
		end
	end

	local function on_stop()
		if not STATE then
			send_to_cordelia('turnoff2_i "heart", 0, 0')

			if next(SCOREs_off) ~= nil then
				for _, score in pairs(SCOREs_off) do
					send_to_cordelia('turnoff2_i ' .. score.instrument_num .. ', 0, 0')
					
					local mode = 0 -- turnoff all
					local csound_string = 'turnoff_everything ' .. mode .. ', ' .. score.instrument_name
					send_to_cordelia(csound_string)

				end
			end

			NOTEs = {}
			SCOREs = {}
			SCOREs_off = {}

			STATE = true

		end
	end

	if reaper.GetPlayState() == 1 then
		local play_pos = reaper.GetPlayPosition()-epsilon

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
					local csound_string = insert_after_pattern(score.code, "%.%w+%(", 'num=' .. score.instrument_num .. ', ' .. score.instrument_name .. ', ')
					--local csound_string = 'cordelia_item(' .. 'num=' .. score.instrument_num .. ', ' .. score.code .. ')'

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
		send_notes_if_selected()
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
_, _, section_id, cmd_id, _, _, _ = reaper.get_action_context()

function init()
	-- set toggle state to off
	reaper.SetToggleCommandState(section_id, cmd_id, 1)
	reaper.RefreshToolbar2(section_id, cmd_id)
end

function in_the_end()
	-- set toggle state to off
	reaper.SetToggleCommandState(section_id, cmd_id, 0)
	--send_to_cordelia('event_i "e", 0, .25')
	reaper.RefreshToolbar2(section_id, cmd_id)
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
