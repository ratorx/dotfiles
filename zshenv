export editor=nvim
export EDITOR=nvim

export LESSHISTFILE=/dev/null

export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=1

export GOPATH="$HOME/.go"
export GOBIN="$HOME/.go/bin"

export CARGO_HOME="$HOME/.cache/cargo"
export RUSTUP_HOME="$HOME/.cache/rustup"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

export HTTPIE_CONFIG_DIR="$HOME/.config/httpie"

export XDG_CONFIG_HOME=$HOME/.config

export ANDROID_SDK_HOME=$HOME/.config/android
export ANDROID_SDK_ROOT=$HOME/.cache/android
export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1

export PATH=$PATH:$GOPATH/bin:$CARGO_HOME/bin
