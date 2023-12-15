local utils = require("jamestansx.utils")
local autocmd = utils.create_autocmd

vim.opt.number = true
vim.opt.relativenumber = true

-- XXX: remove termguicolors once https://github.com/neovim/neovim/pull/26407 has landed
vim.opt.termguicolors = true
vim.opt.cmdheight = 2
vim.opt.pumblend = 10
vim.opt.winblend = 10

-- declutter UI
vim.opt.pumheight = 5
vim.opt.laststatus = 3
vim.opt.synmaxcol = 500 -- performance
vim.opt.showmode = false
vim.opt.hlsearch = false
vim.opt.shortmess:append({
	I = true, -- intro screen
	C = true, -- ins-completion "scanning tags"
	c = true, -- ins-completion message
})

vim.opt.title = true
vim.opt.titlestring = "%f%( [%M%R%H%W]%)%( -%a%)%<"

-- TODO: set a fixed signcolumn
vim.opt.signcolumn = "yes"

vim.opt.redrawtime = 1000
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 10

vim.opt.confirm = true
vim.opt.virtualedit = { "block" }
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"

vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.spelloptions = { "camel" }
vim.opt.spellsuggest = { "best,5" }

vim.opt.wildignorecase = true
vim.opt.wildignore:append({ "*/.git/*", "*/.hg/*", "*/.svn/*" }) -- vcs
vim.opt.wildignore:append({ "*.swp", "*.lock", "*.cache" }) -- caches
vim.opt.wildignore:append({ "*.pyc", "*.pycache", "**/__pycache__/**" }) -- python
vim.opt.wildignore:append({ "**/node_modules/**" }) -- javascript
vim.opt.wildignore:append({ "*.o", "*.out", "*.obj", "*~" }) -- compiled files
vim.opt.wildignore:append({ "*.bmp", "*.gif", "*.ico", "*.png", "*.jpg", "*.jpeg", "*.webp" }) -- pictures
vim.opt.wildignore:append({ "*.mkv", "*.mov", "*.mp4", "*.webm", "*.webp" }) -- videos
vim.opt.wildignore:append({ "*.mp3", "*.wav" }) -- musics
vim.opt.wildignore:append({ "*.doc", "*.docx", "*.pdf", "*.pptx", "*.ppt", "*.xlsx" }) -- documents
vim.opt.wildignore:append({ "*.zip", "*.gz", "*.bz2" }) -- zip
vim.opt.wildignore:append({ "*.otf", "*.ttf", "*.woff" }) -- fonts
vim.opt.wildignore:append({ "*.dll", "*.so" }) -- libraries

vim.opt.undofile = true
vim.opt.exrc = true
vim.opt.modelines = 1

-- proper search
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 2

-- indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftround = true

vim.opt.list = true
vim.opt.listchars = {
	trail = "·",
	tab = "  ⇥",
	nbsp = "␣",
	extends = "→",
	precedes = "←",
}
vim.opt.fillchars = {
	fold = " ",
	foldopen = "▽",
	foldsep = " ",
	foldclose = "▷",
}

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.breakindentopt = { "sbr" }
vim.opt.showbreak = "↪"
vim.opt.linebreak = true

vim.opt.diffopt:append({
	"iwhite",
	"algorithm:histogram",
	"indent-heuristic",
})
vim.opt.jumpoptions = { "stack", "view" }

if vim.fn.executable("rg") == 1 then
	vim.opt.grepprg = "rg --no-heading --smart-case --vimgrep"
	vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

autocmd({ "BufEnter" }, {
	desc = "Set default formatoptions",
	group = "DefaultFormatoptions",
	callback = function()
		vim.opt_local.formatoptions = {
			t = true, -- wrap text with `textwidth`
			c = true, -- wrap comment with `textwidth`
			q = true, -- enable comment formatting with key <gq>
			r = true, -- continue comment on <Enter> in insert mode
			n = true, -- detect list on formatting
			j = true, -- remove comment leader when joining lines
			b = true, -- auto wrap in insert mode, ignore old lines
		}
	end,
})

vim.diagnostic.config({
	virtual_text = { source = "if_many" },
	severity_sort = true,
	update_in_insert = true,
})
vim.fn.sign_define("DiagnosticSignError", { text = "E", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "W", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "I", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "H", texthl = "DiagnosticSignHint" })
