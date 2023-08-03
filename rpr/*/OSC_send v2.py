import socket, struct, re, sys
reload(sys)
sys.setdefaultencoding('utf8')

csound_OSC_port = 10000

def OSC_sendaction(address, action):
  s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  s.sendto(action, address)
  s.close()

def csound_getallout():
  OSC_sendaction(("localhost", csound_OSC_port), "instr route\n getallout()\n endin\n start \"route\"")

array_instr_num = []

def csound_send():

  global array_instr_num
  
  is_any_solo = RPR_AnyTrackSolo(0)
  
  indx = 0
  
  playpos = RPR_GetCursorPosition()
  
  if playpos>.05:
    playpos -= .05

  for i in range(RPR_CountTracks(0)):
    
    retval, meditem, parname, name, var = RPR_GetSetMediaTrackInfo_String(RPR_GetTrack(0, i), "P_NAME", 0, 0)
    
    is_mute = RPR_GetMediaTrackInfo_Value(RPR_GetTrack(0, i), "B_MUTE")
    
    if is_any_solo:
      is_solo = RPR_GetMediaTrackInfo_Value(RPR_GetTrack(0, i), "I_SOLO")
    else:
      is_solo = 1
    
    #RPR_ShowConsoleMsg(str(is_solo) + '\n')
    
    if name.startswith("cs") and is_mute==0.0 and is_solo>0:
      
      track = RPR_GetTrack(0, i)
      allmedianum = RPR_GetTrackNumMediaItems(track)
      
      for j in range(allmedianum):
        
        item = RPR_GetTrackMediaItem(track, j)
        pos = RPR_GetMediaItemInfo_Value(item, "D_POSITION")
        len = RPR_GetMediaItemInfo_Value(item, "D_LENGTH")
        
        if playpos<=pos:
        
          retval, meditem, parname, instr, var = RPR_GetSetMediaItemInfo_String(item, "P_NOTES", 0, 0)
          retval, item, parname, guid, var = RPR_GetSetMediaItemInfo_String(item, "GUID", 0, 0)
          
          start = pos - playpos
          startstring = str(start)
          lenstring = str(len)

          #SCHEDULECH if starts with "
          if instr.startswith('"') or instr.startswith('“') or  instr.startswith('”'):
                      
            lines = instr.splitlines()
            
            comma = ", "
            
            score = "schedulech " + lines[0] + comma + startstring + comma + lenstring + comma + lines[1] + comma + lines[2] + comma + lines[3] +"\n"
            
            score = re.sub('“', '"', score)
            score = re.sub('”', '"', score)
            
            OSC_sendaction(("localhost", 10000), score)
          
          #EVERYTHING ELSE
          else:
            instr = re.sub('“', '"', instr)
            instr = re.sub('”', '"', instr)
            
            #instrname = 'inst' + re.match("{(.*?)-", guid).group(1)
            #score = 'schedule "' + instrname + '", ' + startstring + ", " + lenstring + '\n'
            instrname = str(300 + indx)
            array_instr_num.append(str(300 + indx))
            #RPR_ShowConsoleMsg(instrname + '\n')
            score = 'schedule ' + instrname + ', ' + startstring + ", " + lenstring + '\n'

            instrwithcapture = 'instr ' + instrname + '\n' + instr + '\n' + 'endin\n'
                        
            #RPR_ShowConsoleMsg(instrwithcapture)
            #RPR_ShowConsoleMsg(j+i)
            
            OSC_sendaction(("localhost", 10000), instrwithcapture)
            OSC_sendaction(("localhost", 10000), score)
            
            indx += 1

      
def csound_stop():      
  stop = "exitnow"
  OSC_sendaction(("localhost", 10000), stop)
  
csound_hasplayed = False
csound_stopped = False

def checkifplay():
  
  global csound_hasplayed
  global csound_stopped
  global array_instr_num
  
  if RPR_GetPlayState()==1:
    if csound_hasplayed == False:
        
      OSC_sendaction(("localhost", 10000), 'schedule "heart", 0, -1\n')
      
      csound_send()
      csound_stopped = False
      csound_hasplayed = True
  else:
    #csound_stop()
    if csound_stopped == False:
    
      message_stop = 'instr 700\n'
    
      for x in range(len(array_instr_num)): 
      
        message_stop += 'turnoff2 ' + array_instr_num[x] + ', 0, 0\n'
        message_stop += 'turnoff3 ' + array_instr_num[x] + '\n'
        
      message_stop += 'endin\n' + 'schedule 700, 0, gizero\n'
      OSC_sendaction(("localhost", 10000), message_stop)
        
      OSC_sendaction(("localhost", 10000), 'turnoff2 "heart", 0, 0\n')
      
      csound_stopped = True
      csound_hasplayed = False
      
    
    array_instr_num *= 0
  
  RPR_defer('checkifplay()')

checkifplay()
