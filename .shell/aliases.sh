function is_zsh() { [ -n "$ZSH_NAME" ]; }
function exists() { command -v "$1" >/dev/null; }
function completion_add() { [ -n "$ZPFX" ] && zicompdef "$@"; }

function yadm_setup() {
	local authkeys
	if [ -f "$HOME/.ssh/authorized_keys" ]; then
		authkeys="$(cat "$HOME/.ssh/authorized_keys")"
	fi

	yadm clone "https://dots.ree.to/repo"

	[[ -n "$authkeys" ]] && echo "$authkeys" >> "$HOME/.ssh/authorized_keys"
}

# Bookmarks
typeset -A bookmarks
function j() { cd "${bookmarks[$1]}" || return; }
if is_zsh; then
	# shellcheck disable=SC2154
	function _j() { _arguments "1:bookmark:(${(k)bookmarks})"; }
	completion_add _j j
fi

bookmarks[uni]="$HOME/projects/cambridge/ii"
bookmarks[diss]="$HOME/projects/cambridge/ii/project/dissertation"
bookmarks[continuity]="$HOME/projects/cambridge/ii/project/continuity"
bookmarks[web]="$HOME/projects/ree.to"

# Dotfiles
# shellcheck disable=SC2015
is_zsh && alias d='noglob yadm' || alias d='yadm'
exists git && [ -f "$XDG_CONFIG_HOME/git/diff.inc" ] && ! exists diff-so-fancy && rm "$XDG_CONFIG_HOME/git/diff.inc"

# AWS
if exists aws; then
	# shellcheck disable=SC2015,SC1091
	is_zsh && source /usr/bin/aws_zsh_completer.sh || source /usr/bin/aws_completer
fi

if exists gcloud && is_zsh; then
	source /opt/google-cloud-sdk/path.zsh.inc
	source /opt/google-cloud-sdk/completion.zsh.inc
fi

# Config function
typeset -A config
function cfg() {
	local old
	old="$(pwd)"
	cd "$HOME" || exit
	eval "$EDITOR" "${config[$1]}"
	cd "$old" || exit
}
if is_zsh; then
	# shellcheck disable=SC2154
	function _cfg() { _arguments "1:module:(${(k)config})"; }
	completion_add _cfg cfg
fi

# Systemd
systemd_sudo_commands=(start stop reload restart enable disable mask unmask edit daemon-reload reboot suspend poweroff)

if is_zsh; then
	function sc() {
		if [ "$#" -ne 0 ] && [ "${systemd_sudo_commands[(r)$1]}" == "$1" ]; then
			sudo systemctl "$@"
		else
			systemctl "$@"
		fi
	}
else
	function sc() {
		if [ "$#" -ne 0 ] && [[ " ${systemd_sudo_commands[*]} " = *" $1 "* ]]; then
			sudo systemctl "$@"
		else
			systemctl "$@"
		fi
	}
fi
is_zsh && completion_add sc=systemctl
alias scu="systemctl --user"

# Git

# shellcheck disable=SC2015
is_zsh && alias g='noglob git' || alias g='git'
alias g=git
config[git]="$XDG_CONFIG_HOME/git/*"

# Editor
alias vi='$EDITOR'
if exists nvim; then
	alias todo="nvim +Goyo ~/shared/TODO.md"
	function nvimbench() { bench="$(mktemp)" && /usr/bin/nvim --startuptime "$bench" "$@" && tail -1 "$bench" && rm -f "$bench"; }
	config[nvim]="$XDG_CONFIG_HOME/nvim/*.{vim,toml}"
fi

