#!/usr/bin/zsh
export ANTIBODYPLUGINS="$HOME/.antibody/plugins"
export HISTFILE="$HOME/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

# set cursor
echo -e -n "\x1b[\x36 q"

# antibody
source "$HOME/.antibody/load.zsh"
antibody bundle < "$ANTIBODYPLUGINS"

# fzf
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd -I --type d'

# completions
autoload -U compinit && compinit
source /usr/share/fzf/completion.zsh

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
source /usr/share/fzf/key-bindings.zsh

# Options
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt AUTO_LIST
setopt NO_NOMATCH
setopt AUTO_CD

# Aliases
alias edit='$EDITOR'
alias vim="nvim"
alias pamac="pamac-manager"
alias pacman="pacman --color=always"
alias pacaur="pacaur --color=always"
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
function copy() { cat $1 | c }
alias v="xclip -o -sel clip"
alias pub="cat $HOME/.ssh/id_rsa.pub"
alias cpub="pub | c | echo 'RSA public key copied.'"
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias privip="hostname -i"
alias remove-orphans='pacaur -Rns $(pacaur -Qtdq)'
function pkgdiff() {
    flags="-Qqe"
    hostname=""
    if [ $# -eq 1 ]; then
        hostname=$1
    elif [ $# -eq 2 ]; then
        flags=$1
        hostname=$2
    else
        echo "usage: pkgdiff [flags] <hostname>"
        return 1
    fi

    icdiff -U 0 <(pacman $flags) <(ssh $hostname "pacman $flags")
}
alias nvimconfig="nvim ~/.config/nvim/config.vim ~/.config/nvim/plugins.vim"
function nvimbench() {
    bench=$(mktemp) && /usr/bin/nvim --startuptime $bench $@ && tail -1 $bench && rm -f $bench
}

