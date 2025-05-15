MAIN_CORDELIA_PATH = '/Users/j/Documents/PROJECTs/CORDELIA/'
REMOVE_FILEs = true

Paths = {
	general_functions = MAIN_CORDELIA_PATH .. 'rpr/reaper_general_functions.lua',
	instr_json = MAIN_CORDELIA_PATH .. 'cordelia/config/' .. 'INSTR.json',
	gen_json = MAIN_CORDELIA_PATH .. 'cordelia/config/' .. 'GEN.json',
	methods = MAIN_CORDELIA_PATH .. 'rpr/cordelia_csound/csound_methods/',
	temp = '/Users/j/Documents/temp/'
}

Methods = {
	ATS = {
		dir = Paths.methods .. 'ATS',
		script = Paths.methods .. 'ATS.py'
	},
	CS = {
		dir = Paths.methods .. 'CS',
		script = Paths.methods .. 'CS.py',
	},
	LPC = {
		dir = Paths.methods .. 'LPC',
		script = Paths.methods .. 'LPC.py',
	},
	PVS = {
		dir = Paths.methods .. 'PVS',
		script = Paths.methods .. 'PVS.py',
	},
	PVSrt = {
		dir = Paths.methods .. 'PVSrt',
		script = Paths.methods .. 'PVSrt.py',
	}
}

for _, path in pairs(Paths) do
	if not reaper.file_exists(path) then
		reaper.ShowConsoleMsg('Warning, an init file is missing')
	end
end

dofile(Paths.general_functions)

INSTR_JSON = io.open(Paths.instr_json, 'r')
GEN_JSON = io.open(Paths.gen_json, 'r')

TEMP_DIRECTORY = Paths.temp

local OUTPUT_LENGTH, OUTPUT_POSITION
local MAIN_OUTPUT, SELECTED_GLUED_ITEM, GLUED_ITEM_TRACK

CSOUND_OPTIONs = {
	sr = 48,
	ksmps = 64,
}

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

function get_info_from_items()
	local selected_items_count = reaper.CountSelectedMediaItems(0)

	local channels = {}

	for i = 0, selected_items_count-1  do
		-- GET ITEMS
		local item = reaper.GetSelectedMediaItem(0, i) -- Get selected item i
		local take = reaper.GetActiveTake(item)
		local source = reaper.GetMediaItemTake_Source(take)
		local input_file = reaper.GetMediaSourceFileName(source, "")
		table.insert(channels, reaper.GetMediaSourceNumChannels(source))
	end
	CSOUND_OPTIONs.channels = math.max(table.unpack(channels))
end

function glue_selected_items()
	local selected_items_count = reaper.CountSelectedMediaItems(0)

	if selected_items_count == 0 then
		log('No item selected')
		return
	end

	reaper.PreventUIRefresh(1)
	local current_cursor_pos = reaper.GetPlayPosition()
	OUTPUT_POSITION = reaper.GetMediaItemInfo_Value(reaper.GetSelectedMediaItem(0, 0), "D_POSITION")
	-- Duplicate items
	reaper.Main_OnCommand(41295, 0)

	-- Glue items
	reaper.Main_OnCommand(40362, 0)

	local glued_item = reaper.GetSelectedMediaItem(0, 0)
	local take = reaper.GetActiveTake(glued_item)

	-- Get glued item source
	local source = reaper.GetMediaItemTake_Source(take)
	local input_file = reaper.GetMediaSourceFileName(source, "")
	OUTPUT_LENGTH = reaper.GetMediaItemInfo_Value(glued_item, "D_LENGTH")

	-- Remove item
	GLUED_ITEM_TRACK = reaper.GetMediaItem_Track(glued_item)
	reaper.DeleteTrackMediaItem(GLUED_ITEM_TRACK, glued_item)
	reaper.PreventUIRefresh(-1)
	reaper.SetEditCurPos(current_cursor_pos, true, false )

	return input_file

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
		local output_file = TEMP_DIRECTORY .. basename .. '-' .. i .. 'ch.wav'
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
	local output_file = TEMP_DIRECTORY .. basename .. '.ats'
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
		local delta_time = 1.5

		if newtime-lasttime >= delta_time then
			lasttime = newtime
			--log('Looking for..' .. extract_basename(check_file))

			reaper.defer(wait_for_file)
		end

		reaper.defer(wait_for_file)

	elseif retval and not status then

		log('Done!')
		local track_index = reaper.GetMediaTrackInfo_Value(GLUED_ITEM_TRACK, 'IP_TRACKNUMBER') --reaper.GetNumTracks()
		reaper.InsertTrackAtIndex(track_index, true) -- Create a new track

		local track = reaper.GetTrack(0, track_index)
		reaper.SetMediaTrackInfo_Value(track, "I_NCHAN", CSOUND_OPTIONs.channels)

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
		if REMOVE_FILEs then
			os.remove(SELECTED_GLUED_ITEM)
			os.remove(check_file)
			close_console()
		end

		close_progress_bar = true
		status = true

	end

