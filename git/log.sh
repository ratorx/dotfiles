#! /usr/bin/zsh
# Git Commit Browser (w/ previews)
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

glog() {
    git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@" |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
        --ansi --preview $_viewGitLogLine \
        --header "enter to view, alt-y to copy hash" \
        --bind "enter:execute:$_viewGitLogLine   | less -R" \
        --bind "alt-y:execute:$_gitLogLineToHash | xclip -sel clip"
}

glog "$@"
