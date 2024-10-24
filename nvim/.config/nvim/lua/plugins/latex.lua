return {
    -- for matching of begin/end
    "andymass/vim-matchup",
    {
        "lervag/vimtex",
        config = function()
            vim.g.vimtex_delim_timeout=10
            vim.g.vimtex_matchparen_enabled=0
            if vim.fn.has("macunix") then
                vim.g.vimtex_view_method = "skim"
            else
                vim.g.vimtex_view_method = "zathura"
            end

            vim.g.vimtex_mappings_prefix = "<leader>m"
            -- vim.g.vimtex_compiler_latexmk_engines = { _ = "-lualatex" }
            vim.g.vimtex_quickfix_ignore_filters = { "Marginpar on page" };

            vim.api.nvim_create_autocmd("BufRead", {
                pattern = {
                    "/Users/silvus/phd/semantics/*",
                    "/Users/silvus/phd/vorkurs/*",
                },
                callback = function()
                    vim.g.vimtex_compiler_latexmk_engines = { _ = "-pdf" }
                end,
            })

        end,
    },
}
