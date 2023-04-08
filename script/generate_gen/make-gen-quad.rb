
characters_path = '/Users/j/Documents/PROJECTs/CORDELIA/script/list_greek.txt'
hc_path = '/Users/j/Documents/PROJECTs/CORDELIA/script/list_hc.json'
dir_path = '/Users/j/Documents/PROJECTs/CORDELIA/_GEN/_books/quad/'

lines = File.open(characters_path, 'r').readlines

# giname ftgen 0, 0, #{x_len}, "quadbezier", 0 --- cx1 cy1 x2 y2 

p lines

lines.each do |l|

	name = l.strip.downcase[0, 4]

	x_len = 8192
	x_num = [5, 7].sample
	xs = []

	ys = []
	x_num.times do
	  xs << rand(x_len)
	  ys << rand(0.0 .. 1.0).round(5)
	end
	
	ys[-1] = 0
	xs.sort!

	params = [xs, ys].transpose.flatten.join(', ')

	string = "gi#{name} ftgen 0, 0, #{x_len}, \"quadbezier\", 0, #{params}"
	p string
	File.open(dir_path + name + '.orc', 'w') { |file| file.write(string) }

end