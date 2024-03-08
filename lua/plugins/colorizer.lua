return {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        user_default_options = {
            RGB = true,
            names = false,
            RRGGBB = true,
            AARRGGBB = false,
        },
    }
}
