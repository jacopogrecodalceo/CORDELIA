-- USER CONFIG AREA 1/2 ------------------------------------------------------

-- Dependency Name
local script = 'func-user_inputs.lua' -- 1. The target script path relative to this file. If no folder, then it means preset file is right to the target script.

-------------------------------------------------- END OF USER CONFIG AREA 1/2

-- PARENT SCRIPT CALL --------------------------------------------------------

-- Get Script Path
local script_folder = debug.getinfo(1).source:match("@?(.*[\\|/])")
local script_path = script_folder .. script -- This can be erased if you prefer enter absolute path value above.

-- Run the Script
if reaper.file_exists( script_path ) then
  dofile( script_path )
else
  reaper.MB("Missing parent script.\n" .. script_path, "Error", 0)
  return
end

---------------------------------------------------- END OF PARENT SCRIPT CALL

SCRIPT_NAME = 'Repeat MIDI channel pattern'

local function replace_dots(string)
	local values = {}
	for value in string:gmatch("[^.]+") do
		table.insert(values, math.floor(value))
	end
	return values
end

local function main(pattern)

	-- Get the active MIDI editor
	local midiEditor = reaper.MIDIEditor_GetActive()
	if not midiEditor then return end

	-- Get the active take in the MIDI editor
	local take = reaper.MIDIEditor_GetTake(midiEditor)
	if not take then reaper.ShowMessageBox("No active MIDI editor.", "Error", 0) return end

	-- Select all note if no selection
	if reaper.MIDI_EnumSelNotes(take, 0) == -1 then
		reaper.MIDI_SelectAll(take, true)
	end

	local _, notes_count, _, _ = reaper.MIDI_CountEvts(take)
	for note_index = 0, notes_count - 1 do
		local  retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, note_index)

		if selected then
			local chan = pattern[note_index%notes_count]
			if chan >= 1 then
				chan = 1
			else
				chan = chan - 1
			end
			reaper.MIDI_SetNote(take, note_index, selected, muted, startppqpos, endppqpos, chan, pitch, vel, false)
		end

		-- Update the MIDI editor
		reaper.MIDI_Sort(take)
	end
end

-- this is a standard table
-- 
inputs = {
	-- name, default value
	{
		'pattern', '1.2'
	}
}

keys_csv, values_csv = get_csv(inputs)

--boolean retval, string retvals_csv = reaper.GetUserInputs(string title, integer num_inputs, string captions_csv, string retvals_csv)
local retval, retvals_csv = reaper.GetUserInputs(SCRIPT_NAME, #inputs, keys_csv, values_csv, 512)
if retval then
	local values = split_csv(retvals_csv)
	local pattern = replace_dots(values[1])
	reaper.Undo_BeginBlock()
	main(pattern)
	reaper.Undo_EndBlock(SCRIPT_NAME, -1)
end