return {
  -- Completion
  {
    "saghen/blink.cmp",
    version = "*", -- use latest release tag (blink uses semver)
    dependencies = "rafamadriz/friendly-snippets",
    config = function()
      require("blink.cmp").setup({
        keymap = {
          preset = "default",
          ["<C-y>"] = { "select_and_accept" },
        },
        completion = {
          accept = { auto_brackets = { enabled = true } },
          list = {
            max_items = 200,
            selection = { auto_insert = false },
          },
          menu = { border = "rounded" },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
          },
        },
        signature = {
          enabled = true,
          window = { border = "rounded" },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
      })
    end,
  },

  { "rafamadriz/friendly-snippets", lazy = true },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.9,
            height = 0.9,
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = false,
          },
        },
      })
    end,
  },
}
