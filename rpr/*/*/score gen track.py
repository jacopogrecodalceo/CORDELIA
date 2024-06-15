import struct, re, sys, os
reload(sys)
sys.setdefaultencoding('utf8')

#IDRA_FULL
#IDRA_ORC
#IDRA_SCORE

#GET PATH OF THE CURRENT PROJECT
reaper_project_path, buf_size = RPR_GetProjectPath("", 512)
reaper_project_path = reaper_project_path + '/'

#GET NAME OF THE PROJECT
reaper_project_num, reaper_project_name_ext, buf_size = RPR_GetProjectName(0, "", 512)
reaper_project_name = reaper_project_name_ext.rsplit(".", 1)[0]

#EXTERNAL PATH -- IDRA'S DIRECTORY
IDRA_core_path = '/Users/j/Documents/PROJECTs/IDRA/_core/'

IDRA_full_ending_name = '_full.orc'
IDRA_score_ending_name = '_score.orc'
IDRA_csd_ending_name = '.csd'

#GEN THE MAIN DIRECTORY
IDRA_project_dir = reaper_project_path + reaper_project_name + '_instrs/'
#RPR_ShowConsoleMsg(IDRA_project_dir + "\n")

if os.path.isdir(IDRA_project_dir):
  #RPR_ShowConsoleMsg(IDRA_project_dir + "\n")
  os.system('rm -r ' + IDRA_project_dir)

create_dir_command = 'mkdir ' + IDRA_project_dir
os.system(create_dir_command)

#GET TIME POSITION
time_sel_isset, time_sel_isloop, time_sel_start, time_sel_end, time_sel_allowautoseek = RPR_GetSet_LoopTimeRange(0, 0, 0, 0, 0)          
if time_sel_end>0:
  IDRA_time_start = time_sel_start
  IDRA_time_end   = time_sel_end
else:
  IDRA_time_start = 0
  IDRA_time_end = RPR_GetProjectLength(0)



#GENERATE IDRA SCORE
reaper_count_tracks = RPR_CountTracks(0)

IDRA_dir_name_array = [None]*reaper_count_tracks

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
      os.system('mkdir ' + IDRA_project_dir + dir_track_name)
      track_dir = IDRA_project_dir + dir_track_name + '/'
      #RPR_ShowConsoleMsg(track_dir + "\n")

      #GEN NAME FOR EACH TRACK
      IDRA_each_track_name = str(int(reaper_parent_track_num)) + '-' + reaper_project_name + '_' + reaper_parent_track_name

      #CREATE ORC
      IDRA_dir_name_array[int(reaper_parent_track_num)] = track_dir + IDRA_each_track_name

gen_dir_for_each_track()

for path in IDRA_dir_name_array:
  if path!=None:
    os.system('cp "' + IDRA_core_path + 'command.txt' + '" "' + path.rsplit('/', 1)[0] + '/__' + path.rsplit('/', 1)[-1] + '.command' + '"')

#CREATE AN ARRAY WITH ALL THE MEDIA ITEMS
IDRA_instr_num_array = []

