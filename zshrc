#!/usr/bin/zsh
export ANTIBODYPLUGINS="$HOME/.antibody/plugins"
export HISTFILE="$HOME/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

# set cursor
echo -e -n "\x1b[\x36 q"

# completions
autoload -U compinit && compinit

# key bindings
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

# options
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt AUTO_LIST
setopt NO_NOMATCH
setopt AUTO_CD

# antibody
source "$HOME/.antibody/load.zsh"
antibody bundle < "$ANTIBODYPLUGINS"

# fzf
if command -v fzf >/dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd -I --type d'
    
    # Git Commit Browser (w/ previews)
    alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
    local _gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    local _viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"
    unalias glog

    function glog() {
        glNoGraph |
            fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview $_viewGitLogLine \
            --header "enter to view, alt-y to copy hash" \
            --bind "enter:execute:$_viewGitLogLine   | less -R" \
            --bind "alt-y:execute:$_gitLogLineToHash | xclip -sel clip"
    }
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
fi

# editor
alias edit='$EDITOR'
if command -v nvim >/dev/null; then
    alias vim="nvim"
    alias nvimconfig="nvim ~/.config/nvim/config.vim ~/.config/nvim/plugins.vim"
    function nvimbench() {
        bench=$(mktemp) && /usr/bin/nvim --startuptime $bench $@ && tail -1 $bench && rm -f $bench
    }
fi

# package manager
if command -v pacman >/dev/null; then
    alias pacman="pacman --color=always"
    function pkgdiff() {
        flags="-Qqe"
        hostname=""

        if ! command -v icdiff >/dev/null; then
            echo "pkgdiff requires icdiff"
            return 1
        fi

        if [ $# -eq 1 ]; then
            hostname=$1
        elif [ $# -eq 2 ]; then
            flags=$1
            hostname=$2
        else
            echo "usage: pkgdiff [flags] <hostname>"
            return 1
        fi

        icdiff -U 0 -L "$(hostname)" -L "$hostname" <(pacman $flags) <(ssh $hostname "pacman $flags")
    }
    alias remove-orphans='pacman -Rns $(pacman -Qtdq)'
fi

command -v pacaur >/dev/null && alias pacaur="pacaur --color=always"
command -v pamac-manager >/dev/null && alias pamac="pamac-manager"

# chrome
command -v google-chrome-stable >/dev/null && alias chrome="google-chrome-stable"

# file listing
command -v exa >/dev/null && alias ls="exa -xF" || alias ls="ls -xF"
alias la="ls -a"
alias lh="ls -d .*"
alias ll="ls -lF"

# filesystem operations
alias mv="mv -v"
alias rm="rm -iv"
alias cp="cp -v"
alias df="df -hl"
alias du="du -h"

# clipboard
alias c="perl -pe 'chomp if eof' | xclip -sel clip"
function copy() { cat $1 | c }
alias v="xclip -o -sel clip"

# SSH public key
alias pub="cat $HOME/.ssh/id_rsa.pub"
alias cpub="pub | c | echo 'RSA public key copied.'"

# IP
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias privip="hostname -i"

