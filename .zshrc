
#!/usr/bin/env zsh
antibody() {
	case "$1" in
	bundle)
		source <( /usr/bin/antibody $@ ) 2> /dev/null || /usr/bin/antibody $@
		;;
	*)
		/usr/bin/antibody $@
		;;
	esac
}

_antibody() {
	IFS=' ' read -A reply <<< "$(echo "bundle update list home init help")"
}
compctl -K _antibody antibody

export HISTFILE=.zhistory
export HISTSIZE=500
export SAVEHIST=1000

antibody bundle < ~/.zplugins

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
