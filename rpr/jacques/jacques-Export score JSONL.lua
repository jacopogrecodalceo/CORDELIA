-- Get all media items in the current project
local num_items = reaper.CountMediaItems(0) -- 0 = current project

function get_items_values()
    local items = {} -- table to store all items info
    for i = 0, num_items - 1 do
        local item = reaper.GetMediaItem(0, i)
        local take = reaper.GetActiveTake(item)
        if take and reaper.TakeIsMIDI(take) == false then -- ignore MIDI
            -- item position on timeline
            local onset = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
            -- item length in seconds
            local duration = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
            -- source file
            local source = reaper.GetMediaItemTake_Source(take)
            local path = reaper.GetMediaSourceFileName(source)
            -- offset in source (in seconds)
            local offset = reaper.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS")

            -- build line structure
            local item = {
                onset = onset,
                duration = duration,
                offset = offset,
                path = path
            }

            table.insert(items, item)
        end
    end
    return items
end

-- print all lines
function log(items)
    for i, line in ipairs(items) do
        reaper.ShowConsoleMsg(string.format(
            "Item %d: onset=%.3f, duration=%.3f, offset=%.3f, path=%s\n",
            i,
            line.event.onset,
            line.event.duration,
            line.event.offset,
            line.event.path
        ))
    end
end


function main()
    local items = get_items_values()
    local file_path = reaper.GetProjectPath("") .. "/" .. reaper.GetProjectName(0) ..".jsonl"
    local file = io.open(file_path, "w")

    for _, item in ipairs(items) do
        local line = {
            event = {
                onset = item.onset,
                duration = item.duration,
                offset = item.offset,
                path = item.path
            }
        }

        file:write(string.format(
            '{"event":{"onset":%.12f,"duration":%.12f,"offset":%.12f,"path":"%s"}}\n',
            line.event.onset,
            line.event.duration,
            line.event.offset,
            line.event.path:gsub("\\","\\\\"):gsub('"','\\"')
        ))
    end

    file:close()
    reaper.ShowMessageBox("Export complete:\n" .. file_path, "JSONL Export", 0)

end

main()