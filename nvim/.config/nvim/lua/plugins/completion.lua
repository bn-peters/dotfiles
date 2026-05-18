return {
    -- TODO move snippets
    {
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip.loaders.from_snipmate").lazy_load()
        end
    },
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-omni",
			-- TODO setup snippets
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = {
					["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						elseif luasnip.expandable() then
							luasnip.expand()
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				sources = cmp.config.sources({
					{ name = "omni" },
					{ name = "path" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lua" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})

			-- vim.opt.completeopt = {"menuone", "noselect", "noinsert"}
			vim.opt.completeopt = { "menuone", "noselect" }
			-- time until completion menu is offered
			vim.opt.updatetime = 300

			-- -- Set configuration for specific filetype.
			-- cmp.setup.filetype("gitcommit", {
			-- 	sources = cmp.config.sources({
			-- 		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
			-- 	}, {
			-- 		{ name = "buffer" },
			-- 	}),
			-- })

			-- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			-- cmp.setup.cmdline({ "/", "?" }, {
			-- 	mapping = cmp.mapping.preset.cmdline(),
			-- 	sources = {
			-- 		{ name = "buffer" },
			-- 	},
			-- })

			-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			-- cmp.setup.cmdline(":", {
			-- 	mapping = cmp.mapping.preset.cmdline(),
			-- 	sources = cmp.config.sources({
			-- 		{ name = "path" },
			-- 	}, {
			-- 		{ name = "cmdline" },
			-- 	}),
			-- })

		end,
		},
	}
