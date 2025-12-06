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

local script_path = debug.getinfo(1,'S').source:sub(2):match("(.*/)")
local script_name = 'DURATION SLIDER'
load_modules(script_path)

local slider_x = 20
local slider_y = 30

local window_w = 500
local selected_items_ = items.get_selected()
if #selected_items_ <= 1 then reaper.ShowMessageBox("This script requires exactly one item to be selected.", "Error", 0) return end
local infos = {}

for idx, item_ in ipairs(selected_items_) do
    table.insert(infos, idx, item.get_info(item_))
end

local jitter_values = {}
for _ = 1, #selected_items_ do
    table.insert(jitter_values, math.random())
end

gui.sliders = {
    {
        name = "EXP over items",
        x = slider_x,
        w = window_w-slider_x*2,
        range = {-1/8, 1/8},
        value = 0
    },
    {
        name = "DURATIONs",
        x = slider_x,
        w = window_w-slider_x*2,
        range = {0, 2},
        value = 1
    },
    {
        name = "POSITIONs shift",
        x = slider_x,
        w = window_w-slider_x*2,
        range = {-1/2, 1/2},
        value = 0
    },
    {
        name = "SCROLL jitter inside item",
        x = slider_x,
        w = window_w-slider_x*2,
        range = {-1/8, 1/8},
        value = 0
    },
}

for i, s in ipairs(gui.sliders) do
    s.y = slider_y*i
end
local window_h = slider_y * #gui.sliders + 20

local exp_slider, dur_slider, onset_slider, scroll_jitter_value
local function loop()
    gfx.set(0, 0, 0)
    gfx.rect(0, 0, window_w, window_h, 1)

    -- inside loop
    for _, slider in ipairs(gui.sliders) do
        gui.draw_slider(slider)
        if gui.slider_mouse_hit(slider) then
            slider.value = gui.slider_to_value(slider, gfx.mouse_x)

            exp_slider = gui.sliders[1].value
            dur_slider = gui.sliders[2].value
            onset_slider = gui.sliders[3].value
            scroll_jitter_value = gui.sliders[4].value

            if #selected_items_ > 0 then     
                for idx, item_ in ipairs(selected_items_) do

                    local factor = exp_slider == 0 and 1 or math.exp(math.log(1 + exp_slider) * (idx - 1))
                    local new_duration = infos[idx].duration * dur_slider * factor
                    reaper.SetMediaItemInfo_Value(item_, "D_LENGTH", new_duration)

                    local new_onset = infos[idx].onset + onset_slider * (idx-1)
                    reaper.SetMediaItemInfo_Value(item_, "D_POSITION", new_onset)


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
