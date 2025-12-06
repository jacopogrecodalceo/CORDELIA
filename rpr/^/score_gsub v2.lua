


function dialog(string)
  local ret, retvals = reaper.GetUserInputs("Substitute", 1, string, "")
  if ret then
    return retvals
  end
  return ret
end



function main()

  reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

  -- LOOP THROUGH SELECTED ITEMS
  
  selected_items_count = reaper.CountSelectedMediaItems(0)
  
  before = dialog("BEFORE: ")
  after = dialog("AFTER: ")
  
  -- INITIALIZE loop through selected items
  for i = 0, selected_items_count-1  do
    -- GET ITEMS
    local item = reaper.GetSelectedMediaItem(0, i) -- Get selected item i
    -- GET INFOS
    local retval, score = reaper.GetSetMediaItemInfo_String(item, "P_NOTES", 0, 0)
    -- reaper.ShowConsoleMsg(score)
    score = string.gsub(score, after, before)
    reaper.GetSetMediaItemInfo_String(item, "P_NOTES", score, 1)
  end -- ENDLOOP through selected items

  reaper.Undo_EndBlock("Offset selected media items source positions by snap offset length", -1) -- End of the undo block. Leave it at the bottom of your main function.

end

reaper.PreventUIRefresh(1) -- Prevent UI refreshing. Uncomment it only if the script works.

main() -- Execute your main function

reaper.PreventUIRefresh(-1)  -- Restore UI Refresh. Uncomment it only if the script works.

reaper.UpdateArrange() -- Update the arrangement (often needed)
