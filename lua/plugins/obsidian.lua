return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/notes",
        },
      },

      -- Disable UI features to avoid conflicts with render-markdown.nvim
      ui = {
        enable = false,
      },

      -- Completion for note references and tags
      completion = {
        nvim_cmp = false,
        min_chars = 2,
      },

      -- Daily notes configuration
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
      },

      -- Note ID generation
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      -- Custom frontmatter with auto-tags based on folder
      note_frontmatter_func = function(note)
        -- Auto-generate tags from folder path
        local auto_tags = {}
        local path = note.path and tostring(note.path) or ""

        -- Extract course/program codes from path
        if path:match("MIB2027A") then
          table.insert(auto_tags, "MIB2027A")
        end
        if path:match("PGDAIML") then
          table.insert(auto_tags, "PGDAIML")
        end

        -- Extract term info
        if path:match("term%-(%d+)") then
          local term_num = path:match("term%-(%d+)")
          table.insert(auto_tags, "term-" .. term_num)
        end

        -- Extract subject codes
        if path:match("GMKTG201") then
          table.insert(auto_tags, "GMKTG201")
        end
        if path:match("LEADR201") then
          table.insert(auto_tags, "LEADR201")
        end
        if path:match("GENMA273") then
          table.insert(auto_tags, "GENMA273")
        end

        -- Extract pillar and module info
        if path:match("pillar%-(%d+)") then
          local pillar_num = path:match("pillar%-(%d+)")
          table.insert(auto_tags, "pillar-" .. pillar_num)
        end
        if path:match("module%-(%d+)") then
          local module_num = path:match("module%-(%d+)")
          table.insert(auto_tags, "module-" .. module_num)
        end

        -- Merge with existing tags
        if note.tags then
          for _, tag in ipairs(note.tags) do
            table.insert(auto_tags, tag)
          end
        end

        local out = {
          title = note.title,
          author = "Jeryl Donato Estopace",
          date = os.date("%Y-%m-%d"),
          created = os.date("%Y-%m-%d"),
          tags = auto_tags,
        }

        -- Preserve any manually added metadata
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,

      -- Mappings
      mappings = {
        -- Override gf to work on markdown/wiki links
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle checkboxes
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action: follow link or toggle checkbox
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },

      -- Disable wiki links, use markdown links instead
      preferred_link_style = "markdown",

      -- Templates
      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
    },
  },
}