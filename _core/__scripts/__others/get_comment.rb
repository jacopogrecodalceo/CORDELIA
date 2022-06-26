mine = '/Users/j/Documents/PROJECTs/IDRA/_core/__instr/alone.orc'

def get_csound_comment(orc) 
  first_line = File.open(orc) {|f| f.readline}
  if first_line.start_with?(';')
    return first_line
  end
end

p get_csound_comment(mine)
