-- LSP Configuration using native Neovim 0.11+ API
-- Uses vim.lsp.config() and vim.lsp.enable() instead of deprecated require('lspconfig').setup()

local M = {}

-- LSP Deduplication Handler (from your polish.lua)
local function filter_definitions(err, result, ctx, config)
  if err then return end
  if not result or vim.tbl_isempty(result) then return end
  local results = vim.is_list(result) and result or { result }
  local unique_results = {}
  local seen = {}

  for _, res in ipairs(results) do
    local uri = res.uri or res.targetUri
    local range = res.range or res.targetSelectionRange
    local path = vim.uri_to_fname(uri)
    local real_path = vim.fn.fnamemodify(path, ":p")
    local key = string.format("%s:%s", real_path, range.start.line)

    if not seen[key] then
      seen[key] = true
      table.insert(unique_results, res)
    end
  end

  if #unique_results == 1 then
    vim.lsp.util.jump_to_location(unique_results[1], "utf-8")
  else
    vim.lsp.handlers["textDocument/definition"] = vim.lsp.with(vim.lsp.handlers.definition, { on_list = nil })
    vim.lsp.buf.definition()
  end
end

vim.lsp.handlers["textDocument/definition"] = filter_definitions

-- Diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- LSP keymaps attached automatically when any LSP starts
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local opts = { buffer = bufnr, noremap = true, silent = true }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)

    -- Let null-ls handle formatting for languages with dedicated formatters
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then
      if client:supports_method("textDocument/formatting") then
        client.server_capabilities.documentFormattingProvider = false
      end
      if client:supports_method("textDocument/rangeFormatting") then
        client.server_capabilities.documentRangeFormattingProvider = false
      end
    end
  end,
})

-- Setup function called from plugins/lsp.lua after blink.cmp loads
function M.setup()
  local has_blink, blink = pcall(require, "blink.cmp")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if has_blink then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  -- Global defaults for all LSPs
  vim.lsp.config("*", {
    capabilities = capabilities,
  })

  -- Per-server overrides (nvim-lspconfig ships base configs, we layer on top)
  vim.lsp.config("pyright", {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "standard",
          autoImportCompletions = true,
        },
      },
    },
  })

  vim.lsp.config("gopls", {
    settings = {
      gopls = {
        gofumpt = true,
        usePlaceholders = true,
      },
    },
  })

  vim.lsp.config("yamlls", {
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/kube-strict-1.29.json"] = "k8s*.yaml",
          ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.yaml",
        },
      },
    },
  })

  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
      },
    },
  })

  -- Enable all servers (nvim-lspconfig provides the base configs)
  vim.lsp.enable({
    "bashls",
    "pyright",
    "gopls",
    "terraformls",
    "yamlls",
    "lua_ls",
    "jsonls",
  })
end

return M
