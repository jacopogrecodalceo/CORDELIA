-- @noindex

-- N.B.:
-- This script requires Stephan Roemer's script "sr_Open MIDI editor and zoom to content.lua" available in his ReaPack repo: https://github.com/StephanRoemer/ReaScripts/raw/master/index.xml

local selected_items_count, open_midi_editor_and_zoom_to_content, show_item_properties, open_item_in_external_editor, this_selected_item, this_selected_item_active_take, this_selected_item_source, this_selected_item_source_type, at_least_1_midi_item_is_selected, at_least_1_subproject_is_selected

reaper.Undo_BeginBlock()

selected_items_count = reaper.CountSelectedMediaItems(0)
open_midi_editor_and_zoom_to_content = reaper.NamedCommandLookup("_RS84074b5fb92a906b135f993286a2bfb5f7bc86bd")
show_item_properties = 40009
open_item_in_external_editor = 40109
open_note = 40850

for i = 0, selected_items_count-1 do
	this_selected_item = reaper.GetSelectedMediaItem(0, i)
	this_selected_item_active_take = reaper.GetActiveTake(this_selected_item)

	if this_selected_item_active_take then
		this_selected_item_source = reaper.GetMediaItemTake_Source(this_selected_item_active_take)
		this_selected_item_source_type = reaper.GetMediaSourceType(this_selected_item_source)

		if this_selected_item_source_type == "SECTION" then
			this_selected_item_source = reaper.GetMediaSourceParent(this_selected_item_source)
			this_selected_item_source_type = reaper.GetMediaSourceType(this_selected_item_source)
		end
	end

	if this_selected_item_source_type == nil then
		reaper.Main_OnCommand(open_note, 0)

	elseif this_selected_item_source_type == "MIDI" or this_selected_item_source_type == "MIDIPOOL" then
		at_least_1_midi_item_is_selected = true

	elseif this_selected_item_source_type == "SUBPROJECT" or this_selected_item_source_type == "RPP_PROJECT" then
		at_least_1_subproject_is_selected = true
	end
end

if at_least_1_midi_item_is_selected then
	reaper.Main_OnCommand(open_midi_editor_and_zoom_to_content, 0)

elseif at_least_1_subproject_is_selected then
	reaper.Main_OnCommand(open_item_in_external_editor, 0)

else
	if this_selected_item_source_type ~= nil then
		reaper.Main_OnCommand(show_item_properties, 0)
	end
end

reaper.Undo_EndBlock("MB_Open item properties or subproject or MIDI Editor and zoom to content", -1)