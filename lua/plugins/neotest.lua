return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "jfpedroza/neotest-elixir",
    },
    opts = {
      adapters = {
        ["neotest-elixir"] = {
          test_file_pattern = ".test.exs$",
          filter_dir = function(_, rel_path, _)
            return rel_path == "test"
              or rel_path == "lib"
              or vim.startswith(rel_path, "test/")
              or vim.startswith(rel_path, "lib/")
          end,
        },
      },
    },
  },
}
