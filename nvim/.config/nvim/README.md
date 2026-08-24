# Stable Neovim 0.11.x+ Configuration

A minimal, maintainable Neovim config with LSP for bash, python, go, terraform, k8s yaml.

## Version Strategy

This config does NOT pin commit hashes in plugin specs. Instead:

1. **First install**: lazy pulls the latest from each plugin's branch
2. **`lazy-lock.json` is auto-generated** with real, working commits
3. **That lock file becomes your stability lock** — commit it to git
4. **`:Lazy restore`** goes back to lock file versions if updates break things
5. **`:Lazy update`** updates all plugins and rewrites the lock file

This is the correct pattern for lazy.nvim. Pinned commits in specs only work if the maintainer never force-pushes; branches are safer.

## Installation

### 1. Backup and clear

```bash
mv ~/.config/nvim ~/.config/nvim.bak
rm -rf ~/.local/share/nvim/lazy
```

### 2. Install

```bash
tar xzf nvim-stable-config.tar.gz -C ~/.config
mv ~/.config/nvim-config ~/.config/nvim
nvim
```

### 3. Wait for plugins to install

Lazy will show a UI. Wait for everything to finish (green checkmarks).

### 4. Install LSPs

```
:MasonInstallAll
```

### 5. Lock your versions

Once everything works, commit `~/.config/nvim/lazy-lock.json` to a git repo. This is your snapshot; you can always `:Lazy restore` to get back here.

## LSP Servers

Installed via Mason:
- `bash-language-server` (Bash)
- `pyright` (Python)
- `gopls` (Go)
- `terraform-ls` (Terraform)
- `yaml-language-server` (K8s YAML with schema validation)
- `nil` (Nix)
- `lua-language-server` (Lua)
- `json-lsp` (JSON)

Formatters/linters via null-ls:
- `black` (Python format)
- `gofmt`, `golangci-lint` (Go)
- `terraform fmt`
- `shellcheck` (Bash)

## Key Bindings

**General:**
- `<Space>` = leader
- `<Space>w` = save
- `<Space>q` = quit
- `<Space>e` = toggle neo-tree
- `<Esc>` = clear search highlight

**Telescope:**
- `<Space>ff` = find files
- `<Space>fg` = live grep
- `<Space>fb` = buffers
- `<Space>fh` = help

**LSP:**
- `gd` = definition (with dedup!)
- `K` = hover
- `gr` = references
- `<Space>rn` = rename
- `<Space>ca` = code action
- `<Space>f` = format

**Motion:**
- `s` = flash jump
- `S` = treesitter jump
- `<C-a>` / `<C-x>` = increment/decrement

## Updating

```vim
:Lazy update
```

If something breaks:
```vim
:Lazy restore
```

## Troubleshooting

**Plugin didn't install:**
```vim
:Lazy sync
```

**LSP not attaching:**
```vim
:LspInfo
:Mason
```

**Treesitter parser missing:**
```vim
:TSUpdate
```
