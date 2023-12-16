return {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({
                    async = false,
                    lsp_fallback = true,
                })
            end,
            mode = { "n", "v" },
        },
    },
    init = function()
        vim.opt.formatexpr = [[v:lua.require("conform").formatexpr()]]
    end,
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            ["_"] = { "trim_whitespace" },
        },
        log_level = vim.log.levels.ERROR,
    },
}
