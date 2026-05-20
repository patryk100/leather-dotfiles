# --- OS Detection & Path ---
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS (Apple Silicon)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH=$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin:$PATH
    
    # Plugin paths for Homebrew
    ZSH_HIGHLIGHT_DIR="/opt/homebrew/share/zsh-syntax-highlighting"
    ZSH_AUTOSUGGEST_DIR="/opt/homebrew/share/zsh-autosuggestions"
    
    # macOS ls color flag
    LS_COLOR_FLAG="-G"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Fedora Linux
    export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH
    
    # Plugin paths for Fedora
    ZSH_HIGHLIGHT_DIR="/usr/share/zsh-syntax-highlighting"
    ZSH_AUTOSUGGEST_DIR="/usr/share/zsh-autosuggestions"
    
    # Linux ls color flag
    LS_COLOR_FLAG="--color=auto"

    # Linux-only Aliases
    alias mpv='flatpak run io.mpv.Mpv'
    alias okular='flatpak run org.kde.okular'
    alias obsidian='flatpak run md.obsidian.Obsidian'
    alias wezterm='flatpak run org.wezfurlong.wezterm --config-file=$HOME/.var/app/org.wezfurlong.wezterm/config/wezterm/wezterm.lua'
fi

export EDITOR=nvim
export KUBE_EDITOR=nvim
export AWS_PROFILE=default
export GRIM_DEFAULT_DIR="$HOME/Pictures/Screenshots"
export qemu=qemu-system-x86_64

# --- Tool Initializations ---
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# --- Zsh Integration ---
[[ -f "$ZSH_HIGHLIGHT_DIR/zsh-syntax-highlighting.zsh" ]] && \
    source "$ZSH_HIGHLIGHT_DIR/zsh-syntax-highlighting.zsh"

[[ -f "$ZSH_AUTOSUGGEST_DIR/zsh-autosuggestions.zsh" ]] && \
    source "$ZSH_AUTOSUGGEST_DIR/zsh-autosuggestions.zsh"

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
  # Uses the system 'ls' dynamically based on OS
  alias ls="command ls $LS_COLOR_FLAG"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
else
  # Uses the system 'cat' dynamically
  alias cat='command cat'
fi

alias k='kubectl'
alias qemu='qemu-system-x86_64'

# VPN & Workflow
alias vpn-up='sudo wg-quick up wg0-client'
alias vpn-down='sudo wg-quick down wg0-client'
alias vpn-status='sudo wg show'
alias vpn-toggle='if sudo wg show wg0-client &>/dev/null; then sudo wg-quick down wg0-client; else sudo wg-quick up wg0-client; fi'

# ----------------------------------------------------------------------------
#  Sane line-editing keys
# ----------------------------------------------------------------------------
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop  { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init   zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Delete]="${terminfo[kdch1]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Home]}"          ]] && bindkey -- "${key[Home]}"          beginning-of-line
[[ -n "${key[End]}"           ]] && bindkey -- "${key[End]}"           end-of-line
[[ -n "${key[Delete]}"        ]] && bindkey -- "${key[Delete]}"        delete-char
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

bindkey "^[[H"    beginning-of-line
bindkey "^[[F"    end-of-line
bindkey "^[[3~"   delete-char
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^H"      backward-kill-word
bindkey "^[[3;5~" kill-word
