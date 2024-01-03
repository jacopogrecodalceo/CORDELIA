function remove_duplicates(input_list)
    local seen = {}
    local result = {}

    for _, value in ipairs(input_list) do
        if not seen[value] then
            table.insert(result, value)
            seen[value] = true
        end
    end

    return result
end

function main()
	-- Get the active MIDI editor
	local midiEditor = reaper.MIDIEditor_GetActive()

	if midiEditor then
		-- Get the active take in the MIDI editor
		local take = reaper.MIDIEditor_GetTake(midiEditor)


		if take then

			if reaper.MIDI_EnumSelNotes(take, 0) == -1 then
				reaper.ShowMessageBox("No selected notes.", "Error", 0)
				return
			end

			local track = reaper.GetMediaItemTake_Track(take)

			local info = {}
	
			-- Assuming 'take' and 'track' are defined before this code
			local note_index = 0

			while note_index do
				-- Get the selected notes in the active take
				local selected_note_index = reaper.MIDI_EnumSelNotes(take, note_index)
				
				-- If no selected notes were found
				if selected_note_index == -1 then
					break
				end

				local _, selected, _, _, _, _, pitch, _ = reaper.MIDI_GetNote(take, selected_note_index)

				if selected then
					--reaper.ShowMessageBox(freq, "Info", 0)

					table.insert(info, pitch)
				end

				-- Update note_index for the next iteration
				note_index = note_index + 1
			end

			--local res = table.concat(remove_duplicates(info), ', ')
			local res = table.concat(info, ', ')
			reaper.ShowConsoleMsg(res, "Info", 0)
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

main()