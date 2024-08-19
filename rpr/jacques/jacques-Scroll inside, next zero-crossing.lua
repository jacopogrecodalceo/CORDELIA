--[[
 * ReaScript Name: Create windowed
 * Description: This script takes a selected item and splits it into a sequence of subitems, each based on the tempo of the project
 * Instructions: Select an item an run the action
 * Author: Jacopo Greco d'Alceo
 * Author URI: https://jacopogrecodalceo.github.io
 * Repository: GitHub > X-Raym > EEL Scripts for Cockos REAPER
 * Repository URI: https://github.com/X-Raym/REAPER-EEL-Scripts
 * File URI: https://github.com/X-Raym/REAPER-EEL-Scripts/scriptName.eel
 * Licence: GPL v3
 * Forum Thread: Script: Script name
 * Forum Thread URI: http://forum.cockos.com/***.html
 * REAPER: 5.0 pre 15
 * Extensions: SWS/S&M 2.7.1 (optional)
 * Version: 1.0
--]]

--[[
 * Changelog:
 * v1.3.1 (2015-02-27)
 	# loops takes bug fix
 	# thanks benf and heda for help with looping through regions!
 	# thanks to Heda for the function that embed external lua files!
 * v1.0 (14/08/2024)
	+ Initial Release
 --]]

SCRIPT_NAME = debug.getinfo(1, 'S').source:sub(2):gsub('-jacques', '')

local function get_info(main_item)
	-- Check if the selected item contains an audio source
	local take = reaper.GetActiveTake(main_item)
	if take ~= nil and reaper.TakeIsMIDI(take) == false then
		local item = {}
		item.source = reaper.GetMediaItemTake_Source(take)
		item.file_path = reaper.GetMediaSourceFileName(item.source)
		item.source_onset = reaper.GetMediaItemTakeInfo_Value(take, 'D_STARTOFFS')
		item.source_length, _ = reaper.GetMediaSourceLength(item.source)
		item.length = reaper.GetMediaItemInfo_Value(main_item, 'D_LENGTH')
		item.position = reaper.GetMediaItemInfo_Value(main_item, 'D_POSITION')
		item.track = reaper.GetMediaItem_Track(main_item)
		item.id = main_item
		item.bpm = reaper.TimeMap2_GetDividedBpmAtTime(0, item.position)
		item.sample_rate = reaper.GetMediaSourceSampleRate(item.source)
		item.chs = reaper.GetMediaSourceNumChannels(item.source)
		item.take = take
		return item
	end

end

-- Function to get the sample data from the item
local function get_audio_buffer(item)
	
	local num_samples = item.source_length*item.sample_rate
	-- Create an accessor for the PCM data
	local accessor = reaper.CreateTakeAudioAccessor(item.take)
	local audio_buffer = reaper.new_array(item.chs * num_samples)
	
	-- Get the PCM data from the accessor
	reaper.GetAudioAccessorSamples(accessor, item.sample_rate, item.chs, 0.0, num_samples, audio_buffer)
	
	-- Destroy the accessor to free memory
	reaper.DestroyAudioAccessor(accessor)
	
	return audio_buffer.table()
end

-- Function to find the next zero-crossing in the sample data, with wrap-around support
local function find_next_zero_crossing_position(onset, buf)
    -- Ensure buffer is not empty
    if not buf or #buf == 0 then
        return nil
    end

    local buf_size = #buf

    -- Validate onset
    if onset < 1 or onset > buf_size then
        onset = 1
    end

    local last_sample = buf[onset]

    -- Check for initial nil value
    if last_sample == nil then
		reaper.ShowMessageBox("Failed to retrieve sample data at " .. onset .. " samples on " .. #buf, "Error", 0)
        return nil
    end

    -- Search forward from onset to the end of the buffer
    for i = onset + 1, buf_size do
        local current_sample = buf[i]
        
        -- Check if current_sample is nil
        if current_sample == nil then
            return nil
        end
        
        -- Check for zero-crossing
        if (last_sample < 0 and current_sample >= 0) or (last_sample > 0 and current_sample <= 0) then
            return i
        end
        
        last_sample = current_sample
    end
    
    -- No zero-crossing found, wrap around and search from the beginning of the buffer
    last_sample = buf[1]

    for i = 2, onset do
        local current_sample = buf[i]
        
        -- Check if current_sample is nil
        if current_sample == nil then
            return nil
        end
        
        -- Check for zero-crossing
        if (last_sample < 0 and current_sample >= 0) or (last_sample > 0 and current_sample <= 0) then
            return i
        end
        
        last_sample = current_sample
    end
    
    return nil -- No zero-crossing found after searching the entire buffer
end

local function main() -- local (i, j, item, take, track)

	reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

	-- INITIALIZE loop through selected items
	for i = 0, selected_items_count-1  do

		local selected_item = get_info(reaper.GetSelectedMediaItem(0, i))
		-- Get the sample data
		local buf = get_audio_buffer(selected_item)
		if not buf then
			reaper.ShowMessageBox("Failed to retrieve sample data", "Error", 0)
			return
		end
		local source_onset_sample = selected_item.source_onset*selected_item.sample_rate
		local zero_crossing_sample = find_next_zero_crossing_position(source_onset_sample, buf)
		if not zero_crossing_sample then
			return
		end
		local zero_crossing_second = zero_crossing_sample / selected_item.sample_rate

		reaper.SetMediaItemTakeInfo_Value(selected_item.take, 'D_STARTOFFS', zero_crossing_second)
--[[ 
		for j = 0, subdivision - 1 do
			local new_item = reaper.AddMediaItemToTrack(selected_item.track)
			local take = reaper.AddTakeToMediaItem(new_item)
			local src = reaper.PCM_Source_CreateFromFile(selected_item.file_path)
			reaper.SetMediaItemTake_Source(take, src)
			reaper.PCM_Source_BuildPeaks(src, 0)

			reaper.SetMediaItemInfo_Value(new_item, 'D_POSITION', selected_item.position + segment_dur * j)
			reaper.SetMediaItemInfo_Value(new_item, 'D_LENGTH', segment_dur)
		end
 ]]
	end

	reaper.Undo_EndBlock(SCRIPT_NAME, -1) -- End of the undo block. Leave it at the bottom of your main function.

end

selected_items_count = reaper.CountSelectedMediaItems(0)
if 	selected_items_count > 0 then
	main()
end

reaper.UpdateArrange() -- Update the arrangement (often needed)

--msg_end() -- Display characters in the console to show you the end of the script execution.

-- reaper.ShowMessageBox('Script executed in (s): '..tostring(reaper.time_precise() - time_os), '', 0)