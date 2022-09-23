#!/bin/sh
BASEDIR=$(dirname "$0")

# init .zshrc
#cp $BASEDIR/.zshrc ~/

# init .vimrc
ln -s $BASEDIR/nvim/.vimrc ~/

# init .ideavimrc
ln -s $BASEDIR/nvim/.ideavimrc ~/

# init nvim
ln -s $BASEDIR/nvim ~/.config/
