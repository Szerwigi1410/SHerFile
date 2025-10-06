#!/bin/bash

# Hey it's Szerwigi1410
# For now ts only works with kitty

# files in the current folders
files=(.* *)

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

#--------CONFIG
CONFIG_FILE="$HOME/.config/SHerFile/config"

# If there is no config – create a default one.
if [[ ! -f "$CONFIG_FILE" ]]; then
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo -e "# Your IDE or text editor:" > "$CONFIG_FILE"
    echo -e "EDITOR=nano\n" >> "$CONFIG_FILE"
    echo -e "# UI file manager window size" >> "$CONFIG_FILE"
    echo -e "WIN_HEIGHT=25" >> "$CONFIG_FILE"
    echo -e "WIN_WIDTH=55\n" >> "$CONFIG_FILE"
fi

# Load values from the config
source "$CONFIG_FILE"

IDE="$EDITOR"
HEIGHT="$WIN_HEIGHT"
WIDTH="$WIN_WIDTH"

#--------output .txt file
OUTPUT="temp.txt"
>$OUTPUT;

#--------Main window
dialog --clear --title "SHerFile" --backtitle "Szerwigi's Bash File manager" --menu "File actions" 15 40 5 \
        1 "List files and folders" \
        2 "File browser UI" \
        3 "List all files and folders" \
        4 "Custom command" \
        5 "Custom command --hold" \
        6 "Exit" 2>menu_choice.txt

choice=$(<menu_choice.txt)
clear

#-------cases for main window
case $choice in
    1) ls --color=auto
        ;;
    2)
        while true; do
            files=(.* *)
            if [ ${#files[@]} -eq 0 ]; then
                dialog --msgbox "No files!" 6 40
                clear
                exit 1
            fi

            menu_items=(
                ".." "[go back]"
                "$HOME" "[home]"
            )
            for file in "${files[@]}"; do
                if [ -d "$file" ]; then
                    menu_items+=("$file" "[folder]")
                else
                    menu_items+=("$file" "[file]")
                fi
            done


            choice1=$(dialog --clear --backtitle "Szerwigi's Bash File Manager" \
                --menu "Choose the file or folder to open ($IDE):" $HEIGHT $WIDTH 10 "${menu_items[@]}" \
                3>&1 1>&2 2>&3)

            exit_status=$?
            clear

            if [ $exit_status -eq 0 ] && [ -n "$choice1" ]; then
                if [$choice1 = ".." ]; then
                    cd ..
                elif [$choice1 = "$HOME"]; then
                    cd $HOME
                elif [ -d "$choice1" ]; then
                    cd "$choice1"
                else
                    $IDE "$choice1"
                fi
            else
                echo "Exitting..."
                break
            fi
        done
        ;;
    3) ls --color=auto -a
        ;;
    4)
       dialog --clear --title "Inputbox" --backtitle "Szerwigi's Bash File manager" --inputbox "Custom command:" 10 40 "" 2> $OUTPUT
       kitty $(<$OUTPUT)
       clear
       ;;
    5) dialog --clear --title "Inputbox" --backtitle "Szerwigi's Bash File manager" --inputbox "Custom command --hold:" 10 40 "" 2> $OUTPUT
       kitty --hold $(<$OUTPUT)
       clear
       ;;
    6) echo "Exiting..."
       ;;
    *) echo "Invalid choice"
       ;;
esac
