import socket, struct, re, sys
reload(sys)
sys.setdefaultencoding('utf8')

def OSC_send(action):
  s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  s.sendto(action, ("localhost", 10000))
  s.close()

def csound_getallout():
  OSC_send("instr route\n getallout()\n endin\n start \"route\"")

RPR_instr_array = []

def csound_send():

  global RPR_instr_array
    
  play_pos = RPR_GetCursorPosition()

  track_dir_name = ''
  is_track_mute = False
  is_track_solo = True

  for i in range(RPR_CountTracks(0)):

    track_id = RPR_GetTrack(0, i)
    indx = 0
    #GET TRACK NAME
    retval, meditem, parname, track_name, var = RPR_GetSetMediaTrackInfo_String(track_id, "P_NAME", 0, 0)
    is_track_name = bool(track_name.startswith("cs"))

    #CHECK IF TRACK IS A FOLDER: 0=normal, 1=track is a folder parent
    track_depth = RPR_GetMediaTrackInfo_Value(track_id, "I_FOLDERDEPTH")

    if track_depth==1:
      is_track_mute = bool(RPR_GetMediaTrackInfo_Value(track_id, "B_MUTE"))
      if RPR_AnyTrackSolo(0):
        is_track_solo = bool(RPR_GetMediaTrackInfo_Value(track_id, "I_SOLO") > 0)
      retval, buf, track_dir_name, bufOut_sz = RPR_GetTrackName(track_id, 0, 512)

    if is_track_name and is_track_solo and not is_track_mute:
            
      for j in range(RPR_GetTrackNumMediaItems(track_id)):
        
        item_id = RPR_GetTrackMediaItem(track_id, j)
        item_pos = RPR_GetMediaItemInfo_Value(item_id, "D_POSITION")
        item_len = RPR_GetMediaItemInfo_Value(item_id, "D_LENGTH")
        
        if play_pos<=item_pos:
        
          retval, meditem, parname, item_note, var = RPR_GetSetMediaItemInfo_String(item_id, "P_NOTES", 0, 0)
          retval, meditem, parname, item_guid, var = RPR_GetSetMediaItemInfo_String(item_id, "GUID", 0, 0)
          item_guid = item_guid.replace('{', '').replace('}', '').replace('-', '')    
          #item_guid = item_guid[len(item_guid)//2:]

          SCO_start = item_pos - play_pos

          take_id = RPR_GetMediaItemTake(item_id, 0)
          source, source_type, size = RPR_GetMediaSourceType(RPR_GetMediaItemTake_Source(take_id), '', 512)

          if source_type=='MIDI':
            ret_val, ret_take, MIDI_notes, ret_cc, ret_sysex = RPR_MIDI_CountEvts(take_id, 0, 0, 0)

            for x in range(MIDI_notes):
              note_index = x
              ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_vel = RPR_MIDI_GetNote(take_id, note_index, 0, 0, 0, 0, 0, 0, 0)
              note_start = RPR_MIDI_GetProjTimeFromPPQPos(take_id, startppqposOut)
              note_dur = RPR_MIDI_GetProjTimeFromPPQPos(take_id, endppqposOut-startppqposOut)
              note_vel = float(note_vel)/512
              #RPR_ShowConsoleMsg(str(note_pitch) + ', ' + str(note_vel) + ', ' + str(note_start) + ', ' + str(note_dur) + '\n')
              
              if item_note=='':
                note_env = 'giclassic'
              else:
                note_env = str(item_note)

              comma = ", "
              OSC_schedule = 'evaMIDI "' + track_dir_name + '", ' + str(note_start) + comma + str(note_dur) + comma + str(note_vel) + comma + note_env + comma + 'mtof:i(' + str(note_pitch) + ')\n'
              OSC_send(OSC_schedule)

          else:
            item_note = item_note.replace('“', '"')
            item_note = item_note.replace('”', '"')

            item_note = item_note.replace('rprname', '"' + track_dir_name + '"')
            
            instr_name = 'i' + item_guid
            RPR_instr_array.append(instr_name)

            OSC_instr = 'instr ' + instr_name + '\n' + item_note + '\n' + 'endin\n'
            OSC_schedule = 'event "i", "' + instr_name + '", ' + str(SCO_start) + ", " + str(item_len) + '\n'

            OSC_send(OSC_instr)
            OSC_send(OSC_schedule)

            indx += 1
      
def csound_stop():      
  stop = "exitnow"
  OSC_send(stop)
  
csound_hasplayed = False
csound_stopped = False

def checkifplay():
  
  global csound_hasplayed
  global csound_stopped
  global RPR_instr_array
  
  if RPR_GetPlayState()==1:
    if csound_hasplayed == False:
        
      OSC_send('schedule "heart", 0, -1\n')
      
      csound_send()
      csound_stopped = False
      csound_hasplayed = True
  else:
    #csound_stop()
    if csound_stopped == False:
    
      message_stop = 'instr 700\n'
    
      for x in range(len(RPR_instr_array)): 
      
        message_stop += 'turnoff2 "' + RPR_instr_array[x] + '", 0, 0\n'
        message_stop += 'turnoff3 "' + RPR_instr_array[x] + '"\n'
      
      message_stop += 'turnoff\n'
        
      message_stop += 'endin\n' + 'schedule 700, 0, 1\n'
      OSC_send(message_stop)
        
      OSC_send('turnoff2 "heart", 0, 0\n')
      
      csound_stopped = True
      csound_hasplayed = False
      
    
    RPR_instr_array *= 0
  
  RPR_defer('checkifplay()')

checkifplay()
