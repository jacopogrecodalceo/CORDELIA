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
function split_csv(csv)
	local values = {}
	for value in csv:gmatch("[^,]+") do
		table.insert(values, value)
	end
	return values
end

function get_notes(take)
	local notes = {}
	local _, notes_count, _, _ = reaper.MIDI_CountEvts(take)
	for index_note = 0, notes_count - 1 do
		local _, is_selected, is_muted, start_ppqpos, end_ppqpos, channel, pitch, vel, _ = reaper.MIDI_GetNote(take, index_note)

		if is_selected then
			local onset = reaper.MIDI_GetProjTimeFromPPQPos(take, start_ppqpos)
			local end_note = reaper.MIDI_GetProjTimeFromPPQPos(take, end_ppqpos)

			table.insert(notes, {
				index = index_note,
				onset = onset,
				end_note = end_note,
				pitch = pitch,
				is_selected = is_selected,
				is_muted = is_muted,
				start_ppqpos = start_ppqpos,
				end_ppqpos = end_ppqpos,
				channel = channel,
				vel = vel
			})
			reaper.MIDI_DeleteNote(take, index_note)
		end
	end
	return notes
end

function find_references(notes)
	-- Extract pitch values from the notes and store them in a table
	local pitches = {}
	for _, note in ipairs(notes) do
		table.insert(pitches, note.pitch)
	end

	-- Find the maximum and minimum pitch values
	local highest_pitch = math.max(table.unpack(pitches))
	local lowest_pitch = math.min(table.unpack(pitches))

	local relative_pitch = highest_pitch - lowest_pitch

	local center_pitch = lowest_pitch + math.ceil(relative_pitch / 2)
	log(center_pitch)
	return center_pitch

end

function is_note_present(direction, take, note, epsilon)
	local _, notes_count, _, _ = reaper.MIDI_CountEvts(take)
	for index_note = 0, notes_count - 1 do
		local _, is_selected, is_muted, start_ppqpos, end_ppqpos, channel, pitch, vel, _ = reaper.MIDI_GetNote(take, index_note)
		local onset = reaper.MIDI_GetProjTimeFromPPQPos(take, start_ppqpos)
		local end_note = reaper.MIDI_GetProjTimeFromPPQPos(take, end_ppqpos)

		if pitch == (note.pitch + direction) then
			if (onset >= (note.onset - (epsilon/1000))) or (end_note <= (note.end_note + (epsilon/1000))) then
				-- Move note
				return true
			end
		end
	end
	return false
end

-- Define a comparison function
function compare(a, b)
    return a.pitch > b.pitch
end

-- Sort the table of elements by age

function main(epsilon)
	-- Get the active MIDI editor
	local midiEditor = reaper.MIDIEditor_GetActive()
	if not midiEditor then return end

	-- Get the active take in the MIDI editor
	local take = reaper.MIDIEditor_GetTake(midiEditor)
	if not take then reaper.ShowMessageBox("No active MIDI editor.", "Error", 0) return end

	-- If no selection, select all
	if reaper.MIDI_EnumSelNotes(take, 0) == -1 then
		reaper.MIDI_SelectAll(take, true)
	end

	local notes = get_notes(take)
	local center_pitch = find_references(notes)
	table.sort(notes, compare)

	reaper.MIDI_DisableSort(take)
	local no_sort = true

	for _, note in pairs(notes) do
		log(note.pitch)
		log('---')
		if note.pitch >= center_pitch then
			local direction = 1
			if not is_note_present(direction, take, note, epsilon) then
				reaper.MIDI_InsertNote(take, note.is_selected, note.is_muted, note.start_ppqpos, note.end_ppqpos, note.channel, note.pitch+direction, note.vel, no_sort)
			else
				reaper.MIDI_InsertNote(take, note.is_selected, note.is_muted, note.start_ppqpos, note.end_ppqpos, note.channel, note.pitch, note.vel, no_sort)
			end
		elseif note.pitch < center_pitch then
			local direction = -1
			if not is_note_present(direction, take, note, epsilon) then
				reaper.MIDI_InsertNote(take, note.is_selected, note.is_muted, note.start_ppqpos, note.end_ppqpos, note.channel, note.pitch+direction, note.vel, no_sort)
			else
				reaper.MIDI_InsertNote(take, note.is_selected, note.is_muted, note.start_ppqpos, note.end_ppqpos, note.channel, note.pitch, note.vel, no_sort)
			end
		end
	end
	reaper.MIDI_Sort(take)
end

local retval, retvals_csv = reaper.GetUserInputs('PPQ factor', 1, 'epsilon [ms]', '95', 512)
if retval then
	local values = split_csv(retvals_csv)
	local epsilon = values[1]
	reaper.Undo_BeginBlock()
	main(epsilon)
	reaper.Undo_EndBlock("Vertical stretch", -1)
end