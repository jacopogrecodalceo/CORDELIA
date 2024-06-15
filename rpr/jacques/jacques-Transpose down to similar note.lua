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

-- USER CONFIG AREA 1/2 ------------------------------------------------------

-- Dependency Name
local script = "jacques-Transpose to similar note-functions.lua" -- 1. The target script path relative to this file. If no folder, then it means preset file is right to the target script.

-------------------------------------------------- END OF USER CONFIG AREA 1/2

-- PARENT SCRIPT CALL --------------------------------------------------------

-- Get Script Path
local script_folder = debug.getinfo(1).source:match("@?(.*[\\|/])")
local script_path = script_folder .. script -- This can be erased if you prefer enter absolute path value above.

-- Prevent Init() Execution
preset_file_init = true

-- Run the Script
if reaper.file_exists( script_path ) then
  dofile( script_path )
else
  reaper.MB("Missing parent script.\n" .. script_path, "Error", 0)
  return
end

---------------------------------------------------- END OF PARENT SCRIPT CALL

local function main()

	local hwnd = reaper.MIDIEditor_GetActive()
	if not hwnd then return end

	local take = reaper.MIDIEditor_GetTake(hwnd)
	if not take then return end
	local track = reaper.GetMediaItemTake_Track(take)

	local tuning = get_tuning_list(track)
	if not tuning then return end
	
	reaper.PreventUIRefresh(1)
	reaper.Undo_BeginBlock()
	reaper.MIDI_DisableSort(take)

	local selected_notes = get_selected_notes(take)
	if not selected_notes then return end

	for _, note in ipairs(selected_notes) do
		note.freq = extract_freq_from_name(reaper.GetTrackMIDINoteNameEx(0, track, note.pitch, 0))
		local factor = find_transposition_down(tuning, note)
		reaper.MIDI_InsertNote(take, note.sel, note.muted, note.startppqpos, note.endppqpos, note.chan, note.pitch+factor, note.vel, true)
	end

	reaper.MIDI_Sort(take)
	reaper.Undo_EndBlock('Transpose to similar note', -1)
	reaper.PreventUIRefresh(-1)
	reaper.UpdateArrange()

end

main()