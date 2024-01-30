function split_csv(csv)
	local values = {}
	for value in csv:gmatch("[^,]+") do
		table.insert(values, value)
	end
	return values
end

function main(factor)
	-- Get the active MIDI editor
	local midiEditor = reaper.MIDIEditor_GetActive()
	if not midiEditor then return end

	-- Get the active take in the MIDI editor
	local take = reaper.MIDIEditor_GetTake(midiEditor)
	if not take then reaper.ShowMessageBox("No active MIDI editor.", "Error", 0) return end

	if reaper.MIDI_EnumSelNotes(take, 0) == -1 then
		reaper.MIDI_SelectAll(take, true)
	end

	local _, notes_count, _, _ = reaper.MIDI_CountEvts(take)
	for note_index = 0, notes_count - 1 do
		local  retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, note_index)

		if selected then
			local vel_index = note_index < notes_count / 2 and note_index or notes_count - note_index
			--reaper.ShowMessageBox(tostring(vel_index), '', 0)
			vel = 1+math.floor((vel_index/(notes_count+1))*128)*2
			reaper.MIDI_SetNote(take, note_index, selected, muted, startppqpos, endppqpos, chan, pitch, vel, false)
		end

		-- Update the MIDI editor
		reaper.MIDI_Sort(take)
	end
end

local retval, retvals_csv = reaper.GetUserInputs('PPQ factor', 1, 'factor', '10', 512)
if retval then
	local values = split_csv(retvals_csv)
	local factor = values[1]
	reaper.Undo_BeginBlock()
	main(factor)
	reaper.Undo_EndBlock("Prog notes", -1)
end