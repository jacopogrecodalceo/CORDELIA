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

local function split_csv(csv)
	local values = {}
	for value in csv:gmatch('[^,]+') do
		table.insert(values, value)
	end
	return values
end

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
		return item
	end

end

local function main(subdivision) -- local (i, j, item, take, track)

	reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

	-- YOUR CODE BELOW

	-- LOOP THROUGH SELECTED ITEMS
	local selected_items_count = reaper.CountSelectedMediaItems(0)

	local item_to_remove = {}

	-- INITIALIZE loop through selected items
	for i = 0, selected_items_count-1  do

		local selected_item = get_info(reaper.GetSelectedMediaItem(0, i))
		table.insert(item_to_remove, selected_item)

		local segment_dur = selected_item.length / subdivision

		for j = 0, subdivision - 1 do
			local new_item = reaper.AddMediaItemToTrack(selected_item.track)
			local take = reaper.AddTakeToMediaItem(new_item)
			local src = reaper.PCM_Source_CreateFromFile(selected_item.file_path)
			reaper.SetMediaItemTake_Source(take, src)
			reaper.PCM_Source_BuildPeaks(src, 0)

			reaper.SetMediaItemInfo_Value(new_item, 'D_POSITION', selected_item.position + segment_dur * j)
			reaper.SetMediaItemInfo_Value(new_item, 'D_LENGTH', segment_dur)
			reaper.SetMediaItemTakeInfo_Value(take, 'D_STARTOFFS', math.random()*selected_item.source_length)
		end

	end

	for _, old_selected_item in pairs(item_to_remove) do
		reaper.DeleteTrackMediaItem(old_selected_item.track, old_selected_item.id)
	end

	reaper.Undo_EndBlock('Create windowed', -1) -- End of the undo block. Leave it at the bottom of your main function.

end


-- The following functions may be passed as global if needed
--[[ ----- INITIAL SAVE AND RESTORE ====> ]]

-- ITEMS
--[[ UNSELECT ALL ITEMS
function UnselectAllItems()
	for  i = 0, reaper.CountMediaItems(0) do
		reaper.SetMediaItemSelected(reaper.GetMediaItem(0, i), false)
	end
end

-- SAVE INITIAL SELECTED ITEMS
init_sel_items = {}
local function SaveSelectedItems (table)
	for i = 0, reaper.CountSelectedMediaItems(0)-1 do
		table[i+1] = reaper.GetSelectedMediaItem(0, i)
	end
end

-- RESTORE INITIAL SELECTED ITEMS
local function RestoreSelectedItems (table)
	UnselectAllItems() -- Unselect all items
	for _, item in ipairs(table) do
		reaper.SetMediaItemSelected(item, true)
	end
end]]

-- TRACKS
--[[ UNSELECT ALL TRACKS
function UnselectAllTracks()
	first_track = reaper.GetTrack(0, 0)
	reaper.SetOnlyTrackSelected(first_track)
	reaper.SetTrackSelected(first_track, false)
end

-- SAVE INITIAL TRACKS SELECTION
init_sel_tracks = {}
local function SaveSelectedTracks (table)
	for i = 0, reaper.CountSelectedTracks(0)-1 do
		table[i+1] = reaper.GetSelectedTrack(0, i)
	end
end

-- RESTORE INITIAL TRACKS SELECTION
local function RestoreSelectedTracks (table)
	UnselectAllTracks()
	for _, track in ipairs(table) do
		reaper.SetTrackSelected(track, true)
	end
end

-- LOOP AND TIME SELECTION
--[[ SAVE INITIAL LOOP AND TIME SELECTION
function SaveLoopTimesel()
	init_start_timesel, init_end_timesel = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)
	init_start_loop, init_end_loop = reaper.GetSet_LoopTimeRange(0, 1, 0, 0, 0)
end

-- RESTORE INITIAL LOOP AND TIME SELECTION
function RestoreLoopTimesel()
	reaper.GetSet_LoopTimeRange(1, 0, init_start_timesel, init_end_timesel, 0)
	reaper.GetSet_LoopTimeRange(1, 1, init_start_loop, init_end_loop, 0)
end]]

-- CURSOR
--[[ SAVE INITIAL CURSOR POS
function SaveCursorPos()
	init_cursor_pos = reaper.GetCursorPosition()
end

-- RESTORE INITIAL CURSOR POS
function RestoreCursorPos()
	reaper.SetEditCurPos(init_cursor_pos, false, false)
end]]

-- VIEW
--[[ SAVE INITIAL VIEW
function SaveView()
	start_time_view, end_time_view = reaper.BR_GetArrangeView(0)
end


-- RESTORE INITIAL VIEW
function RestoreView()
	reaper.BR_SetArrangeView(0, start_time_view, end_time_view)
end]]

--[[ <==== INITIAL SAVE AND RESTORE ----- ]]




--msg_start() -- Display characters in the console to show you the begining of the script execution.

--[[ reaper.PreventUIRefresh(1) ]]-- Prevent UI refreshing. Uncomment it only if the script works.

--SaveView()
--SaveCursorPos()
--SaveLoopTimesel()
--SaveSelectedItems(init_sel_items)
--SaveSelectedTracks(init_sel_tracks)

local retval, retvals_csv = reaper.GetUserInputs('Create windowed', 1, 'Subdivision:', '8', 512)
if retval then
	local values = split_csv(retvals_csv)
	local subdivision = table.unpack(values)
	main(subdivision)
end
--RestoreCursorPos()
--RestoreLoopTimesel()
--RestoreSelectedItems(init_sel_items)
--RestoreSelectedTracks(init_sel_tracks)
--RestoreView()

--[[ reaper.PreventUIRefresh(-1) ]] -- Restore UI Refresh. Uncomment it only if the script works.

reaper.UpdateArrange() -- Update the arrangement (often needed)

--msg_end() -- Display characters in the console to show you the end of the script execution.

-- reaper.ShowMessageBox('Script executed in (s): '..tostring(reaper.time_precise() - time_os), '', 0)