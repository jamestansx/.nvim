return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        event = "BufReadPost",
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        opts = {
            ensure_installed = {
                "lua",
                "dart",
                "comment",
                "markdown",
                "markdown_inline",
                "vimdoc",
            },
            highlight = {
                enable = true,
                additional_vim_regex_hightlighting = false,
            },
            indent = {
                enable = true,
                disable = {
                    "dart", -- indentation cause dart file runs very slow
                },
            },
            incremental_selection = { enable = false },
        },
        config = function(_, opts)
            require("nvim-treesitter.install").prefer_git = true
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
