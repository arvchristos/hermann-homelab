#!/bin/bash

HEIGHT=15
WIDTH=60
CHOICE_HEIGHT=6
BACKTITLE="hermann homelab Control Panel"
TITLE="Main menu"
MENU="Choose one of the following options:"

OPTIONS=(1 "Show Network Devices"
         2 "Wake up On LAN Device"
         3  "Wake up saved device"
         4 "Add Network Device"
         5 "Common Devices")

CHOICE=$(dialog --clear --backtitle "$BACKTITLE" --title "$TITLE" --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)

#clear
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
              exit
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
        declare -a LINES
        mapfile -t LINES < <(cat saved_devices.txt | sed 's/-/\n/g' |  sed 's/\[//g' | sed 's/\]//g' )
        declare -a LINES3

        for (( i = 0; i<${#LINES[@]}; i += 2 )); do

          LINES3[$(( $i ))]=$(( $i / 2 + 1 ))
          LINES3[$(( $i + 1 ))]="${LINES[i]} - ${LINES[i+1]}"
        done

        declare CHOICE2

        CHOICE2=$(dialog --clear --title "Wake up saved device" --backtitle "$BACKTITLE" --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${LINES3[@]}" 2>&1 >/dev/tty)
        clear
        if [[ "$CHOICE2" == "" ]]; then
          exit
        fi
        wol ${LINES[((2*($CHOICE2-1)))+1]}


          ;;
        4)
        #Enter Device name
        device_name = ""
        device_addr = ""

        dialog --title "Dialog - Form" \
        --inputbox "Please enter Device Name" 8 60 \
        >> /tmp/out.tmp 2>&1 >/dev/tty
        device_name=`sed -n 1p /tmp/out.tmp`

        if [[ "$device_name" == "" ]]; then
          clear
          echo "Wrong form input"
          exit
        fi
        echo '\n' >> /tmp/out.tmp
        dialog --title "Add network device to saved list" \
        --inputbox "Please enter Device MAC address" 8 60 \
        >> /tmp/out.tmp 2>&1 >/dev/tty
        device_addr=`sed -n 2p /tmp/out.tmp`

        if [[ "$device_addr" == "" ]]; then
          clear
          echo "Wrong form input"
          exit
        fi

        # remove temporary file created
        rm -f /tmp/out.tmp
        clear

        #add to saved Devices file
        echo [$device_name]-[$device_addr] >> saved_devices.txt
            ;;
        5)
          declare -a LINES
          mapfile -t LINES < <(cat saved_devices.txt | sed 's/-/\n/g' |  sed 's/\[//g' | sed 's/\]//g' )
          declare -a LINES3

          for (( i = 0; i<${#LINES[@]}; i += 2 )); do

            LINES3[$(( $i ))]=$(( $i / 2 + 1 ))
            LINES3[$(( $i + 1 ))]="${LINES[i]} - ${LINES[i+1]}"
          done

          declare CHOICE2

          CHOICE2=$(dialog --clear --backtitle "$BACKTITLE" --title "List of saved devices" --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${LINES3[@]}" 2>&1 >/dev/tty)
          clear
          if [[ "$CHOICE2" == "" ]]; then
            exit
          fi

            ;;
esac
