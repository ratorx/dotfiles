#! /usr/bin/zsh
if command -v nvim >/dev/null; then
    export editor=nvim
    export EDITOR=nvim
else
    export editor=vi
    export EDITOR=vi
fi

export LESSHISTFILE=/dev/null
export LESS=-Frix4
export SYSTEMD_LESS="$LESS"

export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=1

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# GTK 2
command -v gtk-demo >/dev/null && export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# Pass
command -v pass >/dev/null && export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"

# Go
if command -v go >/dev/null; then
    export GOPATH="$XDG_DATA_HOME/go"
    export GOBIN="$GOPATH/bin"
    export path=($GOBIN $path)
fi

# Rust
if command -v rustc >/dev/null; then
    export CARGO_HOME="$XDG_DATA_HOME/cargo"
    export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
    export RUST_SRC_PATH="$RUSTUP_HOME/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"
    export path=($CARGO_HOME/bin $path)
    if command -v sccache >/dev/null; then
        RUSTC_WRAPPER=sccache
    fi
fi

# Android
command -v adb >/dev/null && export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"

# Docker
command -v docker >/dev/null && export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# HTTPie
command -v http >/dev/null && export HTTPIE_CONFIG_DIR="$XDG_CONFIG_HOME/httpie"

# Elinks
command -v elinks >/dev/null && export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"

# Pylint
command -v pylint >/dev/null && export PYLINTHOME="$XDG_CACHE_HOME/pylint"

if [ -f /usr/lib/modprobe.d/nvidia.conf ]; then # Nvidia
    export __GL_SHADER_DISK_CACHE_PATH="$XDG_CACHE_HOME/nvidia"
    export LIBVA_DRIVER_NAME=vdpau
    export VDPAU_DRIVER=nvidia
    export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
else # Intel
    export LIBVA_DRIVER_NAME=iHD
    export VDPAU_DRIVER=va_gl
fi

# Local executables
# Add local bin before system bin
export path=($HOME/.local/bin $path)
typeset -U path
