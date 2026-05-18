return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
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

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if ok then
                capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
            end

            vim.lsp.config("ocamllsp", {
                capabilities = capabilities,
                settings = { codelens = { enable = true } },
            })
            vim.lsp.enable("ocamllsp")

            vim.lsp.config("coq_lsp", {
                capabilities = capabilities,
                cmd = { "coq-lsp" },
            })
            vim.lsp.enable("coq_lsp")
        end,
    },
    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup()
        end,
    },
}
