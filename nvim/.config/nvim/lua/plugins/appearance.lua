vim.opt.termguicolors = true
vim.opt.list = false
vim.opt.listchars = {
    space = "·",
    tab = "> ",
    extends = ">",
    precedes = "<",
}


return {
    {
        "folke/noice.nvim",
        opts = {
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false, -- add a border to hover docs and signature help
              },
        },
    },
    {
        "echasnovski/mini.indentscope", 
        opts = {},
        config = function(_, opts)
            require("mini.indentscope").setup(opts)
            vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { link = 'NonText' })
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin-frappe")
        end,
    },
    "joshdick/onedark.vim",
    "arcticicestudio/nord-vim",
    "cocopon/iceberg.vim",
    "altercation/vim-colors-solarized",
    "tomasr/molokai",
    "therubymug/vim-pyte",
    "preservim/vim-colors-pencil",
    "dracula/vim",
    "folke/tokyonight.nvim",

    {
        "nvim-tree/nvim-web-devicons",
        priority = 100,
        config = function(_, opts)
            require("nvim-web-devicons").setup(opts)
        end,

        opts = {
            override = {
                -- TODO move this to the Coq plugin config, there are function calls to do this
                v = {
                    icon = "🐓",
                    color = "#019833",
                    cterm_color = "28",
                    name = "Coq",
                },
            },
        },
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "catppuccin",
                    component_separators = { left = "|", right = "|" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff" },
                    lualine_c = { "filename", "diagnostics" },

                    lualine_x = { "searchcount", "selectioncount", "filesize" },
                    lualine_y = { "filetype", "encoding", "fileformat" },
                    lualine_z = { "location", "progress" },
                },
                -- TODO set up winbar?
            })
        end,
    },
    {
        "akinsho/bufferline.nvim",
        -- TODO remove once #895 is fixed
        -- tag = "v4.5.2",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("bufferline").setup({
                options = {
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            text_align = "left",
                            separator = true
                        }
                    },
                },
            })
        end,
    },
    -- TODO barbecue winbar https://github.com/utilyre/barbecue.nvim
    -- shows breadcrumbs for context
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("barbecue").setup()
            require("barbecue.ui").toggle(true)
        end,
    },
}
