-- Bootstrap package manager lazy.vim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)



vim.g.mapleader = " "


require("lazy").setup({
    --{"junegunn/fzf", build=function()
    --    vim.fn["fzf#install"]()
    --    --{ 'do': { -> fzf#install() } }
    --end},
	--"junegunn/fzf.vim",
    { "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    { "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
    {
        -- "nvim-telescope/telescope.nvim",
        "bn-peters/telescope.nvim",
        branch = "keymap-filter",
        dependencies = { 
            "nvim-lua/plenary.nvim", 
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        lazy = false,
        config = function()
            require("telescope").load_extension("fzf")
        end,
        opts = {
        },
        keys = {
            { "<leader><space>", function()
                    require("telescope.builtin").find_files({})
                end, desc = "find files" },
            { "<leader>ff", function()
                    require("telescope.builtin").find_files({})
                end, desc = "find" },
            { "<leader>fr", function()
                    require("telescope.builtin").oldfiles({})
                end, desc = "recent" },

            { "<leader>sg", function()
                    require("telescope.builtin").grep_string({})
                end, desc = "grep files" },
            { "<leader>sc", function()
                    require("telescope.builtin").current_buffer_fuzzy_find({})
                end, desc = "grep current" },

            { "<leader>bb", function()
                    require("telescope.builtin").buffers({})
                end, desc = "buffers" },
            { "<leader>bt", function()
                    require("telescope.builtin").filetypes({})
                end, desc = "filetypes" },
            -- TODO move
            { "<leader>c", function()
                    require("telescope.builtin").commands({})
                end, desc = "commands" },
            -- TODO move 
            { "<leader>l", function()
                    require("telescope.builtin").colorscheme({})
                end, desc = "commands" },
            -- TODO move
            { "<leader>u", function()
                    require("telescope.builtin").spell_suggest({})
                end, desc = "spell suggest" },
            -- TODO move
            { "<leader>t", function()
                    require("telescope.builtin").builtin({})
                end, desc = "telescope" },
            -- TODO move
            { "<leader>k", function()
                    require("telescope.builtin").keymaps({ 
                        filter = function(keymap)
                            return keymap.desc and keymap.desc ~= "Nvim builtin"
                        end,
                    })
                end, desc = "telescope" },
        },
    },


    -- color schemes
    {"joshdick/onedark.vim", priority = 1000},
    {"arcticicestudio/nord-vim", priority = 1000},
    {"cocopon/iceberg.vim", priority = 1000},
    {"altercation/vim-colors-solarized", priority = 1000},
    {"tomasr/molokai", priority = 1000},
    {"therubymug/vim-pyte", priority = 1000},
    {"preservim/vim-colors-pencil", priority = 1000},
    {"dracula/vim", priority = 1000},

    {"itchyny/lightline.vim",
        config = function() 
            vim.g.lightline = {
                colorscheme = "dracula",
                active = {
                    left = { { "mode", "paste" },
                        { "gitbranch" },
                        { "readonly", "filename", "modified" } },
                    },
                component_function = {
                    gitbranch = "FugitiveHead",
                },
            }
        end},
    -- "ap/vim-buftabline",
    "akinsho/bufferline.nvim",
    "ryanoasis/vim-devicons",

    {"airblade/vim-gitgutter",
        config = function()
            vim.opt.updatetime = 100
        end,
    },
    "tpope/vim-fugitive",

    "tpope/vim-commentary",

    -- { "Valloric/YouCompleteMe", build="./install.py" },

    -- TODO fix completion bug with snippets beginning with \
    -- TODO adding this breaks <tab> everywhere... inserts <t_ü>
    -- {"SirVer/ultisnips",
    --     config = function()
    --         vim.g.UltiSnipsExpandTrigger = "<c-space>"
    --         vim.g.UltiSnipsJumpForwardTrigger ="<c-space>"
    --         vim.g.UltiSnipsJumpBackwardTrigger ="<c-s-space>"
    --     end,
    -- },
    


    "simnalamburt/vim-mundo",
    "wellle/targets.vim",
    "tpope/vim-abolish",
    "tpope/vim-surround",

    {"whonore/coqtail",
        config = function()
            -- function Coq_do_windows()
            --     let width = winwidth(0)
            --     if &columns - 110 > 110
            --         execute "vert res " . (&columns-110)
            --     else
            --         execute "vert res " . (&columns/2)
            --     endif
            -- endfunction

            -- nmap <leader>c. <leader>cl
            -- nmap <M-down> <leader>cj
            -- nmap <M-up> <leader>ck
            -- nmap <M-right> <leader>cl
            -- nmap <leader>cw :call Coq_do_windows()<CR>
            -- imap <M-down> <c-o><leader>cj
            -- imap <M-up> <c-o><leader>ck
            -- imap <M-right> <c-o><leader>cl


            -- let g:coqtail_noimap=1
        end,
    },

    {"lervag/vimtex",
        config = function()
            vim.g.vimtex_view_method = 'zathura'
            vim.g.vimtex_mappings_prefix = "<leader>m"
        end,
    },

    {"folke/which-key.nvim", 
        priority = 999,
        lazy = false,
        config = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 200
            local wk = require("which-key")
            wk.register({
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>f"] = { name = "+files" },
                ["<leader>m"] = { name = "+mode" },
            })
        end,
        keys = {
            { "<C-g>", ":WhichKey<CR>", desc = "trigger which key" },
        },
    },


    "stevearc/dressing.nvim",
        
})



vim.opt.mouse = "a"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.scrolloff = 5

vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99

vim.opt.clipboard = "unnamedplus"

vim.opt.undofile = true

vim.opt.spell = true
vim.opt.spelllang = "en_gb"

vim.opt.title = true


vim.cmd [[ colorscheme dracula ]]
vim.opt.termguicolors = true


-- augroup CoqtailHighlights
--   autocmd!
--   autocmd ColorScheme dracula
--     \  hi def CoqtailChecked ctermbg=0 guibg=#1D3824
--     \| hi def CoqtailSent    ctermbg=53 guibg=#291616
-- augroup END


vim.keymap.set("n", "<leader>bn", ":bn<CR>", { desc = "next buffer" })
vim.keymap.set("n", "<leader>bp", ":bp<CR>", { desc = "previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bp <bar> bd # <CR>", { desc = "delete buffer" })

vim.keymap.set("n", "<CR>", ":noh<CR><CR>", {noremap = true})


-- nnoremap <leader>wh <c-w>h
-- nnoremap <leader>wj <c-w>j
-- nnoremap <leader>wk <c-w>k
-- nnoremap <leader>wl <c-w>l
-- nnoremap <leader>w<Left> <c-w><Left>
-- nnoremap <leader>w<Right> <c-w><Right>
-- nnoremap <leader>w<Up> <c-w><Up>
-- nnoremap <leader>w<Down> <c-w><Down>
