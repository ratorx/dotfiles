# Dotfiles

Configuration files for a fair amount of applications.

## Terminal
* git - vcs
* neovim - editor
* ranger - file browser
* ssh - servers
* tmux - multiplexer (not used anymore)
* zsh - shell

## GUI
* alacritty - terminal emulator
* albert - launcher
* autorandr - screen configuration
* compton - compositor
* dunst - notification daemon
* gtk - toolkit (unified themes w/ qt)
* i3 - WM
* polybar - status bar
* termite - backup terminal emulator
* xorg - display server

## Useful scripts
### Albert
* XDG icon lookup
* Lastpass password lookup
* NetworkManager VPN management
* Better websearch (fuzzy match triggers; xdg icons; default search engine)
* Window switcher (forked from upstream; better icon lookup; fuzzy matching)

### Polybar
* i3 layout module
* Barrier connection module (using ipc hooks)
* NetworkManager VPN module (using ipc hooks)

### i3
* Hostname specific configuration
* Resizable, aspect-ratio preserving video window which can be moved (w/ animations) between the left and right side of the screen
* Blurred screenshot with lock icon (i3lock)

### Git
* Fuzzy search commit history with diff previews to copy commit hashes (slightly modified from original on FZF wiki)

### Other
* Seperate, sticky backlight levels for laptops on battery and power (handles suspend)
* Secure remote control script using barrier and SSH port forwarding (like x2x but with better error recovery) with notifications
