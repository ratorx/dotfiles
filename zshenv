export editor="/usr/bin/nvim"
export EDITOR="/usr/bin/nvim"

export LESSHISTFILE=/dev/null
# Qt
case $(hostname) in
    (poseidon) export QT_SCALE_FACTOR=1.4; export QT_AUTO_SCREEN_SCALE_FACTOR=0;;
    (*) export QT_AUTO_SCREEN_SCALE_FACTOR=1;;
esac
# Go
export GOPATH="$HOME/.go"
export GOBIN="$HOME/.go/bin"
# Rust
export CARGO_HOME="$HOME/.cache/cargo"
export RUSTUP_HOME="$HOME/.cache/rustup"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
# HTTPie
export HTTPIE_CONFIG_DIR="$HOME/.config/httpie"

export PATH=$PATH:$GOPATH/bin:$CARGO_HOME/bin
