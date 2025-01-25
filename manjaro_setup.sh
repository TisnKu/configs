#!/bin/bash
# This is to setup monjaro for my personal use

## generate ssh key, no password
ssh-keygen -t rsa -b 4096 -C "''" -f ~/.ssh/id_rsa -N ''
## print the public key
cat ~/.ssh/id_rsa.pub

echo "Please add the public key to your github account"

## Install yay, fakeroot
sudo pacman -S yay
sudo pacman -S fakeroot
sudo pacman -S pkgconf

## Install zsh
sudo pacman -S zsh
## Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## Install v2raya
yay -S v2raya
sudo systemctl enable v2raya
sudo systemctl start v2raya

## Install google-chrome
yay -S google-chrome

## Install vscode
yay -S visual-studio-code-bin

## Install typora
yay -S typora

## Install switchhosts, and add https://raw.hellogithub.com/hosts
yay -S switchhosts

## Install Microsoft Edge
yay -S microsoft-edge-dev-bin

## Configure alt-shift-t to toggle terminal (KDE-plasma)




