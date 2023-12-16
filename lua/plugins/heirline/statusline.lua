local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local Align, Space, Null, Break, VertSep
do
    Align = { provider = "%=" }
    Space = setmetatable({ provider = " " }, {
        __call = function(_, n)
            return { provider = string.rep(" ", n) }
        end,
    })
    Null = { provider = "" }
    Break = { provider = "%<" }
    VertSep = { provider = "│" }
end

local FileNameBlock, HelpFileNameBlock, QuickFixNameBlock
do
    local FileName = {
        init = function(self)
            self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
            if self.lfilename == "" then
                self.lfilename = self.unnamed
            end
        end,
        hl = function()
            if vim.bo.modified then
                return { fg = utils.get_highlight("Directory").fg, bold = true, italic = true }
            end
            return "Directory"
        end,
        flexible = 1,

        {
            provider = function(self)
                return self.lfilename
            end,
        },
        {
            provider = function(self)
                return vim.fn.pathshorten(self.lfilename, 2)
            end,
        },
        {
            provider = function(self)
                return vim.fn.fnamemodify(self.lfilename, ":t")
            end,
        },
    }

    local FileFlags = {
        update = {
            "BufEnter",
            "OptionSet",
            "BufModifiedSet",
        },
        {
            condition = function()
                return vim.bo.modified
            end,
            provider = function(self)
                return self.modified
            end,
            hl = { fg = "green" },
        },
        {
            condition = function()
                return not vim.bo.modifiable or vim.bo.readonly
            end,
            provider = function(self)
                return self.readonly
            end,
            hl = { fg = "orange" },
        },
    }

    FileNameBlock = {
        static = {
            unnamed = "[No Name]",
            modified = "[+]",
            readonly = "[-]",
        },
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(0)
        end,

        FileName,
        FileFlags,
        Break,
        Space,
    }

    HelpFileNameBlock = {
        condition = function()
            return vim.bo.filetype == "help"
        end,
        provider = function()
            local filename = vim.api.nvim_buf_get_name(0)
            return vim.fn.fnamemodify(filename, ":t")
        end,
        hl = "Directory",
    }

    QuickFixNameBlock = {
        condition = function()
            return vim.bo.buftype == "quickfix"
        end,
        provider = function()
            return vim.w.quickfix_title
        end,
        hl = "Directory",
    }
end

local GitBlock
do
    GitBlock = {
        condition = conditions.is_git_repo,
        hl = { fg = "orange" },

        {
            -- TODO: trigger event on NeogitStatusRefreshed
            update = { "BufEnter" },
            hl = { bold = true },
            provider = function()
                return string.format("%s %s", "", vim.b.gitsigns_head)
            end,
        },
        Space,
    }
end

local DiagnosticsBlock
do
    DiagnosticsBlock = {
        condition = conditions.has_diagnostics,
        static = {
            highlights = {
                "DiagnosticSignError",
                "DiagnosticSignWarn",
                "DiagnosticSignInfo",
                "DiagnosticSignHint",
            },
        },
        init = function(self)
            local diag_counts = { 0, 0, 0, 0 }
            local buf_diag = vim.diagnostic.get(0, {
                severity = { min = vim.diagnostic.severity.HINT },
            })

            for _, d in ipairs(buf_diag) do
                diag_counts[d.severity] = diag_counts[d.severity] + 1
            end

            local children = {}
            for d, count in pairs(diag_counts) do
                if count > 0 then
                    table.insert(children, {
                        provider = string.format("%s%s", vim.fn.sign_getdefined(self.highlights[d])[1].text, count),
                        hl = { fg = utils.get_highlight(self.highlights[d]).fg },
                    })
                end
            end

            for i = 1, #children - 1, 1 do
                table.insert(children[i], { Space })
            end
            self.child = self:new(children, 1)
        end,

        {
            utils.surround({ "![", "]" }, "bright_fg", {
                update = { "DiagnosticChanged", "BufEnter" },
                provider = function(self)
                    return self.child:eval()
                end,
            }),
            Space,
        },
    }
end

local LspActiveBlock
do
    local LspActive = {
        update = { "LspAttach", "LspDetach" },
        provider = function()
            local actives = {}
            local servers = vim.lsp.get_active_clients({ bufnr = 0 })
            for _, server in pairs(servers) do
                table.insert(actives, server.name)
            end
            return string.format("LSP![%s]", table.concat(actives, ","))
        end,
    }

    LspActiveBlock = {
        condition = conditions.lsp_attached,
        hl = { fg = "green" },

        LspActive,
        Space,
    }
end

local FileInfoBlock, FileTypeUCBlock, BufTypeUCBlock
do
    local FileType = {
        update = { "FileType" },
        provider = function()
            return string.lower(vim.bo.filetype)
        end,
    }

    local FileEncoding = {
        provider = function()
            -- :h enc
            local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
            return string.lower(enc)
        end,
    }

    local FileFormat = {
        provider = function()
            return string.lower(vim.bo.fileformat)
        end,
    }

    FileInfoBlock = {
        hl = "Type",
        {
            flexible = 2,
            condition = function()
                return vim.bo.filetype ~= ""
            end,
            { FileType, Space, VertSep, Space },
            { FileType, Space },
            Null,
        },
        {
            flexible = 2,
            { FileEncoding, Space, VertSep, Space },
            Null,
        },
        {
            flexible = 2,
            { FileFormat, Space },
            Null,
        },
    }

    FileTypeUCBlock = {
        provider = function()
            return string.upper(vim.bo.filetype)
        end,
    }
    BufTypeUCBlock = {
        provider = function()
            return string.upper(vim.bo.buftype)
        end,
    }
end

local RulerBlock
do
    RulerBlock = {
        update = { "CursorMoved", "ModeChanged" },
        provider = "%4(%l%):%3c %P",
    }
end

local TerminalNameBlock
do
    TerminalNameBlock = {
        provider = function()
            local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
            return tname
        end,
        hl = "Directory",
    }
end

local DefaultStatusLine, HelpStatusLine, QuickFixStatusLine, TerminalStatusLine, GitStatusLine, UnknownStatusLine
do
    DefaultStatusLine = {
        FileNameBlock,
        { GitBlock, DiagnosticsBlock },
        Align,
        LspActiveBlock,
        Align,
        { FileInfoBlock, RulerBlock },
    }

    UnknownStatusLine = {
        condition = function()
            return conditions.buffer_matches({
                buftype = { "nofile", "prompt" },
            })
        end,

        { BufTypeUCBlock, Align },
    }

    QuickFixStatusLine = {
        condition = function()
            return conditions.buffer_matches({
                buftype = { "quickfix" },
            })
        end,

        { provider = "%q" },
        { Space, QuickFixNameBlock, Align },
    }

    HelpStatusLine = {
        condition = function()
            return conditions.buffer_matches({
                buftype = { "help" },
            })
        end,

        { FileTypeUCBlock, Space, HelpFileNameBlock, Align },
    }

    GitStatusLine = {
        condition = function()
            return conditions.buffer_matches({
                filetype = { "^git.*" },
            })
        end,

        { FileTypeUCBlock, Align },
    }

    TerminalStatusLine = {
        condition = function()
            return conditions.buffer_matches({
                buftype = { "terminal" },
            })
        end,

        { BufTypeUCBlock, Space, TerminalNameBlock, Align },
    }
end

-- TODO: dap componenet
return {
    hl = "StatusLine",
    fallthrough = false,

    UnknownStatusLine,
    HelpStatusLine,
    GitStatusLine,
    QuickFixStatusLine,
    TerminalStatusLine,
    DefaultStatusLine,
}
