execute pathogen#infect()
syntax enable
filetype plugin indent on
" Use UTF-8 without BOM
:se encoding=utf-8 nobomb
" Show “invisible” characters
:se lcs=tab:?\ ,trail:·,eol:¬,nbsp:_
:se background=dark
colorscheme solarized
:se tabstop=4
:se softtabstop=4
:se shiftwidth=4
:se expandtab
:se hlsearch
:se number
:syntax on
:set ttyfast


" Add full file path in statusline
:se statusline+=%F
:se ls=2
":set colorcolumn=80
":highlight ColorColumn ctermbg=6

set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
let g:ctrlp_working_path_mode = 'c'

" Wheel scrolling
:set mouse=a
:map <ScrollWheelUp> <C-Y>
:map <S-ScrollWheelUp> <C-U>
:map <ScrollWheelDown> <C-E>
:map <S-ScrollWheelDown> <C-D>

" Remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

