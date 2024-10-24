return {
    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({})
        end,
        keys = {
            {
                "<leader>f.",
                ":Oil<CR>",
                desc = "open cwd with oil"
            }
        }
    },
    "github/copilot.vim",
    -- TODO add commands (for <space>p) and which key integration
    "tpope/vim-commentary",
    "tpope/vim-abolish",
    "tpope/vim-sleuth",
    {
        "tpope/vim-surround",
        config = function()
            -- use e.g. ysiwe to surround the current word with \emph{} in tex files
            vim.cmd("autocmd FileType tex let b:surround_101 = \"\\\\emph{\\r}\"")
            vim.cmd("autocmd FileType tex let b:surround_116 = \"\\\\tup{\\r}\"")
        end,
    },
    {
        "simnalamburt/vim-mundo",
        keys = {
            {
                "<leader>U",
                ":MundoToggle<CR>",
                desc = "toggle undo tree"
            }
        }
    },
    "wellle/targets.vim",
    {
        "windwp/nvim-autopairs",
        config = function()
            local pairs = require("nvim-autopairs")
            pairs.setup({})

            local Rule = require("nvim-autopairs.rule")

            pairs.add_rule(Rule("\\[", "\\]", "tex"))
            pairs.add_rule(Rule("$", "$", "tex")
                :with_move(function(opts)
                    return opts.next_char == opts.char
                end))
            vim.list_extend(pairs.get_rule("'")[1].not_filetypes, { "coq", "tex" })
            -- get_rule can either return a list of rules or just a rule (wtf)
            pairs.get_rule("`").not_filetypes = { "coq" }
        end,
    },
    "RRethy/vim-illuminate",
    {
        "voldikss/vim-floaterm",
        config = function()
            vim.g.floaterm_position = "top"
            vim.g.floaterm_width = 0.8
            vim.g.floaterm_height = 0.4
            vim.g.floaterm_borderchars = "        "
        end,
        keys = {
            {
                "<C-p>",
                ":FloatermToggle<CR>",
                desc = "toggle term",
            },
            {
                "<leader>P",
                ":FloatermToggle<CR>",
                desc = "toggle term <C-p>",
            },
            {
                "<C-p>",
                "<C-\\><C-n>:FloatermToggle<CR>",
                mode = "t",
                desc = "toggle term",
            },
        },
    },
    {
        "junegunn/fzf.vim",
        dependencies = {
            "junegunn/fzf",
        },
        keys = {
            {
                "<leader>sf",
                ":Ag<CR>",
                "fuzzy search files"
            }
        }
    }
}
