function dialog()
  local ret, orc_name = reaper.GetUserFileNameForRead("/Users/j/Documents/PROJECTs/IDRA", "Path", "orc")
  if ret then
    return orc_name
  end
end

function createtextitem(track, position, length, text, color)
    
  local item = reaper.AddMediaItemToTrack(reaper.GetTrack(0, 0))
  
  reaper.SetMediaItemInfo_Value(item, "D_POSITION", position)
  reaper.SetMediaItemInfo_Value(item, "D_LENGTH", length)
  
  if text then
    reaper.ULT_SetMediaItemNote(item, text)
  end
  
  if color then
    reaper.SetMediaItemInfo_Value(item, "I_CUSTOMCOLOR", color)
  end
  
  return item

end

function readfile(path)
  local file = io.open(path, "rb") -- r read mode and b binary mode
  --if not file then return nil end
  for line in file:lines() do
    
    -- replace i to schedule
    line = line:gsub("^i", "schedulech")
    
    -- grab instrument name
    local allinstruments = {}
    local instrument = line:match('"(.+)"')
    
    -- put all instrument names inside an array
    table.insert(allinstruments, instrument)
    local flags = {}
    local allinstruments_res = {}
    
    for i in ipairs(allinstruments) do
       if not flags[allinstruments[i]] then
          table.insert(allinstruments_res, allinstruments[i])
          flags[allinstruments[i]] = true
       end
    end
    
    for i, v in ipairs(allinstruments_res) do
      reaper.ShowConsoleMsg(v .. "\n")
    end

    createtextitem(0, 0, 4, line)
  end
  file:close()
end

readfile(dialog())
