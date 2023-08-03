import socket, struct, re, sys
reload(sys)
sys.setdefaultencoding('utf8')

def OSC_sendaction(action):
  s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  s.sendto(action, ("localhost", 10000))
  s.close()

def csound_getallout():
  OSC_sendaction("instr route\n getallout()\n endin\n start \"route\"")

array_instr_num = []

def csound_send():

  global array_instr_num
  reaper_dir_track_name = ''
  is_mute = 0
  is_any_solo = RPR_AnyTrackSolo(0)
  
  indx = 0
  
  playpos = RPR_GetCursorPosition()

  for i in range(RPR_CountTracks(0)):
    
    retval, meditem, parname, name, var = RPR_GetSetMediaTrackInfo_String(RPR_GetTrack(0, i), "P_NAME", 0, 0)

    #is_mute = RPR_GetMediaTrackInfo_Value(RPR_GetTrack(0, i), "B_MUTE")
    
    if is_any_solo:
      is_solo = RPR_GetMediaTrackInfo_Value(RPR_GetTrack(0, i), "I_SOLO")
    else:
      is_solo = 1
    
    #RPR_ShowConsoleMsg(str(is_solo) + '\n')
    
    reaper_track_depth = RPR_GetMediaTrackInfo_Value(RPR_GetTrack(0, i), "I_FOLDERDEPTH")
    if reaper_track_depth==1:
      is_mute = RPR_GetMediaTrackInfo_Value(RPR_GetTrack(0, i), "B_MUTE")
      retval, buf, reaper_dir_track_name, bufOut_sz = RPR_GetTrackName(RPR_GetTrack(0, i), 0, 512)

    if name.startswith("cs") and is_mute==0.0 and is_solo>0:
      
      track = RPR_GetTrack(0, i)

      allmedianum = RPR_GetTrackNumMediaItems(track)
      
      for j in range(allmedianum):
        
        item = RPR_GetTrackMediaItem(track, j)
        pos = RPR_GetMediaItemInfo_Value(item, "D_POSITION")
        len = RPR_GetMediaItemInfo_Value(item, "D_LENGTH")
        
        if playpos<=pos:
        
          retval, meditem, parname, instr, var = RPR_GetSetMediaItemInfo_String(item, "P_NOTES", 0, 0)
          #retval, item, parname, guid, var = RPR_GetSetMediaItemInfo_String(item, "GUID", 0, 0)
          
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
            
            OSC_sendaction(score)
          
          #EVERYTHING ELSE
          else:

            reaper_take = RPR_GetMediaItemTake(RPR_GetTrackMediaItem(track, j), 0)
            source, source_type, size = RPR_GetMediaSourceType(RPR_GetMediaItemTake_Source(reaper_take), '', 512)

            if source_type=='MIDI':
              ret_val, ret_take, ret_notes, ret_cc, ret_sysex = RPR_MIDI_CountEvts(reaper_take, 0, 0, 0)
              retval, meditem, parname, item_content, var = RPR_GetSetMediaItemInfo_String(item, "P_NOTES", 0, 0)

              for x in range(ret_notes):
                note_index = x
                ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_vel = RPR_MIDI_GetNote(reaper_take, note_index, 0, 0, 0, 0, 0, 0, 0)
                note_start = RPR_MIDI_GetProjTimeFromPPQPos(reaper_take, startppqposOut)
                note_dur = RPR_MIDI_GetProjTimeFromPPQPos(reaper_take, endppqposOut-startppqposOut)
                note_vel = float(note_vel)/512
                #RPR_ShowConsoleMsg(str(note_pitch) + ', ' + str(note_vel) + ', ' + str(note_start) + ', ' + str(note_dur) + '\n')
                
                if item_content=='':
                  note_env = 'giclassic'
                else:
                  note_env = str(item_content)

                comma = ", "
                score = 'evaMIDI "' + reaper_dir_track_name + '", ' + str(note_start) + comma + str(note_dur) + comma + str(note_vel) + comma + note_env + comma + 'mtof:i(' + str(note_pitch) + ')\n'
                OSC_sendaction(score)

            else:
              instr = re.sub('“', '"', instr)
              instr = re.sub('”', '"', instr)

              instr = re.sub('rprname', '"' + reaper_dir_track_name + '"', instr)
              #instr = instr.replace('rprname', '"' + reaper_dir_track_name + '"')
              #instrname = 'inst' + re.match("{(.*?)-", guid).group(1)
              #score = 'schedule "' + instrname + '", ' + startstring + ", " + lenstring + '\n'
              instrname = str(300 + indx)
              array_instr_num.append(str(300 + indx))
              #RPR_ShowConsoleMsg(instrname + '\n')
              score = 'schedule ' + instrname + ', ' + startstring + ", " + lenstring + '\n'

              instrwithcapture = 'instr ' + instrname + '\n' + instr + '\n' + 'endin\n'
                          
              #RPR_ShowConsoleMsg(instrwithcapture)
              #RPR_ShowConsoleMsg(j+i)
              
              OSC_sendaction(instrwithcapture)
              OSC_sendaction(score)
              
              indx += 1

      
def csound_stop():      
  stop = "exitnow"
  OSC_sendaction(stop)
  
csound_hasplayed = False
csound_stopped = False

def checkifplay():
  
  global csound_hasplayed
  global csound_stopped
  global array_instr_num
  
  if RPR_GetPlayState()==1:
    if csound_hasplayed == False:
        
      OSC_sendaction('schedule "heart", 0, -1\n')
      
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
      OSC_sendaction(message_stop)
        
      OSC_sendaction('turnoff2 "heart", 0, 0\n')
      
      csound_stopped = True
      csound_hasplayed = False
      
    
    array_instr_num *= 0
  
  RPR_defer('checkifplay()')

checkifplay()
