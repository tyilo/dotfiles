let g:python_host_prog = "/usr/local/bin/python2"
let g:python3_host_prog = "/usr/local/bin/python3"

let g:clang_library_path = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib"

call plug#begin('~/.vim/plugged')

Plug 'Tyilo/logos.vim'
Plug 'Tyilo/applescript.vim'
Plug 'Tyilo/cycript.vim'

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

" This overrides my builtin default indent :/
"Plug 'Superbil/llvm.vim'

call plug#end()

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

filetype plugin indent on

set number
set wrap

set undofile
set undodir=$HOME/.vimundo

set history=9999
set undolevels=9999999999
set undoreload=10000

command W w
command Q q
command Wq wq
command WQ wq
cmap w!! exec 'w !sudo dd of=' . shellescape(expand('%'))

set clipboard+=unnamedplus

colorscheme Tomorrow-Night-Bright

let g:deoplete#enable_at_startup = 1

let g:ale_python_flake8_args = "--ignore W191,E711,E501"

let g:ale_linters = {'cpp': ['clangtidy']}

let g:guessindent_prefer_tabs = 1
autocmd BufReadPost * :GuessIndent

" Make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv
