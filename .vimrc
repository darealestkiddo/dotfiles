"
" A (not so) minimal vimrc.
"

" You want Vim, not vi. When Vim finds a vimrc, 'nocompatible' is set anyway.
" We set it explicitely to make our position clear!
"

if has('python3')
endif

call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdcommenter'
Plug 'ycm-core/YouCompleteMe'
call plug#end()
set clipboard=unnamed
set nu rnu
set nocompatible
set encoding=utf-8

filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.

set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set softtabstop =4         " Tab key indents by 4 spaces.
set shiftwidth  =4         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.

set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.

set incsearch              " Highlight while searching with / or ?.
set hlsearch               " Keep matches highlighted.

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.

set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

"set cursorline             " Find the current line quickly.
set wrapscan               " Searches wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.

set list                   " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

" The fish shell is not very compatible to other shells and unexpectedly
" breaks things that use 'shell'.
if &shell =~# 'fish$'
  set shell=/bin/bash
endif

imap jk <ESC>
au BufRead,BufNewFile *.asm set filetype=nasm

" Put all temporary files under the same directory.
" https://github.com/mhinz/vim-galore#temporary-files
set backup
set backupdir   =$HOME/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =$HOME/.vim/files/swap//
set updatecount =100
set undofile
set undodir     =$HOME/.vim/files/undo/
set viminfo     ='100,n$HOME/.vim/files/info/viminfo
inoremap <expr> <Enter> pumvisible() ? "<Esc>a" : "<Enter>"
" auto FileType nasm nnoremap <F9> :w<CR>:!vcvars64.bat && build.bat debug %:r<CR>
auto FileType nasm nnoremap <F9> :w<CR>:!nasm -f win64 % -o %:r.obj && golink /entry:main kernel32.dll user32.dll %:r.obj<CR>
auto FileType nasm nnoremap <F10> :w<CR>:!nasm -f win64 % -o %:r.obj && golink /console /entry:main kernel32.dll user32.dll %:r.obj<CR>
auto FileType nasm nnoremap <F5> :!%:r.exe<CR>
let NERDSpaceDelims=1
