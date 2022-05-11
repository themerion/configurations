#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# VS Code
mkdir -p ~/.config/Code/User
ln -s "${SCRIPT_DIR}/../keybindings.json" "${HOME}/.config/Code/User/keybindings.json"
ln -s "${SCRIPT_DIR}/../settings.json" "${HOME}/.config/Code/User/settings.json"

# Vim
ln -s "${SCRIPT_DIR}/../.vimrc" "${HOME}/.vimrc"
