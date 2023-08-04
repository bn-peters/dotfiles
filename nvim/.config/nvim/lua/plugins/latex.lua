return {
	{
		"lervag/vimtex",
		config = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_mappings_prefix = "<leader>m"
            vim.g.vimtex_compiler_latexmk_engines = { _ = "-lualatex" }
            vim.g.vimtex_quickfix_ignore_filters = { "Marginpar on page" };
		end,
	},
}
