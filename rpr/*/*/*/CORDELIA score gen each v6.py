import struct, re, sys, os
reload(sys)
sys.setdefaultencoding('utf8')

#CORDELIA_FULL
#CORDELIA_ORC
#CORDELIA_SCORE

#GET PATH OF THE CURRENT PROJECT
reaper_project_path, buf_size = RPR_GetProjectPath("", 512)
reaper_project_path = reaper_project_path + '/'

#GET NAME OF THE PROJECT
reaper_project_num, reaper_project_name_ext, buf_size = RPR_GetProjectName(0, "", 512)
reaper_project_name = reaper_project_name_ext.rsplit(".", 1)[0]

#EXTERNAL PATH -- CORDELIA'S DIRECTORY
CORDELIA_core_path = '/Users/j/Documents/PROJECTs/CORDELIA/_core/'
CORDELIA_path = '/Users/j/Documents/PROJECTs/CORDELIA/'

CORDELIA_full_ending_name = '_full.orc'
CORDELIA_score_ending_name = '_score.orc'
CORDELIA_csd_ending_name = '.csd'

#GEN THE MAIN DIRECTORY
CORDELIA_project_dir = reaper_project_path + reaper_project_name + '_instrs/'
#RPR_ShowConsoleMsg(CORDELIA_project_dir + "\n")

if os.path.isdir(CORDELIA_project_dir):
  #RPR_ShowConsoleMsg(CORDELIA_project_dir + "\n")
  os.system('rm -r ' + CORDELIA_project_dir)

create_dir_command = 'mkdir ' + CORDELIA_project_dir
os.system(create_dir_command)
os.system('cp "' + CORDELIA_path + '_scripts/_cmd/command_instr-dir.txt' + '" "' + CORDELIA_project_dir.rsplit('/', 1)[0] + '/__' + CORDELIA_project_dir.rsplit('/', 1)[-1] + '.command' + '"')

#GET TIME POSITION
time_sel_isset, time_sel_isloop, time_sel_start, time_sel_end, time_sel_allowautoseek = RPR_GetSet_LoopTimeRange(0, 0, 0, 0, 0)          
if time_sel_end>0:
  CORDELIA_time_start = time_sel_start
  CORDELIA_time_end   = time_sel_end
else:
  CORDELIA_time_start = 0
  CORDELIA_time_end = RPR_GetProjectLength(0)



#GENERATE CORDELIA SCORE
reaper_count_tracks = RPR_CountTracks(0)

CORDELIA_dir_name_array = [None]*reaper_count_tracks

def gen_dir_for_each_track():  

  for i in range(reaper_count_tracks):
    
    reaper_track = RPR_GetTrack(0, i)
    reaper_track_mute = RPR_GetMediaTrackInfo_Value(reaper_track, "B_MUTE")
    reaper_track_depth = RPR_GetMediaTrackInfo_Value(reaper_track, "I_FOLDERDEPTH")

    if reaper_track_depth==1 and not reaper_track_mute:
      retval, buf, reaper_parent_track_name, bufOut_sz = RPR_GetTrackName(reaper_track, 0, 512)
      reaper_parent_track_num = RPR_GetMediaTrackInfo_Value(reaper_track, "IP_TRACKNUMBER")
      reaper_parent_track_name = reaper_parent_track_name.lower()
      dir_track_name = str(int(reaper_parent_track_num)) + '-' + reaper_parent_track_name

      #CREATE DIRECTORY WITH THE TRACK NAME
      os.system('mkdir ' + CORDELIA_project_dir + dir_track_name)
      track_dir = CORDELIA_project_dir + dir_track_name + '/'
      #RPR_ShowConsoleMsg(track_dir + "\n")

      #GEN NAME FOR EACH TRACK
      CORDELIA_each_track_name = str(int(reaper_parent_track_num)) + '-' + reaper_project_name + '_' + reaper_parent_track_name

      #CREATE ORC
      CORDELIA_dir_name_array[int(reaper_parent_track_num)] = track_dir + CORDELIA_each_track_name

gen_dir_for_each_track()

for path in CORDELIA_dir_name_array:
  if path!=None:
    os.system('cp "' + CORDELIA_path + '_scripts/_cmd/command_instr.txt' + '" "' + path.rsplit('/', 1)[0] + '/__' + path.rsplit('/', 1)[-1] + '.sh' + '"')

#CREATE AN ARRAY WITH ALL THE MEDIA ITEMS
CORDELIA_instr_num_array = []

