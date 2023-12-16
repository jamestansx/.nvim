local M = {}

function M.create_autocmd(ev, opts)
    if opts.group and vim.fn.exists("#" .. opts.group) == 0 then
        vim.api.nvim_create_augroup(opts.group, { clear = true })
    end
    vim.api.nvim_create_autocmd(ev, opts)
end

function M.get_python_path()
    local util = require("lspconfig").util

    -- env
    local env = vim.env.VIRTUAL_ENV
    if env then
        return util.path.join(env, "bin", "python")
    end

    -- root pattern of pyvenv.cfg
    local homedir = vim.loop.os_homedir()
    local result = vim.fs.find("pyvenv.cfg", {
        path = util.root_pattern({
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            ".git",
        })(util.path.sanitize(vim.api.nvim_buf_get_name(0), 0)),
        stop = homedir,
        upward = false,
    })[1]
    if result then
        return util.path.join(vim.fs.dirname(result), "bin", "python")
    end

    -- fallback
    return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

return M
