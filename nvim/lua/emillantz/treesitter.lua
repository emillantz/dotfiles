local M = {}

M.lazy = {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',

    },
    {
        'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {}
    }
}

M.configure = function()
    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            'c',
            'lua',
            'vim',
            'vimdoc',
            'query',
            'rust',
            'java',
            'elixir',
            'yaml',
            'dockerfile',
            'json',
        },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    }

    local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
    }

    local hooks = require('ibl.hooks')

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, 'RainbowRed', {fg = '#E06C75'})
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        end
        )
    vim.g.rainbow_delimiters = { highlight = highlight }
    require('ibl').setup { scope = { highlight = highlight } }

    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

return M
