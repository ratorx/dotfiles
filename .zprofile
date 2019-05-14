typeset -U path

[[ ! $DISPLAY && $XDG_VTNR -eq 1 && -f $XDG_CONFIG_HOME/X11/xinitrc ]] && command -v startx >/dev/null && exec startx "$XDG_CONFIG_HOME/X11/xinitrc"
