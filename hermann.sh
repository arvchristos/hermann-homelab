#!/bin/bash

HEIGHT=15
WIDTH=60
CHOICE_HEIGHT=4
BACKTITLE="Arvanitis Homelab Control Panel"
TITLE="Main menu"
MENU="Choose one of the following options:"

OPTIONS=(1 "Show Network Devices"
         2 "Wake up On LAN Device"
         3 "Option 3")

CHOICE=$(dialog --clear --backtitle "$BACKTITLE" --title "$TITLE" --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            echo "Available network devices"
            declare -a LINES
            mapfile -t LINES < <(sudo nmap -sn 192.168.1.0/24 | awk '/^(Nmap|MAC)/' | sed '$!N;s/\n/ /' | sed '$d'|tr -d '()'| awk '{for(i=9;i<=NF;i++){printf "%s ",$i};printf "- %s - %s\n",$5,$8}')
            declare -a LINES2
            for (( i = 0; i<${#LINES[@]}; i++ )); do
              LINES2[$((2*$i))]=$(($i+1))
              LINES2[$((2*$i+1))]=${LINES[i]}
            done
            declare CHOICE2
            CHOICE2=$(dialog --clear --backtitle "$BACKTITLE" --title "$TITLE" --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${LINES2[@]}" 2>&1 >/dev/tty)
            clear
            if [[ "$CHOICE2" == "" ]]; then
              bash ./homelab_manager.sh
            fi
            ;;
        2)
        OUTPUT="/tmp/input.txt"
        >$OUTPUT
        # cleanup  - add a trap that will remove $OUTPUT
        # if any of the signals - SIGHUP SIGINT SIGTERM it received.
        trap "rm $OUTPUT; exit" SIGHUP SIGINT SIGTERM
        dialog --title "Wake up On LAN Device" --backtitle "$BACKTITLE" --inputbox "Please enter MAC address to send magic packet" 8 60 2>$OUTPUT
        clear
                  # get respose
          respose=$?

          # get data stored in $OUPUT using input redirection
          MAC=$(<$OUTPUT)

          # make a decsion
          case $respose in
            0)
            	wol ${MAC}
            	;;
            1)
            	echo "Cancel pressed."
            	;;
            255)
             echo "[ESC] key pressed."
          esac

          # remove $OUTPUT file
          rm $OUTPUT
            ;;
        3)
            echo "You chose Option 3"
            ;;
esac