def csound_score():

  #global IDRA_instr_num_array
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

      if reaper_parent_track_num!=0:

        for j in range(RPR_GetTrackNumMediaItems(reaper_track)):
          
          reaper_item = RPR_GetTrackMediaItem(reaper_track, j)
          item_position = RPR_GetMediaItemInfo_Value(reaper_item, "D_POSITION")
          item_len = RPR_GetMediaItemInfo_Value(reaper_item, "D_LENGTH")

          IDRA_track_dir = IDRA_dir_name_array[int(reaper_parent_track_num)] + IDRA_score_ending_name
          #RPR_ShowConsoleMsg(IDRA_track_dir + '\n')
          #RPR_ShowConsoleMsg(reaper_track_num)

          IDRA_instr_start = str(item_position)
          IDRA_instr_len = str(item_len)

          retval, meditem, parname, item_note, var = RPR_GetSetMediaItemInfo_String(reaper_item, "P_NOTES", 0, 0)
          
          #REPLACE BUGGY WITH UTF-8
          item_note = re.sub('“', '"', item_note)
          item_note = re.sub('”', '"', item_note)
          
          IDRA_instr_content = item_note

          #GEN INSTRUMENTS NUMBERS
          IDRA_instr_num = str(300 + indx)
          IDRA_instr_num_array.append(IDRA_instr_num)

          #GEN SCHEDULE FOR EACH INSTRUMENT
          IDRA_schedule = 'schedule ' + IDRA_instr_num + ', ' + IDRA_instr_start + ", " + IDRA_instr_len + '\n\n\n'
          
          #WRITE INSTRUMENT TRACK NUMBER -- FOR FUTURE PURPOSE
          IDRA_string_track_num = 'Strack\tinit\t"track_' + str(int(reaper_track_num)) + '"\n'
          IDRA_int_track_num = 'itrack\tinit\t' + str(int(reaper_track_num)) + '\n'

          IDRA_instr = '\tinstr\t' + IDRA_instr_num + '\n' + IDRA_string_track_num + IDRA_int_track_num + '\n' + IDRA_instr_content + '\n' + '\tendin\n'
          
          with open(IDRA_track_dir, 'a') as f:
              f.write(IDRA_instr)

          with open(IDRA_track_dir, 'a') as f:
              f.write(IDRA_schedule)
          
          indx += 1

      else:

        if RPR_GetTrackNumMediaItems(reaper_track)>0:
          
          #RPR_ShowConsoleMsg(str(RPR_GetTrackNumMediaItems(reaper_track)) + '\n')

          for j in range(RPR_GetTrackNumMediaItems(reaper_track)):
          
            reaper_item = RPR_GetTrackMediaItem(reaper_track, j)
            item_position = RPR_GetMediaItemInfo_Value(reaper_item, "D_POSITION")
            item_len = RPR_GetMediaItemInfo_Value(reaper_item, "D_LENGTH")

            #RPR_ShowConsoleMsg(IDRA_track_dir + '\n')
            #RPR_ShowConsoleMsg(reaper_track_num)

            IDRA_instr_start = str(item_position)
            IDRA_instr_len = str(item_len)

            retval, meditem, parname, item_note, var = RPR_GetSetMediaItemInfo_String(reaper_item, "P_NOTES", 0, 0)
            
            #REPLACE BUGGY WITH UTF-8
            item_note = re.sub('“', '"', item_note)
            item_note = re.sub('”', '"', item_note)
            
            IDRA_instr_content = item_note

            #GEN INSTRUMENTS NUMBERS
            IDRA_instr_num = str(300 + indx)
            IDRA_instr_num_array.append(IDRA_instr_num)

            #GEN SCHEDULE FOR EACH INSTRUMENT
            IDRA_schedule = 'schedule ' + IDRA_instr_num + ', ' + IDRA_instr_start + ", " + IDRA_instr_len + '\n\n\n'
            
            #WRITE INSTRUMENT TRACK NUMBER -- FOR FUTURE PURPOSE
            IDRA_string_track_num = 'Strack\tinit\t"track_' + str(int(reaper_track_num)) + '"\n'
            IDRA_int_track_num = 'itrack\tinit\t' + str(int(reaper_track_num)) + '\n'

            IDRA_instr = '\tinstr\t' + IDRA_instr_num + '\n' + IDRA_string_track_num + IDRA_int_track_num + '\n' + IDRA_instr_content + '\n' + '\tendin\n'
            
            for path in IDRA_dir_name_array:
              if path!=None:
                temp_path = path + IDRA_score_ending_name

                with open(temp_path, 'a') as f:
                    f.write(IDRA_instr)

                with open(temp_path, 'a') as f:
                    f.write(IDRA_schedule)
            
            indx += 1

csound_score() 

#EXIT FROM CSOUND -- 1 SECOND CODA
IDRA_exit = 'instr 700\nexitnow()\nendin\nschedule 700, '+ str(IDRA_time_end) + ', 1\n'

for path in IDRA_dir_name_array:
  if path!=None:
    temp_path = path + IDRA_score_ending_name
    with open(temp_path, 'a') as f:
      f.write(IDRA_exit)

#GENERATE IDRA CSOUND CSD
for path in IDRA_dir_name_array:
  if path!=None:
    os.system('cp ' + IDRA_core_path + '_livecode-settings.csd' + ' ' + path + IDRA_csd_ending_name)

#GENERATE IDRA FULL LIVECODING
for path in IDRA_dir_name_array:
  if path!=None:
    os.system('cp ' + IDRA_core_path + '_livecode-full.csd' + ' ' + path + IDRA_full_ending_name)

for path in IDRA_dir_name_array:
    if path!=None:
      IDRA_include_full = '#include "./' + path.rsplit('/', 1)[-1] + IDRA_full_ending_name + '"\n'
      IDRA_include_score = '#include "./' + path.rsplit('/', 1)[-1] + IDRA_score_ending_name + '"\n'
      IDRA_closing_cs = '\n\n\n\n</CsInstruments>\n<CsScore>\n</CsScore>\n</CsoundSynthesizer>'
      IDRA_ending = '\n' + IDRA_include_full + IDRA_include_score + IDRA_closing_cs
      with open(path + IDRA_csd_ending_name, 'a') as f:
        f.write(IDRA_ending)
