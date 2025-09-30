return {
  "ibhagwan/fzf-lua",
  opts = function(_, opts)
    opts.winopts = {
      preview = {
        vertical = "up:60%",
        layout = "vertical",
      },
    }
  end,
}
