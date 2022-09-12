#!/bin/sh
BASEDIR=$(dirname "$0")

# sync .zshrc
cp ~/.zshrc $BASEDIR/

# sync .vimrc
cp ~/.vimrc $BASEDIR/nvim

# commit and push
git add . && git commit -m "sync config files"