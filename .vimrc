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

" Keeps the cursor centered vertically on the screen
set scrolloff=15

" Highlight all matches in a file when searching
set hlsearch

" Get .swp files out of the file dir. http://stackoverflow.com/a/21026618/947
set directory=$HOME/vimtmp/swapfiles/

" Highlight the current line.
set cursorline
hi CursorLine term=none cterm=none ctermbg=yellow guibg=yellow

" Remap jk to esc for faster insert mode exiting.
inoremap jk <esc>
" Disable esc - no thanks
"inoremap <esc> <nop>

" Pathogen - loads anything in ~/vimfiles/bundle
execute pathogen#infect()

syntax enable
filetype plugin indent on
