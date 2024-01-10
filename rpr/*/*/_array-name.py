import socket, struct, re, sys
reload(sys)
sys.setdefaultencoding('utf8')

csound_OSC_port = 10000

def OSC_sendaction(action):
  address = ("localhost", 10000)
  s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  s.sendto(action, address)
  s.close()

instr_array = []

def csound_send():

  global instr_array
  
  is_any_solo = RPR_AnyTrackSolo(0)
  play_pos = RPR_GetCursorPosition()

  indx = 0

  for i in range(RPR_CountTracks(0)):
    
    retval, meditem, parname, name, var = RPR_GetSetMediaTrackInfo_String(RPR_GetTrack(0, i), "P_NAME", 0, 0)
    is_mute = RPR_GetMediaTrackInfo_Value(RPR_GetTrack(0, i), "B_MUTE")
    
    if is_any_solo:
      is_solo = RPR_GetMediaTrackInfo_Value(RPR_GetTrack(0, i), "I_SOLO")
    else:
      is_solo = 1
        
    if name.startswith("cs") and is_mute==0.0 and is_solo>0:
      
      track = RPR_GetTrack(0, i)
      howmany_item = RPR_GetTrackNumMediaItems(track)
      
      for j in range(howmany_item):
        
        item = RPR_GetTrackMediaItem(track, j)
        item_name = re.search('(\d+.*)', item).group()
        item_name = re.search('0x0000(.+)', item).group(1)
        #RPR_ShowConsoleMsg(item_name + '\n')
        item_pos = RPR_GetMediaItemInfo_Value(item, "D_POSITION")
        item_len = RPR_GetMediaItemInfo_Value(item, "D_LENGTH")

        if play_pos<=item_pos:
        
          retval, meditem, parname, item_content, var = RPR_GetSetMediaItemInfo_String(item, "P_NOTES", 0, 0)
          
          start = item_pos - play_pos

          #SCHEDULECH if starts with "
          if item_content.startswith('"') or item_content.startswith('“') or  item_content.startswith('”'):
                      
            lines = item_content.splitlines()
            
            comma = ", "
            
            OSC_schedule = "schedulech " + lines[0] + comma + str(start) + comma + str(item_len) + comma + lines[1] + comma + lines[2] + comma + lines[3] +"\n"
            
            OSC_schedule = re.sub('“', '"', OSC_schedule)
            OSC_schedule = re.sub('”', '"', OSC_schedule)
            
            OSC_sendaction(OSC_schedule)
          
          #EVERYTHING ELSE
          else:
            item_content = re.sub('“', '"', item_content)
            item_content = re.sub('”', '"', item_content)
            
            instr_name = str('item' + str(item_name))
            instr_name_inschedule = '"' + instr_name + '"'
            instr_array.append(instr_name)
            #RPR_ShowConsoleMsg(instr_name + '\n')
            OSC_schedule = 'schedule ' + instr_name_inschedule + ', ' + str(start) + ', ' + str(item_len) + '\n'

            OSC_instr = 'instr ' + instr_name + '\n' + item_content + '\n' + 'endin\n'
                        
            #RPR_ShowConsoleMsg(instrwithcapture)
            #RPR_ShowConsoleMsg(j+i)
            
            OSC_sendaction(OSC_instr)
            OSC_sendaction(OSC_schedule)
            
            indx += 1

      
def csound_stop():      
  stop = "exitnow"
  OSC_sendaction(stop)
  
csound_hasplayed = False
csound_stopped = False

def checkifplay():
  
  global csound_hasplayed
  global csound_stopped
  global instr_array
  
  if RPR_GetPlayState()==1:
    if csound_hasplayed == False:
        
      OSC_sendaction('schedule "heart", 0, -1\n')
      
      csound_send()
      csound_stopped = False
      csound_hasplayed = True
  else:
    #csound_stop()
    if csound_stopped == False:
    
      message_stop = 'instr turnmeoff\n'
    
      for x in range(len(instr_array)): 
      
        message_stop += 'turnoff2 nstrnum("' + instr_array[x] + '"), 0, 0\n'
        message_stop += 'turnoff3 nstrnum("' + instr_array[x] + '")\n'
        
      message_stop += 'turnoff\n' + 'endin\n' + 'schedule "turnmeoff", 0, 1\n'
      
      OSC_sendaction(message_stop)
      OSC_sendaction('turnoff2 "heart", 0, 0\n')
      
      csound_stopped = True
      csound_hasplayed = False
    
    instr_array *= 0
  
  RPR_defer('checkifplay()')

checkifplay()
