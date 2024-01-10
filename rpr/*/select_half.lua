function main()
    -- Get the active MIDI editor
    local midi_editor = reaper.MIDIEditor_GetActive()
    if not midi_editor then return end
    
    -- Get the active take within the MIDI editor
    local take = reaper.MIDIEditor_GetTake(midi_editor)
    if not take then return end
    
    -- Get the number of notes in the take
    local note_count = reaper.MIDI_CountEvts(take)
    if note_count == 0 then return end
    
    -- Calculate the number of notes to select (half of the total)
    local notes_to_select = math.ceil(note_count / 2)
    
    -- Create a table to store the indices of the notes
    local note_indices = {}
    for i = 0, note_count - 1 do
        table.insert(note_indices, i)
    end
    
    -- Randomly select half of the notes
    for _ = 1, notes_to_select do
        -- Select a random index from the table
        local random_index = math.random(1, #note_indices)
        local note_index = note_indices[random_index]
        
        -- Get the note event at the current index
        local _, _, _, _, _, _, _, _, selected = reaper.MIDI_GetNote(take, note_index)
        
        -- Deselect the note by setting the "selected" flag to false
        reaper.MIDI_SetNote(take, note_index, false, 0)
        
        -- Remove the selected index from the table
        table.remove(note_indices, random_index)
    end
    
    -- Redraw the MIDI editor to reflect the changes
    reaper.MIDIEditor_OnCommand(midi_editor, reaper.NamedCommandLookup("_BR_ME_REFRESH"))
end

-- Run the main function
reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("randomly_select_half_of_notes", -1)
