local M = {}

M.lazy = {
    {
        'rust-lang/rust.vim',
        ft = 'rust',
        init = function()
            vim.g.rustfmt_autosave = 1
        end
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
            {
                "chrisgrieser/nvim-lsp-endhints",
                event = "LspAttach",
                opts = {}
            },
        },
        ft = { "rust" },
        config = function()
            vim.g.rustaceanvim = {
                tools = {
                    hover_actions = {
                        auto_focus = true,
                    },
                },
                lsp = {
                    ClientOpts = {
                        load_vscode_settings = false,
                    }
                },
                server = {
                    on_attach = function(client, bufnr)
                        local hints = require('lsp-endhints')
                        hints.setup({
                            icons = {
                                type = "→ ",
                                parameter = "| ",
                                offspec = "",
                                unknown = "",
                            },
                            label = {
                                truncateAtChars = 35,
                                padding = 1,
                                marginLeft = 0,
                                sameKindSeparator = ", "
                            },
                            extmark = {
                                priority = 50,
                            },
                            autoEnableHints = true,
                        })
                        vim.keymap.set(
                            "n",
                            "<leader>cd",
                            function()
                                vim.cmd.RustLsp('openDocs')
                            end
                        )
                    end,
                    diagnostic = {
                        refreshSupport = false,
                    },
                    default_settings = {
                        ['rust-analyzer'] = {
                            check = {
                                command = "clippy",
                                extraArgs = {"--", "-W", "clippy::style"}
                            },
                            linkedProjects = nil
                        }
                    }
                }
            }
        end
    }
}

return M
