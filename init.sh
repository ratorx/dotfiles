#!/usr/bin/bash
# .zshenv
ln -s "$HOME/.dotfiles/zshenv" "$HOME/.zshenv"

# .zshrc
ln -s "$HOME/.dotfiles/zshrc" "$HOME/.zshrc"

# .antibody
ln -s "$HOME/.dotfiles/antibody" "$HOME/.antibody"

# .gitconfig
ln -s "$HOME/.dotfiles/gitconfig" "$HOME/.gitconfig"

# .ssh/
[[ $UID -ne 0 ]] && ln -s "$HOME/.dotfiles/ssh/config" "$HOME/.ssh/config"
[[ $UID -ne 0 ]] && ln -s "$HOME/.dotfiles/ssh/keys" "$HOME/.ssh/authorized_keys"

# tmux - Not currently used
# ln -s "$HOME/.dotfiles/tmux.conf" "$HOME/.tmux.conf"

# npmrc - Move .npm folder to cache
ln -s "$HOME/.dotfiles/npmrc" "$HOME/.npmrc"