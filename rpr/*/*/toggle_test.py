section_id = 0 #0, Main
#cmd_id = RPR_NamedCommandLookup("_S&M_DUMMY_TGL1")
cmd_id = RPR_NamedCommandLookup("_RS3f0090803a2e166647f75e3509da4927e2f1bbbf")

#is_new_value, filename, section_id, cmd_id, mode, resolution, val = RPR_get_action_context()
#toggle_state = RPR_GetToggleCommandStateEx(section_id, cmd_id)
toggle_state = RPR_GetToggleCommandState(cmd_id)
RPR_ShowConsoleMsg(toggle_state)

if toggle_state == 1:
  state_is = RPR_SetToggleCommandState(section_id, cmd_id, 1)
  RPR_RefreshToolbar2(section_id, cmd_id)
elif toggle_state == 0:
  state_is = RPR_SetToggleCommandState(section_id, cmd_id, 0)
  RPR_RefreshToolbar2(section_id, cmd_id)