[core]
	pager = diff-so-fancy | less
[color "diff-highlight"]
	oldNormal = red bold
	oldHighlight = red bold 52
	newNormal = green bold
	newHighlight = green bold 22
[difftool "code"]
	cmd = code --wait --diff $LOCAL $REMOTE

# vim: ft=gitconfig:
