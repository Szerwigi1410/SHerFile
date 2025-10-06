#!/bin/bash

# This script interactively installs either 'brokefetch.sh' or 'brokefetch_EDGE.sh'
# from the current directory to /usr/bin. It prompts the user for choices.

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

action=$(<action_choice.txt)

dialog --clear --title "Warning" --backtitle "Installation of SHerFile" --msgbox "This install script may contain bugs. You take responsibility for using it." 5 81
clear

# --- Step 1: Identify available source files ---

available_scripts=()
if [ -f "SHerFile.sh" ]; then
    available_scripts+=("SHerFile.sh")
fi
if [ -f "cpuinfo_beta.sh" ]; then
    available_scripts+=("cpuinfo_beta.sh")
fi


# Exit if no source files are found
if [ ${#available_scripts[@]} -eq 0 ]; then
    echo -e "${RED}Error code 002:${RESET} SHerFile.sh and SherFile_beta.sh were not found in the current directory."
    exit 1
fi

# --- Step 2: Prompt user for choice if multiple scripts are found ---

source_file=""
if [ ${#available_scripts[@]} -eq 1 ]; then
    source_file="${available_scripts[0]}"
    echo "Found '${source_file}'. This script will be installed."
else
    echo "Multiple cpuinfo scripts found. Please choose one to install:"
    select choice in "${available_scripts[@]}"; do
        if [ -n "$choice" ]; then
            source_file="$choice"
            break
        else
            echo "Invalid choice. Please select a number from the list."
        fi
    done
fi

# --- Step 3: Check for existing installation and prompt for overwrite/remove ---

# Check if an old version of brokefetch exists
if [ -f "/usr/bin/SHerFile" ]; then
    echo "An existing 'SHerFile' script was found at /usr/bin/SHerFile."
    
    # Prompt the user to remove or replace
    dialog --clear --title "Existing Instalation Found" --backtitle "Installation of SHerFile" --menu "An existing 'SHerFile' script was found at /usr/bin/SHerFile.\nWhat do you want to do?" 13 60 15 \
        1 "Replace it with the new version" \
        2 "Remove the old version before installation" \
        3 "Exit installation" 2>action_choice.txt
    case "$action" in
        1) 
            echo "Replacing existing SHerFile script."
            break
            ;;
        2)
            echo "Removing old version before installation."
            sudo rm /usr/bin/SHerFile
            break
            ;;
        3) 
            dialog --clear --title "Exiting" --backtitle "Instalation of SHerFile" --infobox "Exiting installation." 10 30
            break
            ;;    
    esac
fi

# --- Step 4: Perform the installation ---

dialog --clear --title "Instalation" --backtitle "Installation of SHerFile" --msgbox "Installing '$source_file' to /usr/bin/SHerFile..." 15 45
clear

# Copy the chosen file to /usr/bin
sudo cp "$source_file" /usr/bin/SHerFile

# Make the new file executable
sudo chmod +x /usr/bin/SHerFile

# --- Step 5: Verify installation and provide success message ---

if [ -f "/usr/bin/SHerFile" ]; then
    echo "Success! '$source_file' is now installed as 'SHerFile'."
    echo "You can run it from any directory by typing 'SHerFile'."
else
    echo -e "${RED}Error code 003:${RESET} an occurred during installation."
    exit 1
fi

exit 0
