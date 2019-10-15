function is_zsh() { [ -n "$ZSH_NAME" ]; }
function exists() { command -v "$1" >/dev/null; }
function path_add() { is_zsh && export path=("$1" $path) || export PATH="$1:$PATH"; }

# Neovim
if exists nvim; then
	export editor=nvim
	export EDITOR=nvim
else
	export editor=vi
	export EDITOR=vi
fi

export LESSHISTFILE=/dev/null
export LESS="--quit-if-one-screen --RAW-CONTROL-CHARS --ignore-case --mouse --tabs=2"
export SYSTEMD_LESS="$LESS"

export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=1
export QT_QPA_PLATFORMTHEME=gtk2

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
	path_add "$GOBIN"
fi

# Rust
if exists rustc; then
	export CARGO_HOME="$XDG_DATA_HOME/cargo"
	export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
	path_add "$CARGO_HOME/bin"
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

# GPG
[ -f "${GNUPGHOME:-$HOME/.gnupg}/sshcontrol" ] && export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh" && unset SSH_AGENT_PID

# Local executables
# Add local bin before system bin
path_add "$HOME/.local/bin"
is_zsh && typeset -U path

unset -f exists
unset -f is_zsh
unset -f path_add
