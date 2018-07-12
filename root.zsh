#! /usr/bin/zsh
# Set up root zsh session
# Run as regular user

sudo rm -f /root/.dotfiles
sudo -s ln -sT $HOME/.dotfiles /root/.dotfiles
sudo /root/.dotfiles/modman install zsh

# Link Xresources for lightdm colour swap script
sudo rm -f /etc/Xresources
echo "Symlink Xresources"
sudo -s ln -s $HOME/.dotfiles/xrdb/Xresources /etc/Xresources
