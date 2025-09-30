return {
  {
    "3rd/image.nvim",
    build = false,
    opts = {
      processor = "magick_cli",
      rocks = {
        hererocks = true,
      },
    },
  },
  {
    "3rd/diagram.nvim",
    dependencies = {
      "3rd/image.nvim",
    },

    config = function()
      -- First, try to load integrations separately
      local integrations = {}

      local status_markdown, markdown = pcall(require, "diagram.integrations.markdown")
      if status_markdown then
        table.insert(integrations, markdown)
      end

      local status_neorg, neorg = pcall(require, "diagram.integrations.neorg")
      if status_neorg then
        table.insert(integrations, neorg)
      end

      -- Then pass the already-constructed table to setup
      require("diagram").setup({
        integrations = integrations, -- Pass the table directly, not a function
        renderer_options = {
          mermaid = {
            theme = "forest",
            width = 800, -- More reasonable width
            height = 600, -- More reasonable height
            scale = 2, -- Higher scale factor
            fontSize = 14, -- Increase font size
          },
          plantuml = {
            charset = "utf-8",
            scale = 1.5,
          },
          d2 = {
            theme_id = 1,
            layout_engine = "dagre",
            pad = 50,
          },
          gnuplot = {
            theme = "dark",
            size = "800,600",
          },
        },
      })
    end,
  },
}
