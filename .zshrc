#! /usr/bin/zsh
export ANTIBODYHOME="$HOME/.antibody"
export HISTFILE="$HOME/.bash_history"
export HISTSIZE=50000
export SAVEHIST=50000

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
    (*)     echo -ne '\e[5 q' ;;
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
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt AUTO_LIST
setopt NO_NOMATCH
setopt AUTO_CD

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

# Dotfiles
alias d=yadm

# Config function
typeset -A config
function cfg() {
  local old
  old="$(pwd)"
  cd "$HOME"
  eval $EDITOR ${config[$1]}
  cd "$old"
}
function _cfg() { _arguments "1:module:(${(k)config})" }
compdef _cfg cfg

typeset -A bookmarks
function j() { cd "${bookmarks[$1]}" }
function _j() { _arguments "1:bookmark:(${(k)bookmarks})" }
compdef _j j

bookmarks[uni]="$HOME/projects/cambridge/ii"
bookmarks[diss]="$HOME/projects/cambridge/ii/project/dissertation"
bookmarks[continuity]="$HOME/projects/cambridge/ii/project/continuity"
bookmarks[web]="$HOME/projects/ree.to"

# Antibody
source "$ANTIBODYHOME/load.zsh"
antibody bundle < "$ANTIBODYHOME/plugins"
config[antibody]="$ANTIBODYHOME/plugins"

## AWS
if spaceship::exists aws; then
  source /usr/bin/aws_zsh_completer.sh
fi

## Travis
if spaceship::exists travis; then
  source $HOME/.travis/travis.sh
fi

