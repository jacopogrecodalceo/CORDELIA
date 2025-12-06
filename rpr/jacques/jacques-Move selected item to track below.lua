
local function move_item_to_track_above(item)
	if not item then return end
	local track = reaper.GetMediaItem_Track(item)
	local track_idx = reaper.CSurf_TrackToID(track, false) -- 1-based index
	local below_track = reaper.GetTrack(0, track_idx) -- 0-based in API
	if below_track then
		reaper.MoveMediaItemToTrack(item, below_track)
	end 
end

local num_items = reaper.CountSelectedMediaItems(0)
reaper.Undo_BeginBlock() -- start undo block

for i = 0, num_items - 1 do
	local item = reaper.GetSelectedMediaItem(0, i)
	move_item_to_track_above(item)
end

reaper.Undo_EndBlock("Move selected items to track above", -1) -- end undo block
reaper.UpdateArrange() -- refresh arrange view