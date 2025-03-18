#!/bin/bash

# setup necessary tools
# ssh generate key no passwd
ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

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
