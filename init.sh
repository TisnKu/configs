#!/bin/sh
BASEDIR=$(dirname "$0")

# init .zshrc
cp $BASEDIR/.zshrc ~/

# init .vimrc
cp $BASEDIR/nvim/.vimrc ~/

# init nvim
ln -s $BASEDIR/nvim ~/.config/