#!/bin/bash
BASEDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# init .zshrc
#cp $BASEDIR/zshrc ~/.zshrc

# init .vimrc
ln -s $BASEDIR/nvim/vimrc ~/.vimrc

# init .ideavimrc
ln -s $BASEDIR/nvim/ideavimrc ~/.ideavimrc

# init nvim
ln -s $BASEDIR/nvim ~/.config/

