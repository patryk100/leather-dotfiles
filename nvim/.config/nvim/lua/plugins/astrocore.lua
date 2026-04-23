-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- 1. Autocommands (The wrapping fix)
    autocmds = {
      lsp_float_wrap = {
        {
          event = "WinNew",
          callback = function()
            local winid = vim.api.nvim_get_current_win()
            local conf = vim.api.nvim_win_get_config(winid)
            if conf.relative ~= "" then
              vim.wo[winid].wrap = true
              vim.wo[winid].linebreak = true
            end
          end,
        },
      },
    },

    -- 2. Features
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },

    -- 3. Diagnostics
    diagnostics = {
      virtual_text = true,
      underline = true,
      float = {
        border = "rounded",
        source = "always",
      },
    },

    -- 4. Filetypes
    filetypes = {
      extension = { foo = "fooscript" },
      filename = { [".foorc"] = "fooscript" },
      pattern = { [".*/etc/foo/.*"] = "fooscript" },
    },

    -- 5. Vim Options
    options = {
      opt = {
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false, -- Main buffer doesn't wrap, only floats will (via autocmd)
      },
      g = {
        -- mapleader is usually set in lazy_setup.lua
      },
    },

    -- 6. Mappings
    mappings = {
      -- "n" for Normal Mode
      n = {
        -- Smart Python Runner
        ["<Leader>r"] = {
          function()
            local venv = vim.fn.getcwd() .. "/venv/bin/python"
            local python_bin = "python3" -- default fallback

            if vim.fn.filereadable(venv) == 1 then
              python_bin = venv
            end

            -- Run in a floating ToggleTerm
            vim.cmd("TermExec cmd='" .. python_bin .. " " .. vim.fn.expand("%") .. "' direction=float")
          end,
          desc = "Run Python in venv (Floating)",
        },

        -- Keep your buffer navigation
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
      },

      -- "t" for Terminal Mode (Very important!)
      t = {
        -- This lets you hit Esc to get to Normal mode inside the terminal
        ["<Esc>"] = { [[<C-\><C-n>]], desc = "Escape terminal mode" },
      },
    },
  },
}
