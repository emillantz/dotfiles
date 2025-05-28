local M = {}

M.lazy = {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    cmd = "Neotree",
    keys = {
        {
            "<leader>pc",
            function()
                require('neo-tree.command').execute({
                    toggle = true,
                })
            end
        }
    },
    lazy = false,
}

M.configure = function()
    local neotree = require('neo-tree')
    neotree.setup({
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
            },
            --does not seem to work?
            hijack_netrw_behaviour = "open_current"
        },
        window = {
            position = "current",
        },
        event_handlers = {
            {
                event = "file_open_requested",
                handler = function()
                    require("neo-tree.command").execute({action = "close"})
                end
            },
        }
    })
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end

return M
