return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "latex", "rust", "python" },
			})
		end,
	},
}
