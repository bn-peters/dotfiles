return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			-- TODO check these, from blogpost
			-- TODO ensure I understand installation
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "latex", "rust", "toml", "python" },
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
