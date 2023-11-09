return {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
                "nvim-telescope/telescope-fzf-native.nvim",
                build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'  },
		},
		cmd = "Telescope",
		lazy = false,
		config = function()
			require("telescope").setup()
			require("telescope").load_extension("fzf")
		end,
		keys = {
			{
				"<leader><space>",
				function()
					require("telescope.builtin").find_files({})
				end,
				desc = "find files",
			},
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files({
						no_ignore = false,
						follow = true,
					})
				end,
				desc = "find",
			},
			{
				"<leader>fr",
				function()
					require("telescope.builtin").oldfiles({})
				end,
				desc = "recent",
			},

			{
				"<leader>sg",
				function()
					require("telescope.builtin").live_grep({})
				end,
				desc = "grep files",
			},
			{
				"<leader>sw",
				function()
					require("telescope.builtin").grep_string({})
				end,
				desc = "grep word under cursor in files",
			},
			{
				"<leader>sc",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find({})
				end,
				desc = "grep current file",
			},

			{
				"<leader>bb",
				function()
					require("telescope.builtin").buffers({})
				end,
				desc = "buffers",
			},
			{
				"<leader>bt",
				function()
					require("telescope.builtin").filetypes({})
				end,
				desc = "filetypes",
			},
			{
				"<leader>c",
				function()
					require("telescope.builtin").commands({})
				end,
				desc = "commands",
			},
			{
				"<leader>l",
				function()
					require("telescope.builtin").colorscheme()
				end,
				desc = "colour scheme",
			},
			{
				"<leader>u",
				function()
					require("telescope.builtin").spell_suggest({})
				end,
				desc = "spell suggest",
			},
			{
				"<leader>t",
				function()
					require("telescope.builtin").builtin({})
				end,
				desc = "telescope builtins",
			},
			{
				"<leader>p",
				function()
					require("telescope.builtin").keymaps({
						filter = function(keymap)
							return keymap.desc and keymap.desc ~= "Nvim builtin"
						end,
					})
				end,
				desc = "command palette",
			},
			{
				"<leader>h",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "help tags",
			},
		},
	},
}
