PYTHON_PATH = '/opt/homebrew/opt/python@3.11/bin/python3.11'
PYTHON_SCRIPT_PATH = '/Users/j/Documents/RESEARCH/megaindex_venv/main-transient.py'
TEMP_DIR = '/Users/j/Documents/temp/'


function generate_unique_timestamp()
	local jacques_year = 1989
	local jacques_month = 10
	local jacques_day = 11
	-- get current day and month
	local current_day = tonumber(os.date("%d"))
	local current_month = tonumber(os.date("%m"))
	local current_year = tonumber(os.date("%Y"))
	
	-- calculate age
	local age = current_year - jacques_year
	if current_month < jacques_month or (current_month == jacques_month and current_day < jacques_day) then
		age = age - 1
	end


    local timestamp = os.date(age .. "%m%d_%H%M%S")
    return timestamp
end

function extract_basename(file)
	-- Remove the directory path from the file_path using the last directory separator "/"
	local basename = file:match(".*/(.+)")
	-- Remove the extension from the basename
	basename = basename:match("(.+)%..+")
	return basename
end

function get_selected_items()
    local selected_items = {}
    local count = reaper.CountSelectedMediaItems(0)

    for i = 0, count - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        selected_items[#selected_items + 1] = item
    end

    return selected_items
end


function get_item_info(item)
	local take = reaper.GetActiveTake(item)

	if not take or reaper.TakeIsMIDI(take) then reaper.ShowMessageBox("Empty take", "Error", 0) return end
	-- -------------------------------------------------------------------------- --
	--                                    ITEM                                    --
	-- -------------------------------------------------------------------------- --
	local onset = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
	local duration = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
	local fadein = reaper.GetMediaItemInfo_Value(item, "D_FADEINLEN")
	local fadeout = reaper.GetMediaItemInfo_Value(item, "D_FADEOUTLEN")

	-- -------------------------------------------------------------------------- --
	--                                   SOURCE                                   --
	-- -------------------------------------------------------------------------- --
	local source = reaper.GetMediaItemTake_Source(take)
	local channels = reaper.GetMediaSourceNumChannels(source)
	local path = reaper.GetMediaSourceFileName(source)
	if path == "" then
		reaper.ShowMessageBox("Source path not found at " .. onset, "Error", 0)
		reaper.SetEditCurPos(onset, true, true)
		return false, nil
	end
	local offset = reaper.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS")

	-- -------------------------------------------------------------------------- --
	--                                    TABLE                                   --
	-- -------------------------------------------------------------------------- --
	return true, {
			onset = onset,
			duration = duration,
			offset = offset,
			path = path,
			channels = channels,
			fadein = fadein,
			fadeout = fadeout
		}

end

function make_command_string(info)
	local unique_timestamp = generate_unique_timestamp()
	
	local query_path     = info.path
	local basename       = extract_basename(query_path):gsub("-glued", "")
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

function exec_command(command, exit)
    exit = exit == nil and true or exit  -- default to true

	local osa_command
	if exit then
		osa_command = "osascript -e 'tell application \"Terminal\" to do script \"" .. command .. ";exit\"'"
	else
		osa_command = "osascript -e 'tell application \"Terminal\" to do script \"" .. command .. "\"'"
	end

	--reaper.ShowMessageBox(osa_command, "Show command", 0)
	os.execute(osa_command)
end


local timeout_sec = 45

function wait_for_file(info, callback)
    local start_time = reaper.time_precise()

    local function poll()
        local now = reaper.time_precise()

        -- timeout
        if now - start_time > timeout_sec then
            reaper.ShowMessageBox("Timeout: file not found within "..timeout_sec.."s\n", "Error", 0)
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

function add_path_in_new_track(info)
	-- start undo block
	reaper.Undo_BeginBlock()

	-- prevent UI refresh for performance
	reaper.PreventUIRefresh(1)

	-- get number of tracks currently
	local track_count = reaper.CountTracks(0)

	-- create a new track at the end
	reaper.InsertTrackAtIndex(track_count, true)
	local track = reaper.GetTrack(0, track_count)

	-- set track name
	reaper.GetSetMediaTrackInfo_String(track, "P_NAME", info.basename, true)

	-- add a new empty media item (1 second duration as example)
	reaper.SetMediaTrackInfo_Value(track, "I_NCHAN", info.channels)

	-- Add the WAV file to the track
	local item = reaper.AddMediaItemToTrack(track)
	local take = reaper.AddTakeToMediaItem(item)
	local source = reaper.PCM_Source_CreateFromFile(info.output_file)
	reaper.SetMediaItemTake_Source(take, source)
	reaper.PCM_Source_BuildPeaks(source, 0)

	reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", info.basename, true)
	reaper.SetMediaItemInfo_Value(item, "D_POSITION", info.onset)
	-- Adjust the item length to match the WAV file length
	local source_length = reaper.GetMediaSourceLength(reaper.GetMediaItemTake_Source(take))
	reaper.SetMediaItemInfo_Value(item, "D_LENGTH", source_length)

	-- update arrange view
	reaper.TrackList_AdjustWindows(false)
	reaper.UpdateArrange()

	-- restore UI refresh
	reaper.PreventUIRefresh(-1)

	-- end undo block with a descriptive name
	reaper.Undo_EndBlock("Create Track and Add Item", -1)
end

function glue_items()
	local cursor_pos = reaper.GetCursorPosition()

	-- Duplicate items
	reaper.Main_OnCommand(41295, 0)

	-- Glue items
	reaper.Main_OnCommand(40362, 0)

	local glued_item = reaper.GetSelectedMediaItem(0, 0)
	reaper.SetEditCurPos(cursor_pos, true, true)

	return glued_item
end

function remove_glued_item(item)
	local track = reaper.GetMediaItem_Track(item)
	reaper.DeleteTrackMediaItem(track, item)
end

function main()

    local selected_items = get_selected_items()
	if #selected_items < 1 then reaper.ShowMessageBox("No item selected", "Error", 0) return end

	reaper.PreventUIRefresh(1)
	local glued_item = glue_items()
    local ok, info = get_item_info(glued_item)
    if not ok then return end

    local command_string = make_command_string(info)
	--reaper.ShowConsoleMsg(command_string)
    exec_command(command_string, true)
	remove_glued_item(glued_item)
	reaper.PreventUIRefresh(-1)

    -- wait for the output log to exist before adding track
    wait_for_file(info, function()
        add_path_in_new_track(info)
    end)

	--reaper.ShowMessageBox(command_string, "Error", 0)
end

main()