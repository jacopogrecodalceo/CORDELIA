require 'json'
require_relative '_path'

# Set the file paths
path = File.join($cordelia_directory_path, '_INSTR', '*')
json = File.join($cordelia_setting_path, 'instr.json')
fft_script = File.join($cordelia_setting_path, '_script/fft_foundamental.py')

$hard_reset = false
$suffix = ['_so', '_sy', '_lpc', '_conv']

if $hard_reset
	$instruments = {}
else
	$instruments = JSON.parse(File.read(json))
end

def extract_global_vars(filename, name)
	content = File.read(filename)
	gk_vars = content.scan(/\bgk#{name}\w+/).uniq
	gi_vars = content.scan(/\bgi#{name}\w+/).uniq
	gk_vars + gi_vars
end

def process_instr(t)
	# Processing 'instr' type files
	Dir[File.join(t, '*.orc')].each do |f|
		name = File.basename(f, '.*')

		if $hard_reset or !$instruments.key?(name)
			p "#{name} is added"
			global_vars = extract_global_vars(f, name)

			$instruments[name] = {
				'type' => 'instr',
				'path' => f,
				'global_var' => global_vars
			}
		end
	end
end

def process_hybrid(t)
	# Processing 'hybrid' type files
	Dir[File.join(t, '*.orc')].each do |f|
		name = File.basename(f, '.*')

		if $hard_reset or !$instruments.key?(name)
			p "#{name} is added"
			first_lines = File.open(f).first(5)
			keyword = ';REQUIRE'
			required_instr = []

			first_lines.each do |l|
				if l.start_with?(keyword)
					line = l.gsub(keyword, '').strip
					if line.include?(',')
						required_instr = line.split(',')
					else
						required_instr << line
					end
				end
			end

			global_vars = extract_global_vars(f, name)

			$instruments[name] = {
				'type' => 'hybrid',
				'path' => f,
				'required' => required_instr,
				'global_var' => global_vars
			}
		end
	end
end

def process_sonvs(t)
	# Processing 'sonvs' type files
	Dir[File.join(t, '*')].each do |f|
		name = File.basename(f, '.*')
		names = [name]

		$suffix.each do |extension|
			names << name + extension
		end

		names.each do |name|
			if $hard_reset or !$instruments.key?(name)
				p "#{name} is added"
				if File.file?(f)
					$instruments[name] = {
						'type' => 'sonvs',
						'path' => [f],
						'channels' => `soxi -c #{f}`.strip,
						'sample_rate' => `soxi -r #{f}`.strip
					}
				elsif File.directory?(f)
					wav_inside = Dir[File.join(f, '*.wav')]

					$instruments[name] = {
						'type' => 'sonvs',
						'path' => wav_inside,
						'channels' => `soxi -c #{wav_inside.first}`.strip,
						'sample_rate' => `soxi -r #{wav_inside.first}`.strip
					}
				end
			end
		end
	end
end

Dir[path].each do |t|
	
	type = File.basename(t)

	if type == 'instr'
		process_instr(t)
	elsif type == 'hybrid'
		process_hybrid(t)
	elsif type == 'sonvs'
		process_sonvs(t)
	end
end

$instruments = $instruments.sort.to_h

# Write $instruments dictionary to JSON file
File.open(json, 'w') { |f| f.puts JSON.pretty_generate($instruments) }

IO.popen("python3 #{fft_script}") do |io|
	while (line = io.gets)
		puts line
	end
end