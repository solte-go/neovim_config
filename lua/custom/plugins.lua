local cmp = require "cmp"

local plugins = {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "rust-analyzer",
                "gopls",
            },
        },
    },
    -- golang plugins
    {
        "jose-elias-alvarez/null-ls.nvim",
        ft = "go",
        opts = function()
            return require "custom.configs.null-ls"
        end,
    },
    {
        "dreamsofcode-io/nvim-dap-go",
        ft = "go",
        dependencies = "mfussenegger/nvim-dap",
        config = function(_, opts)
            require("dap-go").setup(opts)
            -- require("core.utils").load_mappings("dap_go")
        end
    },
    {
        "olexsmir/gopher.nvim",
        ft = "go",
        config = function(_, opts)
            require("gopher").setup(opts)
            require("core.utils").load_mappings("gopher")
        end,
        build = function()
            vim.cmd [[silent! GoInstallDeps]]
        end,
    },
    -- general configurations
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
        end,
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^5',
        ft = { 'rust' },
        config = function()
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    vim.api.nvim_set_hl(0, "@lsp.type.inlayHint", {
                        fg = "#7a8478",
                        bg = "NONE",
                        italic = true
                    })

                    vim.api.nvim_set_hl(0, "@comment.note", {
                        fg = "#7a8478",
                        bg = "NONE",
                        italic = true
                    })

                    vim.api.nvim_set_hl(0, "@lsp.type.inlayHint.parameter", {
                        fg = "#98C379",
                        bg = "NONE",
                        italic = true
                    })

                    vim.api.nvim_set_hl(0, "@lsp.type.inlayHint.type", {
                        fg = "#4FC3F7",
                        bg = "NONE",
                        italic = true
                    })
                end,
            })


            vim.g.rustaceanvim = {
                server = {
                    on_attach = function(client, bufnr)
                        -- Enable completion triggered by <c-x><c-o>
                        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

                        -- Enable inlay hints
                        if client.server_capabilities.inlayHintProvider then
                            -- vim.lsp.inlay_hint.enable(bufnr, { 0 })
                            vim.lsp.inlay_hint.enable(true, { 0 })
                        end

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

                        vim.keymap.set("n", '<leader>hi', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
                        end, opts)
                    end,

                    settings = {
                        ['rust-analyzer'] = {
                            diagnostics = {
                                enable = true,
                            },
                            inlayHints = {
                                enable = true,
                                showParameterNames = true,
                                parameterHintsPrefix = "<- ",
                                otherHintsPrefix = "=> ",
                                maxLength = 25,
                                lifetimeElisionHints = {
                                    enable = true,
                                    useParameterNames = true,
                                },
                                typeHints = {
                                    enable = true,
                                    hideClosureInitialization = false,
                                    hideNamedConstructor = false,
                                },
                                chainingHints = {
                                    enable = true,
                                },
                                closureReturnTypeHints = {
                                    enable = true, -- Changed from "always" to true
                                },
                                parameterHints = {
                                    enable = true,
                                },
                                reborrowHints = {
                                    enable = true, -- Changed from "always" to true
                                },
                            },
                            checkOnSave = {
                                command = "clippy",
                            },
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                runBuildScripts = true,
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
            }

            -- Rest of your configuration remains the same
        end,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'mfussenegger/nvim-dap',
            'williamboman/mason.nvim',
        },
    },
    {
        'mfussenegger/nvim-dap',
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },
    {
        'saecki/crates.nvim',
        ft = { "toml" },
        config = function(_, opts)
            local crates = require('crates')
            crates.setup(opts)
            require('cmp').setup.buffer({
                sources = { { name = "crates" } }
            })
            crates.show()
            require("core.utils").load_mappings("crates")
        end,
    },
    {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end
    },
    -- {
    --     "theHamsta/nvim-dap-virtual-text",
    --     lazy = false,
    --     config = function(_, opts)
    --         require("nvim-dap-virtual-text").setup()
    --     end
    -- },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            require("dapui").setup()
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        opts = function()
            local M = require "plugins.configs.cmp"
            M.completion.completeopt = "menu,menuone,noselect"
            M.mapping["<CR>"] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = false,
            }
            table.insert(M.sources, { name = "crates" })
            return M
        end,
    },
    -- markdown config
    {
        "toppair/peek.nvim",
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup({
                auto_load = true,        -- whether to automatically load preview when
                -- entering another markdown buffer
                close_on_bdelete = true, -- close preview window on buffer delete

                syntax = true,           -- enable syntax highlighting, affects performance

                theme = 'dark',          -- 'dark' or 'light'

                update_on_change = true,

                app = 'browser', -- 'webview', 'browser', string or a table of strings
                -- explained below

                filetype = { 'markdown' }, -- list of filetypes to recognize as markdown

                -- relevant if update_on_change is true
                throttle_at = 200000,   -- start throttling when file exceeds this
                -- amount of bytes in size
                throttle_time = 'auto', -- minimum amount of time in milliseconds
                -- that has to pass before starting new render
            })
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },
}

return plugins
