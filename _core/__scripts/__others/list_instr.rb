instr_dir      = '/Users/j/Documents/PROJECTs/IDRA/_core/__instr/'
samp_dir      = '/Users/j/Documents/PROJECTs/IDRA/samples/opcode/'
output_dir  = '/Users/j/Documents/PROJECTs/IDRA'
list       = '/Users/j/Documents/PROJECTs/IDRA/_core/__scripts/__others/list_instr/_list_instr.tex'
list_txt = '/Users/j/Documents/PROJECTs/IDRA/_list_instr.txt'

dest_tex = list


tex_in    ='\documentclass[a4paper, landscape]{book}
\usepackage[margin=15mm]{geometry}
\usepackage{multicol}
\setlength{\columnseprule}{1.25pt}
\pagenumbering{gobble}

\begin{document}
\begin{multicols}{3}
'

tex_tab_in = '
\begin{tabular}{ c|c } 
'

tex_tab_out = '
\end{tabular}
\end{center}
\columnbreak
'

tex_out    ='
\end{multicols}
\end{document}
'

#FUNCTIONs
def get_csound_comment(orc) 
  first_line = File.open(orc) {|f| f.readline}
  if first_line.start_with?(';')
    return first_line
  end
end


file = File.open(list, "w")
file.write(tex_in)

all_instr = []

#INSTRs
Dir.glob(instr_dir + '*.orc') do |f|
    if not File.directory?(f)
        name = File.basename(f, '.orc')
        if not name.start_with?('_')
            all_instr.push(name)
            #first_line = get_csound_comment(f)
            #if not first_line.nil?
            #  all_instr.push(first_line)
            #end
        end
    end
end

begin
    file.write('\begin{center} \section*{INSTRs}' + "\n")
    file.write(tex_tab_in)
    all_instr.sort.each_slice(2) do |instr_name| 
      if instr_name[1]
        file.write(instr_name[0] + ' & ' + instr_name[1] + " " + '\\\\' + "\n")
      else
        file.write(instr_name[0] + ' & ' + "---" + " " + '\\\\' + "\n")
      end
    end
    file.write(tex_tab_out)
end

#SAMPs
all_instr = []

Dir.glob(samp_dir + '*.wav') do |f|
  if not File.directory?(f)
    name = File.basename(f, '.wav')
    if not name.start_with?('_')
        all_instr.push(name)
    end
  end
end

begin
  file.write("\n" + '\begin{center} \section*{SAMPs}' + "\n")
  file.write(tex_tab_in)
  all_instr.sort.each_slice(2) do |instr_name| 
    if instr_name[1]
      file.write(instr_name[0] + ' & ' + instr_name[1] + " " + '\\\\' + "\n")
    else
      file.write(instr_name[0] + ' & ' + "---" + " " + '\\\\' + "\n")
    end
  end
  file.write(tex_tab_out)
end



#DIRs
all_instr = []

Dir.glob(samp_dir + '*') do |f|
  if File.directory?(f)
      name = File.basename(f)
      if not name.start_with?('_')
          all_instr.push(name)
      end
  end
end

begin
  file.write("\n" + '\begin{center} \section*{DIRs}' + "\n")
  file.write(tex_tab_in)
  all_instr.sort.each_slice(2) do |instr_name| 
    if instr_name[1]
      file.write(instr_name[0] + ' & ' + instr_name[1] + " " + '\\\\' + "\n")
    else
      file.write(instr_name[0] + ' & ' + "---" + " " + '\\\\' + "\n")
    end
  
end

  rescue IOError => e
    #some error occur, dir not writable etc.
  ensure
    file.write(tex_tab_out)
    file.write(tex_out)
    file.close unless file.nil?
  end

system("/usr/local/texlive/2021/bin/universal-darwin/pdflatex -output-directory=#{output_dir} #{dest_tex} ")

#ALLs
dir      = '/Users/j/Documents/PROJECTs/IDRA/_core/__instr/'
list     = '/Users/j/Documents/PROJECTs/IDRA/_list_instr.txt'

all_instr = []

Dir.glob(instr_dir + '**/*.orc') do |f|
    if not File.directory?(f)
        name = File.basename(f, '.orc')
        if not name.start_with?('_')
            all_instr.push(name)
        end
    end
end



begin
    file = File.open(list_txt, "w")
    all_instr.sort.each do |instr_name| 
        file.write(instr_name + "\n")
end
  rescue IOError => e
    #some error occur, dir not writable etc.
  ensure
    file.close unless file.nil?
  end