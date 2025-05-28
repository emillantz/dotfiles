local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        'rose-pine/neovim',
        lazy = false,
        priority = 1000,
        name = 'rose-pine',
        config = function()
            vim.cmd.colorscheme 'rose-pine'
        end,
    },
    {'HiPhish/rainbow-delimiters.nvim'},
    {'tpope/vim-fugitive'},
    {'mbbill/undotree'},
    {'SmiteshP/nvim-navic'},
    require('emillantz.telescope').lazy,
    require('emillantz.lsp').lazy,
    require('emillantz.rust').lazy,
    require('emillantz.treesitter').lazy,
    require('emillantz.neotree').lazy,
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {},
    },
    {'github/copilot.vim'},
}, {})

require('emillantz.telescope').configure()
require('emillantz.lsp').configure()
require('emillantz.treesitter').configure()
require('emillantz.neotree').configure()
