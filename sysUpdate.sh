#!/bin/bash

PS3='What would you like to do? '
options=("System Updates" "System Clean" "Quit")
echo "*** System Maintenence Script ***"
select opt in "${options[@]}" 
do
	case $opt in
		"System Updates")
		   sudo apt update -y
		   sudo apt upgrade -y
		   sudo apt dist-upgrade -y
		   ;;

	        "System Clean") 
		   sudo apt autoremove --purge
		   sudo apt autoclean -y
		   sudo apt clean -y
		   # Remove orphaned packages
		   sudo debporphan | xargs sudo apt -y remove --purge
		   ;;

		"Quit")
		   break
		   ;;

		*) echo "invalid option $REPLY";;
	esac
done
