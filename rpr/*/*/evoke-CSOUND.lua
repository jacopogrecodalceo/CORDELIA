
local temp_dir = '/Users/j/Documents/PROJECTs/_temp/'
local instr_dir = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/vault'
local py_script = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/exec_csound.py'

local OUTPUT_LENGTH, OUTPUT_POSITION
local MAIN_OUTPUT, SELECTED_GLUED_ITEM

function log(string)
	reaper.ShowConsoleMsg(tostring(string) .. '\n')
end

function extract_basename(file)
	-- Remove the directory path from the file_path using the last directory separator "/"
	local basename = file:match(".*/(.+)")
	-- Remove the extension from the basename
	basename = basename:match("(.+)%..+")
	return basename
end

function generate_unique_timestamp()
    local timestamp = os.date("%y%m%d_%H%M%S")
    return timestamp
end

function close_console()
	local title = reaper.JS_Localize('ReaScript console output', 'common')
	local hwnd = reaper.JS_Window_Find(title, true)
	if hwnd then reaper.JS_Window_Destroy(hwnd) end  
end

function read_orc(file_path)
    local file = io.open(file_path, "r")
    if not file then
        log("Error: Unable to open file.")
        return nil
    end

    local content = file:read("*all")
    file:close()
    return content
end

function find_orc_files_in_directory(directory_path)
	local orc_files_table = {} -- Table to store basename-path pairs

	local function ends_with(str, ending)
		return str:sub(-#ending) == ending
	end

	local dir_separator = package.config:sub(1,1) -- Get the directory separator based on the OS

	for file in io.popen('ls -1 "'..directory_path..'"'):lines() do
		if ends_with(file, ".orc") then
			local basename, extension = file:match("(.+)%.(.+)")
			orc_files_table[basename] = directory_path .. dir_separator .. file
		end
	end

	return orc_files_table
end

function write_file(file_path, string)
    local file = io.open(file_path, 'w')

    if file then
        file:write(string)
        file:close()
        return true
    else
        return false
    end
end

function glue_selected_items()

	local selected_items_count = reaper.CountSelectedMediaItems(0)

	if selected_items_count == 0 then
		log('No item selected')
		return
	end

	-- Glue items
	reaper.Main_OnCommand(40362, 0)

	-- Get glued item source
	local item = reaper.GetSelectedMediaItem(0, 0) -- Get selected item i
	local take = reaper.GetActiveTake(item)
	local source = reaper.GetMediaItemTake_Source(take)
	local input_file = reaper.GetMediaSourceFileName(source, "")
	OUTPUT_LENGTH = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
	OUTPUT_POSITION = reaper.GetMediaItemInfo_Value(item, "D_POSITION")

	-- Undo glue
	reaper.Main_OnCommand(40029, 0)

	return input_file, position, length

end

--[[ function get_channels(input_file)
    local file = io.popen('soxi -c "' .. input_file .. '"')
    local output = file:read("*all")
    file:close()
    return tonumber(output:match("^%s*(.-)%s*$"))
end

function make_each_mono(input_file)
	local output_files = {}
	local basename = input_file:match("([^/\\]-)%.[^./\\]*$")
	for i = 1, get_channels(input_file) do
		local output_file = temp_dir .. basename .. '-' .. i .. 'ch.wav'
		local sox_cmd = 'sox "' .. input_file .. '"' .. ' ' .. '"' .. output_file .. '"' .. ' remix ' .. i
		local success = os.execute(sox_cmd)
		if not success then
			log('Error executing the SOX command: ' .. sox_cmd)
			return
		end
		table.insert(output_files, output_file)
	end
	return output_files
end ]]

--[[ function make_atsa(input_file)
	local output_files = {}
	local basename = input_file:match("([^/\\]-)%.[^./\\]*$")
	local output_file = temp_dir .. basename .. '.ats'
	local atsa_cmd = 'atsa "' .. input_file .. '"' .. ' ' .. '"' .. output_file .. '"'
	local success = os.execute(atsa_cmd)
	if not success then
		log('Error executing the ATSA command: ' .. atsa_cmd)
		return
	end
	table.insert(output_files, output_file)
	return output_files
end ]]


local ctx = reaper.ImGui_CreateContext('Cordelia offline')
local csound_code = 'default text'

reaper.ImGui_SetNextWindowSize(ctx, 610, 940, 1)
reaper.ImGui_Text(ctx, 'Csound instrument')
local popups  = {}
--local popups_name = { 'Bream', 'Haddock', 'Mackerel', 'Pollock', 'Tilefish' }

local orc_files = find_orc_files_in_directory(instr_dir)
local popups_name = {}
for orc, _ in pairs(orc_files) do
    table.insert(popups_name, orc)
end

if not popups.popups then
	popups.popups = {
	  selected_fish = -1,
	  toggles = { true, false, false, false, false },
	}
end

local lasttime = os.time()
local status = false

function wait_for_file()

	local check_file = MAIN_OUTPUT .. '--finished'
	local retval = reaper.file_exists(check_file)

	if not retval and not status then

		local newtime = os.time()

		if newtime-lasttime >= 3.5 then
			lasttime = newtime
			log('Looking for..' .. extract_basename(check_file))

			reaper.defer(wait_for_file)	
		end

		reaper.defer(wait_for_file)	

	elseif retval and not status then

		log('Done!')

		local track_index = reaper.GetNumTracks()
		reaper.InsertTrackAtIndex(track_index, true) -- Create a new track
	
		local track = reaper.GetTrack(0, track_index)
		
		-- Add the WAV file to the track
		local item = reaper.AddMediaItemToTrack(track)
		local take = reaper.AddTakeToMediaItem(item)
		local source = reaper.PCM_Source_CreateFromFile(MAIN_OUTPUT)
		reaper.SetMediaItemTake_Source(take, source)
		reaper.PCM_Source_BuildPeaks(source, 0)
		
		reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", extract_basename(MAIN_OUTPUT), true)
		reaper.SetMediaItemInfo_Value(item, "D_POSITION", OUTPUT_POSITION)
		-- Adjust the item length to match the WAV file length
		local source_length = reaper.GetMediaSourceLength(reaper.GetMediaItemTake_Source(take))
		reaper.SetMediaItemInfo_Value(item, "D_LENGTH", source_length)
		
		-- Remove files
		os.remove(SELECTED_GLUED_ITEM)
		os.remove(check_file)
		
		close_console()

		status = true

	end
	
end

function defer_GUI()

	local visible, keep_GUI_open = reaper.ImGui_Begin(ctx, 'Cordelia offline', true)

	if visible then

		if reaper.ImGui_Button(ctx, 'Select..') then
			reaper.ImGui_OpenPopup(ctx, 'my_select_popup')
		end
		reaper.ImGui_SameLine(ctx)
		local b_retval = reaper.ImGui_Button(ctx, 'ok', 70)
		reaper.ImGui_Text(ctx, popups_name[popups.popups.selected_fish] or '<None>')
		if reaper.ImGui_BeginPopup(ctx, 'my_select_popup') then
			reaper.ImGui_SeparatorText(ctx, 'Aquarium')
			for i, fish in ipairs(popups_name) do
				if reaper.ImGui_Selectable(ctx, fish) then
					popups.popups.selected_fish = i
					csound_code = [[
sr      = 48000
ksmps   = 32
nchnls  = 2
					]]
					csound_code = csound_code .. '\n' .. read_orc(orc_files[fish])
				end
			end
			reaper.ImGui_EndPopup(ctx)
		end


		local retval, return_code = reaper.ImGui_InputTextMultiline(ctx, '##Csound code', csound_code, 500, 850, reaper.ImGui_InputTextFlags_AllowTabInput())
		if retval then csound_code = return_code end
		reaper.ImGui_SameLine(ctx)
		local s_retval = reaper.ImGui_Button(ctx, 'save')

		if s_retval then
			local retval, path = reaper.JS_Dialog_BrowseForSaveFile('Save me', instr_dir, '', '')
			if retval then
				write_file(path .. '.orc', csound_code)
			end
		end

		if b_retval then
			SELECTED_GLUED_ITEM = glue_selected_items()
			local basename = extract_basename(SELECTED_GLUED_ITEM)
			basename = string.gsub(basename, "-glued", "")

			local unique_timestamp = generate_unique_timestamp()

			local output_file_orc = temp_dir .. basename .. '-CS' .. unique_timestamp .. '.orc'
			write_file(output_file_orc, csound_code)
			MAIN_OUTPUT = temp_dir .. basename .. '-CS' .. unique_timestamp .. '.wav'
			local command = string.format('/opt/homebrew/bin/python3 "%s" "%s" "%s" "%s"', py_script, SELECTED_GLUED_ITEM, output_file_orc, MAIN_OUTPUT)
			reaper.ExecProcess(command, -2)
			log(command)

			wait_for_file()
			keep_GUI_open = false
		end

		reaper.ImGui_End(ctx)

	end

	if keep_GUI_open then
		reaper.defer(defer_GUI)
	end

end

local selected_items_count = reaper.CountSelectedMediaItems(0)

if selected_items_count > 0 then
	reaper.defer(defer_GUI)
else
	log('No item selected')
end
