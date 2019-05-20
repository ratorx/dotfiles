#! /usr/bin/zsh
function is_zsh() { [ -n "$ZSH_NAME" ]; }
function exists() { exists "$1"; }

if exists nvim; then
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
exists gtk-demo && export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# Pass
exists pass && export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"

# Go
if exists go; then
    export GOPATH="$XDG_DATA_HOME/go"
    export GOBIN="$GOPATH/bin"
    export path=($GOBIN $path)
fi

# Rust
if exists rustc; then
    export CARGO_HOME="$XDG_DATA_HOME/cargo"
    export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
    export RUST_SRC_PATH="$RUSTUP_HOME/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"
    export path=($CARGO_HOME/bin $path)
    if exists sccache; then
        RUSTC_WRAPPER=sccache
    fi
fi

# Android
exists adb && export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"

# Docker
exists docker && export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# HTTPie
exists http && export HTTPIE_CONFIG_DIR="$XDG_CONFIG_HOME/httpie"

# Elinks
exists elinks && export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"

# Pylint
exists pylint && export PYLINTHOME="$XDG_CACHE_HOME/pylint"

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
is_zsh && typeset -U path

unset -f exists
unset -f is_zsh
