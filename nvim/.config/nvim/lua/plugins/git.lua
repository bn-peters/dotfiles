return {
    {
        "neogitorg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            {
                "<leader>gg",
                ":Neogit<CR>",
                desc = "open git",
            },
        }
    },
    -- "tpope/vim-fugitive",
    -- {
    --     "airblade/vim-gitgutter",
    --     config = function()
    --         vim.opt.updatetime = 100
    --         vim.g.gitgutter_map_keys = false
    --     end,
    -- },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
        lazy = false,
        keys = {
            {
                "<leader>gb",
                ":Gitsigns blame<CR>",
                desc = "blame",
            },
            {
                "<leader>gw",
                ":Gitsigns toggle_word_diff<CR>",
                desc = "toggle word diff",
            }
        }
    },
}
