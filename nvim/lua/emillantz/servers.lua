local M = {}

M.servers = function()

    local efmPrettier = require('efmls-configs.formatters.prettier')
    require('efmls-configs.formatters.shfmt')

    local efmLangs = {
        rust = { require('efmls-configs.formatters.rustfmt') },
        go = { require('efmls-configs.formatters.gofmt') },
        sh = {
            {
                formatCommand = 'shfmt -i 2 -sr -ci -',
                formatStdin = true,
            },
            require('efmls-configs.linters.shellcheck'),
        },
        yaml = {
            {
                formatCommand = 'yamlfmt -formatter retain_line_breaks=true,indentless_arrays=false -in',
                formatStdin = true,
            },
        },
        json = { efmPrettier },
        markdown = { efmPrettier },
    }

    local servers = {
        efm = {
            init_options = { documentFormatting = true },
            settings = {
                rootMarkers = { '.git/' },
                languages = efmLangs,
            },
            filetypes = vim.tbl_keys(efmLangs),
        },

        clangd = {},
        cmake = {},
        gopls = {},
        pyright = {},
        elixirls = {},
        bashls = {},
        dockerls = {},
        docker_compose_language_service = {},
        matlab_ls = {},
        ltex = {},
        lua_ls = {},

--        rust_analyzer = {
--            settings = {
--                ['rust-analyzer'] = {
--                    check = {
--                        command = 'clippy',
--                        extraArgs = { {'--'}, {'-W'}, {'clippy::style'} }
--                    }
--                }
--            }
--        },

        yamlls = {
            settings = {
                yaml = {
                    schemaStore = { enable = false, url = '' },
                    schemas = require('schemastore').yaml.schemas(),
                }
            }
        },

        jdtls = {
        --todo
        },

        jsonls = {
            settings = {
                json = {
                    schemas = require('schemastore').json.schemas(),
                    validate = true,
                }
            }
        },
    }
    return servers
end

return M
