#!/bin/bash

# Function to get the current date in the desired format
get_current_date() {
    date +%d%b%y
}

# Function for system updates
system_updates() {
    echo "Running system updates..."
    sleep 2

    # Define the log directory path
    log_dir="$HOME/update-logs"

    # Create the log directory if it doesn't exist
    if [[ ! -d "$log_dir" ]]; then
        echo "Update logs directory not found. Creating..."
        mkdir -p "$log_dir"
    fi

    # Get the current date
    current_date=$(get_current_date)

    # Save the log file path
    log_file="$log_dir/system_updates_$current_date.log"

    echo "Checking and updating pip..."
    pip3 install --upgrade pip > "$log_file" 2>&1

    # Run system update based on the package manager
    if [[ -x "$(command -v dnf)" ]]; then
        package_manager="dnf"
        echo "dnf package manager found. Continuing..."
        sudo dnf update -y > "$log_file" 2>&1
    elif [[ -x "$(command -v apt)" ]]; then
        package_manager="apt"
        echo "apt package manager found. Continuing..."
        sudo apt update -y > "$log_file" 2>&1
        sudo apt upgrade -y > "$log_file" 2>&1
    elif [[ -x "$(command -v pacman)" ]]; then
        package_manager="pacman"
        echo "pacman package manager found. Continuing..."
        sudo pacman -Syu --noconfirm > "$log_file" 2>&1
    else
        echo "Package manager not found. Exiting..."
        exit 1
    fi

    echo "System updates completed."
    sleep 2
}

# Function for system clean
system_clean() {
    echo "Running system clean..."
    sleep 2

    # Define the log directory path
    log_dir="$HOME/update-logs"

    # Create the log directory if it doesn't exist
    if [[ ! -d "$log_dir" ]]; then
        echo "Update logs directory not found. Creating..."
        mkdir -p "$log_dir"
    fi

    # Get the current date
    current_date=$(get_current_date)

    # Save the log file path
    log_file="$log_dir/system_clean_$current_date.log"

    # Run system clean based on the package manager
    if [[ -x "$(command -v dnf)" ]]; then
        package_manager="dnf"
        echo "dnf package manager found. Continuing..."
        sudo dnf autoremove -y > "$log_file" 2>&1
        sudo dnf clean all -y > "$log_file" 2>&1
    elif [[ -x "$(command -v apt)" ]]; then
        package_manager="apt"
        echo "apt package manager found. Continuing..."
        sudo apt autoremove -y > "$log_file" 2>&1
        sudo apt clean -y > "$log_file" 2>&1
    elif [[ -x "$(command -v pacman)" ]]; then
        package_manager="pacman"
        echo "pacman package manager found. Continuing..."
        sudo pacman -Rns $(pacman -Qtdq) --noconfirm > "$log_file" 2>&1
        sudo pacman -Sc --noconfirm > "$log_file" 2>&1
    else
        echo "Package manager not found. Exiting..."
        exit 1
    fi

    echo "System clean completed."
    sleep 2
}

# Function to clear the terminal
clear_terminal() {
    clear || printf "\033c"
}

# Prompt the user for password
read -s -p "Enter your password: " password
echo

# Validate the password
sudo -k
if ! echo "$password" | sudo -S echo >/dev/null 2>&1; then
    echo "Incorrect password. Exiting..."
    exit 1
fi

# Clear the terminal
clear_terminal

# Main script
PS3='What would you like to do? '
options=("System Update" "System Clean" "Quit")
menu_header="*** System Maintenance Script ***"

while true; do
    clear_terminal
    echo "$menu_header"
    select opt in "${options[@]}"; do
        case $opt in
            "System Update")
                system_updates
                break
                ;;
            "System Clean")
                system_clean
                break
                ;;
            "Quit")
                exit
                ;;
            *) echo "Invalid option. Please try again.";;
        esac
    done
done
