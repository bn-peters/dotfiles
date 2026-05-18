return {
    {
        "whonore/coqtail",
        branch = "main",
        dependencies = {
            "L3MON4D3/LuaSnip",
        },
        config = function()
            vim.g.coqtail_noimap = 1
            vim.g.coqtail_map_prefix = "<leader>m"

            -- Coqtail restores 'joinspaces' on BufLeave by unletting
            -- b:_coqtail_save_js, but nvim-tree preview can enter the Coq
            -- buffer with BufEnter ignored. Seed the value before Coqtail's
            -- own BufLeave autocmd runs so that unlet does not fail.
            vim.api.nvim_create_autocmd("BufLeave", {
                group = vim.api.nvim_create_augroup("CoqtailJoinspacesGuard", { clear = true }),
                pattern = "*",
                callback = function(args)
                    if vim.bo[args.buf].filetype ~= "coq" then return end
                    if vim.b[args.buf]._coqtail_save_js ~= nil then return end

                    vim.b[args.buf]._coqtail_save_js = vim.o.joinspaces
                end,
            })

            local get_coqtail_window = function(s)
                local windows = vim.fn.win_findbuf(vim.b.coqtail_panel_bufs[s])
                if #windows == 0 then return end
                return windows[1]
            end
            local set_printing_width_automatically = function ()
                if vim.b[0].coqtail_panel_bufs == nil then return end
                local goal_window = get_coqtail_window("goal")
                local width = vim.api.nvim_win_get_width(goal_window)

                vim.cmd(":Coq Set Printing Width " .. (width - 5))
            end
            
            vim.api.nvim_create_autocmd("FileType",
                {
                    pattern = "coq",
                    callback = function()
                        vim.opt_local.colorcolumn = "100"
                        vim.opt_local.spell = false

                        vim.keymap.set("n", "<leader>m.", ":CoqToLine<cr>", { buffer = true, desc = "Coq to line"})

                        set_printing_width_automatically()
                        vim.cmd(":Coq Set Printing Width 100 ")
                        vim.keymap.set("n", "<M-down>", function()
                            -- TODO remove this once https://github.com/whonore/Coqtail/issues/345 has been fixed
                            vim.cmd(":CoqNext")
                        end, { buffer = true, desc = "Coq next"})
                        vim.keymap.set("n", "<M-up>", ":CoqUndo<CR>", { buffer = true, desc = "Coq previous"})
                        vim.keymap.set("n", "<M-right>", ":CoqToLine<cr>", { buffer = true, desc = "Coq to line"})
                        vim.keymap.set("i", "<M-down>", "<c-o>:CoqNext<CR>", { buffer = true, desc = "Coq next"})
                        vim.keymap.set("i", "<M-up>", "<c-o>:CoqUndo<CR>", { buffer = true, desc = "Coq previous"})
                        vim.keymap.set("i", "<M-right>", "<c-o>:CoqToLine<CR>", { buffer = true, desc = "Coq to line"})
                        vim.keymap.set("n", "<leader>mt", function()
                            vim.cmd("CoqJumpToEnd")
                            vim.cmd("CoqToTop")
                            vim.cmd("CoqToLine")
                        end, { buffer = true, desc = "Coq restart to line"})
                        vim.keymap.set("n", "<leader>me", ":CoqJumpToError<CR>", { buffer = true, desc = "Coq jump to error"})
                        vim.keymap.set("n", "<leader>mF", function()
                            vim.cmd("$")
                            vim.cmd("CoqToLine")
                            -- This call blocks while CoqToLine is running :/
                            vim.cmd("CoqJumpToError")
                        end, { buffer = true, desc = "Coq execute until error"})

                        vim.keymap.set("n", "<leader>mw", function()
                            if vim.b.coqtail_panel_bufs == nil then return end

                            local goal_window = get_coqtail_window("goal")
                            local info_window = get_coqtail_window("info")
                            local main_window = get_coqtail_window("main")

                            if goal_window == nil or info_window == nil or main_window == nil then
                                return
                            end

                            local current = vim.api.nvim_win_get_height(main_window)
                            local goal_current = vim.api.nvim_win_get_height(goal_window)

                            if goal_current < math.floor(current * 0.7) then
                                vim.api.nvim_win_set_height(goal_window, math.floor(current * 0.7))
                            else
                                vim.api.nvim_win_set_height(info_window, math.floor(current * 0.7))
                            end

                            local current_width = vim.api.nvim_win_get_width(main_window)
                            local other_width = vim.api.nvim_win_get_width(goal_window)

                            -- vim.api.nvim_win_set_width(main_window, math.max(107, math.floor((current_width + other_width) * 0.5)))
                            vim.api.nvim_win_set_width(main_window, 107)
                        end, { buffer = true, desc = "Coq resize panels"})
                    end
                }
            )

            vim.api.nvim_create_autocmd("FileType",
                {
                    pattern = {"coq-goals", "coq-infos"},
                    callback = function()
                        vim.keymap.set("n", "<M-down>", ":CoqNext<CR>", { buffer = true, desc = "Coq next"})
                        vim.keymap.set("n", "<M-up>", ":CoqUndo<CR>", { buffer = true, desc = "Coq previous"})
                        vim.keymap.set("i", "<M-down>", "<c-o>:CoqNext<CR>", { buffer = true, desc = "Coq next"})
                        vim.keymap.set("i", "<M-up>", "<c-o>:CoqUndo<CR>", { buffer = true, desc = "Coq previous"})


                        vim.opt_local.relativenumber = false
                        vim.opt_local.number = false
                        vim.opt_local.spell = false
                    end
                }
            )

            -- TODO this should also check whether its actually the right windows changing in width
            -- vim.api.nvim_create_autocmd("WinResized",
            --     {
            --         callback = function()
            --             set_printing_width_automatically()
            --         end
            --     })
            
            local ls = require("luasnip")
            local parse = ls.parser.parse_snippet
            ls.add_snippets("coq", {
                parse({trig = "forall", wordTrig = false}, "∀"),
                parse({trig = "exists", wordTrig = false}, "∃"),

                parse({trig = "not", wordTrig = false}, "¬"),
                parse({trig = "lor", wordTrig = false}, "∨"),
                parse({trig = "land", wordTrig = false}, "∧"),
                parse({trig = "\\/", wordTrig = false}, "∨"),
                parse({trig = "/\\", wordTrig = false}, "∧"),

                parse({trig = "rightarrow", wordTrig = false}, "→"),
                parse({trig = "implies", wordTrig = false}, "→"),
                parse({trig = "to", wordTrig = false}, "→"),
                parse({trig = "->", wordTrig = false}, "→"),
                parse({trig = "iff", wordTrig = false}, "↔"),
                parse({trig = "<->", wordTrig = false}, "↔"),

                parse({trig = "leftarrow", wordTrig = false}, "←"),
                parse({trig = "<-", wordTrig = false}, "←"),

                parse({trig = "neq", wordTrig = false}, "≠"),
                parse({trig = "<>", wordTrig = false}, "≠"),
                parse({trig = "!=", wordTrig = false}, "≠"),

                parse({trig = "le", wordTrig = false}, "≤"),
                parse({trig = "<=", wordTrig = false}, "≤"),
                parse({trig = "ge", wordTrig = false}, "≥"),
                parse({trig = ">=", wordTrig = false}, "≥"),
                parse({trig = "equiv", wordTrig = false}, "≡"),
                parse({trig = "prec", wordTrig = false}, "≺"),
                parse({trig = "preceq", wordTrig = false}, "≼"),

                parse({trig = "in", wordTrig = false}, "∈"),
                parse({trig = "notin", wordTrig = false}, "∉"),
                parse({trig = "cup", wordTrig = false}, "∪"),
                parse({trig = "cap", wordTrig = false}, "∩"),

                parse({trig = "subset", wordTrig = false}, "⊂"),
                parse({trig = "subseteq", wordTrig = false}, "⊆"),
                parse({trig = "supset", wordTrig = false}, "⊃"),
                parse({trig = "supseteq", wordTrig = false}, "⊇"),

                parse({trig = "sqsubseteq", wordTrig = false}, "⊑"),
                parse({trig = "sqsupseteq", wordTrig = false}, "⊒"),
                parse({trig = "notsubseteq", wordTrig = false}, "⊈"),

                parse({trig = "true", wordTrig = false}, "⊤"),
                parse({trig = "top", wordTrig = false}, "⊤"),

                parse({trig = "false", wordTrig = false}, "⊥"),
                parse({trig = "bottom", wordTrig = false}, "⊥"),
                parse({trig = "bot", wordTrig = false}, "⊥"),

                parse({trig = "vdash", wordTrig = false}, "⊢"),
                parse({trig = "dashv", wordTrig = false}, "⊣"),
                parse({trig = "vDash", wordTrig = false}, "⊨"),
                parse({trig = "Vdash", wordTrig = false}, "⊩"),
                parse({trig = "infty", wordTrig = false}, "∞"),
                parse({trig = "comp", wordTrig = false}, "∘"),
                parse({trig = "cdot", wordTrig = false}, "∙"),
                parse({trig = "mapsto", wordTrig = false}, "↦"),
                parse({trig = "Mapsto", wordTrig = false}, "⤇"),
                parse({trig = "hookrightarrow", wordTrig = false}, "↪"),
                parse({trig = "rightarrowtail", wordTrig = false}, "↣"),
                parse({trig = "up", wordTrig = false}, "↑"),
                parse({trig = "uparrow", wordTrig = false}, "↑"),
                parse({trig = "downarrow", wordTrig = false}, "↓"),


                parse({trig = "valid", wordTrig = false}, "✓"),
                parse({trig = "checkmark", wordTrig = false}, "✓"),
                parse({trig = "diamond", wordTrig = false}, "◇"),
                parse({trig = "box", wordTrig = false}, "□"),
                parse({trig = "bbox", wordTrig = false}, "■"),
                parse({trig = "rhd", wordTrig = false}, "▷"),
                parse({trig = "later", wordTrig = false}, "▷"),

                parse({trig = "lcredit", wordTrig = false}, "£"),
                parse({trig = "pound", wordTrig = false}, "£"),
                parse({trig = "ast", wordTrig = false}, "∗"),
                parse({trig = "sep", wordTrig = false}, "∗"),
                parse({trig = "ulc", wordTrig = false}, "⌜"),
                parse({trig = "urc", wordTrig = false}, "⌝"),
                parse({trig = "lceil", wordTrig = false}, "⎡"),
                parse({trig = "rceil", wordTrig = false}, "⎤"),
                parse({trig = "Lc", wordTrig = false}, "⎡"),
                parse({trig = "Rc", wordTrig = false}, "⎤"),
                parse({trig = "varnothing", wordTrig = false}, "∅"),
                parse({trig = "empty", wordTrig = false}, "∅"),
                parse({trig = "Lam", wordTrig = false}, "Λ"),
                parse({trig = "Sig", wordTrig = false}, "Σ"),
                parse({trig = "aa", wordTrig = false}, "●"),
                parse({trig = "af", wordTrig = false}, "◯"),
                parse({trig = "auth", wordTrig = false}, "●"),
                parse({trig = "frag", wordTrig = false}, "◯"),
                parse({trig = "iff", wordTrig = false}, "↔"),
                parse({trig = "gname", wordTrig = false}, "γ"),
                parse({trig = "incl", wordTrig = false}, "≼"),
                parse({trig = "latert", wordTrig = false}, "▶"),
                parse({trig = "update", wordTrig = false}, "⇝"),
                parse({trig = "bind", wordTrig = false}, "≫="),


                parse({trig = "^^+", wordTrig = false}, "⁺"),
                parse({trig = "__+", wordTrig = false}, "₊"),
                parse({trig = "^^-", wordTrig = false}, "⁻"),
                parse({trig = "__0", wordTrig = false}, "₀"),
                parse({trig = "__1", wordTrig = false}, "₁"),
                parse({trig = "__2", wordTrig = false}, "₂"),
                parse({trig = "__3", wordTrig = false}, "₃"),
                parse({trig = "__4", wordTrig = false}, "₄"),
                parse({trig = "__5", wordTrig = false}, "₅"),
                parse({trig = "__6", wordTrig = false}, "₆"),
                parse({trig = "__7", wordTrig = false}, "₇"),
                parse({trig = "__8", wordTrig = false}, "₈"),
                parse({trig = "__9", wordTrig = false}, "₉"),

                parse({trig = "__a", wordTrig = false}, "ₐ"),
                parse({trig = "__e", wordTrig = false}, "ₑ"),
                parse({trig = "__h", wordTrig = false}, "ₕ"),
                parse({trig = "__i", wordTrig = false}, "ᵢ"),
                parse({trig = "__k", wordTrig = false}, "ₖ"),
                parse({trig = "__l", wordTrig = false}, "ₗ"),
                parse({trig = "__m", wordTrig = false}, "ₘ"),
                parse({trig = "__n", wordTrig = false}, "ₙ"),
                parse({trig = "__o", wordTrig = false}, "ₒ"),
                parse({trig = "__p", wordTrig = false}, "ₚ"),
                parse({trig = "__r", wordTrig = false}, "ᵣ"),
                parse({trig = "__s", wordTrig = false}, "ₛ"),
                parse({trig = "__t", wordTrig = false}, "ₜ"),
                parse({trig = "__u", wordTrig = false}, "ᵤ"),
                parse({trig = "__v", wordTrig = false}, "ᵥ"),
                parse({trig = "__x", wordTrig = false}, "ₓ"),

                parse({trig = "Alpha", wordTrig = false}, "Α"),
                parse({trig = "alpha", wordTrig = false}, "α"),
                parse({trig = "Beta", wordTrig = false}, "Β"),
                parse({trig = "beta", wordTrig = false}, "β"),
                parse({trig = "Gamma", wordTrig = false}, "Γ"),
                parse({trig = "gamma", wordTrig = false}, "γ"),
                parse({trig = "Delta", wordTrig = false}, "Δ"),
                parse({trig = "delta", wordTrig = false}, "δ"),
                parse({trig = "Epsilon", wordTrig = false}, "Ε"),
                parse({trig = "epsilon", wordTrig = false}, "ε"),
                parse({trig = "Zeta", wordTrig = false}, "Ζ"),
                parse({trig = "zeta", wordTrig = false}, "ζ"),
                parse({trig = "Eta", wordTrig = false}, "Η"),
                parse({trig = "eta", wordTrig = false}, "η"),
                parse({trig = "Theta", wordTrig = false}, "Θ"),
                parse({trig = "theta", wordTrig = false}, "θ"),
                parse({trig = "Iota", wordTrig = false}, "Ι"),
                parse({trig = "iota", wordTrig = false}, "ι"),
                parse({trig = "Kappa", wordTrig = false}, "Κ"),
                parse({trig = "kappa", wordTrig = false}, "κ"),
                parse({trig = "Lamda", wordTrig = false}, "Λ"),
                parse({trig = "lamda", wordTrig = false}, "λ"),
                parse({trig = "Lambda", wordTrig = false}, "Λ"),
                parse({trig = "lambda", wordTrig = false}, "λ"),
                parse({trig = "fun", wordTrig = false}, "λ"),
                parse({trig = "lam", wordTrig = false}, "λ"),
                parse({trig = "Mu", wordTrig = false}, "Μ"),
                parse({trig = "mu", wordTrig = false}, "μ"),
                parse({trig = "Nu", wordTrig = false}, "Ν"),
                parse({trig = "nu", wordTrig = false}, "ν"),
                parse({trig = "Xi", wordTrig = false}, "Ξ"),
                parse({trig = "xi", wordTrig = false}, "ξ"),
                parse({trig = "Omicron", wordTrig = false}, "Ο"),
                parse({trig = "omicron", wordTrig = false}, "ο"),
                parse({trig = "Pi", wordTrig = false}, "Π"),
                parse({trig = "pi", wordTrig = false}, "π"),
                parse({trig = "Rho", wordTrig = false}, "Ρ"),
                parse({trig = "rho", wordTrig = false}, "ρ"),
                parse({trig = "Sigma", wordTrig = false}, "Σ"),
                parse({trig = "sigma", wordTrig = false}, "σ"),
                parse({trig = "Tau", wordTrig = false}, "Τ"),
                parse({trig = "tau", wordTrig = false}, "τ"),
                parse({trig = "Upsilon", wordTrig = false}, "Υ"),
                parse({trig = "upsilon", wordTrig = false}, "υ"),
                parse({trig = "Phi", wordTrig = false}, "Φ"),
                parse({trig = "phi", wordTrig = false}, "ϕ"),
                parse({trig = "varphi", wordTrig = false}, "φ"),
                parse({trig = "Chi", wordTrig = false}, "Χ"),
                parse({trig = "chi", wordTrig = false}, "χ"),
                parse({trig = "Psi", wordTrig = false}, "Ψ"),
                parse({trig = "psi", wordTrig = false}, "ψ"),
                parse({trig = "Omega", wordTrig = false}, "Ω"),
                parse({trig = "omega", wordTrig = false}, "ω"),



                parse({trig = "oless", wordTrig = false}, "⧀"),
                parse({trig = "ogreater", wordTrig = false}, "⧁"),
                parse({trig = "oplus", wordTrig = false}, "⊕"),
                parse({trig = "otimes", wordTrig = false}, "⊗"),



                parse({trig = "calV", wordTrig = false}, "𝒱"),
                parse({trig = "calE", wordTrig = false}, "ℰ"),
                parse({trig = "calG", wordTrig = false}, "𝒢"),
                parse({trig = "upbar", wordTrig = false}, "⤉"),
                parse({trig = "lock", wordTrig = false}, "🔒"),

                parse({trig = "[[", wordTrig = false}, "⟦"),
                parse({trig = "]]", wordTrig = false}, "⟧"),

                parse({trig = "union", wordTrig = false}, "∪"),
                parse({trig = "intersection", wordTrig = false}, "∩"),
                parse({trig = "setminus", wordTrig = false}, "∖"),

                parse({trig = "key", wordTrig = false}, "🔑"),

                parse({trig = "join", wordTrig = false}, "⊔"),
                parse({trig = "meet", wordTrig = false}, "⊓"),

                parse({trig = ">>", wordTrig = false}, "≫"),
                parse({trig = "::", wordTrig = false}, "∷"),
                parse({trig = "=>", wordTrig = false}, "⇒"),
                parse({trig = "Uparrow", wordTrig = false}, "⇑"),

            })
        end,
    },
}


-- augroup CoqtailHighlights
--   autocmd!
--   autocmd ColorScheme dracula
--     \  hi def CoqtailChecked ctermbg=0 guibg=#1D3824
--     \| hi def CoqtailSent    ctermbg=53 guibg=#291616
-- augroup END
