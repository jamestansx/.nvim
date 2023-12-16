local utils = require("jamestansx.utils")

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = function(client, _)
                    client.server_capabilities.documentFormattingProvider = false
                end,
            })

            lspconfig.jedi_language_server.setup({
                capabilities = capabilities,
                init_options = {
                    diagnostics = { enable = true },
                    workspace = { environmentPath = utils.get_python_path() },
                },
            })
        end,
    },
    {
        "j-hui/fidget.nvim",
        tags = "v1.0.0",
        event = "LspAttach",
        opts = {
            progress = {
                display = {
                    render_limit = 5,
                    done_ttl = 3,
                    priority = 30,
                },
            },
            notification = {
                override_vim_notify = false, -- TODO: should I replace neovim's notify?
                window = {
                    winblend = 0,
                },
            },
        },
    },
    {
        "akinsho/flutter-tools.nvim",
        event = "BufRead pubspec.yaml",
        ft = { "dart" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            ui = {
                border = "none",
                notification_style = "native",
            },
            fvm = true,
            widget_guide = { enabled = true },
            lsp = {
                color = { enabled = true },
                settings = { showTodos = false },
            },
        },
    },
}
