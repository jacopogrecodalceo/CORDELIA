
cordelia_dir = '/Users/j/Documents/PROJECTs/CORDELIA/_GEN/_books/'
latex_dir = '/Users/j/Documents/PROJECTs/CORDELIA/_GEN/_latex/'

latex_default = '''
\documentclass{standalone}

\usepackage{tabularray}
\usepackage{graphicx}
\usepackage[export]{adjustbox}

\begin{document}

\begin{tblr}{
    cells={valign=m,halign=c},
    vlines
}

---INSERT---


\end{tblr}

\end{document}
'''

latex_tab = '''
\begin{tblr}{
    % cells={valign=m,halign=c},
    row{1}={font=\bfseries},
    colspec={Q|Q},
}
---INSERT---
\end{tblr}'''

latex_tabs = []

Dir.glob(cordelia_dir + '*') do |d|
    if File.directory?(d)
        latex_string = latex_tab
        first_line = "\\SetCell[c=2]{c} #{File.basename(d)}"
        latex_tab_lines = [first_line]
        Dir.glob(d + '/*.png') do |f|
            name = File.basename(f, '.*')
            latex_tab_lines << "#{name} & \\includegraphics[scale=.035, valign=c]{#{f}}"
        end
        string = latex_string.gsub('---INSERT---', latex_tab_lines.join(" \\\\\\\\\\\\\\ \\hline\n"))
        latex_tabs << string
    end
end
string = latex_default.gsub('---INSERT---', latex_tabs.join("\n&"))
File.open(latex_dir + 'out.tex', 'w') { |file| file.write(string) }

Dir.glob(latex_dir + '*.tex') do |f|
    system("pdflatex -output-directory=#{latex_dir} #{f} ")
end
