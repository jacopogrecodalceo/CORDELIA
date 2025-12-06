import re

def dialog():
  ret, orc_name, title, defex = RPR_GetUserFileNameForRead("/Users/j/Documents/PROJECTs/IDRA", "Path", "orc")
  if ret==1:
    return orc_name

def createtextitem(track, position, length, text):
    
  item = RPR_AddMediaItemToTrack(RPR_GetTrack(0, track))
  
  RPR_SetMediaItemInfo_Value(item, "D_POSITION", position)
  RPR_SetMediaItemInfo_Value(item, "D_LENGTH", length)
  
  retval, meditem, parname, instr, var = RPR_GetSetMediaItemInfo_String(item, "P_NOTES", text, 1)
  
  return item


def readfile(path):
  
  file = open(path, 'r')

  #grab instrument name
  instr_name = re.findall(r'"(.*?)"', file.read())
  instr_name = list(dict.fromkeys(instr_name))
  
  #RPR_ShowConsoleMsg(instr_name)
  
  file = open(path, 'r')
  
  for line in file:
    #i to schedulech
    #line = re.sub("^i", "schedulech\t", line)

    lineasarray = re.split('\t+', line)
    
    name = lineasarray[1].strip('\"')
    position = float(lineasarray[2])
    length = float(lineasarray[3])
    dyn = lineasarray[4]
    env = lineasarray[5]
    freq = lineasarray[6]
    
    score = '"' + name + '"\n' + dyn + '\n' + env + '\n' + freq
    
    #RPR_ShowConsoleMsg(score)
    
    for i, val in enumerate(instr_name):
      if name == val:
        createtextitem(i, position, length, score) 
        #RPR_ShowConsoleMsg(i)
        
  #closing files
  file.close() 
  

readfile(dialog())
