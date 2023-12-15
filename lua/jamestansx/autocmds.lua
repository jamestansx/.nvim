local utils = require("jamestansx.utils")
local autocmd = utils.create_autocmd

autocmd({ "TextYankPost" }, {
	desc = "Highlight text on yank",
	group = "HiTextOnYank",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 50,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	desc = "Create missing directories before saving files",
	group = "MkdirOnSave",
	callback = function(ev)
		-- ignore URL pattern
		if not ev.match:match("^%w+://") then
			local file = vim.loop.fs_realpath(ev.match) or ev.match
			vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
		end
	end,
})

autocmd({ "BufReadPost" }, {
	desc = "Restore cursor position",
	group = "RestoreCurPos",
	callback = function(ev)
		local ignore_ft = { "gitcommit", "gitrebase" }
		local ft = vim.bo[ev.buf].ft
		if vim.tbl_contains(ignore_ft, ft) then return end

		local mark = vim.api.nvim_buf_get_mark(0, '"')
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

autocmd({ "BufRead", "FileType" }, {
	desc = "Disable undofile",
	group = "DisableUndofile",
	pattern = {
		-- paths
		"/tmp/*",
		"*.tmp",
		"*.bak",

		-- filetype
		"gitcommit",
		"gitrebase",
	},
	command = [[setlocal noundofile]],
})

autocmd({ "BufRead", "FileType" }, {
	desc = "Do not modify on buffers that shouldn't be edited",
	group = "NoModifiable",
	pattern = {
		-- paths
		"*.orig",
		"*.pacnew",
	},
	command = [[setlocal nomodifiable]],
})

autocmd({ "FileType" }, {
	desc = "Press <q> to close window",
	group = "KeymapQuit",
	pattern = {
		"checkhealth",
		"help",
		"nofile",
		"qf", -- TODO: swtich to bqf.nvim
		"vim",
	},
	callback = function(ev)
		vim.keymap.set("n", "q", "<Cmd>close<Cr>", { silent = true, noremap = true, buffer = ev.buf })
	end,
})
