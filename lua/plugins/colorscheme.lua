return {
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        init = function()
            vim.cmd.colorscheme("kanagawa")
        end,
        opts = {
            compile = true,
            transparent = true,
            theme = "wave",
            background = {
                dark = "wave",
                light = "lotus",
            },
            overrides = function(C)
                local T = C.theme
                return {
                    -- ref: https://github.com/rebelot/kanagawa.nvim#dark-completion-popup-menu
                    Pmenu = { fg = T.ui.shade0, bg = T.ui.bg_p1 },
                    PmenuSel = { fg = "NONE", bg = T.ui.bg_p2 },
                    PmenuSbar = { bg = T.ui.bg_m1 },
                    PmenuThumb = { bg = T.ui.bg_p2 },
                    ["@lsp.type.comment.lua"] = {}, -- it overrides original highlight which makes comment ugly
                }
            end,
        },
    },
}
