return {

	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup()
		end,
        keys = {
			{
				"<leader>ft",
                function()
                    require("nvim-tree.api").tree.toggle({ focus = false})
                end,
				desc = "toggle tree view",
			},
			{
				"<leader>fT",
                ":NvimTreeFindFile<CR>",
				desc = "find current file in tree",
			},
        }
            
	},
}
