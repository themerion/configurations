#!/bin/bash

read -p "Please enter your home directory [$HOME]: " HOME_DIR
HOME_DIR=${HOME_DIR:-$HOME}
echo $HOME_DIR

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_DIR=$( realpath "${SCRIPT_DIR}/.." )

# ----------------------------------------------------------

# Creates a link if the file does not exist
# Params: ($1)Source, ($2)Target
function link() {
    # Check if target file exists
    if test -f $2; then
        # Compare target with source
        cmp -s $1 $2
        if [ $? -eq 0 ]; then
            echo -e "[\e[32mOK\e[0m] Up to date: $2"
        else
            echo -e "[\e[31mERR\e[0m] Exists and have different content: $2"
        fi
    else
        ln -s $1 $2
        if [ $? -eq 0 ]; then
            echo -e "[\e[32mOK\e[0m] Created: $2"
        fi
    fi
}

# Modifies a .desktop file, making sure it uses electron-launcher (for electron Wayland/X11 compat)
# Params: Path-to-file ($1)
function use_electron_launcher() {
    # Check if target file exists
    if test -f "$1"; then
        # Check if you have write permissions
        test -w $1
        if [ $? -eq 0 ]; then
			local HOME_DIR_ESCAPED_SLASHES=$(echo $HOME_DIR | sed "s/\//\\\\\//g")
            sed -i 's/Exec=.*electron-launcher /Exec=/' $1
			sed -i "s/Exec=/Exec=$HOME_DIR_ESCAPED_SLASHES\/bin\/electron-launcher /" $1
			local NAME=$(echo $1 | rev | cut -d\/ -f1 | rev)
            echo -e "[\e[32mOK\e[0m] Using electron-launcher: $NAME"
        else
            echo -e "[\e[31mERR\e[0m] You do not have write permissions. Did you mean to sudo? $1"
        fi
    else
        echo -e "[\e[31mERR\e[0m] The target file does not exist: $1"
    fi
}

# ----------------------------------------------------------


# VS Code settings
mkdir -p "$HOME_DIR/.config/Code/User"
link "${CONFIG_DIR}/keybindings.json" "${HOME_DIR}/.config/Code/User/keybindings.json"
link "${CONFIG_DIR}/settings.json" "${HOME_DIR}/.config/Code/User/settings.json"


# Vim
link "${CONFIG_DIR}/.vimrc" "${HOME_DIR}/.vimrc"


# Wayland electron applications
mkdir -p "${HOME_DIR}/bin"
link "${CONFIG_DIR}/linux/electron-launcher" "${HOME_DIR}/bin/electron-launcher"

mkdir -p ~/.bashrc.d
link "${CONFIG_DIR}/linux/electron-aliases" "${HOME_DIR}/.bashrc.d/electron-aliases"

use_electron_launcher "/usr/share/applications/code.desktop"
use_electron_launcher "/usr/share/applications/google-chrome.desktop"
