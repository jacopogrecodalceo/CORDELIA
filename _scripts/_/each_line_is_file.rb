my_file = '/Users/j/Documents/PROJECTs/CORDELIA/_CORE/2-head/GEN.orc'
my_dir = '/Users/j/Documents/PROJECTs/CORDELIA/_CORE/2-head/all'

File.open(my_file).read.each_line do |line|
  if line.match(/\w+/) != nil
    file_name = line.match(/\w+/).to_s.match(/gi(.*)/)[1]
    new_file = File.open(my_dir + '/' + file_name + '.orc', 'w')
    new_file.write(line)
    new_file.close unless new_file.nil?
    p file_name
  end
end