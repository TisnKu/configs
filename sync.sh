#!/bin/sh
BASEDIR=$(dirname "$0")

# init .zshrc
#cp $BASEDIR/zshrc ~/.zshrc

# init .vimrc
ln -s $BASEDIR/nvim/vimrc ~/.vimrc

# init .ideavimrc
ln -s $BASEDIR/nvim/ideavimrc ~/.ideavimrc

# init nvim
ln -s $BASEDIR/nvim ~/.config/
