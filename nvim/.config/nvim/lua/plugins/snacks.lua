local function floating_terminal_opts()
    return {
        count = 1,
        win = {
            position = "float",
            row = 1,
            width = 0.8,
            height = 0.7,
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
            backdrop = false,
        },
    }
end

local function agent_terminal_opts()
    return {
        count = 2,
        win = {
            position = "right",
            width = 90,
            wo = {
                winbar = "",
            },
        },
    }
end

local function toggle_agent_terminal()
    Snacks.terminal(nil, agent_terminal_opts())
end

return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            picker = {
                sources = {
                    files = {
                        -- frecency: boost recently/frequently used files
                        sort = { fields = { "score:desc", "idx" } },
                    },
                    recent = {
                        sort = { fields = { "score:desc", "idx" } },
                    },
                },
            },
        },
        keys = {
            {
                "<leader><space>",
                function()
                    Snacks.picker.smart()
                end,
                desc = "find files",
            },
            {
                "<leader>ff",
                function()
                    Snacks.picker.files({ ignored = false, follow = true })
                end,
                desc = "find",
            },
            {
                "<leader>fr",
                function()
                    Snacks.picker.recent({})
                end,
                desc = "recent",
            },
            {
                "<leader>fc",
                function()
                    Snacks.picker.files({
                        follow = true,
                        cwd = vim.fn.expand("~/.config/nvim/"),
                    })
                end,
                desc = "find config",
            },
            {
                "<leader>ss",
                function()
                    Snacks.picker.grep({
                        live = false,
                        need_search = false,
                        args = { "--max-columns=9999", "--no-max-columns-preview" },
                        layout = {
                            preset = "ivy_split",
                        },
                    })
                end,
                desc = "search files",
            },
            {
                "<leader>sw",
                function()
                    Snacks.picker.grep_word({})
                end,
                desc = "grep word under cursor in files",
            },
            {
                "<leader>sc",
                function()
                    Snacks.picker.lines({})
                end,
                desc = "grep current file",
            },
            {
                "<leader>bb",
                function()
                    Snacks.picker.buffers({})
                end,
                desc = "buffers",
            },
            {
                "<leader>bt",
                function()
                    Snacks.picker.pick({
                        title = "Filetypes",
                        format = "text",
                        preview = false,
                        layout = "select",
                        finder = function()
                            return vim.tbl_map(function(ft)
                                return { text = ft }
                            end, vim.fn.getcompletion("", "filetype"))
                        end,
                        confirm = function(picker, item)
                            picker:close()
                            if item then vim.bo.filetype = item.text end
                        end,
                    })
                end,
                desc = "filetypes",
            },
            {
                "<leader>c",
                function()
                    Snacks.picker.commands({})
                end,
                desc = "commands",
            },
            {
                "<leader>l",
                function()
                    Snacks.picker.colorschemes({})
                end,
                desc = "colour scheme",
            },
            {
                "<leader>u",
                function()
                    Snacks.picker.spelling()
                end,
                desc = "spell suggest",
            },
            {
                "<leader>T",
                function()
                    Snacks.picker.pickers({})
                end,
                desc = "snacks pickers",
            },
            {
                "<leader>p",
                function()
                    Snacks.picker.keymaps({
                        transform = function(item)
                            if not item.desc or item.desc == "Nvim builtin" then
                                return false
                            end
                            return item
                        end,
                    })
                end,
                desc = "command palette",
            },
            {
                "<leader>h",
                function()
                    Snacks.picker.help({})
                end,
                desc = "help tags",
            },
            {
                "<C-p>",
                function()
                    Snacks.terminal(nil, floating_terminal_opts())
                end,
                desc = "toggle terminal",
            },
            {
                "<leader>P",
                function()
                    Snacks.terminal(nil, floating_terminal_opts())
                end,
                desc = "toggle terminal <C-p>",
            },
            {
                "<C-p>",
                function()
                    Snacks.terminal(nil, floating_terminal_opts())
                end,
                mode = "t",
                desc = "toggle terminal",
            },
            {
                "<C-T>",
                toggle_agent_terminal,
                desc = "toggle AI agent terminal",
            },
            {
                "<C-T>",
                toggle_agent_terminal,
                mode = "t",
                desc = "toggle AI agent terminal",
            },
        },
    },
}
