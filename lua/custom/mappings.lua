local M = {}

M.dap = {
    plugin = true,
    n = {
        -- ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>" },
        ["<Leader>db"] = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Debugger toggle breakpoint" },
        ["<Leader>dd"] = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", "Debugger set conditional breakpoint" },
        ["<Leader>dl"] = { "<cmd>lua require'dap'.step_into()<CR>", "Debugger step into" },
        ["<Leader>dj"] = { "<cmd>lua require'dap'.step_over()<CR>", "Debugger step over" },
        ["<Leader>dk"] = { "<cmd>lua require'dap'.step_out()<CR>", "Debugger step out" },
        ["<Leader>dc"] = { "<cmd>lua require'dap'.continue()<CR>", "Debugger continue" },
        ["<Leader>de"] = { "<cmd>lua require'dap'.terminate())<CR>", "Debugger reset" },
        ["<Leader>dr"] = { "<cmd>lua require'dap'.run_last()<CR>", "Debugger run last" },
    }
}

M.crates = {
    plugin = true,
    n = {
        ["<leader>rcu"] = {
            function()
                require('crates').upgrade_all_crates()
            end,
            "update crates"
        }
    }
}

return M
