return {
  -- LSP base configs (provides default cmd/root_dir/filetypes for each server)
  -- On Neovim 0.11+, this puts server configs in runtimepath so vim.lsp.enable() works
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/lazydev.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Set up all LSP configs using native 0.11+ API
      require("config.lsp.servers").setup()
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason LSP bridge - just handles installation, LSP is configured natively above
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "pyright",
          "gopls",
          "terraformls",
          "yamlls",
          "lua_ls",
          "jsonls",
        },
        automatic_installation = true,
      })
    end,
  },

  -- Null-ls (formatters + linters)
  {
    "nvimtools/none-ls.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local null_ls = require("null-ls")
          null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black.with({ extra_args = { "--line-length=100" } }),
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.terraform_fmt,
          null_ls.builtins.diagnostics.golangci_lint,
        },
      })
    end,
  },

  -- LSP signature help
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    config = function()
      require("lsp_signature").setup({
        bind = true,
        handler_opts = { border = "rounded" },
      })
    end,
  },

  -- Lazydev for editing your Lua config
  {
    "folke/lazydev.nvim",
    ft = "lua",
    config = function()
      require("lazydev").setup()
    end,
  },
}
