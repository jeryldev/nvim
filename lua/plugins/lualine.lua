return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, _)
    return {
      sections = {
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
      },
    }
  end,
}
