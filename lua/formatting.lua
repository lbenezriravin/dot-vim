---@diagnostic disable: undefined-global
-- general formatting
vim.o.textwidth = 80
vim.o.autoindent = true
vim.o.shiftwidth = 4
vim.o.shiftround = true
vim.o.wrap = false
vim.opt.formatoptions = {
    t = true,
    c = true,
    r = true,
    o = true,
    q = true,
    n = true,
    l = true,
    [1] = true,
    j = true,
    p = true,
}

-- Fold syntactically
vim.o.foldmethod = 'expr'
vim.o.foldlevel = 99
-- nvim-treesitter/nvim-treesitter
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

-- tab / whitespace control
vim.o.expandtab = true
vim.o.softtabstop = 4

-- use real tabs in Makefiles
vim.api.nvim_create_autocmd("FileType", {
    pattern = "make",
    callback = function()
        vim.bo.expandtab = false
    end
})

-- windwp/nvim-autopairs
require('nvim-autopairs').setup({})
