# --- Path & Environment ---
# Fixed: Corrected the path to your actual home and added local bins
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH
export EDITOR=nvim
export KUBE_EDITOR=nvim
export AWS_PROFILE=default
export GRIM_DEFAULT_DIR="$HOME/Pictures/Screenshots"
export qemu=qemu-system-x86_64

# --- Tool Initializations ---
# These are the Rust-powered replacements for OMZ
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# --- Zsh Integration (From your Leather-OS DNF packages) ---
# These paths are standard for Fedora/uBlue packages
[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- History Configuration ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# --- Aliases ---
# Modern CLI Tools
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lh --icons --group-directories-first'
  alias la='eza -a --icons --group-directories-first'
else
  alias ls='/usr/bin/ls --color=auto'
fi
if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
else
  alias cat='/usr/bin/cat'
fi
alias k='kubectl'
alias qemu='qemu-system-x86_64'

alias mpv='flatpak run io.mpv.Mpv'
alias okular='flatpak run org.kde.okular'
alias obsidian='flatpak run md.obsidian.Obsidian'
# VPN & Workflow
alias vpn-up='sudo wg-quick up wg0-client'
alias vpn-down='sudo wg-quick down wg0-client'
alias vpn-status='sudo wg show'
alias vpn-toggle='if sudo wg show wg0-client &>/dev/null; then sudo wg-quick down wg0-client; else sudo wg-quick up wg0-client; fi'
alias wezterm='flatpak run org.wezfurlong.wezterm --config-file=$HOME/.var/app/org.wezfurlong.wezterm/config/wezterm/wezterm.lua'

# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/bin/terraform terraform
