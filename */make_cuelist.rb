main_dir = File.dirname(__dir__)
title = File.basename(main_dir)

p "Generating for #{title}"

score_path = main_dir + '/_' + title + '-score_scripted.corll'
opt_path = main_dir + '/opt/' + title + '-opt'
sonvs_dir = main_dir + '/sonvs/'

score_file = File.open(score_path, 'w')
opt_file = File.open(opt_path, 'w')

ref_string = ";#{score_path}"

section_array = []
maximum_ch = []

extensions = ['wav', 'mp3', 'aiff', 'ogg']

extensions.each do |ext|
	Dir.glob(sonvs_dir + "*.#{ext}") do |f|
		name = File.basename(f)
		section_array << name

		ch = `soxi -c #{f}`.strip
		maximum_ch << ch
	end
end

section_array = section_array.sort

score_file.write(ref_string + "\n")

rec_opt = <<CS

;---RECORD ON
schedule "MNEMOSINE", 0, -1, "__#{title}.wav"

CS

score_file.write(rec_opt)

section_array.each_with_index do |f, i|

	index = i + 1

	begin
		number = f.split(/[\s-]/)[1]
		name = f.split(/[\s-]/)[2].gsub(/[^a-zA-Z]/, '').upcase
	rescue
		# Handle the error here
		puts "No name specified"
	end

	label = "#{index.to_s}-#{number}-#{name}"
	p label
	score_file.write("\n;---#{label}\n")

	if index != 1 then	
		turnoff_string = "\t$END\t#{i}, 0"
		turnoff_string << "\t\t;<seq> <when>\n"
	
		score_file.write(turnoff_string)
	end

	schedule_string = ["\t$START\t#{index}, \"#{f}\",\\"]
	schedule_string << "0,\t\t\\;DELAY STARTING SEQ"
	schedule_string << "0,\t\t\\;START SEQ FROM"
	schedule_string << "0,\t\t\\;IS LOOP"
	schedule_string << "1,\t\t\\;DYN"
	schedule_string << "0,\t0,\t\\;FADEIN <sec> <mode>"
	schedule_string << ".005,\t0\t ;FADEOUT <sec> <mode>"
	
	score_file.write(schedule_string.join("\n\t\t"))

end

close_opt = <<CS

;---RECORD OFF & CLOSE
event_i "e", 0, 1

;---ENDLIST
CS

score_file.write(close_opt)

info = ";turnoff_i all instances (0), oldest only (1), or newest only (2), notes with exactly matching (fractional) instrument(4)\n"

score_file.write(info)

score_file.close unless score_file.nil?

opt_file.write("nchnls = #{maximum_ch.max}")