def csound_score():

  #global CORDELIA_instr_num_array
  indx = 0

  for i in range(RPR_CountTracks(0)):

    reaper_track = RPR_GetTrack(0, i)
    reaper_track_num = RPR_GetMediaTrackInfo_Value(reaper_track, "IP_TRACKNUMBER")
    reaper_track_mute = RPR_GetMediaTrackInfo_Value(reaper_track, "B_MUTE")
    reaper_track_depth = RPR_GetMediaTrackInfo_Value(reaper_track, "I_FOLDERDEPTH")

    if reaper_track_depth!=1 and not reaper_track_mute:  

      #GET INFO TRACK
      reaper_track_parent = RPR_GetParentTrack(reaper_track)
      reaper_parent_track_num = RPR_GetMediaTrackInfo_Value(reaper_track_parent, "IP_TRACKNUMBER")
      retval, buf, reaper_track_parent_name, bufOut_sz = RPR_GetTrackName(reaper_track_parent, 0, 512)
      retval, buf, track_his_name, bufOut_sz = RPR_GetTrackName(reaper_track, 0, 512)

      if reaper_parent_track_num!=0:

        for j in range(RPR_GetTrackNumMediaItems(reaper_track)):

          reaper_item = RPR_GetTrackMediaItem(reaper_track, j)
          item_position = RPR_GetMediaItemInfo_Value(reaper_item, "D_POSITION")
          item_len = RPR_GetMediaItemInfo_Value(reaper_item, "D_LENGTH")

          CORDELIA_track_dir = CORDELIA_dir_name_array[int(reaper_parent_track_num)] + CORDELIA_score_ending_name
          #RPR_ShowConsoleMsg(CORDELIA_track_dir + '\n')
          #RPR_ShowConsoleMsg(reaper_track_num)

          CORDELIA_instr_start = str(item_position)
          CORDELIA_instr_len = str(item_len)

          retval, meditem, parname, item_note, var = RPR_GetSetMediaItemInfo_String(reaper_item, "P_NOTES", 0, 0)
          
          #---ADDED 28 febraury
          reaper_take_id = RPR_GetMediaItemTake(reaper_item, 0)
          source, item_type, size = RPR_GetMediaSourceType(RPR_GetMediaItemTake_Source(reaper_take_id), '', 512)

          if item_type=='MIDI':
            ret_val, ret_take, MIDI_notes, ret_cc, ret_sysex = RPR_MIDI_CountEvts(reaper_take_id, 0, 0, 0)

            for x in range(MIDI_notes):
              note_index = x
              ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_vel = RPR_MIDI_GetNote(reaper_take_id, note_index, 0, 0, 0, 0, 0, 0, 0)
              note_start = RPR_MIDI_GetProjTimeFromPPQPos(reaper_take_id, startppqposOut)
              note_dur = RPR_MIDI_GetProjTimeFromPPQPos(reaper_take_id, endppqposOut-startppqposOut)
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

                OSC_schedule = 'evaMIDI "' + reaper_track_parent_name + '", ' + str(note_start) + comma + str(note_dur-item_position) + comma + str(note_vel) + comma + note_env + comma + icps + '\n'
                with open(CORDELIA_track_dir, 'a') as f:
                  f.write(OSC_schedule)
              elif track_his_name.startswith('csdir'):

                division = str(re.search(r'^csdir(\d+)', track_his_name).group(1))

                if division==None:
                  division = 3

                OSC_schedule += 'evaMIDImode "' + reaper_track_parent_name + '", ' + str(note_start) + comma + str(note_dur-item_position) + comma + str(note_vel) + comma + note_env + comma + str(division) + comma + str(2) + comma + str(note_pitch) + '\n'
                with open(CORDELIA_track_dir, 'a') as f:
                  f.write(OSC_schedule)
              else:
                OSC_schedule = 'evaMIDI "' + reaper_track_parent_name + '", ' + str(note_start) + comma + str(note_dur-item_position) + comma + str(note_vel) + comma + note_env + comma + 'mtof:i(' + str(note_pitch) + ')\n'
                with open(CORDELIA_track_dir, 'a') as f:
                  f.write(OSC_schedule)
          else:
            #---

            #REPLACE BUGGY WITH UTF-8
            item_note = re.sub('“', '"', item_note)
            item_note = re.sub('”', '"', item_note)

            item_note = re.sub('gkrprname', 'gk' + reaper_track_parent_name, item_note)
            item_note = re.sub('girprname', 'gi' + reaper_track_parent_name, item_note)
            item_note = re.sub('rprname', '"' + reaper_track_parent_name + '"', item_note)
            
            CORDELIA_instr_content = item_note

            #GEN INSTRUMENTS NUMBERS
            CORDELIA_instr_num = str(300 + indx)
            CORDELIA_instr_num_array.append(CORDELIA_instr_num)

            #GEN SCHEDULE FOR EACH INSTRUMENT
            CORDELIA_schedule = 'schedule ' + CORDELIA_instr_num + ', ' + CORDELIA_instr_start + ", " + CORDELIA_instr_len + '\n\n\n'
            
            #WRITE INSTRUMENT TRACK NUMBER -- FOR FUTURE PURPOSE
            CORDELIA_string_track_num = 'Strack\tinit\t"track_' + str(int(reaper_track_num)) + '"\n'
            CORDELIA_int_track_num = 'itrack\tinit\t' + str(int(reaper_track_num)) + '\n'

            CORDELIA_instr = '\tinstr\t' + CORDELIA_instr_num + '\n' + CORDELIA_string_track_num + CORDELIA_int_track_num + '\n' + CORDELIA_instr_content + '\n' + '\tendin\n'
            
            with open(CORDELIA_track_dir, 'a') as f:
                f.write(CORDELIA_instr)

            with open(CORDELIA_track_dir, 'a') as f:
                f.write(CORDELIA_schedule)
            
            indx += 1

      else:

        if RPR_GetTrackNumMediaItems(reaper_track)>0:
          
          #RPR_ShowConsoleMsg(str(RPR_GetTrackNumMediaItems(reaper_track)) + '\n')

          for j in range(RPR_GetTrackNumMediaItems(reaper_track)):
          
            reaper_item = RPR_GetTrackMediaItem(reaper_track, j)
            item_position = RPR_GetMediaItemInfo_Value(reaper_item, "D_POSITION")
            item_len = RPR_GetMediaItemInfo_Value(reaper_item, "D_LENGTH")

            #RPR_ShowConsoleMsg(CORDELIA_track_dir + '\n')
            #RPR_ShowConsoleMsg(reaper_track_num)

            CORDELIA_instr_start = str(item_position)
            CORDELIA_instr_len = str(item_len)

            retval, meditem, parname, item_note, var = RPR_GetSetMediaItemInfo_String(reaper_item, "P_NOTES", 0, 0)
            
            #REPLACE BUGGY WITH UTF-8
            item_note = re.sub('“', '"', item_note)
            item_note = re.sub('”', '"', item_note)
           
            CORDELIA_instr_content = item_note

            #GEN INSTRUMENTS NUMBERS
            CORDELIA_instr_num = str(300 + indx)
            CORDELIA_instr_num_array.append(CORDELIA_instr_num)

            #GEN SCHEDULE FOR EACH INSTRUMENT
            CORDELIA_schedule = 'schedule ' + CORDELIA_instr_num + ', ' + CORDELIA_instr_start + ", " + CORDELIA_instr_len + '\n\n\n'
            
            #WRITE INSTRUMENT TRACK NUMBER -- FOR FUTURE PURPOSE
            CORDELIA_string_track_num = 'Strack\tinit\t"track_' + str(int(reaper_track_num)) + '"\n'
            CORDELIA_int_track_num = 'itrack\tinit\t' + str(int(reaper_track_num)) + '\n'

            CORDELIA_instr = '\tinstr\t' + CORDELIA_instr_num + '\n' + CORDELIA_string_track_num + CORDELIA_int_track_num + '\n' + CORDELIA_instr_content + '\n' + '\tendin\n'
            
            for path in CORDELIA_dir_name_array:
              if path!=None:
                temp_path = path + CORDELIA_score_ending_name

                with open(temp_path, 'a') as f:
                    f.write(CORDELIA_instr)

                with open(temp_path, 'a') as f:
                    f.write(CORDELIA_schedule)
            
            indx += 1

