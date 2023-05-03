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

function show_pitches()
	--order_table = {'start_pos', 'end_pos', 'instr_name', 'dur', 'dyn', 'env', 'freq'}
    midi_table = {}
	
	for i = 0, reaper.CountTracks(0)-1 do
		local track_id = reaper.GetTrack(0, i)
	
		for j = 0, reaper.GetTrackNumMediaItems(track_id)-1 do
			local item_id = reaper.GetTrackMediaItem(track_id, j)
			local take_id = reaper.GetMediaItemTake(item_id, 0)
	
			if reaper.TakeIsMIDI(take_id) then
	
				local retval, notecnt, ccevtcnt, textsyxevtcnt = reaper.MIDI_CountEvts(take_id)
				for note_index = 0, notecnt-1 do
					local retval, selected, muted, startppqpos, endppqpos, note_chn, note_pitch, note_vel = reaper.MIDI_GetNote(take_id, note_index)
					local retval, selected, muted, ppqpos, type, env = reaper.MIDI_GetTextSysexEvt(take_id, note_index)

					local start_pos = reaper.MIDI_GetProjTimeFromPPQPos(take_id, startppqpos)
					start_pos = start_pos, 2
					local end_pos = reaper.MIDI_GetProjTimeFromPPQPos(take_id, endppqpos)

					local freq = reaper.GetTrackMIDINoteNameEx(0, track_id, note_pitch, note_chn)
					if freq then
						freq = string.match(freq, 'c%s+(.*)')
					else
						freq = midi2freq_edo12(note_pitch)
					end
					
					local instr_name = ''
					local dur = ''
					local dyn = ''

					midi_table[start_pos] = {
						start_pos,
						instr_name,
						dur,
						dyn,
						env,
						freq
					}

					--table.insert(midi_table['vel'], vel)

				end
			end
		end
	end
	--log_table(midi_table)
end



ctx = reaper.ImGui_CreateContext('My script')
show_pitches()

sent_indices = {}
for i, _ in pairs(midi_table) do
    sent_indices[i] = {}
end

function loop()
	reaper.ImGui_SetNextWindowSize(ctx, 500, 500)
	local visible, open = reaper.ImGui_Begin(ctx, 'My window', true)

	for i, _ in pairs(sent_indices) do
		reaper.ImGui_Text(ctx, 'index: '..i)
	end

	if visible then
		local play_pos = reaper.GetPlayPosition()

		reaper.ImGui_Text(ctx, tostring(play_pos))
		reaper.ImGui_Text(ctx, '---')
--[[ 		for index, position in ipairs(midi_table_positions) do
			reaper.ImGui_Text(ctx, 'index: '..index)
			for _, value in pairs(midi_table_params[position]) do
				reaper.ImGui_Text(ctx, 'others: '..value)
			end
			reaper.ImGui_Text(ctx, '---')
		end ]]
--[[ 		for i, _ in pairs(midi_table) do
			if i <= play_pos then
				flag = true
				index = i
			end
		end

		if flag then
			for _, value in pairs(midi_table[index]) do
				reaper.ImGui_Text(ctx, '--: '..value)
				flag = false
			end
		end ]]

		local index = nil
		for i, v in pairs(midi_table) do
			if i <= play_pos and sent_indices[i][1] then
				index = i
			end
		end
	
		-- If an index was found, send the content of that index
		if index ~= nil then
			local content = midi_table[index]
			for _, value in pairs(content) do
				reaper.ImGui_Text(ctx, '--: '..value)
			end
			for i, _ in pairs(contents) do
				sent_indices[index][i] = true
			end
		end

		reaper.ImGui_End(ctx)
		
	end
	if open then
		reaper.defer(loop)
	end
end

reaper.defer(loop)
