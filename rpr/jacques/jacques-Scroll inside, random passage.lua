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
		local source = reaper.GetMediaItemTake_Source(take)
		item.file_path = reaper.GetMediaSourceFileName(source)
		item.source_onset = reaper.GetMediaItemTakeInfo_Value(take, 'D_STARTOFFS')
		item.source_length, _ = reaper.GetMediaSourceLength(source)
		item.length = reaper.GetMediaItemInfo_Value(main_item, 'D_LENGTH')
		item.position = reaper.GetMediaItemInfo_Value(main_item, 'D_POSITION')
		item.track = reaper.GetMediaItem_Track(main_item)
		item.id = main_item
		item.bpm = reaper.TimeMap2_GetDividedBpmAtTime(0, item.position)
		item.take = take
		return item
	end

end

local function main() -- local (i, j, item, take, track)

	reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

	-- INITIALIZE loop through selected items
	for i = 0, selected_items_count-1  do

		local selected_item = get_info(reaper.GetSelectedMediaItem(0, i))
		reaper.SetMediaItemTakeInfo_Value(selected_item.take, 'D_STARTOFFS', math.random()*selected_item.source_length)
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