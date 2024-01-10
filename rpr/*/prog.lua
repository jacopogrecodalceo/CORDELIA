
local ctx_progress_bar = reaper.ImGui_CreateContext('My script')
reaper.ImGui_SetNextWindowSize(ctx_progress_bar, 300, 60, 1)

local progress_bar = {}
local bar_duration = 13

if not progress_bar.plots then
	progress_bar.plots = {
	  progress     = 0.0,
	}
end

local function loop_progress_bar()

	local visible, open = reaper.ImGui_Begin(ctx_progress_bar, 'Loading..', true)
	
	if visible then

		local newtime = os.time()

		if newtime-lasttime >= bar_duration then
			open = false
		else
			progress_bar.plots.progress = (progress_bar.plots.progress + (newtime-lasttime))/bar_duration
		end

		-- Typically we would use (-1.0,0.0) or (-FLT_MIN,0.0) to use all available width,
		-- or (width,0.0) for a specified width. (0.0,0.0) uses ItemWidth.
		local buf = ('%d/%d'):format(math.floor(progress_bar.plots.progress * bar_duration), bar_duration)
		reaper.ImGui_ProgressBar(ctx_progress_bar, progress_bar.plots.progress, -1, 0, buf)

		reaper.ImGui_End(ctx_progress_bar)
	end

	if open then
		reaper.defer(loop_progress_bar)
	end
end

reaper.defer(loop_progress_bar)