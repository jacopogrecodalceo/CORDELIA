-- Dependency Name

local dependency_scripts = {
	'csv',
	'regex',
}

-- PARENT SCRIPT CALL --------------------------------------------------------

local script_source = debug.getinfo(1).source

local script_folder = script_source:match("@?(.*[\\|/])")
local script_name = script_source:match("([^\\/:]+)$")

for _, dependency_script in pairs(dependency_scripts) do
	dependency_script = 'func-' .. dependency_script .. '.lua'
	local script_path = script_folder .. dependency_script -- This can be erased if you prefer enter absolute path value above.

	-- Run the Script
	if reaper.file_exists( script_path ) then
		dofile( script_path )
	else
		reaper.MB("Missing parent script.\n" .. script_path, "Error", 0)
		return
	end
end

---------------------------------------------------- END OF PARENT SCRIPT CALL

function main(pattern)

	-- Get the active MIDI editor
	local midi_editor = reaper.MIDIEditor_GetActive()
	if not midi_editor then return end

	-- Get the active take in the MIDI editor
	local take = reaper.MIDIEditor_GetTake(midi_editor)
	if not take then reaper.ShowMessageBox("No active MIDI editor", "Error", 0) return end

	-- Select all note if no selection
	if reaper.MIDI_EnumSelNotes(take, 0) == -1 then
		reaper.MIDI_SelectAll(take, true)
	end

	local patterns = {}

	local _, notes_count, _, _ = reaper.MIDI_CountEvts(take)
	for note_index = 0, notes_count - 1 do
		local _retval, selected, muted, startppqpos, endppqpos, _chan, pitch, vel = reaper.MIDI_GetNote(take, note_index)

		if selected then
			local channel = pattern[(note_index % #pattern) + 1]

			--[[
			In Cordelia if the channel is 1, it will create an event for all speakers.
			Otherwise, it will be needed to set channel + 1.

			BUT, Reaper set channel 0 as channel 1 - so everything will be fine!
			e.g.
			for a note in channel 1 (usually the left speaker in Cordelia),
			you need to set the target channel to 2.
			--]]

			--channel = channel + 1
			table.insert(patterns, channel)
			reaper.MIDI_SetNote(take, note_index, selected, muted, startppqpos, endppqpos, channel, pitch, vel, false)
		end

	end
	-- Update the MIDI editor
	reaper.MIDI_Sort(take)
	--reaper.ShowConsoleMsg("Patterns: " .. table.concat(patterns, ", "), "Channel Patterns", 0)
end


inputs = {
	{
		'pattern (e.g., 1.2.3, 0=all channels)', '1.2'
	}
}

keys_csv, values_csv = get_csv(inputs)

--[[
boolean retval, string retvals_csv = reaper.GetUserInputs(string title, integer num_inputs, string captions_csv, string retvals_csv)
Maximum fields is 16.
Values are returned as a comma-separated string.
Returns false if the user canceled the dialog.

You can supply special extra information via additional caption fields: extrawidth=XXX to increase text field width, separator=X to use a different separator for returned fields.
--]]

local retval, retvals_csv = reaper.GetUserInputs(script_name, #inputs, keys_csv, values_csv, 512)
if retval then
	local values = split_csv(retvals_csv)
	local pattern = replace_dots(values[1])

	reaper.Undo_BeginBlock()
	main(pattern)
	reaper.Undo_EndBlock(script_name, -1)
end