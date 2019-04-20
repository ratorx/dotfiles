[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
autorandr --change

# Caps Lock -> Ctrl/Escape
setxkbmap -option "ctrl:nocaps"
xcape -e "Control_L=Escape"

# Disable repeat of TAB
# Required for quick view of workspace
xset -r 23

bash -c "cd ~/.config/i3 && make"
exec i3
