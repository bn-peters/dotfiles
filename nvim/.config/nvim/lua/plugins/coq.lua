return {
	{
		"whonore/coqtail",
        branch = "main",
		config = function()
            vim.g.coqtail_noimap = 1
            vim.g.coqtail_map_prefix = "<leader>m"

            vim.list_extend(require("nvim-autopairs").get_rule("'")[1].not_filetypes, { "coq" })
            
            vim.api.nvim_create_autocmd("FileType",
                {
                    pattern = "coq",
                    callback = function()
                        vim.keymap.set("n", "<leader>m.", ":CoqToLine<cr>", { buffer = true, desc = "Coq to line"})

                        vim.keymap.set("n", "<M-down>", ":CoqNext<CR>", { buffer = true, desc = "Coq next"})
                        vim.keymap.set("n", "<M-up>", ":CoqUndo<CR>", { buffer = true, desc = "Coq previous"})
                        vim.keymap.set("n", "<M-right>", ":CoqToLine<cr>", { buffer = true, desc = "Coq to line"})
                        vim.keymap.set("i", "<M-down>", "<c-o>:CoqNext<CR>", { buffer = true, desc = "Coq next"})
                        vim.keymap.set("i", "<M-up>", "<c-o>:CoqUndo<CR>", { buffer = true, desc = "Coq previous"})
                        vim.keymap.set("i", "<M-right>", "<c-o>:CoqToLine<CR>", { buffer = true, desc = "Coq to line"})

                        vim.keymap.set("n", "<leader>mw", function()
                            if vim.b[0].coqtail_panel_bufs == nil then return end

                            local get_window = function(s)
                                local windows = vim.fn.win_findbuf(vim.b[0].coqtail_panel_bufs[s])
                                if #windows == 0 then return end
                                return windows[1]
                            end

                            local goal_window = get_window("goal")
                            local info_window = get_window("info")
                            local main_window = get_window("main")

                            local current = vim.api.nvim_win_get_height(main_window)
                            local goal_current = vim.api.nvim_win_get_height(goal_window)

                            if goal_current < math.floor(current * 0.7) then
                                vim.api.nvim_win_set_height(goal_window, math.floor(current * 0.7))
                            else
                                vim.api.nvim_win_set_height(info_window, math.floor(current * 0.7))
                            end

                            local current_width = vim.api.nvim_win_get_width(main_window)
                            local other_width = vim.api.nvim_win_get_width(goal_window)

                            vim.api.nvim_win_set_width(goal_window, math.min(90, math.floor((current_width + other_width) * 0.5)))
                        end, { buffer = true, desc = "Coq resize panels"})
                    end
                }
            )

            vim.api.nvim_create_autocmd("FileType",
                {
                    pattern = {"coq-goals", "coq-info"},
                    callback = function()
                        vim.keymap.set("n", "<M-down>", ":CoqNext<CR>", { buffer = true, desc = "Coq next"})
                        vim.keymap.set("n", "<M-up>", ":CoqUndo<CR>", { buffer = true, desc = "Coq previous"})
                        vim.keymap.set("i", "<M-down>", "<c-o>:CoqNext<CR>", { buffer = true, desc = "Coq next"})
                        vim.keymap.set("i", "<M-up>", "<c-o>:CoqUndo<CR>", { buffer = true, desc = "Coq previous"})


                        vim.opt.relativenumber = false
                        vim.opt.number = false
                    end
                }
            )
		end,
	},
}


-- augroup CoqtailHighlights
--   autocmd!
--   autocmd ColorScheme dracula
--     \  hi def CoqtailChecked ctermbg=0 guibg=#1D3824
--     \| hi def CoqtailSent    ctermbg=53 guibg=#291616
-- augroup END

