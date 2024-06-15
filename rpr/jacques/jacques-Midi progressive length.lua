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

	if midiEditor then
		-- Get the active take in the MIDI editor
		local take = reaper.MIDIEditor_GetTake(midiEditor)


		if take then

			if reaper.MIDI_EnumSelNotes(take, 0) == -1 then
				reaper.MIDI_SelectAll(take, true)
			end

			-- Assuming 'take' and 'track' are defined before this code
			local note_index = 0
			local notes = 0
			while note_index do
				local selected_note_index = reaper.MIDI_EnumSelNotes(take, note_index)
				if selected_note_index == -1 then
					break
				end
				notes = note_index
				note_index = note_index + 1
			end

			local note_index = 0
			while note_index do
				-- Get the selected notes in the active take
				local selected_note_index = reaper.MIDI_EnumSelNotes(take, note_index)

				-- If no selected notes were found
				if selected_note_index == -1 then
					break
				end

				local  retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, selected_note_index)
				if selected then
					local index_pos = note_index < notes / 2 and note_index or notes - note_index
					--reaper.ShowConsoleMsg(index_pos .. '\n')
					endppqpos = endppqpos + (index_pos)*tonumber(factor)

					--local index_vel = note_index < notes / 2 and note_index or notes - note_index
					--vel = 1+math.floor((index_vel/notes)*255)
					reaper.MIDI_SetNote(take, selected_note_index, selected, muted, startppqpos, endppqpos, chan, pitch, vel, false)
				end

				-- Update note_index for the next iteration
				note_index = note_index + 1
			end

			-- Update the MIDI editor
			reaper.MIDI_Sort(take)
			return
		else
			reaper.ShowMessageBox("No active take in the MIDI editor.", "Error", 0)
			return
		end
	else
		reaper.ShowMessageBox("No active MIDI editor.", "Error", 0)
		return
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