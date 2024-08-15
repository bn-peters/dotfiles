return {
    {
        "folke/which-key.nvim",
        priority = 999,
        lazy = false,
        dependencies = {
            "echasnovski/mini.icons",
        },
        config = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 200
            local wk = require("which-key")
            wk.add({
                { "<leader>b", group = "+buffer" },
                { "<leader>s", group = "+search" },
                { "<leader>f", group = "+files" },
                { "<leader>m", group = "+mode" },
                { "<leader>w", group = "+window" },
                { "<leader>t", group = "+toggles" },
            })
        end,
        keys = {
            { "<C-g>", ":WhichKey<CR>", desc = "trigger which key" },
        },
    },
}