end




local ctx = reaper.ImGui_CreateContext('Cordelia offline')
local csound_code = 'default text'
local method_selected

reaper.ImGui_SetNextWindowSize(ctx, 650, 995, 1)
reaper.ImGui_Text(ctx, 'Csound instrument')

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

popup_prefix = '---'

function create_popup_list()
	local group_names = {}
	local popup_list = {}

	for method, tab in pairs(Methods) do
		table.insert(group_names, method)
	end

	table.sort(group_names)

	for i, group_name in ipairs(group_names) do
		local method = Methods[group_name]
		local files = find_orc_files_in_directory(method.dir)
		method.files = files
		files = convert_table(files)

		popup_list[#popup_list+1] = popup_prefix .. group_name
		for j, file in ipairs(files) do
			table.insert(popup_list, file)
		end
	end

	return popup_list
end

popup = {
	list = {},
	selected_group = ''
}

popup.list = create_popup_list()

function startswith(text, prefix)
    return text:find(prefix, 1, true) == 1
end

local selected_group

function main_context()

	local sr_retval, sr_val = reaper.ImGui_InputText(ctx, 'sample rate', CSOUND_OPTIONs.sr)
	if sr_retval then CSOUND_OPTIONs.sr = sr_val end
	local ksmps_retval, ksmps_val = reaper.ImGui_InputText(ctx, 'ksmps', CSOUND_OPTIONs.ksmps)
	if ksmps_retval then CSOUND_OPTIONs.ksmps = ksmps_val end
	local channels_retval, channels_val = reaper.ImGui_InputText(ctx, 'channels', CSOUND_OPTIONs.channels)
	if channels_retval then CSOUND_OPTIONs.channels = channels_val end

	if reaper.ImGui_Button(ctx, 'Select..') then
		reaper.ImGui_OpenPopup(ctx, 'Instrument popup')
	end

	reaper.ImGui_SameLine(ctx)

	local b_retval = reaper.ImGui_Button(ctx, 'ok', 70)

	reaper.ImGui_Text(ctx, popup.selected_basename or '<None>')
	if reaper.ImGui_BeginPopup(ctx, 'Instrument popup') then

		for i, name in ipairs(popup.list) do

			if startswith(name, popup_prefix) then
				popup.selected_group = string.gsub(name, popup_prefix, '')
				reaper.ImGui_SeparatorText(ctx, popup.selected_group)
			else
				if reaper.ImGui_Selectable(ctx, name) then
					popup.selected_basename = name
					local path = Methods[popup.selected_group].files[name]
					method_selected = Methods[popup.selected_group]
					csound_code = read_orc(path)
					selected_group = popup.selected_group
				end
			end

		end
		reaper.ImGui_EndPopup(ctx)
	end


	local retval, return_code = reaper.ImGui_InputTextMultiline(ctx, '##Csound code', csound_code, 550, 805, reaper.ImGui_InputTextFlags_AllowTabInput())
	if retval then csound_code = return_code end

	for word in csound_code:gmatch("%S+") do
		if INSTR_JSON[word] ~= nil then
			reaper.ShowConsoleMsg(word)
			csound_code = '#include "' .. INSTR_JSON[word]['path'] .. '"\n' .. csound_code
		end
		if GEN_JSON[word] ~= nil then
			csound_code = '#include "' .. INSTR_JSON[word]['path'] .. '"\n' .. csound_code
		end
	end

	reaper.ImGui_SameLine(ctx)
	local s_retval = reaper.ImGui_Button(ctx, 'save')

	if s_retval then
		local retval, path = reaper.JS_Dialog_BrowseForSaveFile('Save me', Methods[selected_group].dir, '', '')
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

		local output_file_orc = TEMP_DIRECTORY .. basename .. '-' .. popup.selected_basename .. unique_timestamp .. '.orc'
		csound_code = string.format("sr\t= %d\nksmps\t= %d\nnchnls\t= %d\n\n\n%s",
			CSOUND_OPTIONs.sr * 1000,
			CSOUND_OPTIONs.ksmps,
			CSOUND_OPTIONs.channels,
			csound_code
		)

		-- INCLUDE MACROs IF THERE'S A FILE NAMED
		if method_selected then
			local MACROs_path = method_selected.dir .. '/_MACROs.orc'
			if reaper.file_exists(MACROs_path) then
				local file = io.open(MACROs_path, 'r')
				csound_code = file:read('*a') .. '\n' .. csound_code
				file:close()
			end
		end

		write_file(output_file_orc, csound_code)
		MAIN_OUTPUT = TEMP_DIRECTORY .. basename .. '-' .. popup.selected_basename .. unique_timestamp .. '.wav'
		local command = string.format('/opt/homebrew/bin/python3.11 "%s" "%s" "%s" "%s"', Methods[selected_group].script, SELECTED_GLUED_ITEM, output_file_orc, MAIN_OUTPUT)
		--log(command)
		reaper.ExecProcess(command, -2)
		--io.popen(command)
		--log(command)
		close_GUI = true

		wait_for_file()
		loop_progress_bar()
	end

end

theme_colors = {
	Border = 0xBFAF00FF,  -- Dark Pastel Yellow
	Button = 0xCDCD00FF,  -- Dark Pastel Yellow
	ButtonActive = 0xB5A200FF,  -- Dark Pastel Yellow
	ButtonHovered = 0xD6D600FF,  -- Dark Pastel Yellow
	FrameBg = 0xCDCD00FF,  -- Dark Pastel Yellow
	FrameBgHovered = 0xE6E600FF,  -- Dark Pastel Yellow
	Header = 0xB5A200FF,  -- Dark Pastel Yellow
	HeaderActive = 0x8C7A0087,  -- Dim Dark Pastel Yellow
	HeaderHovered = 0xB5A200FF,  -- Dark Pastel Yellow
	ResizeGrip = 0xB5A200FF,  -- Dark Pastel Yellow
	ResizeGripActive = 0x8C7A0087,  -- Dim Dark Pastel Yellow
	ResizeGripHovered = 0xB5A200FF,  -- Dark Pastel Yellow
	TextSelectedBg = 0x8C7A0087,  -- Dim Dark Pastel Yellow
	TitleBg = 0xBFAF00FF,  -- Dark Pastel Yellow
	TitleBgActive = 0x000000FF,  -- Black
	WindowBg = 0xBFAF00FF,  -- Dark Pastel Yellow
}
function set_theme()
	for k, color in pairs( theme_colors ) do
		local color_str = reaper.GetExtState( "XR_ImGui_Col", k )
		if color_str ~= "" then
			color = tonumber( color_str, 16 )
		end
		reaper.ImGui_PushStyleColor(ctx, reaper[ "ImGui_Col_" .. k ](), color )
	end
end


function defer_GUI()


	local visible, keep_GUI_open = reaper.ImGui_Begin(ctx, 'Cordelia offline', true)


	if visible then

		main_context()

		reaper.ImGui_End(ctx)

		if close_GUI then keep_GUI_open = false end
	end

	if keep_GUI_open then
		reaper.defer(defer_GUI)
	end

end

local selected_items_count = reaper.CountSelectedMediaItems(0)
get_info_from_items()
if selected_items_count > 0 then
	reaper.defer(defer_GUI)
else
	log('No item selected')
end

local progress_bar = {}
local lasttime_pbar = os.time()
if not progress_bar.plots then
	progress_bar.plots = {
	  progress = 0.0
	}
end

function loop_progress_bar()
	 --ctx = reaper.ImGui_CreateContext('Progress Bar')

	reaper.ImGui_SetNextWindowSize(ctx, 300, 60, 1)

	local visible, open = reaper.ImGui_Begin(ctx, 'Loading..', true)

	if visible then

		local newtime = os.time()

		if newtime-lasttime_pbar < OUTPUT_LENGTH then
			progress_bar.plots.progress = (progress_bar.plots.progress + (newtime-lasttime_pbar))/OUTPUT_LENGTH
		else
			progress_bar.plots.progress = 1
		end
		-- Typically we would use (-1.0,0.0) or (-FLT_MIN,0.0) to use all available width,
		-- or (width,0.0) for a specified width. (0.0,0.0) uses ItemWidth.
		local buf = ('%.02fs/%.02fs'):format(progress_bar.plots.progress * OUTPUT_LENGTH, OUTPUT_LENGTH)
		reaper.ImGui_ProgressBar(ctx, progress_bar.plots.progress, -1, 0, buf)

		reaper.ImGui_End(ctx)
		reaper.UpdateArrange() -- Update the arrangement (often needed)
		if close_progress_bar then
			open = false
			visible = false
		end
	end

	if open then
		reaper.defer(loop_progress_bar)
	end
end
