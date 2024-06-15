set mouse=a
set number
let mapleader = "q"
set cursorline
let g:neovide_remember_window_size = v:true

colorscheme onehalflight
" colorscheme deep-space

if exists('g:neovide')
	let g:neovide_input_use_logo=v:true
	" copy
	vnoremap <D-c> "+y
	inoremap <D-v> <Esc>"+ya

	" paste
	nnoremap <D-v> "+p
	inoremap <D-v> <Esc>"+pa
	cnoremap <D-v> <c-r>+

	" undo
	nnoremap <D-z> u
	inoremap <D-z> <Esc>ua

	" save
	nnoremap <D-s> :w<Enter>
	inoremap <D-s> <Esc>:w<Enter>

	"
	nnoremap <D-a> <Esc>ggVG
	inoremap <D-a> ggVG

endif

let g:neovide_transparency=0.95

let g:neovide_cursor_trail_size=0.75
let g:neovide_cursor_animation_length=0.075

let g:neovide_cursor_vfx_mode = "pixiedust"
let g:neovide_cursor_vfx_particle_phase=125.5
let g:neovide_cursor_vfx_particle_lifetime=2.5
let g:neovide_cursor_vfx_particle_density=25.0

" let g:neovide_hide_mouse_when_typing = v:true

