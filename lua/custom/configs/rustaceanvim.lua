local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

vim.g.rustaceanvim = {
    -- Server configuration
    server = {
        -- Standalone file support
        standalone = true,

        on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Buffer local mappings
            local opts = { buffer = bufnr, noremap = true, silent = true }

            -- Code navigation
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

            -- Rust-specific mappings
            vim.keymap.set('n', '<leader>rr', function()
                vim.cmd.RustLsp('runnables')
            end, opts)

            vim.keymap.set('n', '<leader>rd', function()
                vim.cmd.RustLsp('debuggables')
            end, opts)

            vim.keymap.set('n', '<leader>rt', function()
                vim.cmd.RustLsp('testables')
            end, opts)

            vim.keymap.set('n', '<leader>rm', function()
                vim.cmd.RustLsp('expandMacro')
            end, opts)

            vim.keymap.set('n', '<leader>rc', function()
                vim.cmd.RustLsp('openCargo')
            end, opts)

            vim.keymap.set('n', '<leader>rp', function()
                vim.cmd.RustLsp('parentModule')
            end, opts)
        end,

        settings = {
            -- rust-analyzer settings
            ['rust-analyzer'] = {
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    runBuildScripts = true,
                },
                -- Add clippy lints for Rust code analysis
                checkOnSave = {
                    command = 'clippy',
                    extraArgs = { '--all', '--', '-W', 'clippy::all' },
                },
                procMacro = {
                    enable = true,
                    ignored = {
                        ['async-trait'] = { 'async_trait' },
                        ['napi-derive'] = { 'napi' },
                        ['async-recursion'] = { 'async_recursion' },
                    },
                },
                diagnostics = {
                    enable = true,
                    experimental = {
                        enable = true,
                    },
                },
                inlayHints = {
                    maxLength = nil,
                    lifetimeElisionHints = {
                        enable = "skip_trivial",
                        useParameterNames = true,
                    },
                    closureReturnTypeHints = {
                        enable = "always",
                    },
                    parameterHints = {
                        enable = true,
                    },
                    typeHints = {
                        enable = true,
                        hideClosureInitialization = false,
                        hideNamedConstructor = false,
                    },
                    chainingHints = {
                        enable = true,
                    },
                    bindingModeHints = {
                        enable = true,
                    },
                    reborrowHints = {
                        enable = "mutable",
                    },
                },
            },
        },
    },

    -- DAP configuration
    dap = {
        adapter = function()
            local mason_registry = require('mason-registry')
            local codelldb = mason_registry.get_package('codelldb')
            local extension_path = codelldb:get_install_path() .. '/extension/'
            local codelldb_path = extension_path .. 'adapter/codelldb'
            local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

            return require('rustaceanvim.config').get_codelldb_adapter(
                codelldb_path,
                liblldb_path
            )
        end,
    },

    -- Tools configuration
    tools = {
        hover_actions = {
            auto_focus = true,
        },
        inlay_hints = {
            auto = true,
            show_parameter_hints = true,
        },
        executor = require('rustaceanvim.executors').termopen,
    },
    capabilities = capabilities,
}
