local lazypath = vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- TODO: import plugins directory
}, {
	default = { lazy = true },
	install = { colorscheme = { "lunaperche" } }, -- TODO: change default install colorscheme
	checker = { enabled = false },
	change_detection = { enabled = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"tutor",
				"rplugin",
				"tohtml",
				"gzip",
				"zipPlugin",
				"tarPlugin",
			},
		},
	},
})