if &shell =~# 'fish$'
	set shell=bash
endif

syntax on

set noexpandtab
set smartindent
set autoindent
set tabstop=4
set shiftwidth=4

set bs=2

set number

set nowrap

cmap w!! exec 'w !sudo dd of=' . shellescape(expand('%'))

colorscheme Tomorrow-Night-Bright

let g:guessindent_prefer_tabs = 1
autocmd BufReadPost * :GuessIndent

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

