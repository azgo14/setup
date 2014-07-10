execute pathogen#infect()
syntax enable
filetype plugin indent on
" Use UTF-8 without BOM
:se encoding=utf-8 nobomb
" Show “invisible” characters
:se lcs=tab:?\ ,trail:·,eol:¬,nbsp:_
:se background=dark
colorscheme solarized
:se tabstop=2
:se softtabstop=2
:se shiftwidth=2
:se expandtab
:se hlsearch
:se number
:syntax on

" Search results not at bottom
:set scrolloff=10

" Make vim draw faster
:se lazyredraw
:se ttyfast

" Fix vim colors
:set t_Co=256

" Stop Nerdtree from opening as soon as vim starts
let g:NERDTreeHijackNetrw=0

" Color column after 80 differently
let &colorcolumn=join(range(81,999),",")

" Add full file path in statusline
:se statusline+=%F
:se ls=2

set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" Wheel scrolling
:set mouse=a
:map <ScrollWheelUp> <C-Y>
:map <S-ScrollWheelUp> <C-U>
:map <ScrollWheelDown> <C-E>
:map <S-ScrollWheelDown> <C-D>

" Remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

