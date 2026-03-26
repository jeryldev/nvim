return {
  {
    "mrcjkb/rustaceanvim",
    lazy = false,
    keys = {
      -- Running and debugging
      { "<leader>rr", "<cmd>RustLsp run<cr>",              desc = "Rust: Run current binary" },
      { "<leader>rd", "<cmd>RustLsp debuggables<cr>",      desc = "Rust: Debug current binary" },
      { "<leader>rt", "<cmd>RustLsp testables<cr>",        desc = "Rust: Run test under cursor" },
      { "<leader>rT", "<cmd>RustLsp testables!<cr>",       desc = "Rust: Run all tests in file" },

      -- Code actions and navigation
      { "<leader>ra", "<cmd>RustLsp codeAction<cr>",       desc = "Rust: Code action (quick fix)" },
      { "<leader>re", "<cmd>RustLsp expandMacro<cr>",      desc = "Rust: Expand macro recursively" },
      { "<leader>rh", "<cmd>RustLsp hover actions<cr>",    desc = "Rust: Hover actions menu" },
      { "<leader>rp", "<cmd>RustLsp parentModule<cr>",     desc = "Rust: Go to parent module" },
      { "<leader>rj", "<cmd>RustLsp joinLines<cr>",        desc = "Rust: Join lines (smart)" },

      -- Cargo and documentation
      { "<leader>rc", "<cmd>RustLsp openCargo<cr>",        desc = "Rust: Open Cargo.toml" },
      { "<leader>rD", "<cmd>RustLsp openDocs<cr>",         desc = "Rust: Open docs.rs for symbol" },
      { "<leader>rg", "<cmd>RustLsp crateGraph<cr>",       desc = "Rust: View crate dependency graph" },

      -- Workspace management
      { "<leader>rR", "<cmd>RustLsp reloadWorkspace<cr>",  desc = "Rust: Reload workspace & rebuild" },
      { "<leader>rs", "<cmd>RustLsp syntaxTree<cr>",       desc = "Rust: Show syntax tree" },

      -- Additional useful commands
      { "<leader>rm", "<cmd>RustLsp moveItemDown<cr>",     desc = "Rust: Move item down" },
      { "<leader>rM", "<cmd>RustLsp moveItemUp<cr>",       desc = "Rust: Move item up" },
      { "<leader>rx", "<cmd>RustLsp explainError<cr>",     desc = "Rust: Explain error at cursor" },
      { "<leader>rl", "<cmd>RustLsp renderDiagnostic<cr>", desc = "Rust: Render full diagnostic" },
    },
    config = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- Additional buffer-local keymaps can go here
            vim.keymap.set(
              "n",
              "<leader>rq",
              function()
                vim.cmd.RustAnalyzer("Stop")
                vim.cmd.RustAnalyzer("Start")
              end,
              { buffer = bufnr, desc = "Restart rust-analyzer" }
            )
          end,
          settings = {
            -- rust-analyzer settings
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              checkOnSave = {
                command = "clippy",
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
      }
    end,
  },

  -- Crates.nvim for Cargo.toml features
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        cmp = {
          enabled = true,
        },
      },
    },
    -- keys = {
    --   { "<leader>cu", function() require("crates").update_crate() end, desc = "Crates: Update crate under cursor" },
    --   { "<leader>cU", function() require("crates").upgrade_crate() end, desc = "Crates: Upgrade crate to latest" },
    --   { "<leader>ca", function() require("crates").update_all_crates() end, desc = "Crates: Update all crates (compatible)" },
    --   { "<leader>cA", function() require("crates").upgrade_all_crates() end, desc = "Crates: Upgrade all crates (latest)" },
    --   { "<leader>ce", function() require("crates").expand_plain_crate_to_inline_table() end, desc = "Crates: Expand to inline table" },
    --   { "<leader>cE", function() require("crates").extract_crate_into_table() end, desc = "Crates: Extract into table" },
    --   { "<leader>cf", function() require("crates").show_features_popup() end, desc = "Crates: Show features popup" },
    --   { "<leader>cd", function() require("crates").show_dependencies_popup() end, desc = "Crates: Show dependencies popup" },
    --   { "<leader>cv", function() require("crates").show_versions_popup() end, desc = "Crates: Show versions popup" },
    --   { "<leader>ci", function() require("crates").show_crate_popup() end, desc = "Crates: Show crate info popup" },
    --   { "<leader>ch", function() require("crates").open_homepage() end, desc = "Crates: Open homepage in browser" },
    --   { "<leader>cr", function() require("crates").open_repository() end, desc = "Crates: Open repository in browser" },
    --   { "<leader>cD", function() require("crates").open_documentation() end, desc = "Crates: Open docs.rs in browser" },
    --   { "<leader>cC", function() require("crates").open_crates_io() end, desc = "Crates: Open crates.io in browser" },
    -- },
  },
}

