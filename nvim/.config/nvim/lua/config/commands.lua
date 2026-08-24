-- Custom Commands

vim.api.nvim_create_user_command("Format", function()
  vim.lsp.buf.format({ async = true })
end, {})

-- Install all LSPs at once (correct Mason package names)
vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd("MasonInstall bash-language-server pyright gopls terraform-ls yaml-language-server lua-language-server json-lsp")
end, {})
