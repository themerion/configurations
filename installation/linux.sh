#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_DIR=$( realpath "${SCRIPT_DIR}/.." )

# ----------------------------------------------------------

# Creates a link if the file does not exist
# Params: ($1)Source, ($2)Target
function link() {
    # Check if target file exists
    test -f $2
    if [ $? -eq 0 ]; then
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

# Creates a link ONLY if the file exists
# Params: ($1)Source, ($2)Target
function link_overwrite() {
    # Check if target file exists
    test -f $2
    if [ $? -eq 0 ]; then
        # Check if you have write permissions
        test -w $2
        if [ $? -eq 0 ]; then
            rm $2
            ln -s $1 $2
            echo -e "[\e[32mOK\e[0m] Overwrote: $2"
        else
            echo -e "[\e[31mERR\e[0m] You do not have write permissions. Did you mean to sudo? $2"
        fi
    else
        echo -e "[\e[31mERR\e[0m] The target file does not exist. Maybe you have forgotten to install a package? $2"
    fi
}

# ----------------------------------------------------------

# VS Code settings
mkdir -p ~/.config/Code/User
link "${CONFIG_DIR}/keybindings.json" "${HOME}/.config/Code/User/keybindings.json"
link "${CONFIG_DIR}/settings.json" "${HOME}/.config/Code/User/settings.json"

# Vim
link "${CONFIG_DIR}/.vimrc" "${HOME}/.vimrc"

# Wayland electron applications
mkdir -p ~/.bashrc.d
link "${CONFIG_DIR}/wayland-electron-aliases" "${HOME}/.bashrc.d/wayland-electron-aliases"

link_overwrite "${CONFIG_DIR}/code.desktop" "/usr/share/applications/code.desktop"
link_overwrite "${CONFIG_DIR}/google-chrome.desktop" "/usr/share/applications/google-chrome.desktop"