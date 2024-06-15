reaper.Undo_BeginBlock()

selected_items_count = reaper.CountSelectedMediaItems(0)
for i = 0, selected_items_count-1  do
  -- GET ITEMS
  item = reaper.GetSelectedMediaItem(0, i) -- Get selected item i
  take = reaper.GetActiveTake(item) -- Get the active take
  if take ~= nil then -- if ==, it will work on "empty"/text items only
    -- GET INFOS
    value_get = reaper.GetMediaItemTakeInfo_Value(take, "D_PITCH") -- Get the value of a the parameter
    --[[
    D_STARTOFFS : double *, start offset in take of item
    D_VOL : double *, take volume
    D_PAN : double *, take pan
    D_PANLAW : double *, take pan law (-1.0=default, 0.5=-6dB, 1.0=+0dB, etc)
    D_PLAYRATE : double *, take playrate (1.0=normal, 2.0=doublespeed, etc)
    D_PITCH : double *, take pitch adjust (in semitones, 0.0=normal, +12 = one octave up, etc)
    B_PPITCH, bool *, preserve pitch when changing rate
    I_CHANMODE, int *, channel mode (0=normal, 1=revstereo, 2=downmix, 3=l, 4=r)
    I_PITCHMODE, int *, pitch shifter mode, -1=proj default, otherwise high word=shifter low word = parameter
    I_CUSTOMCOLOR : int *, custom color, windows standard color order (i.e. RGB(r,g,b)|0x100000). if you do not |0x100000, then it will not be used (though will store the color anyway)
    IP_TAKENUMBER : int, take number within the item (read-only, returns the take number directly)
    ]]
    -- MODIFY INFOS
    value_set = value_get + .25-- Prepare value output
    -- SET INFOS
    reaper.SetMediaItemTakeInfo_Value(take, "D_PITCH", value_set) -- Set the value to the parameter
  end -- ENDIF active take
end -- ENDLOOP through selected items

reaper.UpdateArrange()
reaper.Undo_EndBlock('j_Pitch +.25', 1)
