local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options


require "paq" {
	'savq/paq-nvim';
	'nvim-treesitter/nvim-treesitter';
	'neovim/nvim-lspconfig';
	{'junegunn/fzf', run = fn['fzf#install']};
	'junegunn/fzf.vim';
	'ojroques/nvim-lspfuzzy';
	'vim-airline/vim-airline';
	'vim-airline/vim-airline-themes';
	'easymotion/vim-easymotion';
	'preservim/nerdcommenter';
	'ryanoasis/vim-devicons';
	'ap/vim-css-color';
	'Raimondi/delimitMate';
	'airblade/vim-gitgutter';
	'terryma/vim-multiple-cursors';
	'sainnhe/gruvbox-material';
	'folke/lsp-colors.nvim';
	'mfussenegger/nvim-jdtls';

-- cmp
	'hrsh7th/cmp-nvim-lsp';
	'hrsh7th/cmp-buffer';
	'hrsh7th/nvim-cmp';
	'hrsh7th/cmp-vsnip';
	'hrsh7th/vim-vsnip';
}

-------------------- OPTIONS -------------------------------
cmd 'colorscheme gruvbox-material'            -- Put your favorite colorscheme here
opt.background = 'dark'
opt.signcolumn = 'number'
opt.completeopt = 'menu,menuone,noinsert'
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
g.airline_theme = 'gruvbox_material'
g.airline_powerline_fonts = 0
g.gruvbox_material_background = 'soft'
g['deoplete#enable_at_startup'] = 1
g.vsnip_snippet_dir = '/home/xnyuq/.config/nvim/snippets'
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
--map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
--map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

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
--ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

-------------------- LSP -----------------------------------
local lsp = require 'lspconfig'
local lspfuzzy = require 'lspfuzzy'

-- We use the default settings for clangd and pylsp: the option table can stay empty
lsp.clangd.setup{}
lsp.pyright.setup{}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lsp.html.setup{
    capabilities = capabilities,
}
lsp.eslint.setup{}
lsp.ccls.setup{}
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

--- nvim-cmp
local cmp = require'cmp'

cmp.setup({
snippet = {
    expand = function(args)
    -- For `vsnip` user.
    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

    -- For `luasnip` user.
    -- require('luasnip').lsp_expand(args.body)

    -- For `ultisnips` user.
    -- vim.fn["UltiSnips#Anon"](args.body)
    end,
},
mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
},
sources = {
    { name = 'nvim_lsp' },

    -- For vsnip user.
    { name = 'vsnip' },

    -- For luasnip user.
    -- { name = 'luasnip' },

    -- For ultisnips user.
    -- { name = 'ultisnips' },

    { name = 'buffer' },
}
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

--- templates
cmd[[ autocmd BufNewFile *.cpp 0r ~/.config/nvim/templates/skeleton.cpp]]
cmd[[ autocmd BufNewFile *.py 0r ~/.config/nvim/templates/skeleton.py]]
cmd[[ autocmd BufNewFile *.c 0r ~/.config/nvim/templates/skeleton.c]]
cmd[[ autocmd BufNewFile *.java 0r ~/.config/nvim/templates/skeleton.java]]
