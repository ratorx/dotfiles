#! /bin/bash
# Git Commit Browser (w/ previews)
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\\{7\\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

glog() {
    git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@" |
    fzf --no-sort --reverse --tiebreak=index --no-multi --ansi --exit-0 --preview "$_viewGitLogLine" | 
    grep -o '[a-f0-9]\{7\}' | 
    tr -d '\n' | 
    xclip -i -sel clip >/dev/null 2>&1

    # Send through exit code
    e=$? && [ $e -eq 130 ] || [ $e -eq 1 ] || return $e
}

glog "$@"
