values_get = {}

ret, value_input = reaper.GetUserInputs("Fade", 2, "Fade in,Fade out", "")

if ret then
	for num in value_input:gmatch("([^,]*)") do
		table.insert(values_get, num/1000)
		-- reaper.ShowConsoleMsg(num)
	end
end

reaper.Undo_BeginBlock()

-- LOOP THROUGH SELECTED ITEMS
	selected_items_count = reaper.CountSelectedMediaItems(0)
	
	-- INITIALIZE loop through selected items
	for i = 0, selected_items_count-1  do
		-- GET ITEMS
		item = reaper.GetSelectedMediaItem(0, i) -- Get selected item i
		--[[
		B_MUTE : bool * to muted state
		B_LOOPSRC : bool * to loop source
		B_ALLTAKESPLAY : bool * to all takes play
		B_UISEL : bool * to ui selected
		C_BEATATTACHMODE : char * to one char of beat attached mode, -1=def, 0=time, 1=allbeats, 2=beatsosonly
		C_LOCK : char * to one char of lock flags (&1 is locked, currently)
		D_VOL : double * of item volume (volume bar)
		D_POSITION : double * of item position (seconds)
		D_LENGTH : double * of item length (seconds)
		D_SNAPOFFSET : double * of item snap offset (seconds)
		D_FADEINLEN : double * of item fade in length (manual, seconds)
		D_FADEOUTLEN : double * of item fade out length (manual, seconds)
		D_FADEINLEN_AUTO : double * of item autofade in length (seconds, -1 for no autofade set)
		D_FADEOUTLEN_AUTO : double * of item autofade out length (seconds, -1 for no autofade set)
		C_FADEINSHAPE : int * to fadein shape, 0=linear, ...
		C_FADEOUTSHAPE : int * to fadeout shape
		I_GROUPID : int * to group ID (0 = no group)
		I_LASTY : int * to last y position in track (readonly)
		I_LASTH : int * to last height in track (readonly)
		I_CUSTOMCOLOR : int * : custom color, windows standard color order (i.e. RGB(r,g,b)|0x100000). if you do not |0x100000, then it will not be used (though will store the color anyway)
		I_CURTAKE : int * to active take
		IP_ITEMNUMBER : int, item number within the track (read-only, returns the item number directly)
		F_FREEMODE_Y : float * to free mode y position (0..1)
		F_FREEMODE_H : float * to free mode height (0..1)
		]]
		
		-- SET INFOS
		reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN", tonumber(values_get[1])) -- Set the value to the parameter
    	reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN", tonumber(values_get[2])) -- Set the value to the parameter
	end -- ENDLOOP through selected items

reaper.UpdateArrange()
reaper.Undo_EndBlock('Fade', 1)