csound_score() 

#EXIT FROM CSOUND -- 1 SECOND CODA
CORDELIA_exit = 'instr 700\nevent("e", 0, 1)\nendin\nschedule 700, '+ str(CORDELIA_time_end) + ', 1\n'

for path in CORDELIA_dir_name_array:
  if path!=None:
    temp_path = path + CORDELIA_score_ending_name
    with open(temp_path, 'a') as f:
      f.write(CORDELIA_exit)

#GENERATE CORDELIA CSOUND CSD
for path in CORDELIA_dir_name_array:
  if path!=None:
    os.system('cp ' + CORDELIA_core_path + 'cordelia-setting.csd' + ' ' + path + CORDELIA_csd_ending_name)

#GENERATE CORDELIA FULL LIVECODING
for path in CORDELIA_dir_name_array:
  if path!=None:
    os.system('cp ' + CORDELIA_core_path + 'cordelia-full.csd' + ' ' + path + CORDELIA_full_ending_name)

for path in CORDELIA_dir_name_array:
    if path!=None:
      CORDELIA_include_full = '#include "./' + path.rsplit('/', 1)[-1] + CORDELIA_full_ending_name + '"\n'
      CORDELIA_include_score = '#include "./' + path.rsplit('/', 1)[-1] + CORDELIA_score_ending_name + '"\n'
      CORDELIA_closing_cs = '\n\n\n\n</CsInstruments>\n<CsScore>\n</CsScore>\n</CsoundSynthesizer>'
      CORDELIA_ending = '\n' + CORDELIA_include_full + CORDELIA_include_score + CORDELIA_closing_cs
      with open(path + CORDELIA_csd_ending_name, 'a') as f:
        f.write(CORDELIA_ending)