# Prompt Config
SPACESHIP_PROMPT_ORDER=(
dir           # Current directory section
git           # Git section (git_branch + git_status)
aws           # Amazon Web Services section
venv          # virtualenv section
exec_time     # Execution time
line_sep      # Line break
jobs          # Background jobs indicator
exit_code     # Exit code section
char          # Prompt character
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

SPACESHIP_GIT_BRANCH_PREFIX=" "
SPACESHIP_GIT_STATUS_SHOW="false"

SPACESHIP_EXEC_TIME_PREFIX=""
SPACESHIP_EXEC_TIME_ELAPSED="5"

# Git
alias g=git
config[git]="~/.gitconfig"

# Systemd
systemd_sudo_commands=(start stop reload restart enable disable mask unmask edit daemon-reload)

function sc() {
  if [ "$#" -ne 0 ] && [ "${systemd_sudo_commands[(r)$1]}" == "$1" ]; then
    sudo systemctl "$@"
  else
    systemctl "$@"
  fi
}
compdef sc=systemctl
alias scu="systemctl --user"

# FZF
if spaceship::exists fzf; then
  export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden --ignore-file /home/reeto/.local/share/fzf/gitignore 2>/dev/null'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --follow --no-ignore-vcs --hidden --ignore-file /home/reeto/.local/share/fzf/gitignore 2>/dev/null'

  source /usr/share/fzf/completion.zsh
  source /usr/share/fzf/key-bindings.zsh

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

# Editor
alias vi='$EDITOR'
if spaceship::exists nvim; then
  alias todo="nvim +Goyo ~/public/TODO.md"
  function nvimbench() { bench="$(mktemp)" && /usr/bin/nvim --startuptime "$bench" "$@" && tail -1 "$bench" && rm -f "$bench" }
  config[nvim]="~/.config/nvim/*.vim"
fi

# Package manager
if spaceship::exists pacman; then
  function pkgdiff() {
    flags="-Qqe"
    hostnames=()

    for var in "$@"; do
      case "$var" in
        (-*) flags="$var" ;;
        (*) hostnames+="$var" ;;
      esac
    done

    if [[ ${#hostnames[@]} -eq 1 ]]; then
      icdiff -U 0 -L "$(hostname)" -L "${hostnames[1]}"  <(pacman $flags) <(ssh "${hostnames[1]}" "pacman $flags")
    elif [[ ${#hostnames[@]} -eq 2 ]]; then
      icdiff -U 0 -L "${hostnames[1]}" -L "${hostnames[2]}"  <(ssh "${hostnames[1]}" "pacman $flags") <(ssh "${hostnames[2]}" "pacman $flags")
    else
      echo "usage: pkgdiff [flags] <host 1> [host 2]"
      return 1
    fi
  }

  _pkgs() {
    local -a cmd packages packages_long
    packages_long=(/var/lib/pacman/local/*(/))
    packages=( ${${packages_long#/var/lib/pacman/local/}%-*-*} )
    compadd "$@" -a packages
  }
  function binaries() { pacman -Qql $1 | sed -n '/\/usr\/bin\/./s/\/usr\/bin\///p' }
  function pkgsize() { pacman --config /dev/null -Rdd --print-format '%s' $(pactree -u "$1") | awk '{size+=$1} END { print size }' | numfmt --round=nearest --to=iec-i --suffix=B --format="%.1f" }
  compdef _pkgs binaries pkgsize
  function pkgs() { comm -13 <(pacman -Qgq base base-devel | sort -u) <(pacman ${1:--Qqe} | sort -u) | column }
fi

# Chrome
spaceship::exists google-chrome-stable && alias chrome="google-chrome-stable"

# Irssi
spaceship::exists irssi && alias irssi="irssi --config=$XDG_CONFIG_HOME/irssi/config --home=$XDG_DATA_HOME/irssi"

# File listing
if spaceship::exists exa; then
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

# Use trash-put if available
# Not recommended, but very useful if used sparingly (and not relied on)
spaceship::exists trash-put && alias rm=trash-put || alias rm="rm -Iv"
spaceship::exists trash-list && alias tls=trash-list
spaceship::exists trash-restore && alias tres=trash-restore

# Alias for going back directories
alias up=bd

# $HOME directory cleaning
HOMEDIR_ALLOWS="$HOME/.config/homedir_allows"
alias check_homedir="fd -H --type d --maxdepth 1 --ignore-file $HOMEDIR_ALLOWS "\." >> $HOMEDIR_ALLOWS && $EDITOR $HOMEDIR_ALLOWS"

# Python
if spaceship::exists bpython; then
  function python() { [ "$#" -eq 0 ] && bpython || /usr/bin/python "$@" }
fi

# SSH public key
function pub() { [ "$#" -eq 0 ] && cat "$HOME/.ssh/id_ecdsa.pub" || cat "$HOME/.ssh/id_$1.pub" }

# Clipboard
if spaceship::exists xclip; then
  function c() { tr -d '\n' | xclip -sel clip }
  function copy() { cat $1 | c }
  alias v="xclip -o -sel clip"
  alias cpub="pub | c | echo 'RSA public key copied.'"
fi

# Lastpass
if spaceship::exists lpass && spaceship::exists fzf; then
  function cpass() {
    lpass show -xjG "" | jq -r '.[] | "\(.name) (\(.username)) \(.password)"' | fzf --exit-0 --with-nth "..-2" | awk '{print $NF}' | c
  }
fi

# GPG
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# IP
alias pubip="drill myip.opendns.com @resolver1.opendns.com | awk '!/;;/ && /IN/' | head -n 1 | awk '{ print \$NF  }'"
alias privip="hostname -i"

# Config files
config[alacritty]="~/.config/alacritty/alacritty.yml##yadm.j2"
config[compton]="~/.config/compton/compton.conf"
config[dunst]="~/.config/dunst/dunstrc"
config[i3]="~/.config/i3/config.d/**/*.conf"
config[latex]="~/.latexmkrc"
config[polybar]="~/.config/polybar/{config, modules/*}"
config[ranger]="~/.config/ranger/*.conf ~/.config/ranger/commands.py ~/.config/ranger/scope.sh"
config[ssh]="~/.ssh/config"
config[termite]="~/.config/termite/config"
config[tmux]="~/.tmux.conf"
config[xorg]="~/.Xresources ~/.xinitrc"
config[zathura]="~/.config/zathura/zathurarc"
config[zsh]="~/.zshrc ~/.zshenv ~/.zprofile"