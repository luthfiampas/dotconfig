# ==============================================================================
# DEKORASI & WINDOW MANAGER
# ==============================================================================
export XDG_CURRENT_DESKTOP=niri
export XDG_SESSION_DESKTOP=niri
export XDG_SESSION_TYPE=wayland

export MOZ_ENABLE_WAYLAND=1
export ELECTRON_OZONE_PLATFORM_HINT=auto
export QT_QPA_PLATFORM="wayland;xcb"
export QT_SCREEN_SCALE_FACTORS="1;1"
export GTK_USE_PORTAL=1

export _JAVA_AWT_WM_NONREPARENTING=1
export AVALONIA_GLOBAL_SCALE_FACTOR=1
export WGPU_BACKEND=gl

# ==============================================================================
# DEFAULT UTILITIES & SYSTEM CONFIG
# ==============================================================================
export EDITOR=vim
export SYSTEMD_EDITOR=vim
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# ==============================================================================
# OH MY ZSH DIRECTORY
# ==============================================================================
export ZSH="$HOME/.oh-my-zsh"

# ==============================================================================
# RUNTIME CONFIGURATIONS
# ==============================================================================
# Java & Gradle
export JAVA_HOME=/usr/lib/jvm/java-26-openjdk
export GRADLE_USER_HOME=$HOME/.gradle
export GRADLE_OPTS="--enable-native-access=ALL-UNNAMED"
export KOTLIN_DAEMON_DIR=$HOME/.gradle/kotlin

# Android SDK
export ANDROID_SDK_ROOT=/opt/android-sdk

# .NET
export DOTNET_gcServer=0
export DOTNET_GCHeapHardLimit=100000000

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Go
export GOPATH=$HOME/.go

# Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ==============================================================================
# SYSTEM PATH
# ==============================================================================
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH
export PATH="$HOME/.flutter/bin:$PATH"
export PATH=$GOPATH/bin:$PATH
export PATH=$HOME/.dotnet/tools:$PATH
export PATH=$PATH:~/.scripts
