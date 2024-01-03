open_inline_editor_id = 40847
close_inline_editor_id = 41887
_, _, section_id, cmd_id, _, _, _ = reaper.get_action_context()
cmd_state = reaper.GetToggleCommandState(section_id, cmd_id)

reaper.ShowConsoleMsg(cmd_state)

function main()
    reaper.Undo_BeginBlock()

    local items_count = reaper.CountMediaItems(0)

    for i = 0, items_count - 1 do
        local item = reaper.GetMediaItem(0, i)
        local take = reaper.GetActiveTake(item)

        if take and reaper.TakeIsMIDI(take) then
            reaper.SetMediaItemSelected(item, true)
            local command_id = cmd_state == 0 and open_inline_editor_id or close_inline_editor_id
            reaper.Main_OnCommand(command_id, 0)
            reaper.SetMediaItemSelected(item, false)
        end
    end

    cmd_state = 1 - cmd_state
    reaper.ShowConsoleMsg(cmd_state)
    reaper.Undo_EndBlock('Toggle inline editor for all MIDI items', -1)
    reaper.SetToggleCommandState(section_id, cmd_id, cmd_state)
end

main()
reaper.UpdateArrange()
reaper.RefreshToolbar2(section_id, cmd_id)
