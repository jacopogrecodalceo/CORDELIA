" this file is part of csound-vim
" https://github.com/luisjure/csound-vim
" Language:	csound	
" Maintainer:	luis jure <lj@eumus.edu.uy>
" License:	MIT
" Last Change:	2020-02-24

" Vim syntax file

" clean syntax
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" csound is case sensitive
syntax case match

" no spell check in code
syntax spell notoplevel

" set help program to vim help
set keywordprg=

" set fold method
set foldmethod=syntax

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" load list of all opcodes from a file
let mycsound_opcodes=globpath(&rtp, "syntax/mycsound_opcodes")
if filereadable(mycsound_opcodes)
   runtime! syntax/mycsound_opcodes
else
   runtime! syntax/csound_opcodes
endif

" csound opcodes and operators
syn match csOperator	"^"
syn match csOperator	"<<"
syn match csOperator	"<="
syn match csOperator	"<"
syn match csOperator	"=="
syn match csOperator	"="
syn match csOperator	">="
syn match csOperator	">>"
syn match csOperator	">"
syn match csOperator	"||"
syn match csOperator	"|"
syn match csOperator	"-" 
syn match csOperator	":" 
syn match csOperator	"!="
syn match csOperator	"?" 
syn match csOperator	"/"
syn match csOperator	"("
syn match csOperator	")"
syn match csOperator	"*" 
syn match csOperator	"&"
syn match csOperator	"&&"
syn match csOperator	"%" 
syn match csOperator	"+" 


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" csd sections (with folding)
syn match	csdTags		"^\s*</*CsoundSynthesizer>"
syn region	csOptions	matchgroup=csdTags	start="<CsOptions>" end="</CsOptions>" fold transparent contains=csComment
syn region	csVersion	matchgroup=csdTags	start="<CsVersion>" end="</CsVersion>" fold transparent contains=csComment
syn region	csLicense	matchgroup=csdTags	start="<Cs\(Short\|\)License>" end="</Cs\(Short\|\)License>" fold transparent contains=csComment
syn region	csFile	matchgroup=csdTags	start="<Cs\(File\|FileB\|MidifileB\|SampleB\)>" end="</Cs\(File\|FileB\|MidifileB\|SampleB\)>" fold transparent contains=csComment
syn region	csInstruments	matchgroup=csdTags	start="<CsInstruments>" end="</CsInstruments>" fold transparent contains=ALLBUT,csScoStatement
syn region	csScore		matchgroup=csdTags	start="<CsScore>" end="</CsScore>" fold transparent contains=csScoStatement,csComment,csString,csMacro,csMacroName,csDefine

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" header
syn keyword	csHeader	sr kr ksmps nchnls 0dbfs A4

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" local and global variables
syn	match	csVariable	"\<[akipSfw]\w\+\>"
syn	match	csVariable	"\<g[akipSfw]\w\+\>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" program flow control
syn keyword	csConditional	cggoto cigoto cingoto ckgoto cngoto cnkgoto else elseif endif goto if igoto kgoto rigoto then tigoto timout
syn keyword	csLoop	loop_ge loop_gt loop_le loop_lt until while do od
" labels
syn match	csLabel	"^\s*\<\S\{-}:"
syn match	csLabel "\(\<\(goto\|igoto\|kgoto\|rigoto\|tigoto\|reinit\)\s\+\)\@<=\(\w\+\)"
syn match	csLabel	"\(\<\(cggoto\|cigoto\|ckgoto\|cngoto\|cingoto\|cnkgoto\)\s\+.\{-},\s*\)\@<=\(\w\+\)"
syn match	csLabel	"\(\<\(timout\|loop_ge\|loop_gt\|loop_le\|loop_lt\)\(.*,\s*\)*\)\@<=\(\w\+\s*$\)"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" macros, includes and defines
" syn match	csMacro		+^\s*#\s*\<include\>\s\+.\{-}".\{-}"+
syn region	csDefine	matchgroup=csMacro start="\(^\s*#\s*define\>.\{-}\s\+\)\@<=#" end="#" fold transparent
syn match	csMacro		"^\s*#\(include\|define\|undef\|ifdef\|ifndef\|else\|end\)"
syn match	csMacroName	"\(^\s*#\(include\|define\|undef\|ifdef\|ifndef\)\s\+\)\@<=\(\w\+\)"
syn match	csMacroName	"\$\w\+\.\{,1}"	contained


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" strings
syn match	csString        +".\{-}"+

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" comments
syn match	csComment	";.*$"
syn match	csComment	"//.*$"
syn region	csComment	matchgroup=csComment	start="/\*" end="\*/" fold

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" instruments and user-defined opcodes (with folding)
syn region	csInstrRegion	matchgroup=csInstrument	start="\(^\s*\)\@<=\<instr\>" end="\(^\s*\)\@<=\<endin\>" transparent

" numbered instruments
syn match	csInstrName	"\(^\s*instr\s\+.*,*\)\@<=\<\d\+\>"
" named instruments
syn match	csInstrName	"\(^\s*instr\s\+.*,*\)\@<=\<+*[_a-zA-Z]\w\+\>"

syn region	csOpcodeRegion	matchgroup=csInstrument	start="\(^\s*\)\@<=\<opcode\>" end="\(^\s*\)\@<=\<endop\>" fold transparent
syn match	csOpcodeName	"\(^\s*opcode\s\+\)\@<=\(\S\+\),"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" score statements
syn match	csScoStatement	"^\s*f\s*\d\+"	contained	" function tables
syn match	csScoStatement	"^\s*[iq]\s*\(\.\|\d\+\)"	contained	" numbered instrument
syn match	csScoStatement	+^\s*[iq]\s*"[_a-zA-Z]\w*"+	contained	" named instrument
syn match	csScoStatement	"^\s*[abemnrstvxy]" contained	" score events

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR DEFINITIONS
" Csound classes are linked to some of the default highlighting categories
" defined in synload.vim:
   
hi link	csOpcode	Label
hi link	csOperator	Type
hi link	csHeader	Statement
hi link	csInstrument	Special
hi link	csInstr	Label
hi link	csInstrName	Type
hi link	csOpcodeName	Label
hi link	csVariable  	String
hi link	csdSection  	Label
hi link	csdTags  	Define
hi link	csComment	Comment
hi link csConditional	Conditional
hi link csLoop	Repeat
hi link	csMacro 	Define
hi link	csMacroName	Label
hi link	csLabel 	Define
hi link	csString	String
hi link	csScoStatement  	Label

" to change the appearance you can either:
" 1. link to some other default methods (i. e. Constant, Identifier, etc.) 
" 2. change the color definition of these defaults in synload.vim
" 3. instead of linking to defaults, define your colours right here.
"    For example, you can try the following lines:

" hi csOpcode   	term=bold	ctermfg=darkred 	guifg=red	gui=bold
" hi csInstrument	term=bold	ctermfg=lightblue	guifg=blue	gui=bold
" hi csComment  	term=bold	ctermfg=13	guifg=#a0a0a0
" hi csdTags    	term=bold	ctermbg=blue     	guifg=blue	gui=bold
"
" You can easily change them to suit your preferences.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let b:current_syntax = "csound"
