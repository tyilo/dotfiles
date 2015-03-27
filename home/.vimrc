if &shell =~# 'fish$'
	set shell=bash
endif

syntax on

function! SetIndent()
	let l:use_tabs = 1
	let l:indent_width = 4
	let l:tab_width = 4

	if l:use_tabs
		set noexpandtab
		set softtabstop=0
		let &shiftwidth = l:indent_width
		let &tabstop = l:tab_width
	else
		set expandtab
		let &softtabstop = l:indent_width
		let &shiftwidth = l:indent_width
		let &tabstop = l:tab_width
	endif
endfunction

call SetIndent()

set smartindent
set autoindent

set backspace=2

set number
set wrap

let mapleader = ","

command W w
command Q q
command Wq wq
command WQ wq
cmap w!! exec 'w !sudo dd of=' . shellescape(expand('%'))

set guifont=Anonymous\ Pro:h14

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'Tyilo/logos.vim'
Plugin 'Tyilo/applescript.vim'
Plugin 'Tyilo/cycript.vim'

Plugin 'ogier/guessindent'
Plugin 'dag/vim-fish'
Plugin 'chriskempson/vim-tomorrow-theme'

Plugin 'editorconfig/editorconfig-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'ervandew/supertab'
Plugin 'sjl/gundo.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-surround'
Plugin 'itchyny/lightline.vim'

call vundle#end()

filetype plugin indent on

colorscheme Tomorrow-Night-Bright

set clipboard=unnamed

let g:guessindent_prefer_tabs = 1
autocmd BufReadPost * :GuessIndent

let g:syntastic_cpp_compiler_options = '-std=c++11'

if &term =~ "xterm.*"
	let &t_ti = &t_ti . "\e[?2004h"
	let &t_te = "\e[?2004l" . &t_te
	function XTermPasteBegin(ret)
		set pastetoggle=<Esc>[201~
		set paste
		return a:ret
	endfunction
	map <expr> <Esc>[200~ XTermPasteBegin("i")
	imap <expr> <Esc>[200~ XTermPasteBegin("")
	cmap <Esc>[200~ <nop>
	cmap <Esc>[201~ <nop>
endif

function! <SID>StripTrailingWhitespaces()
	let l = line(".")
	let c = col(".")
	%s/\s\+$//e
	call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

set laststatus=2
