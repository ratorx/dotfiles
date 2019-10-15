#! /usr/bin/zsh
export ANTIBODYHOME="$HOME/.shell/antibody"
export HISTFILE="$HOME/.bash_history"
export HISTSIZE=500000
export SAVEHIST=500000

typeset -U fpath

# Terminal title
autoload -Uz add-zsh-hook
function xterm_title_precmd () { print -Pn '\e]2;%~\a' }
function xterm_title_preexec () { print -Pn '\e]2;'; print -n "${(q)1}\a" }
if [[ "$TERM" == (screen*|xterm*|rxvt*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

# Vim Keys
bindkey -v
KEYTIMEOUT=1

function zle-line-init zle-keymap-select {
	case ${KEYMAP} in
		(vicmd) echo -ne '\e[1 q' ;;
		(*)			echo -ne '\e[5 q' ;;
	esac
	zle .reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

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
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[4~" end-of-line
bindkey '^[[3~' delete-char
bindkey '^A' kill-whole-line
bindkey '^X' sudo-command-line
bindkey '^[.' insert-last-word
bindkey "^?" backward-delete-char

# Options
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_EXPIRE_DUPS_FIRST AUTO_LIST NO_NOMATCH AUTO_CD

# Completions
export fpath=($HOME/.local/share/zsh/completions $fpath)

autoload -Uz compinit
setopt EXTENDEDGLOB
for dump in $HOME/.zcompdump(#qN.m1); do
	compinit
	[[ -s "$dump" && (! -s "$dump.zwc" || "$dump" -nt "$dump.zwc") ]] && zcompile "$dump"
done
unsetopt EXTENDEDGLOB
compinit -C

# Bash Completions
autoload -Uz bashcompinit
bashcompinit

# Load common aliases and functions
[ -f "$HOME/.shell/aliases" ] && source "$HOME/.shell/aliases"

# Antibody
source "$ANTIBODYHOME/load.zsh"
antibody bundle < "$ANTIBODYHOME/plugins"
config[antibody]="$ANTIBODYHOME/plugins"

# Prompt Config
SPACESHIP_PROMPT_ORDER=(
	dir        # Current directory section
	git_branch # Git section (git_branch + git_status)
	exec_time  # Execution time
	line_sep   # Line break
	jobs       # Background jobs indicator
	venv       # virtualenv section
	char       # Prompt character
)

SPACESHIP_RPROMPT_ORDER=(
	user
	host
)

SPACESHIP_CHAR_SYMBOL=""
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_CHAR_PREFIX=""
SPACESHIP_CHAR_COLOR_SUCCESS="magenta"

SPACESHIP_DIR_TRUNC=0
SPACESHIP_DIR_COLOR="blue"
SPACESHIP_DIR_LOCK_SYMBOL="  "
SPACESHIP_DIR_PREFIX=" "

SPACESHIP_USER_SHOW="true"
SPACESHIP_USER_SUFFIX=""

SPACESHIP_HOST_SHOW="true"
SPACESHIP_HOST_PREFIX="@"

SPACESHIP_GIT_BRANCH_SYMBOL=""
SPACESHIP_GIT_BRANCH_PREFIX=""
SPACESHIP_GIT_BRANCH_COLOR="242"
SPACESHIP_GIT_STATUS_MODIFIED="*"
SPACESHIP_GIT_STATUS_AHEAD="↑"
SPACESHIP_GIT_STATUS_BEHIND="↓"
SPACESHIP_GIT_STATUS_DIVERGED="⇅"

SPACESHIP_EXEC_TIME_PREFIX=""
SPACESHIP_EXEC_TIME_ELAPSED="5"

SPACESHIP_VENV_PREFIX=""
SPACESHIP_VENV_COLOR="242"

# FZF
if spaceship::exists fzf; then
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

