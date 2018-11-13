let g:python3_host_prog = "/usr/bin/python3"

let g:clang_library_path = "/usr/lib"

call plug#begin('~/.vim/plugged')

Plug 'Tyilo/logos.vim'
Plug 'Tyilo/applescript.vim'
Plug 'Tyilo/cycript.vim'

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-eunuch'
Plug 'machakann/vim-highlightedyank'

Plug 'lambdalisue/suda.vim'

Plug 'bogado/file-line'
Plug 'thirtythreeforty/lessspace.vim'
Plug 'ogier/guessindent'
Plug 'dag/vim-fish'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'itchyny/lightline.vim'

" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'zchee/deoplete-jedi'
Plug 'w0rp/ale'
Plug 'Mortal/clang_complete', { 'branch': 'follow_reference' }

Plug 'rust-lang/rust.vim'
Plug 'cypok/vim-sml'
Plug 'petRUShka/vim-sage'
Plug 'udalov/kotlin-vim'

Plug 'FStarLang/VimFStar', { 'for': 'fstar' }

" Plug 'git://git.code.sf.net/p/atp-vim/code', { 'as': 'atp-vim' }

" This overrides my builtin default indent :/
"Plug 'Superbil/llvm.vim'

call plug#end()

augroup filetypedetect
    au BufRead,BufNewFile *.jif setfiletype java
augroup END

" let b:atp_Viewer = "evince"

let g:clang_make_default_keymappings = 0
au FileType cpp nnoremap <buffer> <Leader>d :call g:ClangGotoDeclaration()<CR>
au FileType cpp nnoremap <buffer> <Leader>g :call g:ClangFollowReference()<CR>
let g:clang_auto_select = 2
let g:clang_complete_auto = 0
let g:clang_auto_user_options = "compile_commands.json"

function! SetDefaultIndent()
	set noexpandtab
	set softtabstop=4
	set shiftwidth=4
	set tabstop=4
endfunction

call SetDefaultIndent()

set number
set wrap

set undofile
set undodir=$HOME/.vimundo

set history=9999
set undolevels=9999
set undoreload=10000

set inccommand=nosplit

command W w
command Q q
command Wq wq
command WQ wq
cmap w!! w suda://%

set clipboard+=unnamedplus

colorscheme Tomorrow-Night-Bright

let g:deoplete#enable_at_startup = 1

let g:ale_lint_on_text_changed = 'never'
let g:ale_python_flake8_executable = "pyflakes_wrapper"

let g:ale_linters = {
\	'cpp': [],
\	'python': ['flake8'],
\}

let g:guessindent_prefer_tabs = 1
autocmd BufReadPost * :GuessIndent

" Make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv
