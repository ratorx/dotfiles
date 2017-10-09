#!/usr/bin/zsh
export ANTIBODYPLUGINS="$HOME/.antibody/plugins"
export HISTFILE="$HOME/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

# Antibody
source "$HOME/.antibody/load.zsh"

# Load everything

# Plugins
antibody bundle < "$ANTIBODYPLUGINS"

# Completions
autoload -U compinit && compinit

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
setopt NO_NOMATCH

setopt AUTO_CD
cdpath=($HOME/Projects cdpath)

# Aliases
alias e='$EDITOR'
alias vim="nvim"
alias pamac="pamac-manager"
alias chrome="google-chrome-stable"

alias ls="ls -xF --color=auto"
alias la="ls -A"
alias lh="ls -d .*"

alias mv="mv -v"
alias rm="rm -iv"
alias cp="cp -v"

alias df="df -Pkhl"

# Git
alias gs="git status -sb"

alias gd="git diff"
alias gpl="git pull"
alias gps="git push"
alias gcl="git clone"
alias gf="git fetch"
alias gco="git checkout"

alias ga="git add"
alias gaa="git add ."

alias gc="git commit -m"
alias gca="git commit -am"

# Utilities

alias c="perl -pe 'chomp if eof' | xclip -sel clip"
alias v="xclip -o -sel clip"

alias pub="cat $HOME/.ssh/id_rsa.pub"
alias cpub="pub | c | echo 'RSA public key copied.'"

alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

alias remove-orphans='pacaur -Rns $(pacaur -Qtdq)'

alias reload="source $HOME/.zshrc && echo 'Config reloaded.'"

alias pkgdiff='colordiff --suppress-common-lines -y <(ssh poseidon "pacman -Qqe") <(ssh zeus "pacman -Qqe")'
