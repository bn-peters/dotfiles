local codex = { name = "codex" }

return {
    {
        "folke/sidekick.nvim",
        cmd = "Sidekick",
        dependencies = {
            "folke/snacks.nvim",
        },
        opts = {
            nes = {
                enabled = false,
            },
            cli = {
                win = {
                    layout = "right",
                    split = {
                        width = 80,
                    },
                },
            },
        },
        keys = {
            {
                "<leader>aa",
                function()
                    require("sidekick.cli").focus(codex)
                end,
                mode = { "n", "t" },
                desc = "focus/unfocus Codex",
            },
            {
                "<leader>at",
                function()
                    require("sidekick.cli").toggle(codex)
                end,
                mode = { "n", "t" },
                desc = "toggle Codex",
            },
        },
    },
}
