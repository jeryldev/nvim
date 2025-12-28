-- Simplified pyworks.nvim setup - Auto-configures all dependencies!
return {
  {
    "jeryldev/pyworks.nvim",
    dependencies = {
      {
        "GCBallesteros/jupytext.nvim",
        config = function()
          -- Only setup jupytext if the CLI is available
          local has_jupytext = vim.fn.executable("jupytext") == 1

          -- Check in common venv locations
          if not has_jupytext then
            local venv_paths = {
              vim.fn.getcwd() .. "/.venv/bin/jupytext",
              vim.fn.expand("~") .. "/.local/bin/jupytext",
            }
            for _, path in ipairs(venv_paths) do
              if vim.fn.executable(path) == 1 then
                has_jupytext = true
                -- Add to PATH
                local dir = vim.fn.fnamemodify(path, ":h")
                vim.env.PATH = dir .. ":" .. vim.env.PATH
                break
              end
            end
          end

          if has_jupytext then
            -- Configure jupytext with percent style (for Python cells with # %%)
            -- NOTE: This is the ONLY place jupytext.setup() should be called
            -- Calling it multiple times causes BufWriteCmd race conditions
            require("jupytext").setup({
              style = "percent",
              output_extension = "auto",
              force_ft = nil,
              custom_language_formatting = {
                python = { extension = "py", style = "percent" },
                julia = { extension = "jl", style = "percent" },
                r = { extension = "R", style = "percent" },
              },
            })
          else
            -- Don't setup jupytext, let pyworks handle notebooks
            -- Disable jupytext.nvim's handler since it will fail anyway
            pcall(vim.api.nvim_clear_autocmds, {
              group = "jupytext.nvim",
              pattern = "*.ipynb",
            })

            vim.api.nvim_create_autocmd("BufReadCmd", {
              group = vim.api.nvim_create_augroup("PyworksNotebook", { clear = true }),
              pattern = "*.ipynb",
              callback = function(ev)
                -- Prevent other handlers from running
                vim.api.nvim_buf_set_var(ev.buf, "jupytext_handled", true)

                -- Get the buffer name which should be the file path
                local filepath = vim.api.nvim_buf_get_name(ev.buf)

                -- If still empty, try ev.match
                if filepath == "" then
                  filepath = ev.match or ev.file
                end

                -- Make absolute if needed
                if not filepath:match("^/") then
                  -- Try to get cwd, but handle errors
                  local cwd = vim.fn.getcwd()
                  if cwd and cwd ~= "" then
                    filepath = cwd .. "/" .. filepath
                  else
                    -- Fallback: try to expand the path
                    filepath = vim.fn.expand(filepath)
                  end
                end

                -- Safely load the file
                local ok, content = pcall(vim.fn.readfile, filepath)
                if not ok then
                  -- File doesn't exist or can't be read
                  vim.api.nvim_buf_set_lines(0, 0, -1, false, {
                    "Error: Could not read notebook file",
                    "",
                    "File: " .. filepath,
                    "",
                    "Possible reasons:",
                    "- File does not exist",
                    "- Permission denied",
                    "- Invalid path",
                  })
                  vim.bo.filetype = "text"
                  vim.bo.modifiable = false

                  vim.schedule(function()
                    vim.notify("❌ Could not read notebook file", vim.log.levels.ERROR)
                    vim.notify("📝 Check the file path and permissions", vim.log.levels.INFO)
                  end)
                else
                  -- Successfully read file, show as JSON
                  vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
                  vim.bo.filetype = "json"
                  vim.bo.modifiable = false

                  -- Show helpful message
                  vim.schedule(function()
                    vim.notify("📓 Notebook in JSON view (jupytext not installed)", vim.log.levels.WARN)
                    vim.notify("💡 Run :PyworksSetup from any .py file to install jupytext", vim.log.levels.INFO)
                  end)
                end

                -- Mark as loaded to prevent re-processing
                vim.api.nvim_buf_set_var(ev.buf, "pyworks_notebook_loaded", true)
                vim.cmd.setlocal("buftype=nofile")
              end,
            })
          end
        end,
      },
      "nvim-lua/plenary.nvim", -- Required: Core utilities
      "benlubas/molten-nvim",  -- Required: Code execution
      "3rd/image.nvim",        -- Required: Image display
    },
    config = function()
      require("pyworks").setup({
        -- Pyworks auto-configures everything with your proven settings!
        -- Just specify any preferences:
        python = {
          use_uv = true,         -- Use uv for faster package installation
        },
        image_backend = "kitty", -- Ghostty supports Kitty graphics protocol

        -- Optional: Skip auto-configuration of specific dependencies
        -- skip_molten = false,
        -- skip_jupytext = false,
        -- skip_image = false,
        -- skip_keymaps = false,
      })
    end,
    lazy = false,   -- Load immediately for file detection
    priority = 100, -- Load early
  },
}
