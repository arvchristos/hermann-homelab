# hermann-homelab
Bash script to ease my humble homelab's management

## Screenshots
![main menu](https://i.imgur.com/tIXuWeC.png)
![wake up on lan](https://i.imgur.com/iT4yFcA.png)
![wake up saved device](https://i.imgur.com/BLkjliC.png)

## Current functionality includes:
* Scan and show network devices in dialog list
* Wake up device based on LAN
* List and add saved devices

## Upcoming
* Operations on saved Devices
* Delete and edit saved device info from UI (Currently possible through saved_devices.txt file)

## Requirements
* nmap
* dialog
* awk
* sed

## Saved Devices file info:
* **saved_devices.txt** file
* File has the following format:
  ```
  [DEVICE1 NAME]-[DEVICE1 MAC ADDRESS]
  [DEVICE1 NAME]-[DEVICE1 MAC ADDRESS]
  ...
  ```
* Must be on the same directory with the **hermann** executable
