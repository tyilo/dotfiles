let g:python3_host_prog = "/usr/bin/python3"

let g:clang_library_path = "/usr/lib"

if has('nvim')
	call plug#begin('~/.local/share/nvim/plugged')
else
	call plug#begin('~/.vim/plugged')
endif

Plug 'Tyilo/logos.vim'
Plug 'Tyilo/applescript.vim'
Plug 'Tyilo/cycript.vim'

Plug 'JuliaEditorSupport/julia-vim'

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-eunuch'
Plug 'machakann/vim-highlightedyank'

Plug 'lambdalisue/suda.vim'

Plug 'bogado/file-line'
Plug 'Cimbali/vim-better-whitespace'
Plug 'ogier/guessindent'
Plug 'blankname/vim-fish'
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
Plug 'itchyny/lightline.vim'

if has('nvim')
	Plug 'https://framagit.org/tyreunom/coquille.git/'
else
	Plug 'let-def/vimbufsync'
	Plug 'the-lambda-church/coquille', { 'branch': 'pathogen-bundle' }
endif

"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'

if has('nvim')
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
	Plug 'Shougo/deoplete.nvim'
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'zchee/deoplete-jedi'
Plug 'lervag/vimtex'

" Plug 'Shougo/deoplete-clangx'

Plug 'w0rp/ale'
" Plug 'Mortal/clang_complete', { 'branch': 'follow_reference' }

Plug 'rust-lang/rust.vim'
Plug 'cypok/vim-sml'
Plug 'petRUShka/vim-sage'
Plug 'udalov/kotlin-vim'
Plug 'evanleck/vim-svelte'

Plug 'FStarLang/VimFStar', { 'for': 'fstar' }

Plug 'HerringtonDarkholme/yats.vim'

" Plug 'git://git.code.sf.net/p/atp-vim/code', { 'as': 'atp-vim' }

" This overrides my builtin default indent :/
"Plug 'Superbil/llvm.vim'

call plug#end()

let g:better_whitespace_enabled=0
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0
let g:strip_only_modified_lines=1
let g:strip_whitelines_at_eof=1
let g:show_spaces_that_precede_tabs=1

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

if exists('&inccommand')
	set inccommand=nosplit
endif

command W w
command Q q
command Wq wq
command WQ wq
cmap w!! w suda://%

set clipboard+=unnamedplus

silent! colorscheme Tomorrow-Night-Bright

let g:deoplete#enable_at_startup = 1

call deoplete#custom#var('omni', 'input_patterns', {
\	'tex': g:vimtex#re#deoplete
\})

let g:ale_lint_on_text_changed = 'never'
let g:ale_python_flake8_executable = "pyflakes_wrapper"

let g:ale_linters = {
\	'asm': [],
\	'cpp': ['clangcheck'],
\	'python': ['flake8'],
\}

let g:ale_cpp_clangcheck_options = '--extra-arg=-std=c++17'

let g:ale_fixers = {
\	'cpp': ['clang-format'],
\	'python': ['black'],
\	'javascript': ['prettier'],
\	'css': ['prettier'],
\	'html': ['prettier'],
\	'svelte': ['prettier'],
\}

let g:ale_javascript_prettier_options = '--plugin-search-dir=/home/tyilo/.npm-packages/lib'

set hidden
let g:LanguageClient_serverCommands = {
\	'cpp': ['clangd'],
\	'python': ['pyls'],
\}

let g:guessindent_prefer_tabs = 1
autocmd BufReadPost * :GuessIndent
autocmd Filetype python set softtabstop=4 tabstop=4 shiftwidth=4 expandtab

" Make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

let g:tex_comment_nospell=1

function! ClearCoqHighlight()
    hi clear CheckedByCoq
    hi clear SentToCoq
    hi clear CoqErrorCommand
    hi clear CoqError
endfunction

au FileType coq nnoremap <buffer> <Leader>p oProof. reflexivity. Qed.<Esc>
au FileType coq nnoremap <Leader>l :call CoqLaunch()<CR>
au FileType coq nnoremap <Leader>r :call CoqStop()<CR> <bar> :call ClearCoqHighlight()<CR> <bar> :call CoqLaunch()<CR> <bar> :call CoqToCursor()<CR>
au FileType coq nnoremap <Leader>s :call CoqSearch("
au BufNewFile,BufReadPost *.v :set softtabstop=2 tabstop=2 shiftwidth=2 expandtab

au BufNewFile,BufRead *.tex :set spell textwidth=88

"let g:coquille_auto_move = 'true'

au FileType coq call coquille#FNMapping()
if has('nvim')
	"au FileType coq call CoqLaunch()
else
	"au FileType coq CoqLaunch
endif

nnoremap <Leader>f :ALEFix<CR>
