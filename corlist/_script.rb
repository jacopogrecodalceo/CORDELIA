title			= File.basename(__dir__)

score_path		= __dir__ + '/_' + title + '-score_scripted.csd'
opt_path		= __dir__ + '/_' + title + '-opt'

score_file = File.open(score_path, 'w')
opt_file = File.open(opt_path, 'w')

ref_string = ";#{score_path}"

section_array = []
maximum_ch = []


Dir.glob(__dir__ + '/*.wav') do |f|
	name = File.basename(f)
	section_array << name

	ch = `soxi -c #{f}`.strip
	maximum_ch << ch
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

	number = f.split(/[\s-]/)[1]
	name = f.split(/[\s-]/)[2].gsub(/[^a-zA-Z]/, '').upcase
	label = "#{number}-#{name}-#{index.to_s}"
	score_file.write(";---#{label}\n")

	schedule_string = []

	schedule_string << "$START\t#{index},\\"
	schedule_string << "\"#{f}\",\\"
	schedule_string << "0,\t\t\\;DELAY STARTING SEQ"
	schedule_string << "0,\t\t\\;START SEQ FROM"
	schedule_string << "0,\t\t\\;IS LOOP"
	schedule_string << "1,\t\t\\;DYN"
	schedule_string << "0,\t0,\t\\;FADEIN"
	schedule_string << ".005,\t0\t ;FADEOUT"
	
	score_file.write(schedule_string.join("\n\t"))

	score_file.write("\n;---\n")
	
	turnoff_string = "$END\t#{index}, 0\n"

	score_file.write(turnoff_string)

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