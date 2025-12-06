gui = {}

function gui.slider_to_value(slider, mouse_x)
    local t = (mouse_x - slider.x) / slider.w
    if t < 0 then t = 0 end
    if t > 1 then t = 1 end
    return slider.range[1] + t * (slider.range[2] - slider.range[1])
end

function gui.slider_mouse_hit(slider)
    local cap = gfx.mouse_cap & 1 == 1
    return cap and gfx.mouse_y >= slider.y-10 and gfx.mouse_y <= slider.y+20
end

function gui.draw_slider(slider)
    -- ---------- CLAMP VALUE ----------
    slider.value = math.max(slider.range[1], math.min(slider.range[2], slider.value))

    -- ---------- DRAW BACKGROUND TRACK ----------
    gfx.set(0.3, 0.3, 0.3)                          -- dark grey
    gfx.rect(slider.x, slider.y, slider.w, 10, 0)    -- filled = 0

    -- ---------- COMPUTE HANDLE POSITION ----------
    local t = (slider.value - slider.range[1]) / (slider.range[2] - slider.range[1])
    t = math.max(0, math.min(1, t))                 -- clamp 0..1
    local handle_x = slider.x + t * slider.w

    -- ---------- DRAW HANDLE ----------
    gfx.set(1, 1, 1)                                -- white handle
    gfx.rect(handle_x - 5, slider.y - 5, 10, 15, 1) -- filled handle

    -- ---------- DRAW TEXT LABEL ----------
    local text_y = slider.y - 15

    gfx.set(1, 1, 1)                                -- white text
    gfx.x = slider.x
    gfx.y = text_y
    gfx.printf("%s: %.3f", slider.name, slider.value)
end

return gui