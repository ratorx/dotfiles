#! /usr/bin/zsh

# Configure instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export HISTFILE="$HOME/.bash_history"
export HISTSIZE=500000
export SAVEHIST=500000

typeset -U fpath

bindkey -e

function up-line-or-local-history() {
	zle set-local-history 1
	zle up-line-or-history
	zle set-local-history 0
}

function down-line-or-local-history() {
	zle set-local-history 1
	zle down-line-or-history
	zle set-local-history 0
}
zle -N up-line-or-local-history
zle -N down-line-or-local-history

# Key bindings
bindkey '^[[A' up-line-or-local-history
bindkey '^[[B' down-line-or-local-history

# Options
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_EXPIRE_DUPS_FIRST AUTO_LIST NO_NOMATCH AUTO_CD

# Completions
export fpath=($XDG_DATA_HOME/zsh/completions $fpath)

# Zinit
declare -A ZINIT
ZINIT[HOME_DIR]="$XDG_DATA_HOME/zinit"
# Bad form to run curled script, but we always run zinit.zsh anyway so the repository is already trusted.
ZINIT_SRC="${ZINIT[HOME_DIR]}/bin/zinit.zsh" 
if [ -f "$ZINIT_SRC" ]; then
	source "$ZINIT_SRC"

	zinit ice depth'1' atload'source ~/.shell/zsh/p10k.zsh'
	zinit light romkatv/powerlevel10k

	zinit wait lucid for \
		blockf zsh-users/zsh-completions \
		ratorx/zsh-bd \
		OMZP::sudo/sudo.plugin.zsh \
		OMZP::colored-man-pages/colored-man-pages.plugin.zsh \
		OMZP::command-not-found/command-not-found.plugin.zsh

	zinit ice wait lucid atinit"zpcompinit; zpcdreplay"
	zinit load zdharma/fast-syntax-highlighting
else
	function zinit() { ZINIT_HOME="${ZINIT[HOME_DIR]}" sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"; zsh -i -c -- 'zinit self-update'; }
fi
unset ZINIT_SRC

# Load common aliases and functions
[ -f "$HOME/.shell/aliases.sh" ] && source "$HOME/.shell/aliases.sh"

# FZF
if exists fzf; then
	source "$HOME/.shell/fzf.sh"

	# Override default FZF Ctrl+R
	# Enter to execute command
	function fzf-history-widget-customised() {
		local selected num
		setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
		selected=( $(fc -rl 1 | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort --expect=ctrl-e $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
		local ret=$?
		if [ -n "$selected" ]; then
			local accept=1
			if [[ $selected[1] = ctrl-e ]]; then
				accept=0
				shift selected
			fi
			num=$selected[1]
			if [ -n "$num" ]; then
				zle vi-fetch-history -n $num
				[[ $accept = 1 ]] && zle accept-line
			fi
		fi
		zle .reset-prompt
		return $ret
	}

zle -N fzf-history-widget-customised
bindkey '^R' fzf-history-widget-customised
fi
