--[[
* ReaScript Name: List all audio takes paths in the console
* About: A simple code snippet
* Author: X-Raym
* Author URI: https://www.extremraym.com
* Repository: GitHub > X-Raym > REAPER-ReaScripts
* Repository URI: https://github.com/X-Raym/REAPER-ReaScripts
* Licence: GPL v3
* Forum Thread:
* Forum Thread URI:
* REAPER: 5.0
* Version: 1.2
--]]

--[[
* Changelog:
* v1.2 (2015-12-16)
+ Sorting option
* v1.1 (2015-12-16)
+ Minimalist report
+ Possibility to delete duplicates sources
+ User Config Area
# All items real support (1.0 had a 250 items limitations)
* v1.0 (2015-07-14)
+ Initial Release
--]]

-- GLOBAL VARIABLEs
SCRIPT_NAME = 'Copy these files in project directory?'
TEMP_DIR = '/Users/j/Documents/temp/'
COUNT_ITEMs = reaper.CountMediaItems(0)
TEMP_SOURCEs = {}
MAIN_MESSAGE = ''

PROJECT_DIR = reaper.GetProjectPath(0)

-- Initialize ReaImGui context
local ctx = reaper.ImGui_CreateContext(SCRIPT_NAME)

local function add_message(string)
	--reaper.ShowConsoleadd_message(val..'\n')
	MAIN_MESSAGE = MAIN_MESSAGE .. string .. '\n'
end

-- Count the number of times a value occurs in a table
local function table_count(tt, item)
	local count
	count = 0
	for _, xx in pairs(tt) do
		if item == xx then count = count + 1 end
	end
	return count
end

-- Remove duplicates from a table array
local function table_unique(tt)
	local newtable
	newtable = {}
	for ii, xx in ipairs(tt) do
		if(table_count(newtable, xx) == 0) then
			newtable[#newtable+1] = xx
		end
	end
	return newtable
end

local function get_basename(path)
    -- Extract the filename from the path
    local name = path:match("^.+/(.+)$") or path
    -- Remove the file extension
    local basename = name:match("^(.-)%.[^%.]*$") or name

    return basename
end

local function list_path_in_temp(name)
    local paths = {}
    local handle

    -- Determine the platform and execute the appropriate command
    if package.config:sub(1, 1) == '\\' then
        -- Windows
        handle = io.popen('dir "' .. TEMP_DIR .. '" /b')
    else
        -- Unix-based (Linux, macOS)
        handle = io.popen('ls "' .. TEMP_DIR .. '"')
    end

    -- Read the command output
    if handle then
        for path in handle:lines() do
			if string.find(path, name, 1, true) then
            	table.insert(paths, path)
			end
        end
        handle:close()
    else
        error("Failed to list directory contents")
    end

    return paths
end

local function add_other_files()
	local new_table = {}
	for _, temp_source in pairs(TEMP_SOURCEs) do
		local basename = get_basename(temp_source)
		local paths = list_path_in_temp(basename)
		for _, path in pairs(paths) do
			table.insert(new_table, path)
		end
	end

	add_message('\n\n\n')
	add_message('The following files will be copied inside the project directory:')
	add_message(PROJECT_DIR)
	add_message('==========')
	TEMP_SOURCEs = {}
	for _, file in pairs(new_table) do
		table.insert(TEMP_SOURCEs, file)
		add_message(file)
	end
	add_message('==========')

end

local function copy_files()
	for _, temp_basename in pairs(TEMP_SOURCEs) do

		local original_path = TEMP_DIR .. temp_basename
		local destination_path = PROJECT_DIR .. '/' .. temp_basename

		-- Open the source file in read mode
		local source_file = io.open(original_path, "rb")
		if not source_file then
			return false, 'Could not open source file'
		end

		-- Read the entire contents of the source file
		local content = source_file:read("*all")
		source_file:close()

		-- Open the destination file in write mode
		local destination_file = io.open(destination_path, "wb")
		if not destination_file then
			return false, 'Could not open destination file'
		end

		-- Write the contents to the destination file
		destination_file:write(content)
		destination_file:close()

	end

	return true
end


local function fill_message()

	local sources = {}

	-- Loop in Items
	for i = 0, COUNT_ITEMs - 1 do

		local item = reaper.GetMediaItem(0, i)
		local take = reaper.GetActiveTake(item)

		if take ~= nil then

			if reaper.TakeIsMIDI(take) == false then
				local path = reaper.GetMediaSourceFileName(reaper.GetMediaItemTake_Source(take), '')
				if path ~= '' then table.insert(sources, path) end
			end

		end

	end

	sources = table_unique(sources)
	table.sort(sources)

	local other_sources = {}

	for i, source in ipairs(sources) do
		if string.find(source, '/temp/') then
			table.insert(TEMP_SOURCEs, source)
		else
			table.insert(other_sources, source)
		end
	end

	-- Display results
	add_message('==========')
	add_message('TEMP SOURCEs used in this project')
	for i, temp_source in ipairs(TEMP_SOURCEs) do
		add_message(temp_source)
	end
	add_message('==========')
	add_message('OTHER SOURCEs used in this project')
	for i, file in ipairs(other_sources) do
		add_message(file)
	end
	add_message('==========')
	--reaper.ShowMessageBox(MAIN_MESSAGE, 'Copy ' .. #TEMP_SOURCEs .. ' files inside the project folder', 1)
end

-- Function that runs the GUI
local function main()
	-- Begin the ImGui frame, and ensure the window stays open
	local visible, open = reaper.ImGui_Begin(ctx, 'Simple GUI', true)

	local text = MAIN_MESSAGE
	
	-- Get the size of the text
	local text_width, text_height = reaper.ImGui_CalcTextSize(ctx, text)

	-- Calculate window size based on text size, adding padding for buttons and margins
	local window_width = text_width + 20 -- Adjust as needed
	local window_height = text_height + 60 -- Adjust for buttons and spacing

	-- Set the window size to fit the content
	reaper.ImGui_SetNextWindowSize(ctx, window_width, window_height, reaper.ImGui_Cond_Always())

	-- Proceed only if the window is visible
	if visible then
		-- Display some text in the window
		reaper.ImGui_Text(ctx, text)

		-- Create buttons and handle their events
		if reaper.ImGui_Button(ctx, 'Ok') then
			-- Perform an action if OK is clicked
			local success, err = copy_files()
			if success then
				reaper.ShowMessageBox('Files copied successfully.', 'YUP', 0)
			else
				reaper.ShowMessageBox(err, 'ERROR', 0)
			end

			open = false
		end

		-- Add some spacing between buttons
		reaper.ImGui_SameLine(ctx)

		if reaper.ImGui_Button(ctx, 'Cancel') then
			-- Close the script without performing any action
			open = false
		end

		-- End the ImGui window
		reaper.ImGui_End(ctx)
	end

	-- If the window should still be open, keep running the script
	if open then
		reaper.defer(main)
	end
end

-- INIT
if COUNT_ITEMs > 0 then
	fill_message()
	add_other_files()

	if #TEMP_SOURCEs > 0 then
		main()
	else
		reaper.ShowMessageBox('No temporary files in temp directory!', 'PAS DE PROBLÈMEs', 0)
	end
end