title			= File.basename(__dir__)

score_path		= __dir__ + '/_' + title + '-score_scripted.csd'
opt_path		= __dir__ + '/_' + title + '-opt'

score_file = File.open(score_path, 'w')
opt_file = File.open(opt_path, 'w')

ref_string =";\t\twhen\tfile\t\t\t\tstart\tloop\tgain\tfadin\tmode\tfadout\tmode"

section_array = []
maximum_ch = []


Dir.glob(__dir__ + '/*.wav') do |f|
	name = File.basename(f)
	section_array << name

	ch = `soxi -c #{f}`.strip
	maximum_ch << ch
end

section_array = section_array.sort

csound_instance_div = 1000.0

csound_score_instr_num = 1.0


score_file.write(ref_string + "\n")

rec_opt = <<CS

;---RECORD ON
schedule "MNEMOSINE", 0, -1, "__#{title}.wav"

CS

score_file.write(rec_opt)

default_fade = '5'

section_array.each_with_index do |f, i|

	score_file.write(";---\n")
	index = i + 1

	schedule_string = []

	schedule_string << "schedule #{csound_score_instr_num + index/csound_instance_div}, 0, 1,\\"
	schedule_string << "\"#{f}\",\t\\;filename"
	schedule_string << "0,\t\\;start from"
	schedule_string << "0,\t\\;is a loop (0 or 1)"
	schedule_string << ".5,\t\\;volume"
	schedule_string << "#{default_fade},\t\\;fadein duration"
	schedule_string << "0,\t\\;fadein mode"
	schedule_string << "#{default_fade},\t\\;fadeout duration"
	schedule_string << "0\t;fadeout mode"
	
	score_file.write(schedule_string.join("\n\t"))

	score_file.write("\n;---\n")
	turnoff = "turnoff2_i #{csound_score_instr_num + index/csound_instance_div}, 4, 1\n"

	score_file.write(turnoff)

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