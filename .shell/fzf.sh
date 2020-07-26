function is_zsh() { [ -n "$ZSH_NAME" ]; }
# shellcheck disable=SC1090
function optional_source() { [ -f "$1" ] && source "$1"; }
# shellcheck disable=SC2015
function shell_source() { is_zsh && optional_source "$1.zsh" || optional_source "$1.bash"; }

# Global Linux install
shell_source "/usr/share/fzf/completion"
shell_source "/usr/share/fzf/key-bindings"

# Local install
shell_source "$HOME/.fzf/bin/completion"
shell_source "$HOME/.fzf/bin/key-bindings"

# Homebrew OS X install
shell_source "$HOME/.fzf"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"'
--color=dark
--color=fg:-1,bg:-1
--color=fg+:3,bg+:-1
--color=preview-fg:-1,preview-bg:-1
--color=hl:-1,hl+:3,gutter:-1,pointer:5,border:15
--color=prompt:5,marker:5,info:3,spinner:3,header:-1
'
