local M = {}

local function remove_docs(docs)
    if docs then
        for i = 1, #docs.signatures do
            if docs.signatures[i] and docs.signatures[i].documentation then
                if docs.signatures[i].documentation.value then
                    docs.signatures[i].documentation.value = nil
                else
                    docs.signatures[i].documentation = nil
                end
            end
        end
    end
    return docs
end

function M.signature_help(_, result, ctx, config)
    return vim.lsp.handlers.signature_help(_, remove_docs(result), ctx, config)
end

function M.on_attach()
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(M.signature_help, {
        anchor_bias = "above", -- XXX: wait for https://github.com/neovim/neovim/pull/24494 to be merged
    })

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = true,
        severity_sort = true,
        virtual_text = { source = "if_many" },
    })
end

return M
