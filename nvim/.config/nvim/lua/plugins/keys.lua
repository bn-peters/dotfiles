return {
	{
		"folke/which-key.nvim",
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
}
