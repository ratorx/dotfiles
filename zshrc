#!/usr/bin/zsh
export ANTIBODYPLUGINS="$HOME/.antibody/plugins"
export HISTFILE="$HOME/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

# Config home
export XDG_CONFIG_HOME=$HOME/.config

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
bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[4~" end-of-line
bindkey '^[[3~' delete-char
bindkey '^A' kill-whole-line

bindkey '^X' sudo-command-line

# Options
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt AUTO_LIST
setopt NO_NOMATCH

setopt AUTO_CD
cdpath=($HOME/Dropbox/Documents/Cambridge/IB $HOME/Projects)

# Aliases
alias e='$EDITOR'
alias vim="nvim"
alias pamac="pamac-manager"
alias chrome="google-chrome-stable"

alias ls="exa -xF"
alias la="ls -a"
alias lh="ls -d .*"

alias mv="mv -v"
alias rm="rm -iv"
alias cp="cp -v"

alias df="df -Pkhl"

# Utilities

alias c="perl -pe 'chomp if eof' | xclip -sel clip"
alias v="xclip -o -sel clip"

alias pub="cat $HOME/.ssh/id_rsa.pub"
alias cpub="pub | c | echo 'RSA public key copied.'"

alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

alias remove-orphans='pacaur -Rns $(pacaur -Qtdq)'

alias reload="source $HOME/.zshrc && echo 'Config reloaded.'"

alias pkgdiff='colordiff --suppress-common-lines -y <(pacman -Qqe) <(ssh zeus "pacman -Qqe")'
