export editor="/usr/bin/nvim"
export EDITOR="/usr/bin/nvim"

export LESSHISTFILE=/dev/null
# Go
export GOPATH="$HOME/.go"
export GOBIN="$HOME/.go/bin"
# Rust
export CARGO_HOME="$HOME/.cache/cargo"
export RUSTUP_HOME="$HOME/.cache/rustup"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

export PATH=$PATH:$GOPATH/bin:$CARGO_HOME/bin
