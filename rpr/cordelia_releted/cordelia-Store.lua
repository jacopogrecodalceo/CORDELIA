-- USER CONFIG AREA 1/2 ------------------------------------------------------

-- Dependency Name
local script = "cordelia-functions.lua" -- 1. The target script path relative to this file. If no folder, then it means preset file is right to the target script.

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

---------------------------------------------------- END OF PARENT SCRIPT CAL

-- =================================================================
-- =================================================================
-- =================================================================

MIDI_CORRECTION = 512
MAIN_TRACK_NAME = '_main'

-- =================================================================
-- =================================================================
-- =================================================================

function split_csv(csv)
	local values = {}
	for value in csv:gmatch("[^,]+") do
		table.insert(values, value)
	end
	return values
end

local retval, retvals_csv = reaper.GetUserInputs('Render with', 3, 'channels, sample rate, ksmps', '2,48,64', 512)

if retval then

	local values = split_csv(retvals_csv)
	local channels = values[1]
	local sr = tonumber(values[2]) * 1000
	local ksmps = values[3]

	--store_main(channels, tostring(sr), ksmps)
	store_tracks(channels, tostring(sr), ksmps)

end

