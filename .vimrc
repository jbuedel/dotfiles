" Pathogen - loads anything in ~/vimfiles/bundle
execute pathogen#infect()

" Why isn't solarized working on vim (it looks great on gvim).

" The backup dir should gets the swp and ~ files, hence the next two options are not needed.
set backupdir=~/vimtmp
set nobackup
set nowritebackup

" I have no idea what this does
set backspace=indent,eol,start

" Show line numbers
set number

" Start vim (but really gvim) maximized
":set lines=999 columns=999
au GUIEnter * simalt ~x

" Use all spaces, no tabs
set tabstop=2 shiftwidth=2 expandtab

" Highlight all matches in a file when searching
set hlsearch

" Get .swp files out of the file dir. http://stackoverflow.com/a/21026618/947
set directory=$HOME/vimtmp/swapfiles/

set incsearch " Preview as you type "
set ignorecase " Don't be case sensitive "
set smartcase " If you type a capital letter, be case sensitive "

" Highlight the current line.
set cursorline
" The yellow highlight obscures syntax highlighting.
hi CursorLine term=none cterm=none ctermbg=none guibg=yellow

" Remap jk to esc for faster insert mode exiting.
inoremap jk <esc>
" Disable esc - no thanks
"inoremap <esc> <nop>


syntax enable
filetype plugin indent on

" Treat .config files as xml - unfortunately it is not working
au BufNewFile, BufRead *.config set filetype=xml

set shell=powershell
set shellcmdflag=-command

