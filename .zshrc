
#!/usr/bin/env zsh
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

# Options
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export HISTORY_SUBSTRING_SEARCH_FUZZY="true"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt AUTO_LIST

setopt AUTO_CD
cdpath=($HOME/Projects cdpath)
