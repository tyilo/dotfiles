let g:python3_host_prog = "/usr/bin/python3"

let g:clang_library_path = "/usr/lib"

call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'github/copilot.vim'

" Plug 'Tyilo/logos.vim'
" Plug 'Tyilo/applescript.vim'
" Plug 'Tyilo/cycript.vim'

" Plug 'JuliaEditorSupport/julia-vim'

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-eunuch'
Plug 'machakann/vim-highlightedyank'

Plug 'lambdalisue/suda.vim'

Plug 'bogado/file-line'
Plug 'Cimbali/vim-better-whitespace'
Plug 'ogier/guessindent'
" Plug 'blankname/vim-fish'
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
Plug 'itchyny/lightline.vim'

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'lervag/vimtex'

Plug 'dense-analysis/ale'
" Plug 'Mortal/clang_complete', { 'branch': 'follow_reference' }

Plug 'maximbaz/lightline-ale'

" Plug 'rust-lang/rust.vim'
" Plug 'cypok/vim-sml'
" Plug 'petRUShka/vim-sage'
" Plug 'udalov/kotlin-vim'
" Plug 'evanleck/vim-svelte'
" Plug 'cespare/vim-toml'
Plug 'meatballs/vim-xonsh'

" Plug 'FStarLang/VimFStar', { 'for': 'fstar' }

Plug 'HerringtonDarkholme/yats.vim'

Plug 'raimon49/requirements.txt.vim'

Plug 'gioele/vim-autoswap'

Plug 'editorconfig/editorconfig-vim'

Plug 'elixir-editors/vim-elixir'

" Plug 'git://git.code.sf.net/p/atp-vim/code', { 'as': 'atp-vim' }

" This overrides my builtin default indent :/
"Plug 'Superbil/llvm.vim'

call plug#end()

autocmd BufEnter * :syntax sync fromstart

let g:lightline = {}
let g:lightline.component_expand = {
\	'linter_checking': 'lightline#ale#checking',
\	'linter_infos': 'lightline#ale#infos',
\	'linter_warnings': 'lightline#ale#warnings',
\	'linter_errors': 'lightline#ale#errors',
\	'linter_ok': 'lightline#ale#ok',
\}

let g:lightline.component_type = {
\	'linter_checking': 'right',
\	'linter_infos': 'right',
\	'linter_warnings': 'warning',
\	'linter_errors': 'error',
\	'linter_ok': 'right',
\}

let g:lightline.active = {
\	'right': [
\		['lineinfo'],
\		['percent'],
\		['fileformat', 'fileencoding', 'filetype'],
\		['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok']
\	]
\}

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

au FileType python nnoremap <buffer> <Leader>p oprint(, file=__import__("sys").stderr)<ESC>%a
au FileType python nnoremap <buffer> <Leader>r O<C-A> = <Esc>p

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

set cursorcolumn
set cursorline

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

" Needed for autoswap
set title

let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('sources', {
\	'_': ['ale'],
\})

let g:ale_lint_on_text_changed = 'never'

let g:ale_linters = {
\	'asm': [],
\   'cpp': ['cc'],
\	'python': ['pylsp', 'mypy'],
\	'rust': ['analyzer', 'cargo'],
\}

let g:rust_cargo_use_clippy = 1

let g:ale_cpp_cc_executable = 'g++'
let g:ale_cpp_cc_options = '-std=c++17 -Wall'

let g:ale_cpp_clang_options = '-std=c++17 -Wall'
let g:ale_cpp_clangd_options = '-std=c++17 -Wall'
let g:ale_cpp_clangcheck_options = '--extra-arg=-std=c++17 --extra-arg=-Wall'
let g:ale_cpp_clangtidy_options = '-std=c++17 -Wall'
let g:ale_cpp_gcc_options = '-std=c++17 -Wall'

let g:ale_fixers = {
\	'cpp': ['clang-format'],
\	'python': ['black', 'isort'],
\	'javascript': ['prettier'],
\	'typescript': ['prettier'],
\	'css': ['prettier'],
\   'sccs': ['prettier'],
\	'html': ['prettier'],
\	'svelte': ['prettier'],
\   'yaml': ['prettier'],
\   'markdown': ['prettier'],
\   'json': ['prettier'],
\   'rust': ['rustfmt'],
\}

set hidden

let g:guessindent_prefer_tabs = 1
autocmd BufReadPost * :GuessIndent
autocmd Filetype python set softtabstop=4 tabstop=4 shiftwidth=4 expandtab

" Make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

let g:tex_flavor = 'latex'

let g:tex_comment_nospell=1

au BufNewFile,BufReadPost *.html,*.js,*.css :set softtabstop=2 tabstop=2 shiftwidth=2 expandtab
au BufNewFile,BufReadPost *.v :set softtabstop=2 tabstop=2 shiftwidth=2 expandtab

au BufNewFile,BufRead *.tex :set spell textwidth=88

nnoremap <Leader>f :ALEFix<CR>
nnoremap <Leader>g :ALEGoToDefinition<CR>
nnoremap <Leader>r :ALEFindReferences<CR>

nnoremap <silent> <Leader>k <Plug>(ale_previous_wrap)
nnoremap <silent> <Leader>j <Plug>(ale_next_wrap)
nnoremap <silent> <Leader>l <Plug>(ale_last)
nnoremap <silent> <Leader>h <Plug>(ale_first)

lua require'lua_init'
