typeset -U path

[[ ! $DISPLAY && $XDG_VTNR -eq 1 && -f $XDG_CONFIG_HOME/X11/xinitrc ]] && exec startx "$XDG_CONFIG_HOME/X11/xinitrc"
