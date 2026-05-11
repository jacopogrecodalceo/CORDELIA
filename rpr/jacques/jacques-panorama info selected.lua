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
					_G[mod_name] = mod
				end
		end

		i = i + 1
	end
end

local script_path = debug.getinfo(1, 'S').source
local script_dir_path = script_path:sub(2):match("(.*/)")
load_modules(script_dir_path)

local script_name = path.get_basename(script_path)


local function round(n, decimals)
	decimals = decimals or 2
	return math.floor(n * (10 ^ decimals) + 0.5) / (10 ^ decimals)
end


local function compute_stats(values)
	if #values == 0 then
		return { min = 0, max = 0, avg = 0, median = 0, stddev = 0 }
	end

	table.sort(values)
	local sum = 0
	for _, v in ipairs(values) do
		sum = sum + v
	end
	local avg = sum / #values
	local median = values[math.ceil(#values / 2)]

	local variance = 0
	for _, v in ipairs(values) do
		variance = variance + (v - avg) ^ 2
	end
	variance = variance / #values
	local stddev = math.sqrt(variance)

	return {
		min = round(values[1], 2),
		max = round(values[#values], 2),
		avg = round(avg, 2),
		median = round(median, 2),
		stddev = round(stddev, 2),
		count = #values
	}
end


local function find_outliers(values, stats)
	if #values < 4 then return {} end

	local sorted = {}
	for _, v in ipairs(values) do
		table.insert(sorted, v)
	end
	table.sort(sorted)

	local q1_idx = math.ceil(#sorted * 0.25)
	local q3_idx = math.ceil(#sorted * 0.75)
	local q1 = sorted[q1_idx]
	local q3 = sorted[q3_idx]
	local iqr = q3 - q1

	if iqr == 0 then return {} end

	local lower_bound = q1 - 1.5 * iqr
	local upper_bound = q3 + 1.5 * iqr

	local outliers = {}
	for _, v in ipairs(values) do
		if v < lower_bound or v > upper_bound then
				local deviation = round((v - stats.avg) / stats.avg * 100, 0)
				table.insert(outliers, { value = v, deviation = deviation })
		end
	end

	return outliers
end


local function print_separator()
	reaper.ShowConsoleMsg(string.rep("─", 70) .. "\n")
end


local function analyze_items(selected_items_)
	if #selected_items_ == 0 then return end

	reaper.ShowConsoleMsg("\n")
	print_separator()
	reaper.ShowConsoleMsg("ITEM PANORAMA ANALYSIS\n")
	print_separator()

	local metrics = {
		duration = {},
		fadein = {},
		fadeout = {},
		offset = {},
		channels = {}
	}

	local all_info = {}

	-- Collect data
	for idx, item_ in ipairs(selected_items_) do
		local info = item.get_info(item_)
		if not info then
				reaper.ShowMessageBox("Error in getting info from item", "Error", 0)
				return
		end

		all_info[idx] = info
		table.insert(metrics.duration, info.duration)
		table.insert(metrics.fadein, info.fadein)
		table.insert(metrics.fadeout, info.fadeout)
		table.insert(metrics.offset, info.offset)
		table.insert(metrics.channels, info.channels)
	end

	-- Compute stats for each metric
	local stats = {}
	for key, values in pairs(metrics) do
		stats[key] = compute_stats(values)
	end

	-- Print aggregate overview
	reaper.ShowConsoleMsg("\n📊 AGGREGATE OVERVIEW\n")
	reaper.ShowConsoleMsg(string.format("  Total items: %d\n", #selected_items_))
	reaper.ShowConsoleMsg(string.format("  Avg duration: %.2f sec  (range: %.2f – %.2f)\n",
		stats.duration.avg, stats.duration.min, stats.duration.max))
	reaper.ShowConsoleMsg(string.format("  Avg fade in: %.0f ms  (range: %.0f – %.0f)\n",
		stats.fadein.avg, stats.fadein.min, stats.fadein.max))
	reaper.ShowConsoleMsg(string.format("  Avg fade out: %.0f ms  (range: %.0f – %.0f)\n",
		stats.fadeout.avg, stats.fadeout.min, stats.fadeout.max))
	reaper.ShowConsoleMsg(string.format("  Avg channels: %.1f  (range: %d – %d)\n",
		stats.channels.avg, stats.channels.min, stats.channels.max))
	reaper.ShowConsoleMsg(string.format("  Avg offset: %.2f sec  (range: %.2f – %.2f)\n",
		stats.offset.avg, stats.offset.min, stats.offset.max))

	-- Duration outliers
	local duration_outliers = find_outliers(metrics.duration, stats.duration)
	if #duration_outliers > 0 then
		reaper.ShowConsoleMsg("\n⚠️  DURATION OUTLIERS (IQR method)\n")
		for _, outlier in ipairs(duration_outliers) do
				local sign = outlier.deviation > 0 and "+" or ""
				reaper.ShowConsoleMsg(string.format("  • %.2f sec  (%s%d%% from avg)\n",
					outlier.value, sign, outlier.deviation))
		end
	else
		reaper.ShowConsoleMsg("\n✓ Duration: no outliers detected\n")
	end

	-- Fade in outliers
	local fadein_outliers = find_outliers(metrics.fadein, stats.fadein)
	if #fadein_outliers > 0 then
		reaper.ShowConsoleMsg("\n⚠️  FADE IN OUTLIERS (IQR method)\n")
		for _, outlier in ipairs(fadein_outliers) do
				local sign = outlier.deviation > 0 and "+" or ""
				reaper.ShowConsoleMsg(string.format("  • %.0f ms  (%s%d%% from avg)\n",
					outlier.value, sign, outlier.deviation))
		end
	else
		reaper.ShowConsoleMsg("\n✓ Fade in: no outliers detected\n")
	end

	-- Fade out outliers
	local fadeout_outliers = find_outliers(metrics.fadeout, stats.fadeout)
	if #fadeout_outliers > 0 then
		reaper.ShowConsoleMsg("\n⚠️  FADE OUT OUTLIERS (IQR method)\n")
		for _, outlier in ipairs(fadeout_outliers) do
				local sign = outlier.deviation > 0 and "+" or ""
				reaper.ShowConsoleMsg(string.format("  • %.0f ms  (%s%d%% from avg)\n",
					outlier.value, sign, outlier.deviation))
		end
	else
		reaper.ShowConsoleMsg("\n✓ Fade out: no outliers detected\n")
	end

	-- Channel outliers
	local channel_outliers = find_outliers(metrics.channels, stats.channels)
	if #channel_outliers > 0 then
		reaper.ShowConsoleMsg("\n⚠️  CHANNEL COUNT OUTLIERS (IQR method)\n")
		for _, outlier in ipairs(channel_outliers) do
				local sign = outlier.deviation > 0 and "+" or ""
				reaper.ShowConsoleMsg(string.format("  • %d ch  (%s%d%% from avg)\n",
					outlier.value, sign, outlier.deviation))
		end
	else
		reaper.ShowConsoleMsg("\n✓ Channels: no outliers detected\n")
	end

	-- Print individual items
	--[[ reaper.ShowConsoleMsg("\n")
	print_separator()
	reaper.ShowConsoleMsg("INDIVIDUAL ITEMS\n")
	print_separator()

	for idx, info in ipairs(all_info) do
		reaper.ShowConsoleMsg(string.format("\n[%d] %s\n", idx, info.path))
		reaper.ShowConsoleMsg(string.format("    Duration: %.2f sec | Fade in: %.0f ms | Fade out: %.0f ms\n",
				info.duration, info.fadein, info.fadeout))
		reaper.ShowConsoleMsg(string.format("    Channels: %d | Offset: %.2f sec\n",
				info.channels, info.offset))
	end

	print_separator()
	reaper.ShowConsoleMsg("\n") ]]
end


local function main()
	local selected_items_ = items.get_selected()
	analyze_items(selected_items_)
end

main()