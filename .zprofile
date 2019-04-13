typeset -U path

[[ ! $DISPLAY && $XDG_VTNR -eq 1 && -f $HOME/.xinitrc ]] && exec startx
