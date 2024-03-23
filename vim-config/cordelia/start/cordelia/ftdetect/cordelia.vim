" this file is part of csound-vim
" https://github.com/luisjure/csound-vim
" Language:	csound	
" Maintainer:	luis jure <lj@eumus.edu.uy>
" License:	MIT
" Last Change:	2020-02-14

au BufNewFile,BufRead *.cor	set filetype=cordelia
au BufNewFile		*.cor	0r <sfile>:p:h:h/templates/template.csd
au BufNewFile,BufRead	*.cor	runtime! macros/csound.vim


