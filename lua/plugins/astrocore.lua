-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        scrolloff = 8, -- keep 8 lines above/below cursor
        sidescrolloff = 8, -- keep 8 columns left/right of cursor
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- Telescope keybindings
        ["<Leader>fw"] = { "<cmd>Telescope live_grep<cr>", desc = "Find words" },
        ["<Leader>fg"] = { "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        ["<Leader>ff"] = { "<cmd>Telescope find_files<cr>", desc = "Find files" },
        ["<Leader>fb"] = { "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
        ["<Leader>fh"] = { "<cmd>Telescope help_tags<cr>", desc = "Find help" },
        ["<Leader>fo"] = { "<cmd>Telescope oldfiles<cr>", desc = "Find old files" },
        ["<Leader>fc"] = { "<cmd>Telescope grep_string<cr>", desc = "Find word under cursor" },

        -- Obsidian keybindings
        ["<Leader>o"] = { desc = "Obsidian" },
        ["<Leader>oo"] = { "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian app" },
        ["<Leader>on"] = { "<cmd>ObsidianNew<cr>", desc = "New note" },
        ["<Leader>oq"] = { "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch" },
        ["<Leader>os"] = { "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
        ["<Leader>ot"] = { "<cmd>ObsidianTags<cr>", desc = "Search tags" },
        ["<Leader>od"] = { "<cmd>ObsidianToday<cr>", desc = "Today's note" },
        ["<Leader>oy"] = { "<cmd>ObsidianYesterday<cr>", desc = "Yesterday's note" },
        ["<Leader>ob"] = { "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },
        ["<Leader>ol"] = { "<cmd>ObsidianLinks<cr>", desc = "Show links" },
        ["<Leader>ow"] = { "<cmd>ObsidianWorkspace<cr>", desc = "Switch workspace" },
        ["<Leader>op"] = { "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
        ["<Leader>or"] = { "<cmd>ObsidianRename<cr>", desc = "Rename note" },
        ["gf"] = {
          function()
            if require("obsidian").util.cursor_on_markdown_link() then
              return "<Cmd>ObsidianFollowLink<CR>"
            else
              return "gf"
            end
          end,
          desc = "Follow link or file",
          expr = true,
        },

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}
