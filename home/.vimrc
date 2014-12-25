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

Plugin 'ogier/guessindent'
Plugin 'dag/vim-fish'
Plugin 'chriskempson/vim-tomorrow-theme'

call vundle#end()
filetype plugin indent on

colorscheme Tomorrow-Night-Bright

set clipboard=unnamed

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

function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
