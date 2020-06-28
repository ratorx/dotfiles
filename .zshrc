#! /usr/bin/zsh

# Configure instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ANTIBODYHOME="$HOME/.shell/antibody"
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
# bindkey '^[[1;5D' backward-word
# bindkey '^[[1;5C' forward-word
# bindkey "^[[H" beginning-of-line
# bindkey "^[[1~" beginning-of-line
# bindkey "^[[F" end-of-line
# bindkey "^[[4~" end-of-line
# bindkey '^[[3~' delete-char
# bindkey '^A' kill-whole-line
# bindkey '^X' sudo-command-line
# bindkey '^[.' insert-last-word
# bindkey "^?" backward-delete-char

# Options
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_EXPIRE_DUPS_FIRST AUTO_LIST NO_NOMATCH AUTO_CD

# Completions
export fpath=($XDG_DATA_HOME/zsh/completions $fpath)

autoload -Uz compinit
setopt EXTENDEDGLOB
for dump in $HOME/.zcompdump(#qN.m1); do
	compinit
	[[ -s "$dump" && (! -s "$dump.zwc" || "$dump" -nt "$dump.zwc") ]] && zcompile "$dump"
done
unsetopt EXTENDEDGLOB
compinit -C

# Bash completions
autoload -Uz bashcompinit
bashcompinit

# Load common aliases and functions
[ -f "$HOME/.shell/aliases" ] && source "$HOME/.shell/aliases"

# Antibody
source "$ANTIBODYHOME/load.zsh"
antibody bundle < "$ANTIBODYHOME/plugins"
config[antibody]="$ANTIBODYHOME/plugins"

# Prompt config
[[ ! -f ~/.shell/zsh/p10k.zsh ]] || source ~/.shell/zsh/p10k.zsh

# FZF
if exists fzf; then
	[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
	[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

	[ -f "$HOME"/.fzf/bin/completion.zsh ] && source "$HOME"/.fzf/bin/completion.zsh
	[ -f "$HOME"/.fzf/bin/key-bindings.zsh ] && source "$HOME"/.fzf/bin/key-bindings.zsh

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
