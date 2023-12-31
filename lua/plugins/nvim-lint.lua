return {
    "mfussenegger/nvim-lint",
    ft = {
        "python",
    },
    opts = {
        debounce_ms = 300,
        events = {
            "BufWritePost",
            "BufReadPost",
            "TextChanged",
            "InsertLeave",
        },
        linters_by_ft = {
            python = { "ruff" },
        },
    },
    config = function(_, opts)
        local lint = require("lint")
        local function debounce(ms, callback)
            local timer = vim.loop.new_timer()
            return function(...)
                local argv = { ... }
                timer:start(ms, 0, function()
                    timer:stop()
                    vim.schedule_wrap(callback)(unpack(argv))
                end)
            end
        end
        local function try_lint(bufnr)
            if vim.api.nvim_buf_is_valid(bufnr) then
                vim.api.nvim_buf_call(bufnr, function()
                    lint.try_lint()
                end)
            end
        end

        lint.linters_by_ft = opts.linters_by_ft
        require("jamestansx.utils").create_autocmd(opts.events, {
            desc = "Activate linters",
            group = "Lint",
            callback = function(ev)
                debounce(opts.debounce_ms, try_lint)(ev.buf)
            end,
        })
    end,
}
