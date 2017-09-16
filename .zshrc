#!/usr/bin/zsh
export ANTIBODYDIR="$HOME/.antibody"
export ANTIBODYPLUGINS="$ANTIBODYDIR/plugins"
export HISTFILE="$HOME/.zhistory"
export ALIASFILE="$HOME/.zalias"
export HISTSIZE=10000
export SAVEHIST=10000

# Antibody
source "$ANTIBODYDIR/init.zsh"

# Load everything

# Plugins
antibody bundle < "$ANTIBODYPLUGINS"

# Completions
autoload -U compinit && compinit

# Aliases
source "$ALIASFILE"

# Key Bindings
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

bindkey '^[[1;5A' history-substring-search-up
bindkey '^[[1;5B' history-substring-search-down
bindkey '^X' prepend-sudo

# Options
export HISTORY_SUBSTRING_SEARCH_FUZZY="true"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt AUTO_LIST

setopt AUTO_CD
cdpath=($HOME/Projects cdpath)
