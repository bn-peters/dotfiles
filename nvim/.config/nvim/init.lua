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
	{ import = "plugins" },

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
vim.opt.spelllang = "en_gb"

vim.opt.title = true


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
-- vim.keymap.set("n", "<tab>", ":bn<CR>", { desc = "next buffer" })
-- vim.keymap.set("n", "<s-tab>", ":bp<CR>", { desc = "previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bp <bar> bd # <CR>", { desc = "delete buffer" })
vim.keymap.set("n", "<leader>fc", ":e ~/.config/nvim/init.lua<CR>", { desc = "open config" })

-- stuff
vim.keymap.set("n", "<CR>", ":noh<CR><CR>", { noremap = true })
vim.keymap.set("n", "<space>L", ":Lazy<CR>", { desc = "open Lazy control panel"})

-- terminal
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { desc = "exit terminal mode" })
vim.keymap.set("t", "<A-left>", "<C-\\><C-N><C-w><left>", { desc = "window left" })
vim.keymap.set("t", "<A-right>", "<C-\\><C-N><C-w><right>", { desc = "window right" })
vim.keymap.set("t", "<A-up>", "<C-\\><C-N><C-w><up>", { desc = "window up" })
vim.keymap.set("t", "<A-down>", "<C-\\><C-N><C-w><down>", { desc = "window down" })

-- window management
vim.keymap.set("n", "<leader>w<left>", "<C-w><left>", { desc = "window left" })
vim.keymap.set("n", "<leader>w<right>", "<C-w><right>", { desc = "window right" })
vim.keymap.set("n", "<leader>w<up>", "<C-w><up>", { desc = "window up" })
vim.keymap.set("n", "<leader>w<down>", "<C-w><down>", { desc = "window down" })
vim.keymap.set("n", "<A-left>", "<C-w><left>", { desc = "window left" })
vim.keymap.set("n", "<A-right>", "<C-w><right>", { desc = "window right" })
vim.keymap.set("n", "<A-up>", "<C-w><up>", { desc = "window up" })
vim.keymap.set("n", "<A-down>", "<C-w><down>", { desc = "window down" })
