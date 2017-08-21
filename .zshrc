
#!/usr/bin/env zsh
export ANTIBODYDIR="$HOME/.antibody"
export ANTIBODYPLUGINS="$ANTIBODYDIR/plugins"
export HISTFILE="$HOME/.zhistory"
export HISTSIZE=500
export SAVEHIST=1000

# Antibody
source "$ANTIBODYDIR/init.zsh"
# Load plugins
antibody bundle < "$ANTIBODYPLUGINS"

# History sub-string-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Completions
autoload -U compinit && compinit

# Custom
# Aliases
alias ls="ls --color=auto"
alias code="code-insiders"

# Options
setopt AUTO_CD
cdpath=($HOME/Projects cdpath)
