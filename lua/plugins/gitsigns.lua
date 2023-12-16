local function on_attach(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
    end

	-- stylua: ignore start
	--diff navigation
	map("n", "]c", function()
		if vim.wo.diff then return "]c" end
		vim.schedule(function() gs.next_hunk() end)
		return "<Ignore>"
	end, { expr = true })
	map("n", "[c", function()
		if vim.wo.diff then return "[c" end
		vim.schedule(function() gs.prev_hunk() end)
		return "<Ignore>"
	end, { expr = true })
    -- TODO: line blame
    -- stylua: ignore end
end

return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add = { text = "│" },
            change = { text = "│" },
        },
        current_line_blame_opts = {
            delay = 500,
        },
        preview_config = {
            border = "none",
        },
        on_attach = on_attach,
        attach_to_untracked = false,
    },
}
