local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias

paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself
paq {'nvim-treesitter/nvim-treesitter'}
paq {'neovim/nvim-lspconfig'}
paq {'junegunn/fzf', run = fn['fzf#install']}
paq {'junegunn/fzf.vim'}
paq {'ojroques/nvim-lspfuzzy'}
paq {'vim-airline/vim-airline'}
paq {'vim-airline/vim-airline-themes'}
paq {'easymotion/vim-easymotion'}
paq {'preservim/nerdcommenter'}
paq {'ryanoasis/vim-devicons'}
paq {'ap/vim-css-color'}
paq {'Raimondi/delimitMate'}
paq {'airblade/vim-gitgutter'}
paq {'terryma/vim-multiple-cursors'}
paq {'sainnhe/gruvbox-material'}
paq {'folke/lsp-colors.nvim'}
paq {'shougo/deoplete-lsp'}
paq {'shougo/deoplete.nvim', run = fn['remote#host#UpdateRemotePlugins']}
paq {'tbodt/deoplete-tabnine', run = './install.sh'}
paq {'mfussenegger/nvim-jdtls'}

-------------------- OPTIONS -------------------------------
cmd 'colorscheme gruvbox-material'            -- Put your favorite colorscheme here
opt.background = 'dark'
opt.signcolumn = 'number'
opt.completeopt = 'menuone,noselect'
opt.clipboard = 'unnamedplus'
opt.swapfile = false
opt.mouse = 'a'
opt.expandtab = true                -- Use spaces instead of tabs
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.joinspaces = false              -- No double spaces with join
--opt.list = true                     -- Show some invisible characters
opt.number = true                   -- Show line numbers
opt.relativenumber = true           -- Relative line numbers
opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = 4                  -- Size of an indent
opt.sidescrolloff = 8               -- Columns of context
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current
opt.tabstop = 4                     -- Number of spaces tabs count for
opt.termguicolors = true            -- True color support
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
opt.wrap = false                    -- Disable line wrap
g.delimitMate_expand_cr = 1
g.airline_powerline_fonts = 1
g.gruvbox_material_background = 'soft'
g['deoplete#enable_at_startup'] = 1
cmd[[ let g:NERDCustomDelimiters = { 'c': { 'left': '/* ', 'right': ' */', 'leftAlt': '////' } }]]


local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- MAPPINGS ------------------------------
map('', '<leader>c', '"+y')       -- Copy to clipboard in normal, visual, select and operator modes
map('i', '<C-u>', '<C-g>u<C-u>')  -- Make <C-u> undo-friendly
map('i', '<C-w>', '<C-g>u<C-w>')  -- Make <C-w> undo-friendly

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

map('n', '<C-l>', '<cmd>noh<CR>')    -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``')  -- Insert a newline in normal mode
map('n', '<leader>i', ':10split input.txt<CR>')
map('n', '<leader>y', ':%y+<CR>')
map('i', 'jk', '<ESC>')

-- map build and run commands
cmd [[autocmd FileType cpp nnoremap <F9> :w<CR>:!build.sh 1 %:r<CR>]]
cmd [[autocmd FileType cpp nnoremap <F10> :w<CR>:!build.sh 0 %:r<CR>]]
cmd [[autocmd FileType cpp nnoremap <F5> :!./%:r < input.txt<CR>]]
cmd [[autocmd FileType python nnoremap <F5> :w<CR>:!python3 % < input.txt<CR>]]
cmd [[autocmd FileType java nnoremap <F5> :w<CR>:!java % < input.txt<CR>]]

-------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

-------------------- LSP -----------------------------------
local lsp = require 'lspconfig'
local lspfuzzy = require 'lspfuzzy'

-- We use the default settings for clangd and pylsp: the option table can stay empty
lsp.clangd.setup{}
lsp.pyright.setup{}
--lsp.jdtls.setup{cmd={'jdtls'}}
lspfuzzy.setup{}  -- Make the LSP client use FZF instead of the quickfix list
cmd[[if has('nvim-0.5')
  augroup lsp
    au!
    au FileType java lua require('jdtls').start_or_attach({cmd = {'jdtls'}})
  augroup end
endif]]

map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

-------------------- COMMANDS ------------------------------
cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'  -- disabled in visual mode

--cmd [[highlight! link SignColumn LineNr]]

--- lsp UI customization

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = true,
  underline = false,
  update_in_insert = true,
})
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end


--- templates
cmd[[ autocmd BufNewFile *.cpp 0r ~/.config/nvim/templates/skeleton.cpp]]
cmd[[ autocmd BufNewFile *.py 0r ~/.config/nvim/templates/skeleton.py]]
cmd[[ autocmd BufNewFile *.c 0r ~/.config/nvim/templates/skeleton.c]]
cmd[[ autocmd BufNewFile *.java 0r ~/.config/nvim/templates/skeleton.java]]
