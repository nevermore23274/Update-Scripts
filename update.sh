#!/bin/bash
# System updates
echo "What would you like to run?"
select yn in "1" "2" "3"; do
    case $yn in
        1 ) sudo pacman -Syyu;
            yay -Sua;
            break;;
        2 ) sudo pacman-mirrors --fasttrack;
            sudo pacman -Syyu;
            break;;
        3 ) sudo find ~/.cache/ -type f -atime +2 -delete;
            sudo pacman -Sc;
            sudo journalctl --vacuum-time=2weeks;
            sudo pacman -Rs $(pacman -Qdtq);
            sudo rm /var/lib/pacman/db.lck;
            break;;
        no ) exit;;
    esac
done
