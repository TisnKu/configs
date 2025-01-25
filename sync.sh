#!/bin/bash
BASEDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# init .vimrc
ln -s $BASEDIR/nvim/vimrc ~/.vimrc

# init .ideavimrc
ln -s $BASEDIR/nvim/ideavimrc ~/.ideavimrc

# init nvim
ln -s $BASEDIR/nvim ~/.config/

# add import alacritty statement to ~/.config/alacritty/alacritty.toml
# example: import: \n - ~/configs/alacritty/alacritty.toml
# if alacritty folder does not exist or toml do not exist, create it
if [ ! -d ~/.config/alacritty ]; then
    mkdir ~/.config/alacritty
fi
if [ ! -f ~/.config/alacritty/alacritty.toml ]; then
    touch ~/.config/alacritty/alacritty.toml
fi

if ! grep -q "configs" ~/.config/alacritty/alacritty.toml; then
    echo "import:" >> ~/.config/alacritty/alacritty.toml
    echo "  - ~/configs/alacritty/alacritty.toml" >> ~/.config/alacritty/alacritty.toml
fi


