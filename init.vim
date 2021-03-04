map <F4> :syn on<CR>
set nu rnu
se autochdir
set encoding=UTF-8
set clipboard=unnamedplus
set cursorline
set nowb
set noswapfile
set backupdir=~/tmp,/tmp
set backupcopy=yes
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=/tmp
"Set proper tab
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
if has('mouse')
    set mouse=a
endif
set autoindent
set smartindent
set autoread
set autowrite
set splitbelow
set splitright

call plug#begin('~/.config/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
"Plug 'overcache/NeoSolarized'
Plug 'morhetz/gruvbox'
Plug 'tibabit/vim-templates'
" Use release branch (Recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Moving around easier
Plug 'easymotion/vim-easymotion'
Plug 'preservim/nerdcommenter'
Plug 'Chiel92/vim-autoformat'
Plug '907th/vim-auto-save'
Plug 'ryanoasis/vim-devicons'
Plug 'ap/vim-css-color'
Plug 'Raimondi/delimitMate'

call plug#end()


let delimitMate_expand_cr = 1
let g:auto_save = 0  " enable AutoSave on Vim startup
"autoformat bind
noremap <F3> :Autoformat<CR>
"input
nnoremap <leader>i :10split input.txt<CR>
nnoremap <leader>w <C-W>W
"split
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
"autoformat
let g:AutoPairsShortcutJump = ''
"autocmd filetype cpp au BufWrite * :Autoformat
"autocmd filetype c au BufWrite * :Autoformat
"autocmd filetype python au BufWrite * :Autoformat

autocmd filetype cpp nnoremap <F9> :!g++ -g -DQUYNX_DEBUG -Wall -Wshadow -Wno-unused-result -std=gnu++17 -O2 % -o %:r -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG<CR>
autocmd filetype cpp nnoremap <F10> :!g++ -g -DQUYNX_DEBUG -Wall -Wshadow -Wno-unused-result -std=gnu++17 -O2 % -o %:r<CR>
autocmd filetype c nnoremap <F10> :!gcc -g -O2 -std=c11 -o %:r % && ./%:r<CR>
autocmd filetype asm let g:asmsyntax = 'nasm'
autocmd filetype asm nnoremap <F10> :!nasm -f elf % && ld -m elf_i386 %:r.o -o %:r && ./%:r <CR>
autocmd filetype asm nnoremap <F9> :!nasm -f elf % && ld -m elf_i386 %:r.o -o %:r<CR>
autocmd filetype asm set filetype=nasm
autocmd filetype c nnoremap <F9> :! gcc -g -std=c11 -o %:r % -O2<CR>
autocmd filetype cpp nnoremap <F5> :!./%:r<input.txt<CR>
autocmd filetype c nnoremap <F5> :!./%:r <CR>
autocmd filetype python nnoremap <F5> :!python3 % < input.txt<CR>
autocmd filetype asm nnoremap <F5> :!./%:r < input.txt<CR>
"yank
nnoremap <leader>y :%y<CR>
"nerd tree cfg
map <leader>b :NERDTreeToggle<CR>
let NERDTreeMinimalUI=1
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <leader>t <C-w>w
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"move line around
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
inoremap <leader>j <Esc>:m .+1<CR>==gi
inoremap <leader>k <Esc>:m .-2<CR>==gi
vnoremap <leader>j :m '>+1<CR>gv=gv
vnoremap <leader>k :m '<-2<CR>gv=gv

"UI stuffs
syntax on
set background=dark
set termguicolors
"if exists('+termguicolors')
  "let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  "let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  "set termguicolors
"endif
let g:airline_theme='gruvbox'
"set signcolumn=number
colorscheme gruvbox
hi Normal guibg=NONE ctermbg=NONE
let g:airline_powerline_fonts = 0
let g:gruvbox_transparent_bg = 1

set hidden

set nobackup
set nowritebackup

" Better display for messages
"set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c
"
"Skeleton template
":autocmd BufNewFile *.cpp 0r ~/.config/nvim/templates/skeleton.cpp
":autocmd BufNewFile *.py 0r ~/.config/nvim/templates/skeleton.py
":autocmd BufNewFile *.c 0r ~/.config/nvim/templates/skeleton.c

"vim-templates
let g:tmpl_search_paths = ['/home/quynx/.config/nvim/templates']

"coc shit
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" Note coc#float#scroll works on neovim >= 0.4.0 or vim >= 8.2.0750
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" NeoVim-only mapping for visual mode scroll
" Useful on signatureHelp after jump placeholder of snippet expansion
if has('nvim')
  vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
  vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

