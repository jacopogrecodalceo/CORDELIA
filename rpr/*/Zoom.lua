x = reaper.GetCursorPositionEx(0)

zoom = .025

--reaper.ShowConsoleMsg(x, y)

reaper.GetSet_ArrangeView2(0, 1, 0, 0, x-zoom, x+zoom)

