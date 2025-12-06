import socket, struct, re, sys
reload(sys)
sys.setdefaultencoding('utf8')

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

  for j in range(RPR_GetTrackNumMediaItems(track_id)):
    item_id = RPR_GetTrackMediaItem(track_id, j)
    retval, meditem, parname, item_guid, var = RPR_GetSetMediaItemInfo_String(item_id, "GUID", 0, 0)
    item_guid = item_guid.replace('{', '').replace('}', '').replace('-', '')
    RPR_ShowConsoleMsg(item_guid)
    RPR_ShowConsoleMsg('\n')