# Package Manager
PKGLIST='cat <(pacman -Qqe) <(pacman -Qqdtt)'
if exists pacman; then
	function pkgdiff() {
		local -a hostnames
		for var in "$@"; do
			hostnames+=("$var")
		done

		if [[ ${#hostnames[@]} -eq 1 ]]; then
			# shellcheck disable=SC2029
			icdiff -U 0 -L "$(hostname)" -L "${hostnames[1]}"  <(eval "$PKGLIST") <(ssh "${hostnames[1]}" "$PKGLIST")
		elif [[ ${#hostnames[@]} -eq 2 ]]; then
			# shellcheck disable=SC2029
			icdiff -U 0 -L "${hostnames[1]}" -L "${hostnames[2]}"  <(ssh "${hostnames[1]}" "$PKGLIST") <(ssh "${hostnames[2]}" "$PKGLIST")
		else
			echo "usage: pkgdiff <host 1> [host 2]"
			return 1
		fi
	}

	function pkgsnc() {
		local pkglist
		pkglist="$PKGLIST"

		case "$1" in
			explicit) pkglist="pacman -Qqe" ;;
			optional) pkglist="pacman -Qqdtt" ;;
		esac
		comm -13 <(pacman -Qgq base-devel | sort -u) <(eval "$pkglist" | grep -v ^base$ | sort -u)
	}
	alias pkgs='pkgsnc | column'

	function binaries() { pacman -Qql "$@" | sed -n '/\/usr\/bin\/./s/\/usr\/bin\///p'; }
	# shellcheck disable=SC2046
	function pkgsize() { pacman --config /dev/null -Rdd --print-format '%s' $(pactree -u "$@") | awk '{size+=$1} END { print size }' | numfmt --round=nearest --to=iec-i --suffix=B --format="%.1f"; }
fi

# Chrome
exists google-chrome-stable && alias chrome="google-chrome-stable"

# Irssi
exists irssi && alias irssi='irssi --config=$XDG_CONFIG_HOME/irssi/config --home=$XDG_DATA_HOME/irssi'

# File listing
if exists exa; then
	alias ls="exa -xF"
	alias lt="ls -T --group-directories-first"
	alias ll="exa -lF --git"
else
	alias ls="ls -xF"
	alias ll="\\ls -lF"
fi

alias la="ls -a"
alias lh="ls -d .*"
alias lla="ll -a"

# Filesystem operations
alias mv="mv -v"
alias rm="rm -Iv"
alias cp="cp -v"
alias df="df -hl"
alias du="du -h"
alias ncdu="ncdu -x"

exists udiskie-mount && alias rmount=udiskie-mount
exists udiskie-umount && alias rumount=udiskie-umount

# Use trash-put if available
# Not recommended, but very useful if used sparingly (and not relied on)
# shellcheck disable=SC2015
exists trash-put && alias rm=trash-put || alias rm="rm -Iv"
exists trash-list && alias tls=trash-list
exists trash-restore && alias tres=trash-restore

# Alias for going back directories
alias up=bd

# $HOME directory cleaning
HOMEDIR_ALLOWS="$XDG_CONFIG_HOME/homedir_allows"
# shellcheck disable=SC2139
alias check_homedir="fd -H --maxdepth 1 --ignore-file $HOMEDIR_ALLOWS >> $HOMEDIR_ALLOWS && '$EDITOR' $HOMEDIR_ALLOWS"

# Python
if exists bpython; then
	function python() {
		if [ "$#" -eq 0 ]; then
			bpython
		else
			/usr/bin/python "$@"
		fi
	}
fi

# SSH public key
function pub() {
	ssh-add -L | sed -n "0,/(none)/s//$USER@$HOST/p"
}

# Clipboard
if exists xclip; then
	function c() { tr -d '\n' | xclip -sel clip; }
	function copy() { c < "$1"; }
	alias v="xclip -o -sel clip"
	alias cpub="pub | tee >(c)"
fi

# Lastpass
if exists lpass && exists fzf; then
	function cpass() {
		lpass show -xjG "" | jq -r '.[] | "\(.name) (\(.username)) \(.password)"' | fzf --exit-0 --with-nth "..-2" | awk '{print $NF}' | c
	}
fi

# FZF
if exists fzf; then
	# shellcheck disable=SC2016
	exists rg && export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden --ignore-file $XDG_DATA_HOME/fzf/gitignore 2>/dev/null'
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
	# shellcheck disable=SC2016
	exists fd && export FZF_ALT_C_COMMAND='fd --type d --follow --no-ignore-vcs --hidden --ignore-file $XDG_DATA_HOME/fzf/gitignore 2>/dev/null'
fi

# Repl
typeset -A repl_cmd
typeset -A repl_def
repl_cmd[jq]='jq -r {q}'
repl_def[jq]='.'

repl_cmd[awk]='awk {q}'
repl_def[awk]='//'

function _repl_common() {
	stdin="$(< /dev/stdin)"
	fzf \
		--print-query \
		--query "${repl_def[$1]}" \
		--preview "${repl_cmd[$1]} <<< '$stdin'" \
		--preview-window "up:99%" \
		< /dev/null
}

# shellcheck disable=SC2015,SC2016
is_zsh && function repl() { echo "${repl_cmd[$1]//\{q\}/'$(_repl_common "$1")'}"; } \
			 || function repl() { echo "${repl_cmd[$1]//\{q\}/\'$(_repl_common "$1")\'}"; }

# IP
alias pubip="drill myip.opendns.com @resolver1.opendns.com | awk '!/;;/ && /IN/' | head -n 1 | awk '{ print \$NF	}'"
alias privip="hostname -i"

# Start Linux VM
function startvm() {
	ssh "$1" '"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm Linux --type headless'
}

# Config files
config[alacritty]="$XDG_CONFIG_HOME/alacritty/alacritty.yml##template"
config[bash]="$HOME/.bashrc $HOME/.bash_profile"
config[compton]="$XDG_CONFIG_HOME/compton/compton.conf"
config[dunst]="$XDG_CONFIG_HOME/dunst/dunstrc"
config[i3]="$XDG_CONFIG_HOME/i3/config.d/**/*.i3config"
config[kitty]="$XDG_CONFIG_HOME/kitty/kitty.conf##template"
config[latex]="$HOME/.latexmkrc"
config[polybar]="$XDG_CONFIG_HOME/polybar/config $XDG_CONFIG_HOME/polybar/modules/*"
config[ranger]="$XDG_CONFIG_HOME/ranger/*.conf $XDG_CONFIG_HOME/ranger/commands.py $XDG_CONFIG_HOME/ranger/scope.sh"
config[shell]="$HOME/.shell/aliases"
config[ssh]="$HOME/.ssh/config.d/*"
config[termite]="$XDG_CONFIG_HOME/termite/config"
config[tmux]="$HOME/.tmux.conf"
config[xorg]="$XDG_CONFIG_HOME/X11/*"
config[yadm]="$XDG_CONFIG_HOME/yadm/bootstrap"
config[zathura]="$XDG_CONFIG_HOME/zathura/zathurarc"
config[zsh]="$HOME/.zshrc $HOME/.zshenv $HOME/.zprofile $HOME/.shell/zsh/*"

unset -f is_zsh
# vim: set ft=sh:
