function load_modules(dir)
    local i = 0
    while true do
        local file_name = reaper.EnumerateFiles(dir, i)
        if not file_name then break end

        local mod_name = file_name:match("^func%-(.+)%.lua$")
        if mod_name then
            local file_path = dir .. file_name
            local ok, mod = pcall(dofile, file_path)
            if ok and type(mod) == "table" then
                -- assign module to global variable with the same name as the file suffix
                _G[mod_name] = mod
            end
        end

        i = i + 1
    end
end

local script_path = debug.getinfo(1,'S').source:sub(2):match("(.*/)")
local script_name = 'FAISS'
load_modules(script_path)
--math.randomseed(os.time())

PYTHON_PATH = '/opt/homebrew/opt/python@3.11/bin/python3.11'
PYTHON_SCRIPT_PATH = '/Users/j/Documents/RESEARCH/megaindex_venv/main-single.py'
TEMP_DIR = '/Users/j/Documents/temp/'

local TIMEOUT_SEC = 45

local function make_command_string(info)
	local unique_timestamp = path.generate_unique_timestamp()

	local query_path     = info.path
	local basename       = path.get_file_name(query_path):gsub("-glued", "")
	local duration       = tostring(info.duration or "")
	local offset         = tostring(info.offset or "")
	local channels       = tostring(info.channels or "")
	local appendix       = "-FAISS-"

	local output_file = TEMP_DIR .. basename .. appendix .. unique_timestamp .. ".wav"
	local output_log  = TEMP_DIR .. basename .. appendix .. unique_timestamp .. ".log"

	info.basename    = basename .. "-" .. unique_timestamp
	info.output_file = output_file
	info.output_log  = output_log

	-- escape using \" for Terminal inside AppleScript single-quoted script
	local function esc(path)
		return "\\\"" .. path .. "\\\""
	end

	local command = table.concat({
		esc(PYTHON_PATH),
		esc(PYTHON_SCRIPT_PATH),
		esc(query_path),
		"--duration", duration,
		"--offset", offset,
		"--output", esc(output_file),
		"--output_log", esc(output_log),
		"--channels", channels
	}, " ")
	info.command = command
	return command
end

local function wait_for_file(info, callback)
    local start_time = reaper.time_precise()

    local function poll()
        local now = reaper.time_precise()

        -- timeout
        if now - start_time > TIMEOUT_SEC then
            reaper.ShowMessageBox("Timeout: file not found within "..TIMEOUT_SEC.."s\n", "Error", 0)
            --reaper.ShowMessageBox(info.command, "Error", 0)
            return
        end

        -- check file existence
        if reaper.file_exists(info.output_log) then
            callback()
			os.remove(info.path)
            return
        end

        -- schedule next poll without busy-wait
        reaper.defer(poll)
    end

    poll()
end

local function add_new_item(info)
	reaper.Undo_BeginBlock()
	reaper.PreventUIRefresh(1)
	reaper.TrackList_AdjustWindows(false)

	item.fill(info.new_item, info.output_file, info.offset, true)

	reaper.UpdateArrange()
	reaper.PreventUIRefresh(-1)
	reaper.Undo_EndBlock(script_name .. '-2', -1)
end

local function main()
    local selected_items = items.get_selected()
	if #selected_items < 1 then useful.error('No item selected') return end

	local first_onset = reaper.GetMediaItemInfo_Value(selected_items[1], "D_POSITION")

	reaper.Undo_BeginBlock()
	local glued_item = items.glue()
    local info = item.get_info(glued_item)
	info.onset = first_onset
	if not info then useful.error('Error in getting info from glued item') return end

	local new_track = track.create_new_under_item(glued_item)
	local new_empty_item = item.create_emtpy(new_track, info.onset, info.duration)
	info.new_item = new_empty_item

    local command_string = make_command_string(info)
	--reaper.ShowConsoleMsg(command_string)
    command.exec_in_terminal(command_string, true)
	item.remove(glued_item)

	reaper.Undo_EndBlock(script_name .. '-1', -1)

    -- wait for the output log to exist before adding track
    wait_for_file(info, function()
        add_new_item(info)
    end)

end


main()

