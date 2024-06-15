require 'JSON'


characters_path = '/Users/j/Documents/PROJECTs/CORDELIA/script/generate_gen/list_characters.txt'
hc_path = '/Users/j/Documents/PROJECTs/CORDELIA/script/generate_gen/list_hc.json'
dir_path = '/Users/j/Documents/PROJECTs/CORDELIA/_GEN/_books/shakespeare/'

hc_file = File.open(hc_path)
hc_data = JSON.load(hc_file)

names = []


File.open(characters_path, 'r').each_line do |line|
	line = line.downcase.strip
	list = line.split(':')
	
	names << [list[0][0, 4], list[1].strip.to_i]
	
end

def generate_numbers(x, remaining_sum)
	numbers = []
  
	x.times do |i|
		max_number = remaining_sum - (x - i - 1)
		number = rand(1..max_number)
		numbers << number
		remaining_sum -= number
	end
  
	numbers
end

  

names.each do |name_with_num|

	name = 'jo' + name_with_num[0]
	division = name_with_num[1]
	round_num = 5

	algorithm = []
	algorithm_num = 3

	xs = generate_numbers(algorithm_num, division)
	xs.shuffle!

	ys = []

	algorithm_num.times do
		algorithm << hc_data.keys.sample
		ys << rand(0.0 .. 1.0).round(round_num)
	end

	ys[rand(0 .. (ys.length-2))] = 1
	ys[-1] = 0

	strings = ["gi#{name}\thc_gen 0, gienvdur, 0"]

	algorithm.each_with_index do |e, i|
		params = hc_data[e]['params']
		if params
			params_rand = []
			params.each do |j|
				params_rand << rand(j[0].to_f .. j[1].to_f).round(round_num)
			end
			params = params_rand.join(', ')
		else
			params = ''
		end

		if e == 'tightrope_walker'
			p1 = rand(0.0 .. 1.0).round(round_num)
			p2 = rand(0.0 .. p1).round(round_num)

			params = "#{p1}, #{p2}"
		end

		strings << "\t\thc_segment(#{xs[i]}/#{division}, #{ys[i]}, #{hc_data[e]['csound']}(#{params}))"
	end
	string = strings.join(", \\ \n")

	if ys.include?(1)
		File.open(dir_path + name + '.orc', 'w') { |file| file.write(string) }
	else
		p "WARNING not include 1"
	end
	
end
