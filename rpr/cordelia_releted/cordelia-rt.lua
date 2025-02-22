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
local scripts = {
	"cordelia-rt-functions.lua",
	"cordelia-rt-main.lua",
}

-------------------------------------------------- END OF USER CONFIG AREA 1/2

-- PARENT SCRIPT CALL --------------------------------------------------------

for _, script in ipairs(scripts) do
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
end

---------------------------------------------------- END OF PARENT SCRIPT CALL

CORDELIA_PATH = '/Users/j/Documents/PROJECTs/CORDELIA/cordelia'

-- =================================================================
-- =================================================================
-- =================================================================

MIDI_CORRECTION = 512
EPSILON = 0.005  -- Small delta to adjust the play position

-- =================================================================
-- =================================================================
-- =================================================================

_, _, SECTION_ID, CMD_ID, _, _, _ = reaper.get_action_context()  -- Get the action context

-- =================================================================
-- =================================================================
-- =================================================================

local socket = require('socket.core')
local s = socket.udp()

function send_to_cordelia(message)
	-- log(message)
	-- Encode the message as a byte string before sending
	s:sendto(message, socket.dns.toip('localhost'), 10025)
end

init()
reaper.defer(main())
reaper.atexit(cleanup)

