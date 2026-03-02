-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

  -- == Telescope (Fuzzy Finder) ==
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    opts = function(_, opts)
      local actions = require "telescope.actions"
      opts = require("astrocore").extend_tbl(opts, {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
      })
      return opts
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
      telescope.load_extension "fzf"
    end,
  },

  -- == Catppuccin Theme ==
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "frappe", -- latte, frappe, macchiato, mocha
      transparent_background = true,
      integrations = {
        telescope        = { enabled = true, style = "nvchad" },
        heirline         = true,
        gitsigns         = true,
        indent_blankline = { enabled = true, scope_color = "lavender" },
        native_lsp       = {
          enabled = true,
          underlines = {
            errors      = { "undercurl" },
            hints       = { "undercurl" },
            warnings    = { "undercurl" },
            information = { "undercurl" },
          },
        },
        mini      = { enabled = true },
        nvimtree  = true,
        treesitter = true,
        which_key = true,
        snacks    = true,
      },
    },
  },

  -- == Render Markdown (Inline Markdown Preview) ==
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      file_types = { "markdown" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
    },
  },

  -- == Obsidian.nvim ==
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function(_, opts)
      local astrocore = require "astrocore"
      return astrocore.extend_tbl(opts, {
        workspaces = {
          {
            name = "cmdr",
            path = "~/Documents/cmdr",
          },
        },

        -- Daily notes configuration
        daily_notes = {
          folder = "daily",
          date_format = "%Y-%m-%d",
          alias_format = "%B %-d, %Y",
        },

        -- Templates configuration
        templates = {
          folder = "templates",
          date_format = "%Y-%m-%d",
          time_format = "%H:%M",
        },

        -- Completion: detect what's available at runtime
        completion = {
          nvim_cmp = astrocore.is_available "nvim-cmp",
          blink = astrocore.is_available "blink.cmp",
          min_chars = 2,
        },

        -- Prefer the picker that's actually installed
        finder = (astrocore.is_available "telescope.nvim" and "telescope.nvim")
          or (astrocore.is_available "fzf-lua" and "fzf-lua")
          or (astrocore.is_available "mini.pick" and "mini.pick"),

        -- Note ID generation
        note_id_func = function(title)
          local suffix = ""
          if title ~= nil then
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            suffix = tostring(os.time())
          end
          return suffix
        end,

        -- Note path generation
        note_path_func = function(spec)
          local path = spec.dir / tostring(spec.id)
          return path:with_suffix ".md"
        end,

        -- Use vim.ui.open (works on Linux and macOS)
        follow_url_func = vim.ui.open,

        -- Image paste location
        attachments = {
          img_folder = "assets/imgs",
        },

        -- Disable built-in UI: render-markdown.nvim handles markdown rendering
        ui = { enable = false },
      })
    end,
  },

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard and snacks options
  {
    "folke/snacks.nvim",
    opts = {
      -- Animated indent scope guides
      indent = {
        enabled = true,
        animate = { enabled = true },
      },
      -- Smooth scrolling
      scroll = { enabled = true },
      -- Animated cursor
      animate = { enabled = true },
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
