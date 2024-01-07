local M = {}

M.lazy = {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
        'nvim-lua/plenary.nvim'
    }
}

M.configure = function()
    local telescope = require('telescope')
    local config = require('telescope.config')
    local args = { unpack(config.values.vimgrep_arguments) }

    table.insert(args, '--hidden')
    table.insert(args, '--glob')
    table.insert(args, '!**/.git/*')

    telescope.setup({})
end

return M
