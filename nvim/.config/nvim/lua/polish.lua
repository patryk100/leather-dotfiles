-- lua/polish.lua
-- NO WRAPPER: This code runs the moment it is required

-- 1. Create the filter function
local function filter_definitions(err, result, ctx, config)
  if err then return end
  if not result or vim.tbl_isempty(result) then return end

  local results = vim.is_list(result) and result or { result }
  local unique_results = {}
  local seen = {}

  -- Add this inside your loop in polish.lua if duplicates persist
  for _, res in ipairs(results) do
    local uri = res.uri or res.targetUri
    local range = res.range or res.targetSelectionRange
    
    -- Normalize the path (handles symlinks and ../ common in venvs)
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
    -- Fallback to default handler if there are truly multiple locations
    vim.lsp.handlers["textDocument/definition"] = vim.lsp.with(
      vim.lsp.handlers.definition, { on_list = nil }
    )
    vim.lsp.buf.definition()
  end
end

-- 2. Apply the override globally
vim.lsp.handlers["textDocument/definition"] = filter_definitions

-- Optional: Print to the console so you KNOW it worked
-- print("LSP Deduplication Active!")
