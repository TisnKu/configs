#!/bin/bash

# Change default shell to zsh
chsh -s $(which zsh)

# setup necessary tools
# ssh generate key no passwd
ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

# wait for user to copy the key and add it to github
# wait for user to press enter
read -p "Press enter after adding the key to github"

if (!(Test-Path ~/configs))
{
  git clone git@github.com:TisnKu/configs.git ~/configs
}
sudo +x ~/configs/sync.sh
./configs/sync.sh


# Install neovim
sudo apt-add-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim -y
## rename original vi to ovi
sudo mv /usr/bin/vi /usr/bin/ovi
sudo ln -s /usr/bin/nvim /usr/bin/vi

# ripgrep, fd, fzf
sudo apt install ripgrep fd-find fzf -y

# autojump
git clone https://github.com/wting/autojump.git
cd autojump
./install.py

# git setup
git config --global core.longpaths true
git config --global user.name "TK"
git config --global push.autoSetupRemote true
