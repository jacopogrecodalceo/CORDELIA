local temp_dir = '/Users/j/Documents/PROJECTs/_temp/'

local OUTPUT_LENGTH, OUTPUT_POSITION
local MAIN_OUTPUT, SELECTED_GLUED_ITEM

function log(string)
	reaper.ShowConsoleMsg(tostring(string) .. '\n')
end

function log_table(table, indent)
    indent = indent or 0
    local indentStr = string.rep(" ", indent)

    for key, value in pairs(table) do
        if type(value) == "table" then
            log(indentStr .. key .. ": {")
            log_table(value, indent + 4)
            log(indentStr .. "}")
        else
            log(indentStr .. key .. ": " .. tostring(value))
        end
    end
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




local lasttime = os.time()
local status = false
local close_GUI = false
local close_progress_bar = false
function wait_for_file()

	local check_file = MAIN_OUTPUT .. '--finished'
	local retval = reaper.file_exists(check_file)

	if not retval and not status then

		local newtime = os.time()

		if newtime-lasttime >= 3.5 then
			lasttime = newtime
			--log('Looking for..' .. extract_basename(check_file))

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

		close_progress_bar = true
		status = true

	end
	
end


local cs_option = {
	sr = 48,
	ksmps = 32,
	channels = 2
}


local ctx = reaper.ImGui_CreateContext('Cordelia offline')
local csound_code = 'default text'

reaper.ImGui_SetNextWindowSize(ctx, 650, 995, 1)
reaper.ImGui_Text(ctx, 'Csound instrument')

methods = {
	ATS = {
		dir = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/ATS',
		script = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/exec_csound-ATS.py'
	},
	CS = {
		dir = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS',
		script = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/exec_csound-CS.py'
	},
	LPC = {
		dir = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/LPC',
		script = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/exec_csound-LPC.py'
	}
}

--[[
CS: {
    files: {
        klast_vco2: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS/klast_vco2.orc
        buzz_double: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS/buzz_double.orc
        buzz: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS/buzz.orc
        fractalnoi_slow: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS/fractalnoi_slow.orc
        fractalnoi: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS/fractalnoi.orc
        buzz_double-samphold: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS/buzz_double-samphold.orc
    }
    script: /Users/j/Documents/PROJECTs/CORDELIA/rpr/exec_csound-CS.py
    dir: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS
}
]]

local function convert_table(input_table)
    local keys = {}

    for k, _ in pairs(input_table) do
        table.insert(keys, k)
    end

	table.sort(keys)

    return keys
end

for method, tab in pairs(methods) do
	tab.files = find_orc_files_in_directory(tab.dir)
	tab.basenames = convert_table(tab.files)
end

