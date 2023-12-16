local M = {}

function M.on_attach(bufnr)
    local function map(mode, lhs, rhs, opts)
        opts = vim.tbl_extend("force", {
            noremap = true,
            silent = true,
        }, opts or {})
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
    end

	-- stylua: ignore start
	-- TODO: document symbol
	--goto
	map("n", "gd", vim.lsp.buf.definition)
	map("n", "gr", vim.lsp.buf.references)
	map("n", "gi", vim.lsp.buf.implementation)
	map("n", "gD", vim.lsp.buf.type_definition)

	-- help
	map("n", "K", vim.lsp.buf.hover)
	map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help)

	--actions
	map("n", "<leader>a", vim.lsp.buf.code_action)
	map("n", "<leader>r", vim.lsp.buf.rename)
    -- stylua: ignore end
end

return M
