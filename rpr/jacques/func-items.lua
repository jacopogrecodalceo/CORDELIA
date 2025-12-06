items = {}

function items.get_selected()
    local selected_items = {}
    local count = reaper.CountSelectedMediaItems(0)

    for i = 0, count - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        selected_items[#selected_items + 1] = item
    end

    return selected_items
end

function items.glue()
	local cursor_pos = reaper.GetCursorPosition()

    -- Disable locking
	reaper.Main_OnCommand(40570, 0)

	-- Duplicate items
	reaper.Main_OnCommand(41295, 0)

    -- Glue items
	reaper.Main_OnCommand(40362, 0)

    -- Enable locking
	reaper.Main_OnCommand(40569, 0)

	local glued_item = reaper.GetSelectedMediaItem(0, 0)
	reaper.SetEditCurPos(cursor_pos, true, true)

	return glued_item
end

return items