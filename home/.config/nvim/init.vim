call plug#begin('~/.vim/plugged')

Plug 'Tyilo/logos.vim'
Plug 'Tyilo/applescript.vim'
Plug 'Tyilo/cycript.vim'

Plug 'ogier/guessindent'
Plug 'dag/vim-fish'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'itchyny/lightline.vim'

Plug 'Shougo/deoplete.nvim'
Plug 'benekastah/neomake'

call plug#end()

function! SetDefaultIndent()
	set noexpandtab
	set softtabstop=4
	set shiftwidth=4
	set tabstop=4
endfunction

call SetDefaultIndent()

set number
set wrap

command W w
command Q q
command Wq wq
command WQ wq
cmap w!! exec 'w !sudo dd of=' . shellescape(expand('%'))

set clipboard=unnamed

function! <SID>StripTrailingWhitespaces()
	let l = line(".")
	let c = col(".")
	%s/\s\+$//e
	call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()


colorscheme Tomorrow-Night-Bright

let g:deoplete#enable_at_startup = 1

let g:neomake_cpp_clang_args = ["-std=c++11", "-Wextra", "-Wall"]
autocmd! BufWritePost * Neomake

let g:guessindent_prefer_tabs = 1
autocmd BufReadPost * :GuessIndent

" Make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv
