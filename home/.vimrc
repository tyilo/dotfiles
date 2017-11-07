if &shell =~# 'fish$'
	set shell=bash
endif

syntax on

function! SetIndent(use_tabs, width)
	if a:use_tabs
		set noexpandtab
		set softtabstop=0
		let &shiftwidth = a:width
		let &tabstop = a:width
	else
		set expandtab
		let &softtabstop = a:width
		let &shiftwidth = a:width
		let &tabstop = a:width
	endif
endfunction

command! -nargs=* SetIndent call SetIndent(<f-args>)

function! SetDefaultIndent()
	call SetIndent(1, 4)
endfunction

call SetDefaultIndent()

function! SetExecutableBit()
	let fname = expand("%:p")
	checktime
	execute "au FileChangedShell " . fname . " :echo"
	silent !chmod a+x %
	checktime
	execute "au! FileChangedShell " . fname
endfunction
command! Xbit call SetExecutableBit()
command! ChmodX call SetExecutableBit()

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

filetype plugin indent on

set clipboard=unnamed

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
