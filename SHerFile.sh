#!/bin/bash

#----COLOR-CODES:

GREEN="\033[32m"
RED="\033[31m"
BLUE="\033[34m"
CYAN="\033[36m"
WHITE="\033[37m"
YELLOW="\033[33m"
PURPLE="\033[35m"
BOLD="\033[1m"
RESET="\033[0m"
BLACK="\033[30m"
GRAY="\033[90m"

dialog --clear --menu "File actions" 15 30 5 \
        1 "List files" \
        2 "List all files" \
        3 "Exit" 2>menu_choice.txt

#configs=("Hyprland" "Waybar" "Quit")

choice=$(<menu_choice.txt)
clear

case $choice in
    1) ls --color=auto;;
    2) ls --color=auto -a;;
    3) echo "Exiting...";;
    *) echo "Invalid choice";;
esac