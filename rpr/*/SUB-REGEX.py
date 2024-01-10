import re

def open_reaper_dialog(string):
  title = "Sub REGEX"
  num_inputs = 1
  retval, title, num_inputs, captions_csv, retvals_csv, retvals_csv_sz = RPR_GetUserInputs(title, num_inputs, string, "", 1024)
  if retval:
    return retvals_csv

def substitute_regex(string, before, after):
  regex = r"%s" % before
  #regex = before
  
  #RPR_ShowConsoleMsg(regex)

  #You can manually specify the number of replacements by changing the 4th argument
  res = re.sub(regex, after, string, 0, re.MULTILINE)
  return res

def main():

  RPR_Undo_BeginBlock() #Beginning of the undo block. Leave it at the top of your main function.

  #LOOP THROUGH SELECTED ITEMS
  selected_items_count = RPR_CountSelectedMediaItems(0)
  
  before = open_reaper_dialog("BEFORE: ")
  after = open_reaper_dialog("AFTER: ")
  #INITIALIZE loop through selected items
  for i in range(selected_items_count):
    #GET ITEMS
    item = RPR_GetSelectedMediaItem(0, i) #Get selected item i
    #GET INFOS
    retval, item, parname, score, setNewValue = RPR_GetSetMediaItemInfo_String(item, "P_NOTES", 0, 0)
    #RPR_ShowConsoleMsg(score)
    score_sub = substitute_regex(score, before, after)
    RPR_GetSetMediaItemInfo_String(item, "P_NOTES", score_sub, 1)

  RPR_Undo_EndBlock("SUB-REGEX", -1) #End of the undo block. Leave it at the bottom of your main function.


RPR_PreventUIRefresh(1) #Prevent UI refreshing. Uncomment it only if the script works.

main() #Execute your main function

RPR_PreventUIRefresh(-1)  #Restore UI Refresh. Uncomment it only if the script works.

RPR_UpdateArrange() #Update the arrangement (often needed)

