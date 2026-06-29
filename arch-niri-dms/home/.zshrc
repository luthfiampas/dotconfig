# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
# ZSH HISTORY SETTINGS
# ==============================================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_BEEP

# ==============================================================================
# ALIASES & INTERACTIVE INTERFACES
# ==============================================================================
alias virt-manager="env PYENV_VERSION=system virt-manager"

# Configure dircolors
if [ -r ~/.dircolors ]; then
  eval "$(dircolors -b ~/.dircolors)"
fi

# Configure auto suggestions plugin style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

# ==============================================================================
# OH MY ZSH THEME & PLUGINS INITS
# ==============================================================================
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  fzf
  git
  nvm
  pyenv
  zsh-autosuggestions
  zsh-bat
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ==============================================================================
# CONFIGURATION FOR TOOLS
# ==============================================================================
export FZF_CTRL_T_COMMAND='
  if [[ "$PWD" == "$HOME" ]]; then
    fd --type f --hidden \
      --exclude .git \
      --exclude .steam \
      --exclude .cache \
      --exclude .nvm \
      --exclude .nuget \
      --exclude .cargo \
      --exclude .npm \
      --exclude .mozilla \
      --exclude .codeium \
      --exclude .go \
      --exclude .rustup \
      --exclude .seafile \
      --exclude .thunderbird \
      --exclude .gnupg \
      --exclude .java \
      --exclude .swt \
      --exclude .windsurf \
      --exclude .pyenv \
      --exclude .ccnet \
      --exclude .ollama \
      --exclude .docker \
      --exclude .templateengine \
      --exclude .pki \
      --exclude .dotnet \
      --exclude .eclipse \
      --exclude .aspnet \
      --exclude .vscode \
      --exclude .local \
      --exclude .config/chromium \
      --exclude .config/blender \
      --exclude .config/go \
      --exclude .config/inkscape \
      --exclude .config/qbittorrent \
      --exclude .config/REAPER \
      --exclude .config/Upscayl \
      --exclude .config/Electron \
      --exclude .config/Code \
      --exclude .config/Bitwarden \
      --exclude .config/zed \
      --exclude .config/.avalonia-build-tasks \
      --exclude .config/calibre \
      --exclude .config/obs-studio \
      --exclude .config/sqlitebrowser
  else
    fd --type f --hidden --exclude .git --exclude node_modules
  fi
'
