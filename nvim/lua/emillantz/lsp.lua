local M = {}

M.lazy = {
    { 'williamboman/mason.nvim', opts = {} },
    { 'williamboman/mason-lspconfig.nvim' },
    {
       'neovim/nvim-lspconfig',
        event = 'InsertEnter',
        dependencies = {
            { 'j-hui/fidget.nvim', event = 'LspAttach', tag = 'legacy', opts = {} },
            { 'creativenull/efmls-configs-nvim', event = 'LspAttach', version = '1.x.x' },
            'folke/neodev.nvim',
            'lvimuser/lsp-inlayhints.nvim',
        },
    },
    { 'RRethy/vim-illuminate' },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            --for json and yaml servers
            'b0o/schemastore.nvim',


            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
        },
        opts = function()
            local cmp = require('cmp')
            local defaults = require('cmp.config.default')()
            local luasnip = require('luasnip')

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line -1, line, true)[1]:sub(col, col):match('%s') == nil
            end
            require('luasnip.loaders.from_vscode').lazy_load()
            luasnip.config.setup({})
            return {
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true
                },

                ['<C-a>'] = cmp.mapping.abort(),

                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if #cmp.get_entries() == 1 then
                            cmp.confirm({ select = true })
                        else
                            cmp.select_next_item()
                        end
                -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
                -- that way you will only jump inside the snippet region
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
            }),
            sorting = defaults.sorting
        }
        end,
    },
}

M.configure = function()
    local on_attach = function(client, buf)
        local nmap = function(keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = buf, desc = desc })
        end
        local vmap = function(keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
            end

            vim.keymap.set('v', keys, func, { buffer = buf, desc = desc })
        end

        if client.server_capabilities.documentSymbolProvider then
            require('nvim-navic').attach(client, buf)
        end

        if client.name == 'ruff' then
            client.server_capabilities.hoverProvider = false
        end

        nmap('<leader>gd', vim.lsp.buf.definition, '[g]o to [d]efinition')
        nmap('<leader>gD', vim.lsp.buf.declaration, '[go] to [Declaration]')

        nmap('<leader>gi', vim.lsp.buf.implementation, '[g]o to [i]mplementation')

        if client.server_capabilities.documentFormattingProvider then
            --nmap('<leader>fl', vim.lsp.buf.format(), '[l]sp [f]ormat')
        end

        vim.keymap.set('n', '<leader>d', vim.diagnostic.goto_next, { desc = 'lookup next [d]iagnostic' })
        vim.keymap.set('n', '<leader>D', vim.diagnostic.goto_prev, { desc = 'lookup previous [D]iagnostic' })

        vim.keymap.set('n', '<leader>gl', vim.diagnostic.open_float, { desc = 'open diagnostic' })

    end

    require('neodev').setup()

    local lspconfig = require('lspconfig')
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local servers = require('emillantz.servers').servers()

    require('mason-lspconfig').setup({
        automatic_installation=true,
        ensure_installed = servers,
        PATH = "prepend",
    })

    for server, config in pairs(servers) do
        config.on_attach = on_attach
        lspconfig[server].setup(config)
    end

end

return M
