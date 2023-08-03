import socket, struct, re, sys, os
reload(sys)
sys.setdefaultencoding('utf8')

project_folder, buf_size = RPR_GetProjectPath("", 512)
project_folder = project_folder + '/'

project_num, project_name_ext, buf_size = RPR_GetProjectName(0, "", 512)
project_name = project_name_ext.rsplit(".", 1)[0]

IDRA_path = '/Users/j/Documents/PROJECTs/IDRA/_core/'

# create FOLDER
folder_command = 'mkdir ' + project_folder + project_name
os.system(folder_command)
project_folder = project_folder + project_name + '/'

# create COMMAND
IDRA_command_name_ext = 'command.txt'
command_name_ext = '__' + project_name + '.command'

copy_command = 'cp "' + IDRA_path + IDRA_command_name_ext + '" "' + project_folder + command_name_ext + '"'
#RPR_ShowConsoleMsg(copy_command)
os.system(copy_command)



# create ORC
orc_name_ext = project_name + '.orc'
orc_path = project_folder + orc_name_ext

if os.path.exists(orc_path):
  os.remove(orc_path)

instr_num = []

def write_orc(orc):

  global folder, orc_path
  
  with open(orc_path, 'a') as f:
      f.write(orc)
      
  #RPR_ShowConsoleMsg(path)

def csound_score():

  global instr_num
  
  indx = 0
  
  playpos = RPR_GetCursorPosition()

  for i in range(RPR_CountTracks(0)):
    
    retval, meditem, parname, name, var = RPR_GetSetMediaTrackInfo_String(RPR_GetTrack(0, i), "P_NAME", 0, 0)
    
    is_mute = RPR_GetMediaTrackInfo_Value(RPR_GetTrack(0, i), "B_MUTE")
    
    if name.startswith("cs") and is_mute==0.0:
      
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
            
            write_orc(score)
          
          #EVERYTHING ELSE
          else:
          
            #replace bug utf-8
            instr = re.sub('“', '"', instr)
            instr = re.sub('”', '"', instr)
            #replace e() with e_mid()
            instr = re.sub('eva\(', 'eva_i(itrack, ', instr) 
            instr = re.sub('evad\(', 'evad_i(itrack, ', instr)
            #RPR_ShowConsoleMsg(instr)
            
            #instrname = 'inst' + re.match("{(.*?)-", guid).group(1)
            #score = 'schedule "' + instrname + '", ' + startstring + ", " + lenstring + '\n'
            instrname = str(300 + indx)
            instr_num.append(str(300 + indx))
            #RPR_ShowConsoleMsg(instrname + '\n')
            score = 'schedule ' + instrname + ', ' + startstring + ", " + lenstring + '\n\n\n'
            
            
            track_num = RPR_GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
            track_num = str(int(track_num))
            string_track_num = '\tStrack\tinit\t"track_' + track_num + '"\n'
            int_track_num = '\titrack\tinit\t' + track_num + '\n'

            instrwithcapture = '\tinstr\t' + instrname + '\n' + string_track_num + int_track_num + '\n' + instr + '\n' + '\tendin\n'
                        
            #RPR_ShowConsoleMsg(instrwithcapture)
            #RPR_ShowConsoleMsg(j+i)
            
            write_orc(instrwithcapture)
            write_orc(score)
            
            indx += 1
            
  project_length = RPR_GetProjectLength(0)
  project_length = str(project_length+10)
  write_orc('instr 700\nexitnow()\nendin\nschedule 700, '+ project_length + ', 1\n')
            
csound_score()



# create CSD
IDRA_csd_name_ext = '_livecode-settings.csd'
csd_name_ext = project_name + '_score' + '.csd'
csd_path = project_folder + csd_name_ext

copy_csd = 'cp ' + IDRA_path + IDRA_csd_name_ext + ' ' + project_folder + csd_name_ext
os.system(copy_csd)

def csd_write():

  define_midi = '#define midi  ##\n'
  define_nolimit = '#define nolimit  ##\n'
  include_csd = '#include "' + IDRA_path + '_livecode-include.csd' + '"\n'
  include_orc = '#include "./' + orc_name_ext + '"'
  close = '\n\n\n\n</CsInstruments>\n<CsScore>\n</CsScore>\n</CsoundSynthesizer>'
  
  with open(csd_path, 'a') as f:
      f.write('\n' + define_nolimit + define_midi + include_csd + include_orc + close)

csd_write()


