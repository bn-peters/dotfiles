return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",
		lazy = false,
		-- config = function()
		-- 	require("nvim-treesitter.configs").setup({
		-- 		ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "toml", "python" },
		-- 		auto_install = true,
		-- 		highlight = {
		-- 			enable = true,
                    -- disable =  { "latex" },
		-- 		},
		-- 		ident = { enable = true },
		-- 	})
		-- end,
	},
}
