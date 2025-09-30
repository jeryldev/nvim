return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 1000,
    opts = {
      servers = {
        -- Expert Elixir LSP (new official Elixir language server)
        lexical = {
          cmd = { vim.fn.expand("~/.local/bin/expert/apps/expert/burrito_out/expert_darwin_arm64") },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd()
          end,
          filetypes = { "elixir", "eelixir", "heex", "surface" },
          settings = {},
        },
        emmet_language_server = {
          filetypes = {
            "css",
            "eruby",
            "html",
            "javascript",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "pug",
            "typescriptreact",
            -- Add Elixir template filetypes
            "heex",
            "eex",
            "elixir",
            "surface",
          },
          init_options = {
            showExpandedAbbreviation = "always",
            showAbbreviationSuggestions = true,
            showSuggestionsAsSnippets = false,
            -- Add language mappings for Elixir templates
            includeLanguages = {
              ["heex"] = "html",
              ["eex"] = "html",
              ["elixir"] = "html",
              ["phoenix-heex"] = "html",
            },
          },
        },
        tailwindcss = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "elixir",
            "ex",
            "exs",
            "heex",
            "eex",
            "surface",
          },
        },
      },
      setup = {
        -- Setup for Expert Elixir LSP (lexical)
        lexical = function(_, opts)
          local lspconfig = require("lspconfig")
          local configs = require("lspconfig.configs")

          -- Define lexical configuration if it doesn't exist
          if not configs.lexical then
            configs.lexical = {
              default_config = {
                cmd = opts.cmd,
                filetypes = opts.filetypes,
                root_dir = opts.root_dir,
                settings = opts.settings or {},
              },
            }
          end

          -- Setup the server
          lspconfig.lexical.setup(opts)
          return true -- Prevent LazyVim from trying to set it up again
        end,
        tailwindcss = function(_, opts)
          -- Setup filetypes
          opts.filetypes = opts.filetypes or {}

          -- Add Elixir-related filetypes
          local elixir_filetypes = { "elixir", "ex", "exs", "heex", "eex", "surface" }
          for _, ft in ipairs(elixir_filetypes) do
            if not vim.tbl_contains(opts.filetypes, ft) then
              table.insert(opts.filetypes, ft)
            end
          end

          -- Language ID mappings
          opts.settings = opts.settings or {}
          opts.settings.tailwindCSS = opts.settings.tailwindCSS or {}
          opts.settings.tailwindCSS.includeLanguages =
            vim.tbl_deep_extend("force", opts.settings.tailwindCSS.includeLanguages or {}, {
              elixir = "html-eex",
              ex = "html-eex",
              exs = "html-eex",
              heex = "html-eex",
              eex = "html-eex",
              surface = "html",
            })

          -- Enhanced class detection patterns
          opts.settings.tailwindCSS.experimental = opts.settings.tailwindCSS.experimental or {}
          opts.settings.tailwindCSS.experimental.classRegex = {
            'class="([^"]*)',
            "class='([^']*)'",
            "class={:([^}]*)",
            "class={[\"|']([^}'\"]*)[\"|']",
            'class={"([^"}]*)"',
            'class: "([^"]*)"',
            '~H""".*class="([^"]*)"',
            '~E""".*class="([^"]*)"',
            'class: "([^"]*)"',
            "class: '([^']*)'",
          }

          -- Optimized root directory finder
          opts.root_dir = function(fname)
            local util = require("lspconfig.util")
            local function map_css_to_project(css_file, project_root)
              opts.settings.tailwindCSS.experimental.configFile = css_file
              return project_root
            end

            -- Check for Phoenix project with direct file checks (most efficient)
            local mix_root = util.root_pattern("mix.exs")(fname)
            if mix_root then
              -- Direct check for common CSS files
              for _, css_path in ipairs({ "/assets/css/app.css", "/assets/css/main.css" }) do
                local css_file = mix_root .. css_path
                if vim.fn.filereadable(css_file) == 1 then
                  return map_css_to_project(css_file, mix_root)
                end
              end

              -- If needed, check other CSS files in assets but limit scan depth
              if vim.fn.isdirectory(mix_root .. "/assets") == 1 then
                -- Only look in specific directories to limit scanning
                for _, dir in ipairs({ "/assets/css", "/assets/styles" }) do
                  local path = mix_root .. dir
                  if vim.fn.isdirectory(path) == 1 then
                    local css_files = vim.fn.glob(path .. "/*.css", false, true)
                    for _, css_file in ipairs(css_files) do
                      -- Quick check for key patterns without reading entire file
                      local content = vim.fn.readfile(css_file, "", 10) -- Read only first 10 lines
                      for _, line in ipairs(content) do
                        if line:match("@import%s+['\"]tailwindcss['\"]") or line:match("@tailwind%s+") then
                          return map_css_to_project(css_file, mix_root)
                        end
                      end
                    end
                  end
                end
              end
            end

            -- Project structure check (more limited scope)
            local project_root = util.root_pattern("package.json", ".git")(fname)
            if project_root then
              -- Check only the most common CSS locations
              for _, css_path in ipairs({
                "/src/styles/main.css",
                "/src/css/main.css",
                "/css/main.css",
                "/assets/css/main.css",
              }) do
                local css_file = project_root .. css_path
                if vim.fn.filereadable(css_file) == 1 then
                  local content = vim.fn.readfile(css_file, "", 5)
                  for _, line in ipairs(content) do
                    if line:match("@import%s+['\"]tailwindcss['\"]") or line:match("@tailwind%s+") then
                      return map_css_to_project(css_file, project_root)
                    end
                  end
                end
              end
            end

            -- Fallback for standalone files (avoid file operations if possible)
            local global_css = vim.fn.expand("~/.config/tailwindcss/tailwind.css")

            -- Create the file only if we need it and it doesn't exist
            if vim.fn.filereadable(global_css) ~= 1 then
              local dir = vim.fn.expand("~/.config/tailwindcss")
              if vim.fn.isdirectory(dir) ~= 1 then
                vim.fn.mkdir(dir, "p")
              end

              local f = io.open(global_css, "w")
              if f then
                f:write("@import 'tailwindcss';\n")
                f:close()
              end
            end

            -- Use the file's directory and global CSS
            local file_dir = vim.fn.fnamemodify(fname, ":h")
            opts.settings.tailwindCSS.experimental.configFile = global_css
            return file_dir
          end
        end,
      },
    },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = "VeryLazy",
    opts = {
      render = "background", -- or "virtual"
      enable_tailwind = true,
      enable_named_colors = true,
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- Add other formatters here as needed
      },
      formatters = {
        biome = {
          require_cwd = false,
        },
      },
    },
  },
}
