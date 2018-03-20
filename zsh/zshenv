if command -v nvim >/dev/null; then
    export editor=nvim
    export EDITOR=nvim
else
    export editor=vi
    export EDITOR=vi
fi

export LESSHISTFILE=/dev/null

export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=1

export XDG_CONFIG_HOME=$HOME/.config

# Go setup
if command -v go >/dev/null; then
    export GOPATH="$HOME/.go"
    export GOBIN="$HOME/.go/bin"
    [ -z $PATH_APP ] && export PATH_APP=$GOBIN || export PATH_APP=$PATH_APP:$GOBIN
fi

# Rust setup
if command -v rustc >/dev/null; then
    export CARGO_HOME="$HOME/.cache/cargo"
    export RUSTUP_HOME="$HOME/.cache/rustup"
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
    [ -z $PATH_APP ] && export PATH_APP=$CARGO_HOME/bin || export PATH_APP=$PATH_APP:$CARGO_HOME/bin
fi

# HTTPie setup
command -v http >/dev/null && export HTTPIE_CONFIG_DIR="$HOME/.config/httpie"
