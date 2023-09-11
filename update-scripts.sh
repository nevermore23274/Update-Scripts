#!/bin/bash

# Function to get the current date in the desired format
get_current_date() {
    date +%d%b%y
}

# Function for system updates
system_updates() {
    echo "Running system updates..."

    # Check if the log directory exists
    if [[ -d "/var/log/update-logs" ]]; then
        echo "Update logs directory found. Continuing..."
    else
        echo "Update logs directory not found. Creating..."
        sudo mkdir -p /var/log/update-logs
    fi

    # Get the current date
    current_date=$(get_current_date)

    # Check the distribution and use the appropriate package manager
    if [[ -x "$(command -v dnf)" ]]; then
        package_manager="dnf"
        echo "dnf package manager found. Continuing..."
    elif [[ -x "$(command -v apt)" ]]; then
        package_manager="apt"
        echo "apt package manager found. Continuing..."
    elif [[ -x "$(command -v pacman)" ]]; then
        package_manager="pacman"
        echo "pacman package manager found. Continuing..."
    else
        echo "Package manager not found. Exiting..."
        exit 1
    fi

    echo "Checking and updating pip..."
    sudo pip3 install --upgrade pip > "/var/log/update-logs/system_updates_$current_date.log" 2>&1

    # Run system update based on the package manager
    case $package_manager in
        "dnf")
            sudo dnf update -y > "/var/log/update-logs/system_updates_$current_date.log" 2>&1
            ;;
        "apt")
            sudo apt update -y > "/var/log/update-logs/system_updates_$current_date.log" 2>&1
            sudo apt upgrade -y > "/var/log/update-logs/system_updates_$current_date.log" 2>&1
            ;;
        "pacman")
            sudo pacman -Syu --noconfirm > "/var/log/update-logs/system_updates_$current_date.log" 2>&1
            ;;
    esac

    echo "System updates completed."
}

# Function for system clean
system_clean() {
    echo "Running system clean..."

    # Check if the log directory exists
    if [[ -d "/var/log/update-logs" ]]; then
        echo "Update logs directory found. Continuing..."
    else
        echo "Update logs directory not found. Creating..."
        sudo mkdir -p /var/log/update-logs
    fi

    # Get the current date
    current_date=$(get_current_date)

    # Check the distribution and use the appropriate package manager
    if [[ -x "$(command -v dnf)" ]]; then
        package_manager="dnf"
        echo "dnf package manager found. Continuing..."
    elif [[ -x "$(command -v apt)" ]]; then
        package_manager="apt"
        echo "apt package manager found. Continuing..."
    elif [[ -x "$(command -v pacman)" ]]; then
        package_manager="pacman"
        echo "pacman package manager found. Continuing..."
    else
        echo "Package manager not found. Exiting..."
        exit 1
    fi

    # Run system clean based on the package manager
    case $package_manager in
        "dnf")
            sudo dnf autoremove -y > "/var/log/update-logs/system_clean_$current_date.log" 2>&1
            sudo dnf clean all -y > "/var/log/update-logs/system_clean_$current_date.log" 2>&1
            ;;
        "apt")
            sudo apt autoremove -y > "/var/log/update-logs/system_clean_$current_date.log" 2>&1
            sudo apt clean -y > "/var/log/update-logs/system_clean_$current_date.log" 2>&1
            ;;
        "pacman")
            sudo pacman -Rns $(pacman -Qtdq) --noconfirm > "/var/log/update-logs/system_clean_$current_date.log" 2>&1
            sudo pacman -Sc --noconfirm > "/var/log/update-logs/system_clean_$current_date.log" 2>&1
            ;;
    esac

    echo "System clean completed."
}

# Main script
PS3='What would you like to do? '
options=("System Update" "System Clean" "Quit")
echo "*** System Maintenance Script ***"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script requires root privileges. Please enter your password."
    exec sudo bash "$0" "$@"
fi

select opt in "${options[@]}"
do
    case $opt in
        "System Update")
            system_updates
            ;;
        "System Clean")
            system_clean
                       ;;
        "Quit")
            break
            ;;
        *) echo "Invalid option. Please select a valid option."
            ;;
    esac
done
