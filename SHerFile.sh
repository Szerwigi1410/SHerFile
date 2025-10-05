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

OUTPUT="temp.txt"
>$OUTPUT;

dialog --clear --title "SHerFile" --backtitle "Szerwigi's Bash File manager" --menu "File actions" 15 40 5 \
        1 "List files" \
        2 "List all files" \
        3 "Custom command" \
        4 "Custom command --hold" \
        5 "Exit" 2>menu_choice.txt

choice=$(<menu_choice.txt)
clear

case $choice in
    1) ls --color=auto;;
    2) ls --color=auto -a;;
    3) dialog --clear --title "Inputbox" --backtitle "Szerwigi's Bash File manager" --inputbox "Custom command:" 10 40 "" 2> $OUTPUT
       kitty $(<$OUTPUT)
       clear
       ;;
    4) dialog --clear --title "Inputbox" --backtitle "Szerwigi's Bash File manager" --inputbox "Custom command --hold:" 10 40 "" 2> $OUTPUT
       kitty --hold $(<$OUTPUT)
       clear
       ;;   
    5) echo "Exiting...";;
    *) echo "Invalid choice";;
esac