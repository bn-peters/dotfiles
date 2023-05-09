vim.opt.termguicolors = true

return {
	-- TODO configure
	-- TODO change cursor color in light mode
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	"joshdick/onedark.vim",
	"arcticicestudio/nord-vim",
	"cocopon/iceberg.vim",
	"altercation/vim-colors-solarized",
	"tomasr/molokai",
	"therubymug/vim-pyte",
	"preservim/vim-colors-pencil",
	"dracula/vim",
	"folke/tokyonight.nvim",

	{
		"nvim-tree/nvim-web-devicons",
		priority = 100,
		config = function(_, opts)
			require("nvim-web-devicons").setup(opts)
		end,

		opts = {
			override = {
				-- TODO move this to the Coq plugin config, there are function calls to do this
				v = {
					icon = "🐓",
					color = "#019833",
					cterm_color = "28",
					name = "Coq",
				},
			},
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lualine").setup({
				options = {
					theme = "catppuccin",
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff" },
					lualine_c = { "filename", "diagnostics" },

					lualine_x = { "searchcount", "selectioncount", "filesize" },
					lualine_y = { "filetype", "encoding", "fileformat" },
					lualine_z = { "location", "progress" },
				},
				-- TODO set up winbar?
			})
		end,
	},
	-- TODO configure
	-- TODO evaluate bufferline vs cokeline
	{
		"akinsho/bufferline.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("bufferline").setup({
				options = {
					offsets = {
						{
							filetype = "NvimTree",
							text = "Nvim Tree",
							highlight = "Directory",
							separator = false, -- use a "true" to enable the default, or set your own character
						},
					},
				},
			})
		end,
	},
	-- TODO barbecue winbar https://github.com/utilyre/barbecue.nvim
	-- shows breadcrumbs for context
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("barbecue").setup()
			require("barbecue.ui").toggle(true)
		end,
	},
}
