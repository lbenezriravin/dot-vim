-- security
vim.o.exrc = false  -- ignore ~/.exrc
vim.o.secure = true  -- disallow local rc exec

-- tab / whitespace control
vim.o.expandtab = true  -- expand hard tabs to spaces
vim.o.softtabstop=4  -- expand tabs to 4 spaces
vim.o.tabstop = 8  -- use 8 spaces for hard tabs

-- formatting options
vim.o.autoindent = true
vim.o.shiftwidth = 4
vim.o.shiftround = true
vim.o.textwidth = 79
vim.opt.formatoptions = vim.opt.formatoptions
    + 't'
    + 'c'
    + 'r'
    - 'o'
    + 'q'
    - 'a'
    + 'n'
    - '2'
    + 'j'

-- display settings
vim.o.ruler = true
vim.o.hidden = true
vim.o.hlsearch = true
vim.opt.listchars = {
    trail = '-',
    nbsp = '+',
    eol = '$',
    tab = '>-'
}
vim.opt.termguicolors = true
vim.opt.syntax = 'on'
vim.opt.laststatus = 2

-- windows
vim.o.splitbelow = true
vim.o.splitright = true

-- editing
vim.o.mouse = ''
vim.o.showmatch = true
vim.o.clipboard = 'unnamed,unnamedplus'
vim.o.undofile = true
vim.o.undodir = vim.env.HOME .. '/.vim/undodir'
vim.o.backspace = 'indent,eol,start'

vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- plugins
vim.cmd('packadd paq-nvim')
local paq = require('paq').paq

paq({'savq/paq-nvim', opt = true})

paq({'nvim-treesitter/nvim-treesitter'})
require('nvim-treesitter.configs').setup({
    highlight = {enable = true},
    incremental_selection = {enable = true},
    indent = {enable = true}
})

paq({'norcalli/nvim-colorizer.lua'})
require('colorizer').setup()

paq({'marko-cerovac/material.nvim'})
-- Theme style
vim.g.material_style = 'palenight'

-- Colorscheme settings
require('material').setup({
    disable = {
        background = true,
    },
    custom_colors = {
        line_numbers = '#C09090',
        comments = '#609060',
    },
    lualine_style = 'stealth',
})

-- custom highlights don't appear to work...
-- Apply the colorscheme
vim.cmd('colorscheme material')


paq({'kyazdani42/nvim-web-devicons', opt = true})
paq({'hoob3rt/lualine.nvim'})
require('lualine').setup({
    options = {theme = 'material'}
})

paq({'neovim/nvim-lspconfig'})
local lspconfig = require('lspconfig')
lspconfig.clangd.setup({})
lspconfig.rust_analyzer.setup({})
lspconfig.pyright.setup({})

vim.g.ale_linters_explicit = 1
vim.g.ale_linters = {
    cpp = {'cpplint'},  -- `pip install --user cpplint`
    gitcommit = {'gitlint'},  -- `pip install --user gitlint`
    markdown = {'mdl'},  -- `gem install mdl`
    sh = {'shellcheck'},  -- `cabal update; cabal install ShellCheck`
    yaml = {'yamllint'}  -- `pip install --user yamllint`
}
vim.g.ale_fixers = {
    rust = {'rustfmt'},
    python = {'black'},
}
paq({'w0rp/ale'})

vim.api.nvim_set_keymap(
    "n",
    "<Leader><space>",
    ":ALEFix<Enter>:w<Enter>",
    { noremap = true, silent = true }
)

paq({'tpope/vim-fugitive'})
paq({'godlygeek/tabular'})
paq({'martinda/Jenkinsfile-vim-syntax'})

vim.g.vim_markdown_folding_disabled = 1
paq({'plasticboy/vim-markdown'})

paq({'nvim-lua/popup.nvim'})
paq({'nvim-lua/plenary.nvim'})
paq({'nvim-telescope/telescope.nvim'})

-- miscellaneous
vim.g.vimpager_scrolloff = 0

-- use real tabs in Makefiles and Kconfig
vim.api.nvim_command([[
    augroup ExpandTabsOverride
        autocmd! FileType make setlocal noexpandtab sw=4 ts=4 sts=4
        autocmd! FileType kconfig setlocal noexpandtab sw=4 ts=4 sts=4
    augroup END
]])

-- Fern file browser
paq({'lambdalisue/fern.vim'})

-- Hack to make fern work with nvim
paq({'antoinemadec/FixCursorHold.nvim'})

-- Fern keybindings
vim.api.nvim_set_keymap(
    "n",
    "<Leader>f",
    ":Fern . -drawer -toggle<Enter>",
    { noremap = true, silent = true }
)

-- Default to extended regular expressions ("very magic")
vim.api.nvim_set_keymap(
    "n",
    "/",
    "/\\v",
    { noremap = true}
)

-- Open command output in a new tab
-- https://vim.fandom.com/wiki/Capture_ex_command_output
vim.cmd([[
function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)
]])

vim.api.nvim_set_keymap(
    "n",
    "tm",
    ":TabMessage ",
    {noremap = true}
)

-- Don't wrap by default, gross
vim.o.wrap = false

-- Mappings.
-- Copied from the nvim-lspconfig docs
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'rust_analyzer', 'tsserver' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end

-- Bufferline
paq({'akinsho/bufferline.nvim'})
require("bufferline").setup({})

-- Copied from the docs
-- These commands will navigate through buffers in order regardless of which mode you are using
-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap(
    "n",
    "fl",
    ":BufferLineCycleNext<CR>",
    opts
)
vim.api.nvim_set_keymap(
    "n",
    "fh",
    ":BufferLineCyclePrev<CR>",
    opts
)

-- These commands will move the current buffer backwards or forwards in the bufferline
vim.api.nvim_set_keymap(
    "n",
    "Fl",
    ":BufferLineMoveNext<CR>",
    opts
)
vim.api.nvim_set_keymap(
    "n",
    "Fh",
    ":BufferLineMovePrev<CR>",
    opts
)

-- Autoclose brackets, quotes, etc.
paq({'windwp/nvim-autopairs'})
require('nvim-autopairs').setup({})

-- Toggle between absolute and relative numbers. Useful for using motions
-- without having to do mental math.
paq({'myusuf3/numbers.vim'})
vim.g.numbers_exclude = {'fern'}


-- Fold syntactically
vim.o.foldmethod = 'expr'
vim.o.foldlevel = 99
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
