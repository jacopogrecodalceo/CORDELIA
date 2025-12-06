import struct, re, sys, os
reload(sys)
sys.setdefaultencoding('utf8')

project_folder, buf_size = RPR_GetProjectPath("", 512)
project_folder = project_folder + '/'

project_num, project_name_ext, buf_size = RPR_GetProjectName(0, "", 512)
project_name = project_name_ext.rsplit(".", 1)[0]

CORDELIA_path = '/Users/j/Documents/PROJECTs/CORDELIA/'

# create FOLDER
folder_command = 'mkdir ' + project_folder + project_name
os.system(folder_command)
project_folder = project_folder + project_name + '/'

#GEN COMMAND
os.system('cp "' + CORDELIA_path + '_scripts/_cmd/command.txt' + '" "' + project_folder + '__' + project_name + '.command' + '"')
os.system('cp "' + CORDELIA_path + '_scripts/_cmd/command_quick.txt' + '" "' + project_folder + '__' + project_name + '_quick.command' + '"')

time_sel = 0
time_sel_isset, time_sel_isloop, time_sel_start, time_sel_end, time_sel_allowautoseek = RPR_GetSet_LoopTimeRange(0, 0, 0, 0, 0)          

# create ORC
orc_name_ext = project_name + '_orc.orc'
orc_path = project_folder + orc_name_ext

if os.path.exists(orc_path):
  os.remove(orc_path)

RPR_instr_array = []

def write_orc(orc):

  global orc_path
  
  with open(orc_path, 'a') as f:
      f.write(orc)
      
  #RPR_ShowConsoleMsg(path)

def csound_score():

  global RPR_instr_array
    
  play_pos = RPR_GetCursorPosition()
  indx = 0

  track_dir_name = ''
  is_track_mute = False
  is_track_solo = True

  for i in range(RPR_CountTracks(0)):

    track_id = RPR_GetTrack(0, i)
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
    retval, buf, track_his_name, bufOut_sz = RPR_GetTrackName(track_id, 0, 512)

    if is_track_name and is_track_solo and not is_track_mute:
            
      for j in range(RPR_GetTrackNumMediaItems(track_id)):
        
        item_id = RPR_GetTrackMediaItem(track_id, j)
        item_pos = RPR_GetMediaItemInfo_Value(item_id, "D_POSITION")
        item_len = RPR_GetMediaItemInfo_Value(item_id, "D_LENGTH")
        
        if play_pos<=item_pos:
        
          retval, meditem, parname, item_note, var = RPR_GetSetMediaItemInfo_String(item_id, "P_NOTES", 0, 0)
          #retval, meditem, parname, item_guid, var = RPR_GetSetMediaItemInfo_String(item_id, "GUID", 0, 0)
          #item_guid = item_guid.replace('{', '').replace('}', '').replace('-', '')    
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
              if note_dur <= 0:
                note_dur = .25
              note_vel = float(note_vel)/512
              #RPR_ShowConsoleMsg(str(note_pitch) + ', ' + str(note_vel) + ', ' + str(note_start) + ', ' + str(note_dur) + '\n')
              
              if item_note=='':
                note_env = 'giclassic'
              else:
                note_env = str(item_note)

              comma = ", "

              if track_his_name.startswith('csedo'):

                root = re.search(r'^csedo\d+_(.+)', track_his_name).group(1).upper()
                root = '"0' + str(root) + '"'

                edo = str(re.search(r'^csedo(\d+)', track_his_name).group(1))

                degree = note_pitch
                icps = 'rpredo(' + root + comma + edo + comma + str(degree) + ')'

                OSC_schedule = 'evaMIDI "' + track_dir_name + '", ' + str(note_start-play_pos) + comma + str(note_dur-play_pos-item_pos) + comma + str(note_vel) + comma + note_env + comma + icps + '\n'
                write_orc(OSC_schedule)
              elif track_his_name.startswith('csdir'):

                division = str(re.search(r'^csdir(\d+)', track_his_name).group(1))

                if division==None:
                  division = 3

                OSC_schedule += 'evaMIDImode "' + track_dir_name + '", ' + str(note_start-play_pos) + comma + str(note_dur-play_pos-item_pos) + comma + str(note_vel) + comma + note_env + comma + str(division) + comma + str(2) + comma + str(note_pitch) + '\n'
                write_orc(OSC_schedule)

              else:
                OSC_schedule = 'evaMIDI "' + track_dir_name + '", ' + str(note_start-play_pos) + comma + str(note_dur-play_pos-item_pos) + comma + str(note_vel) + comma + note_env + comma + 'mtof:i(' + str(note_pitch) + ')\n'
                write_orc(OSC_schedule)

          else:
            item_note = item_note.replace('“', '"')
            item_note = item_note.replace('”', '"')

            item_note = item_note.replace('gkrprname', 'gk' + track_dir_name)
            item_note = item_note.replace('girprname', 'gi' + track_dir_name)
            item_note = item_note.replace('rprname', '"' + track_dir_name + '"')
            
            instr_name = 350+indx
            RPR_instr_array.append(instr_name)

            OSC_instr = 'instr ' + str(instr_name) + '\n' + item_note + '\n' + 'endin\n'
            OSC_schedule = 'schedule ' + str(instr_name) + ', ' + str(SCO_start) + ", " + str(item_len) + '\n'

            write_orc(OSC_instr)
            write_orc(OSC_schedule)
        
        indx += 1

  project_length = RPR_GetProjectLength(0)
  if time_sel_end!=0:
    project_length = time_sel_end
  write_orc('instr 700\nevent("e", 0, 1)\nendin\nschedule 700, '+ str(project_length) + ', 1\n')
            
csound_score()



# create CSD
CORDELIA_csd_name_ext = 'cordelia-setting.csd'
csd_name_ext = project_name + '.csd'
csd_path = project_folder + csd_name_ext

copy_csd = 'cp ' + CORDELIA_path + "_core/" + CORDELIA_csd_name_ext + ' ' + project_folder + csd_name_ext
os.system(copy_csd)


CORDELIA_csd_full = 'cordelia-full.csd'
full_path = project_folder + project_name + '_full' + '.csd'
copy_full_csd = 'cp ' + CORDELIA_path + "_core/" + CORDELIA_csd_full + ' ' + full_path
os.system(copy_full_csd)

def csd_write():

  define_midi = '#define midi  ##\n'
  define_nolimit = '#define nolimit  ##\n'
  include_csd = '#include "./' + project_name + '_full' + '.csd' + '"\n'
  include_orc = '#include "./' + orc_name_ext + '"'
  close = '\n\n\n\n</CsInstruments>\n<CsScore>\n</CsScore>\n</CsoundSynthesizer>'
  
  with open(csd_path, 'a') as f:
      f.write('\n' + define_nolimit + define_midi + include_csd + include_orc + close)

csd_write()

#os.system('open ' + project_folder + '__' + project_name + '_quick.command')
