" this file is inspired by luis jure csound-vim
" https://github.com/luisjure/csound-vim
" Language:	Cordelia
" Maintainer: jacopo greco d'alceo
" License: MIT
" Last Change:	2024-03-23

au BufNewFile,BufRead       *.cor	set filetype=cordelia
" au BufNewFile               *.cor	0r <sfile>:p:h:h/templates/template.csd
" au BufNewFile,BufRead       *.cor	runtime! macros/csound.vim


