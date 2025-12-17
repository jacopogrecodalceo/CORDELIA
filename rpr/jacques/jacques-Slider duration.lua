-- @description Duration Slider + Live Item Update
local function load_modules(dir)
    local i = 0
    while true do
        local file_name = reaper.EnumerateFiles(dir, i)
        if not file_name then break end

        local mod_name = file_name:match("^func%-(.+)%.lua$")
        if mod_name then
            local file_path = dir .. file_name
            local ok, mod = pcall(dofile, file_path)
            if ok and type(mod) == "table" then
                -- assign module to global variable with the same name as the file suffix
                _G[mod_name] = mod
            end
        end

        i = i + 1
    end
end

local script_path = debug.getinfo(1, 'S').source:sub(2):match("(.*/)")
local script_name = 'DURATION SLIDER'
load_modules(script_path)

local slider_x = 20
local slider_y = 30

local window_w = 500
local selected_items_ = items.get_selected()
if #selected_items_ <= 1 then
    reaper.ShowMessageBox("This script requires exactly one item to be selected.", "Error", 0)
    return
end
local infos = {}

local project_sr = reaper.GetSetProjectInfo(0, "PROJECT_SRATE", 0, false)

for idx, item_ in ipairs(selected_items_) do
    table.insert(infos, idx, item.get_info(item_))
end

local jitter_values = {}
for _ = 1, #selected_items_ do
    table.insert(jitter_values, math.random())
end

gui.sliders = {
    {
        name = "EXP DUR over items",
        x = slider_x,
        w = window_w - slider_x * 2,
        range = { -1 / 8, 1 / 8 },
        value = 0
    },
    {
        name = "DURATIONs",
        x = slider_x,
        w = window_w - slider_x * 2,
        range = { 0, 2 },
        value = 1
    },
    {
        name = "shift POSITIONs [samp]",
        x = slider_x,
        w = window_w - slider_x * 2,
        range = { -1000, 1000 },
        value = 0
    },
    {
        name = "shift POSITIONs [ms]",
        x = slider_x,
        w = window_w - slider_x * 2,
        range = { -1000, 1000 },
        value = 0
    },
    {
        name = "SCROLL jitter inside item",
        x = slider_x,
        w = window_w - slider_x * 2,
        range = { -1 / 8, 1 / 8 },
        value = 0
    },
}

for i, s in ipairs(gui.sliders) do
    s.y = slider_y * i
end
local window_h = slider_y * #gui.sliders + 20

local dur_exp_slider, dur_slider, onset_shift_samp_slider, onset_shift_ms_slider, scroll_jitter_value
local function loop()
    gfx.set(0, 0, 0)
    gfx.rect(0, 0, window_w, window_h, 1)

    -- inside loop
    for _, slider in ipairs(gui.sliders) do
        gui.draw_slider(slider)
        if gui.slider_mouse_hit(slider) then
            slider.value = gui.slider_to_value(slider, gfx.mouse_x)

            dur_exp_slider = gui.sliders[1].value
            dur_slider = gui.sliders[2].value
            onset_shift_samp_slider = gui.sliders[3].value
            onset_shift_ms_slider = gui.sliders[4].value
            scroll_jitter_value = gui.sliders[5].value

            if #selected_items_ > 0 then
                for idx, item_ in ipairs(selected_items_) do
                    local dur_exp = dur_exp_slider == 0 and 1 or math.exp(math.log(1 + dur_exp_slider) * (idx - 1))
                    local new_duration = infos[idx].duration * dur_slider * dur_exp
                    reaper.SetMediaItemInfo_Value(item_, "D_LENGTH", new_duration)

                    
                    local new_onset_samp = onset_shift_samp_slider / project_sr * (idx - 1)
                    local new_onset_ms =  onset_shift_ms_slider / 1000 * (idx - 1)
                    reaper.SetMediaItemInfo_Value(item_, "D_POSITION", infos[idx].onset + new_onset_ms + new_onset_samp)


                    local new_offset = infos[idx].offset + jitter_values[idx] * scroll_jitter_value
                    reaper.SetMediaItemTakeInfo_Value(infos[idx].take, "D_STARTOFFS", new_offset)

                    reaper.UpdateItemInProject(item_)
                end
            end
        end
    end
    gfx.update()
    if gfx.getchar() >= 0 then reaper.defer(loop) end
end

gfx.init(script_name, window_w, window_h)
reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

loop()

reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_name, -1)
