function split_csv(csv)
	local values = {}
	for value in csv:gmatch("[^,]+") do
		table.insert(values, value)
	end
	return values
end

function get_tracks()
	local tracks = {}
	local selected_tracks_count = reaper.CountSelectedTracks(0)
	if selected_tracks_count <= 1 then
		for i = 0, reaper.CountTracks(0)-1  do
			table.insert(tracks, reaper.GetTrack(0, i))
		end
	else
		for i = 0, selected_tracks_count-1  do
			table.insert(tracks, reaper.GetSelectedTrack(0, i))
		end
	end
	return tracks
end

function main(tracks, original, substitution)

	for _, track in pairs(tracks) do
		--GET INFOS
		local retval, track_name = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', '', 0)
		if retval then
			local result = string.gsub(track_name, original, substitution)
			reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', result, 1)
		end
	end

end

local tracks = get_tracks()
local retval, retvals_csv = reaper.GetUserInputs('Replace name in ' .. tostring(#tracks) .. ' tracks', 2, 'Original:,Substitution:', '', 512)
if retval then
	local values = split_csv(retvals_csv)
	local original, substitution = table.unpack(values)
	reaper.Undo_BeginBlock()
	main(tracks, original, substitution)
	reaper.Undo_EndBlock("Regex track name", -1)
	reaper.UpdateArrange() -- Update the arrangement (often needed)

end