function tab_context(method_name)

	local sr_retval, sr_val = reaper.ImGui_InputText(ctx, 'sample rate', cs_option.sr)
	if sr_retval then cs_option.sr = sr_val end
	local ksmps_retval, ksmps_val = reaper.ImGui_InputText(ctx, 'ksmps', cs_option.ksmps)
	if ksmps_retval then cs_option.ksmps = ksmps_val end
	local channels_retval, channels_val = reaper.ImGui_InputText(ctx, 'channels', cs_option.channels)
	if channels_retval then cs_option.channels = channels_val end

	local method = methods[method_name]
	if reaper.ImGui_Button(ctx, 'Select..') then
		reaper.ImGui_OpenPopup(ctx, 'Instrument popup')
	end

	reaper.ImGui_SameLine(ctx)
	local b_retval = reaper.ImGui_Button(ctx, 'ok', 70)
	
	reaper.ImGui_Text(ctx, method.selected or '<None>')
	if reaper.ImGui_BeginPopup(ctx, 'Instrument popup') then
		reaper.ImGui_SeparatorText(ctx, 'Aquarium')

		for _, basename in pairs(method.basenames) do
			if reaper.ImGui_Selectable(ctx, basename) then
				method.selected = basename
				csound_code = read_orc(method.files[basename])
			end
		end
		reaper.ImGui_EndPopup(ctx)
	end

	local retval, return_code = reaper.ImGui_InputTextMultiline(ctx, '##Csound code', csound_code, 550, 805, reaper.ImGui_InputTextFlags_AllowTabInput())
	if retval then csound_code = return_code end
	reaper.ImGui_SameLine(ctx)
	local s_retval = reaper.ImGui_Button(ctx, 'save')

	if s_retval then
		local retval, path = reaper.JS_Dialog_BrowseForSaveFile('Save me', method.dir, '', '')
		local save_to
		if string.sub(path, -4) == ".orc" then
			save_to = path
		else
			save_to = path .. '.orc'

		end

		if retval then
			write_file(save_to, csound_code)
		end
	end
	
	if b_retval then
		SELECTED_GLUED_ITEM = glue_selected_items()
		local basename = extract_basename(SELECTED_GLUED_ITEM)
		basename = string.gsub(basename, "-glued", "")

		local unique_timestamp = generate_unique_timestamp()

		local output_file_orc = temp_dir .. basename .. '-' .. method.selected .. unique_timestamp .. '.orc'
		csound_code = string.format("sr\t= %d\nksmps\t= %d\nnchnls\t= %d\n\n\n%s",
			cs_option.sr * 1000,
			cs_option.ksmps,
			cs_option.channels,
			csound_code
		)
		write_file(output_file_orc, csound_code)
		MAIN_OUTPUT = temp_dir .. basename .. '-' .. method.selected .. unique_timestamp .. '.wav'
		local command = string.format('/opt/homebrew/bin/python3 "%s" "%s" "%s" "%s"', method.script, SELECTED_GLUED_ITEM, output_file_orc, MAIN_OUTPUT)
		reaper.ExecProcess(command, -2)
		log(command)
		close_GUI = true

		wait_for_file()
		loop_progress_bar()
	end

end


function defer_GUI()

	local visible, keep_GUI_open = reaper.ImGui_Begin(ctx, 'Cordelia offline', true)

	if visible then

		if reaper.ImGui_BeginTabBar(ctx, 'CS_TAB') then

			local item_name = 'CS'
			reaper.ImGui_SetNextItemWidth(ctx, 100)
			if reaper.ImGui_BeginTabItem(ctx, item_name) then
				tab_context(item_name)
				reaper.ImGui_EndTabItem(ctx)
			end
			item_name = 'ATS'
			reaper.ImGui_SetNextItemWidth(ctx, 100)
			if reaper.ImGui_BeginTabItem(ctx, item_name) then
				tab_context(item_name)
			  	reaper.ImGui_EndTabItem(ctx)
			end
			item_name = 'LPC'
			reaper.ImGui_SetNextItemWidth(ctx, 100)
			if reaper.ImGui_BeginTabItem(ctx, item_name) then
				tab_context(item_name)
			  	reaper.ImGui_EndTabItem(ctx)
			end

			reaper.ImGui_EndTabBar(ctx)
		end

		reaper.ImGui_End(ctx)

		if close_GUI then keep_GUI_open = false end
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



local progress_bar = {}
local lasttime_pbar = os.time()
if not progress_bar.plots then
	progress_bar.plots = {
	  progress     = 0.0
	}
end

function loop_progress_bar()
	reaper.ImGui_SetNextWindowSize(ctx, 300, 60, 1)

	local visible, open = reaper.ImGui_Begin(ctx, 'Loading..', true)
	
	if visible then

		local newtime = os.time()

		if newtime-lasttime_pbar < OUTPUT_LENGTH then
			progress_bar.plots.progress = (progress_bar.plots.progress + (newtime-lasttime_pbar))/OUTPUT_LENGTH			
		end
		-- Typically we would use (-1.0,0.0) or (-FLT_MIN,0.0) to use all available width,
		-- or (width,0.0) for a specified width. (0.0,0.0) uses ItemWidth.
		local buf = ('%.02f/%.02fs'):format(progress_bar.plots.progress * OUTPUT_LENGTH, OUTPUT_LENGTH)
		reaper.ImGui_ProgressBar(ctx, progress_bar.plots.progress, -1, 0, buf)

		reaper.ImGui_End(ctx)
		if close_progress_bar then
			open = false
			visible = false
		end
	end

	if open then
		reaper.defer(loop_progress_bar)
	end
end
