-- Get all media items in the current project
local num_items = reaper.CountMediaItems(0) -- 0 = current project

function get_events()
	local events = {} -- table to store all items info
	for i = 0, num_items - 1 do
		local item = reaper.GetMediaItem(0, i)
		local take = reaper.GetActiveTake(item)
		if take and reaper.TakeIsMIDI(take) == false then -- ignore MIDI
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
			local path = reaper.GetMediaSourceFileName(source)
			if path == "" then
				--[[ reaper.ShowMessageBox("Source path not found at " .. onset, "Error", 0)
				reaper.SetEditCurPos(onset, true, true)
				return false, nil ]]
				goto continue
			end
			local offset = reaper.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS")

			-- -------------------------------------------------------------------------- --
			--                                    TABLE                                   --
			-- -------------------------------------------------------------------------- --
			local event = {
				item = {
					onset = onset,
					duration = duration,
					fadein = fadein,
					fadeout = fadeout
				},
				source = {
					offset = offset,
					path = path,
				}
			}

			table.insert(events, event)
			::continue::
		end
	end
	return true, events
end

function to_jsonl(e)
	local s = "{"
	-- encode item
	s = s .. '"item":{'
	s = s .. '"onset":' .. e.item.onset .. ','
	s = s .. '"duration":' .. e.item.duration .. ','
	s = s .. '"fadein":' .. e.item.fadein .. ','
	s = s .. '"fadeout":' .. e.item.fadeout
	s = s .. '},'
	-- encode source
	s = s .. '"source":{'
	s = s .. '"offset":' .. e.source.offset .. ','
	s = s .. '"path":"' .. e.source.path .. '"'
	s = s .. '}}'
	return s
end


function main()

	local project_name = reaper.GetProjectName(0)
	local project_path = reaper.GetProjectPath()

	if not project_name or project_name == "" or project_path == "" then
		reaper.ShowMessageBox("Please save the project first", "Error", 0)
		return
	end

	project_name = project_name:gsub("%.RPP$", "")

	local retval, events = get_events()
	if not retval then
		return
	end
	local file_path = reaper.GetProjectPath("") .. "/" .. project_name .."-cordeliamap.jsonl"
	local file = io.open(file_path, "w")

	for _, event in ipairs(events) do
		file:write(to_jsonl(event) .. "\n")  -- <- newline per event
	end

	file:close()
	reaper.ShowMessageBox("Export complete:\n" .. file_path, "JSONL Export", 0)

end

main()