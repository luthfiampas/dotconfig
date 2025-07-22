# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zsh History Settings
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

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Configure aliases
alias spotify="spotify_player"
alias virt-manager="env PYENV_VERSION=system virt-manager"

# Configure functions
cd_cloud() {
  builtin cd "/cloud/me/$1"
}

cd_local() {
  builtin cd "/local/me/$1"
}

# Configure pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Configure nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Configure dotnet tools
export PATH=$HOME/.dotnet/tools:$PATH

# Configure go
export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH

# Configure rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Configure ssh-agent service
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# Add .bin PATH
export PATH=$PATH:~/.bin

# Configure default editors
export EDITOR=vim
export SYSTEMD_EDITOR=vim

# Configure auto suggestions plugin
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

# Configure dircolors
if [ -r ~/.dircolors ]; then
  eval "$(dircolors -b ~/.dircolors)"
fi

# Configure theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Configure plugins
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
