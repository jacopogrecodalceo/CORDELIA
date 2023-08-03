
for i in range(RPR_CountTracks(0)):

  reaper_track = RPR_GetTrack(0, i)
  play_pos = RPR_GetCursorPosition()

  for j in range(RPR_GetTrackNumMediaItems(reaper_track)):

    reaper_item = RPR_GetTrackMediaItem(reaper_track, j)
    reaper_take = RPR_GetMediaItemTake(reaper_item, 0)
    reaper_source = RPR_GetMediaItemTake_Source(reaper_take)
    source, source_type, size = RPR_GetMediaSourceType(reaper_source, '', 512)

    if source_type=='MIDI':
      ret_val, ret_take, ret_notes, ret_cc, ret_sysex = RPR_MIDI_CountEvts(reaper_take, 0, 0, 0)
      retval, meditem, parname, item_content, var = RPR_GetSetMediaItemInfo_String(reaper_item, "P_NOTES", 0, 0)

      for x in range(ret_notes):
        note_index = x
        ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_vel = RPR_MIDI_GetNote(reaper_take, note_index, 0, 0, 0, 0, 0, 0, 0)
        note_start = RPR_MIDI_GetProjTimeFromPPQPos(reaper_take, startppqposOut)
        note_dur = RPR_MIDI_GetProjTimeFromPPQPos(reaper_take, endppqposOut-startppqposOut)
        note_vel = float(note_vel)/256
        #RPR_ShowConsoleMsg(str(note_pitch) + ', ' + str(note_vel) + ', ' + str(note_start) + ', ' + str(note_dur) + '\n')
        
        if item_content=='':
          note_env = 'giclassic'
        else:
          note_env = item_content

        comma = ", "
        reaper_dir_track_name = 'test'
        score = 'schedulech "' + reaper_dir_track_name + '", ' + str(note_start-play_pos) + comma + str(note_dur) + comma + str(note_vel) + comma + note_env + comma + 'mtof(' + str(note_pitch) + ')\n'
        RPR_ShowConsoleMsg(score)
