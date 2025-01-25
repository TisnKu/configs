#!/bin/bash
BASEDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# init .vimrc
ln -s $BASEDIR/nvim/vimrc ~/.vimrc

# init .ideavimrc
ln -s $BASEDIR/nvim/ideavimrc ~/.ideavimrc

# init nvim
ln -s $BASEDIR/nvim ~/.config/

# add import alacritty statement to ~/.config/alacritty/alacritty.yml
# example: import: \n - ~/configs/alacritty/alacritty.yml
# if alacritty folder does not exist or yml do not exist, create it
if [ ! -d ~/.config/alacritty ]; then
    mkdir ~/.config/alacritty
fi
if [ ! -f ~/.config/alacritty/alacritty.yml ]; then
    touch ~/.config/alacritty/alacritty.yml
fi

if ! grep -q "configs" ~/.config/alacritty/alacritty.yml; then
    echo "import:" >> ~/.config/alacritty/alacritty.yml
    echo "  - ~/configs/alacritty/alacritty.yml" >> ~/.config/alacritty/alacritty.yml
fi


