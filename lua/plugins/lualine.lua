return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = "|",
        section_separators = "",
        file_status = true,
        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
      },
    },
  },
}
