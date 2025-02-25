set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vim Plugins
Bundle 'gmarik/vundle'
Bundle 'morhetz/gruvbox'
Bundle 'kien/ctrlp.vim.git'
Bundle 'scrooloose/nerdtree.git'
"Bundle 'Shougo/neocomplete.vim.git'
"#Bundle 'Rip-Rip/clang_complete.git'
Bundle 'tpope/vim-fugitive.git'

call vundle#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax enable
filetype plugin indent on
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Show “invisible” characters
set lcs=tab:?\ ,trail:·,eol:¬,nbsp:_
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set hlsearch
set number
:syntax on

" Allow backspace during insertion mode for delete
set backspace=2

" Search results not at bottom
set scrolloff=10

" Make vim draw faster
set lazyredraw
set ttyfast

colorscheme gruvbox

" Stop Nerdtree from opening as soon as vim starts
let g:NERDTreeHijackNetrw=0

" Color column after 80 differently
let &colorcolumn=join(range(81,999),",")

" Add full file path in statusline
set statusline+=%F
set ls=2

set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
"" Don't delete cache after exit
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.o
let g:ctrlp_max_files = 0

" Wheel scrolling
set mouse=a
:map <ScrollWheelUp> <C-Y>
:map <S-ScrollWheelUp> <C-U>
:map <ScrollWheelDown> <C-E>
:map <S-ScrollWheelDown> <C-D>

" Remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

if 0
" Start neocomplete automatically
let g:neocomplete#enable_at_startup = 0

" Neocomplete and clang_complete niceness
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#force_omni_input_patterns.c =
      \ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:neocomplete#force_omni_input_patterns.cpp =
      \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
let g:neocomplete#force_omni_input_patterns.objc =
      \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
let g:neocomplete#force_omni_input_patterns.objcpp =
      \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
"let g:clang_use_library = 1
endif
