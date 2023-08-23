require 'json'
require 'csound.rb'

#soundfont_dir = '/Volumes/petit_elements_di_j/_sonvs_reseau/soundfont'
soundfont_dir = '/Volumes/petit_elements_di_j/_sonvs_reseau/soundfont'
soundfont_ext = ['sf', 'sf2', 'sf3']
temp_dir = '/Users/j/Documents/PROJECTs/_temp/'

json_file_path = '/Volumes/petit_elements_di_j/_sonvs_reseau/soundfont/sf.json'
list_path = '/Volumes/petit_elements_di_j/_sonvs_reseau/soundfont/sflist.txt'
 
json_data = {}


def sanitize_filename(filename)
	filename.strip.tap do |name|

		name.downcase!
		# NOTE: File.basename doesn't work right with Windows paths on Unix
		# get only the filename, not the whole path
		name.gsub!(/^.*(\\|\/)/, '')
	
		# Strip out the non-ascii character
		name.gsub!(/[^0-9A-Za-z.\-]/, '_')
		name.gsub!(/\./, '')
		name.gsub!(/\-/, '')
		name.gsub!(/_+/, '_')

	end
end
  
def make_sfinstr(instr_name, sf_file, index, prog, bank)
	main_string = <<-CS
		instr #{instr_name}_load

	iload   sfload "#{sf_file}"
	ir      sfpreset #{prog}, #{bank}, iload, #{index}
			turnoff
	
		endin
		schedule "#{instr_name}_load", 0, 1
	
		$start_instr(#{instr_name})
		
	aout		sfplay3m 1, ftom:i(A4), $dyn_var/2048, icps, #{index}, 1
		
		$dur_var(10)
		$end_instr					
	CS

	#puts main_string
	#puts '-' * 40

	return main_string
end

# ===============================================================
# Get all sf files and create a cs_log file
# ===============================================================

if Dir.exist?(soundfont_dir)
	
	Dir.glob(File.join(soundfont_dir, '**', "*{#{soundfont_ext.join(',')}}"), File::FNM_CASEFOLD) do |f|
		if not File.directory?(f)
			basename = File.basename(f, ".*")
			extension = File.extname(f)
			dir = File.dirname(f)

			orc_path = temp_dir + '_printsf.orc'
			sco_path = temp_dir + '_printsf.sco'
			log_path = dir + "/#{basename}.cs_log"

			if not File.exist?(log_path)
				sf_score = File.open(sco_path, 'w')
				sco = "i1 0 0 \"#{f}\"\ne\n"
				sf_score.write(sco)
				sf_score.close unless sf_score.nil?

				sf_orc = File.open(orc_path, 'w')
				string = <<~CS
					instr 1
				
				isf	sfload	p4
					sfplist isf
				
					endin
				CS
				sf_orc.write(string)
				sf_orc.close unless sf_orc.nil?
				
				cmd = `csound #{orc_path} #{sco_path} -I -n -O "#{log_path}"`
				puts "Treating..#{basename}"
			else
				puts "#{basename} exists!"
			end

		end
	end

	# ===============================================================
	# Open each cs_log file and check if there's a list
	# ===============================================================

	index = 0

	Dir.glob(File.join(soundfont_dir, '**', "*.cs_log")) do |f|

		content = File.read(f)

		# Extract content between "---string---" and "--end---"
		match = content.match(/Preset list[\s\S]*?(?=Score finished)/)
	
		if match

			text = match[0].strip
			lines = text.split("\n")
			# Remove the first and last lines
			if lines.length > 2
				lines.shift
				lines.pop
			else
				lines.shift
			end

			basename = File.basename(f, '.*')
			dir = File.dirname(f)
			
			Dir.glob(File.join(dir, '*')) do |file_path|
				if File.extname(file_path) != '.cs_log' &&
					File.basename(file_path, '.*') == basename &&
					File.extname(file_path).downcase.include?('sf')
				
					sf_file = file_path
					lines.each do |line|
						# Join the remaining lines back into a string
						sf_info = line.match(/(\d+)\)\s+(.*?)\s+prog/)
						preset_index = sf_info[1]
						instr_name = sf_info[2]

						prog = line.match(/prog:(\d+)/)[1]
						bank = line.match(/bank:(\d+)/)[1]
						instr_name = 'sf_' + sanitize_filename(instr_name)
						
						if json_data.key?(instr_name)

							counter = 1
							new_instr_name = "#{instr_name}_#{counter}"
							
							while json_data.key?(new_instr_name)
								counter += 1
								new_instr_name = "#{instr_name}_#{counter}"
							end
							
							json_data[new_instr_name] = {
									'csound' => make_sfinstr(new_instr_name, sf_file, index, prog, bank)
								}
						else
							json_data[instr_name] = {
								'csound' => make_sfinstr(instr_name, sf_file, index, prog, bank)
							}
						end
						index += 1
					end
				end
			end

		end
	end


	File.open(list_path, 'w') do |file|
		instr_names = json_data.keys
		instr_names.sort!
		file.write(instr_names.join("\n"))
	end

	# Open the file in write mode and write the data as JSON
	File.open(json_file_path, 'w') do |file|
		file.write(JSON.pretty_generate(json_data))
	end
	
	puts "Data has been written to #{json_file_path}"
end