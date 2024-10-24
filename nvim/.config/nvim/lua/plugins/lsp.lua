return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lsp = require("lspconfig")

            -- TODO from https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/, check!
            -- LSP Diagnostics Options Setup
            local sign = function(opts)
                vim.fn.sign_define(opts.name, {
                    texthl = opts.name,
                    text = opts.text,
                    numhl = "",
                })
            end

            sign({ name = "DiagnosticSignError", text = "" })
            sign({ name = "DiagnosticSignWarn", text = "" })
            sign({ name = "DiagnosticSignHint", text = "" })
            sign({ name = "DiagnosticSignInfo", text = "" })

            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                update_in_insert = true,
                underline = true,
                severity_sort = false,
                float = {
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })

            vim.cmd([[
                set signcolumn=yes
                autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
            ]])

            lsp.ocamllsp.setup {
                 settings = { codelens = { enable = true } },
            }
            -- lsp.texlab.setup({

            -- })
        end,
    },
    -- {
    -- "jose-elias-alvarez/null-ls.nvim",
    -- }
    -- show LSP status in bottom right corner
    {
        "j-hui/fidget.nvim",
        -- TODO remove when plugin is updated
        branch = "legacy",
            config = function()
                require("fidget").setup()
            end,
    },
}
