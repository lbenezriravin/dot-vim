---@diagnostic disable: undefined-global
-- security
vim.o.exrc = false  -- ignore ~/.exrc
vim.o.secure = true  -- disallow local rc exec

require("plugins")

require('syntax')
require('display')
require('formatting')
require('keymaps')

-- windows
vim.o.splitbelow = true
vim.o.splitright = true

-- editing
vim.o.mouse = ''
vim.o.showmatch = true
vim.o.clipboard = 'unnamedplus'
vim.o.undofile = true
vim.o.undodir = vim.env.HOME .. '/.vim/undodir'
vim.o.backspace = 'indent,eol,start'

-- miscellaneous
vim.g.vim_markdown_folding_disabled = 1
vim.g.vimpager_scrolloff = 0
