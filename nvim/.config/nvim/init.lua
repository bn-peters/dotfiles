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
	{ 
        import = "plugins",
        defaults = {
            lazy = false
        },
    },

	-- { "Valloric/YouCompleteMe", build="./install.py" },
},
{
    change_detection = {
        enabled = false,
    },
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
vim.opt.spelllang = { "en_gb", "de" }

vim.opt.title = true
vim.opt.linebreak = true
vim.opt.wrap = true
vim.opt.smoothscroll = true


vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    callback = function()
        vim.opt.breakindent = true
        vim.opt.linebreak = true
    end
})

-- buffers
vim.keymap.set("n", "<leader>bn", ":bn<CR>", { desc = "next buffer" })
vim.keymap.set("n", "<leader>bp", ":bp<CR>", { desc = "previous buffer" })
vim.keymap.set("n", "<leader>b#", ":b#<CR>", { desc = "previously opened buffer" })
-- vim.keymap.set("n", "<tab>", ":bn<CR>", { desc = "next buffer" })
-- vim.keymap.set("n", "<s-tab>", ":bp<CR>", { desc = "previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bp <bar> bd # <CR>", { desc = "delete buffer" })
-- vim.keymap.set("n", "<leader>fc", ":e ~/.config/nvim/init.lua<CR>", { desc = "open config" })

-- stuff
vim.keymap.set("n", "<CR>", ":noh<CR><CR>", { noremap = true })
vim.keymap.set("n", "<space>L", ":Lazy<CR>", { desc = "open Lazy control panel"})

-- terminal
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { desc = "exit terminal mode" })
-- vim.keymap.set("t", "<A-left>", "<C-\\><C-N><C-w><left>", { desc = "window left" })
-- vim.keymap.set("t", "<A-right>", "<C-\\><C-N><C-w><right>", { desc = "window right" })
-- vim.keymap.set("t", "<A-up>", "<C-\\><C-N><C-w><up>", { desc = "window up" })
-- vim.keymap.set("t", "<A-down>", "<C-\\><C-N><C-w><down>", { desc = "window down" })

-- toggles
vim.keymap.set("n", "<leader>ts", ":set spell!<CR>", { desc = "toggle spellcheck" })
vim.keymap.set("n", "<leader>tr", ":set relativenumber!<CR>", { desc = "toggle relative line numbers" })
vim.keymap.set("n", "<leader>tn", ":set number!<CR>", { desc = "toggle line numbers" })
vim.keymap.set("n", "<leader>tl", ":set cursorline!<CR>", { desc = "toggle cursor line" })
vim.keymap.set("n", "<leader>tc", ":set cursorcolumn!<CR>", { desc = "toggle cursor column" })
vim.keymap.set("n", "<leader>tl", ":set list!<CR>", { desc = "toggle invisible chars" })
vim.keymap.set("n", "<leader>tw", ":set linebreak!<CR>", { desc = "toggle word wrap" })

-- window management
vim.keymap.set("n", "<leader>w<left>", "<C-w><left>", { desc = "window left" })
vim.keymap.set("n", "<leader>w<right>", "<C-w><right>", { desc = "window right" })
vim.keymap.set("n", "<leader>w<up>", "<C-w><up>", { desc = "window up" })
vim.keymap.set("n", "<leader>w<down>", "<C-w><down>", { desc = "window down" })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "window left" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "window down" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "window up" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "window right" })
vim.keymap.set("n", "<leader>w<lt>", "<C-w><lt>", { desc = "window enlarge horizontal" })
vim.keymap.set("n", "<leader>w>", "<C-w>>", { desc = "window shrink horizontal" })
vim.keymap.set("n", "<leader>w-", "<C-w>-", { desc = "window enlarge vertical" })
vim.keymap.set("n", "<leader>w+", "<C-w>+", { desc = "window shrink vertical" })
-- vim.keymap.set("n", "<A-left>", "<C-w><left>", { desc = "window left" })
-- vim.keymap.set("n", "<A-right>", "<C-w><right>", { desc = "window right" })
-- vim.keymap.set("n", "<A-up>", "<C-w><up>", { desc = "window up" })
-- vim.keymap.set("n", "<A-down>", "<C-w><down>", { desc = "window down" })
