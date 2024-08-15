return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "toml", "python" },
				auto_install = true,
				highlight = {
					enable = true,
                    disable =  { "latex" },
				},
				ident = { enable = true },
			})
		end,
	},
}
