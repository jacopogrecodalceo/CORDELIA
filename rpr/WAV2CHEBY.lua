-- Specify the Python script path
local cheby_script = '/Users/j/Documents/PROJECTs/CORDELIA/cordelia_atsa/_gensyn-cheby.py'
local temp_dir = '/Users/j/Documents/PROJECTs/_temp/'

function log(string)
	reaper.ShowConsoleMsg(tostring(string) .. '\n')
end

function close_console()
	local title = reaper.JS_Localize('ReaScript console output', 'common')
	local hwnd = reaper.JS_Window_Find(title, true)
	if hwnd then reaper.JS_Window_Destroy(hwnd) end  
end

selected_item_source_original_file = {}

function glue_selected_items()
	local selected_items_count = reaper.CountSelectedMediaItems(0)

	if selected_items_count == 0 then
		log('No item selected')
		return
	end

	for i = 0, selected_items_count-1  do
		-- GET ITEMS
		local item = reaper.GetSelectedMediaItem(0, i) -- Get selected item i
		local take = reaper.GetActiveTake(item)
		local source = reaper.GetMediaItemTake_Source(take)
		selected_item_source_original_file[item] = source
	end

	-- Glue
	reaper.Main_OnCommand(40362, 0)

end

function execute_script(command)
--[[ 	local file_handle = io.popen(command)
	local output = file_handle:read("*a")  -- Read the entire output as a string
	file_handle:close()
	return output ]]
	--reaper.ExecProcess(command, -1)

	local ret = reaper.ExecProcess(command, -2)
	reaper.ExecProcess('say done', -2)
	return ret
end

function generate_unique_timestamp()
    local timestamp = os.time()
    local unique_part = os.clock() * 1000 -- Multiply by 1000 to get milliseconds (you can adjust this as needed)
    local unique_part = math.floor(unique_part + 0.5)
    return string.format("%s_%03d", tostring(timestamp), unique_part)
end

lasttime = os.time()
input_file = ''
output_position = nil
raw_file = ''

function get_selected_items(notes)
	local selected_items_count = reaper.CountSelectedMediaItems(0)

	if selected_items_count == 0 then
		log('No item selected')
		return
	end
	
	-- INITIALIZE loop through selected items
	for i = 0, selected_items_count-1  do
		-- GET ITEMS
		local item = reaper.GetSelectedMediaItem(0, i) -- Get selected item i
		local take = reaper.GetActiveTake(item)
		local source = reaper.GetMediaItemTake_Source(take)
		-- Check if a media source is available
		if source ~= nil then

			-- Get the file name of the media source
			input_file = reaper.GetMediaSourceFileName(source, "")
			local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
			output_position = reaper.GetMediaItemInfo_Value(item, "D_POSITION")

--[[ 			local values = retvals_csv:gmatch('([^,]+)')
			local notes = values[0]
 ]]
 			-- Remove the directory path from the file_path using the last directory separator "/"
			local basename = input_file:match(".*/(.+)")
			-- Remove the extension from the basename
			basename = basename:match("(.+)%..+")
			basename = string.gsub(basename, "-glued", "")

			local destination_path = temp_dir .. basename .. '-cheby' .. generate_unique_timestamp() .. '.wav'
			
			local command = string.format('/opt/homebrew/bin/python3 "%s" "%s" "%s" %f %i', cheby_script, input_file, destination_path, length, notes)
			local ret = execute_script(command)
			
			--reaper.SetMediaItemTake_Source(take, selected_item_source_original_file[item])
			--UNDO
			reaper.Main_OnCommand(40029, 0)
			

			raw_file = destination_path
		end
	end
end

main_status = false

function check_when_file_exists()

	local check_file = raw_file .. '--finished'
    
	if reaper.file_exists(check_file) == false and main_status == false then
		
		local newtime=os.time()

		if newtime-lasttime >= 3.5 then
			lasttime = newtime
			log('Looking for..')
			log(check_file)
			reaper.defer(check_when_file_exists)	
		end
		reaper.defer(check_when_file_exists)	
		return 

	elseif reaper.file_exists(check_file) == true and main_status == false then

		log('Done!')
		local file = raw_file
		local track_index = reaper.GetNumTracks()
		reaper.InsertTrackAtIndex(track_index, true) -- Create a new track
	
		local track = reaper.GetTrack(0, track_index)
		
		-- Add the WAV file to the track
		local item = reaper.AddMediaItemToTrack(track)
		local take = reaper.AddTakeToMediaItem(item)
		local src = reaper.PCM_Source_CreateFromFile(file)
		reaper.SetMediaItemTake_Source(take, src)
		reaper.PCM_Source_BuildPeaks(src, 0)
	
		reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", file, true)
		reaper.SetMediaItemInfo_Value(item, "D_POSITION", output_position)
		-- Adjust the item length to match the WAV file length
		local source_length = reaper.GetMediaSourceLength(reaper.GetMediaItemTake_Source(take))
		reaper.SetMediaItemInfo_Value(item, "D_LENGTH", source_length)
		os.remove(input_file)
		os.remove(check_file)
		close_console()
		main_status = true
		return
	end

	return
end

reaper.ClearConsole()

local retval, notes = reaper.GetUserInputs('How many notes', 1, 'notes', '30', 512)
glue_selected_items()
get_selected_items(notes)

check_when_file_exists()
