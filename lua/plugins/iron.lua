return {
  {
    "Vigemus/iron.nvim",
    cmd = {
      "IronRepl",
      "IronReplHere",
      "IronRestart",
      "IronSend",
      "IronFocus",
      "IronHide",
      "IronWatch",
      "IronAttach",
    },
    keys = {
      -- REPL Commands
      { "<leader>is", "<cmd>IronRepl<cr>", desc = "[I]ron [S]tart REPL (quick testing)" },
      { "<leader>ir", "<cmd>IronRestart<cr>", desc = "[I]ron [R]estart REPL" },
      { "<leader>if", "<cmd>IronFocus<cr>", desc = "[I]ron [F]ocus REPL window" },
      { "<leader>ih", "<cmd>IronHide<cr>", desc = "[I]ron [H]ide REPL window" },

      -- Send Commands
      { "<leader>ic", desc = "[I]ron send [C]ode motion (e.g. ici{)", mode = { "n" } },
      { "<leader>ic", desc = "[I]ron send [C]ode selection", mode = { "v" } },
      { "<leader>iF", desc = "[I]ron send entire [F]ile to REPL" },
      { "<leader>il", desc = "[I]ron send [L]ine to REPL" },
      { "<leader>iu", desc = "[I]ron send [U]ntil cursor (from file start)" },
      { "<leader>im", desc = "[I]ron send [M]arked text" },

      -- Mark Commands
      { "<leader>imc", desc = "[I]ron [M]ark [C]ode motion", mode = { "n" } },
      { "<leader>imc", desc = "[I]ron [M]ark [C]ode selection", mode = { "v" } },
      { "<leader>imd", desc = "[I]ron [M]ark [D]elete" },

      -- REPL Control
      { "<leader>i<cr>", desc = "[I]ron send <CR> (Enter key)" },
      { "<leader>i<space>", desc = "[I]ron interrupt (Ctrl+C)" },
      { "<leader>iq", desc = "[I]ron [Q]uit/exit REPL" },
      { "<leader>iC", desc = "[I]ron [C]lear REPL output" },
    },
    main = "iron.core", -- <== This informs lazy.nvim to use the entrypoint of `iron.core` to load the configuration.
    opts = function()
      local view = require("iron.view")
      return {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            sh = {
              command = { "fish" },
            },
            python = {
              command = { "python3" },
            },
            javascript = {
              command = { "node" },
            },
            typescript = {
              command = { "ts-node" },
            },
            lua = {
              command = { "lua" },
            },
            ruby = {
              command = { "irb" },
            },
            elixir = {
              command = { "iex" },
            },
            julia = {
              command = { "julia" },
            },
            r = {
              command = { "R" },
            },
          },
          -- How the repl window will be displayed
          -- Opens REPL in a vertical split on the right with 40% of window width
          repl_open_cmd = view.split.vertical.botright(0.4),
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          send_motion = "<leader>ic", -- Send text using motion
          visual_send = "<leader>ic", -- Send visually selected text
          send_file = "<leader>iF", -- Send the entire file to REPL
          send_line = "<leader>il", -- Send the current line
          send_until_cursor = "<leader>iu", -- Send from start of file to cursor position
          send_mark = "<leader>im", -- Send previously marked text
          mark_motion = "<leader>imc", -- Mark text object using motion
          mark_visual = "<leader>imc", -- Mark visual selection
          remove_mark = "<leader>imd", -- Remove/delete mark
          cr = "<leader>i<cr>", -- Send carriage return to REPL
          interrupt = "<leader>i<space>", -- Interrupt REPL execution (sends Ctrl+C)
          exit = "<leader>iq", -- Quit/exit the REPL
          clear = "<leader>iC", -- Clear the REPL window
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = { italic = true },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }
    end,
  },
}
