return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      opts.picker.layout = {
        layout = {
          backdrop = false,
          width = 0.8,
          min_width = 80,
          height = 0.8,
          min_height = 30,
          box = "vertical",
          border = "rounded",
          title = "{title} {live} {flags}",
          title_pos = "center",
          { win = "input", height = 1, border = "bottom" },
          { win = "list", border = "none" },
          { win = "preview", title = "{preview}", height = 0.6, border = "top" },
        },
      }

      -- Show hidden files (dotfiles) and gitignored files
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.files = {
        hidden = true,
        ignored = true,
      }
      opts.picker.sources.grep = {
        hidden = true,
        ignored = true,
      }
      opts.picker.sources.explorer = {
        hidden = true,
        ignored = true,
      }

      return opts
    end,
  },
}
