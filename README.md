# hermann-homelab
Bash script to ease my humble homelab's management

## Current functionality includes:
* Scan and show network devices in dialog list
* Wake up device based on LAN

## Upcoming
* Log of saved devices
* Operations on saved Devices
* Add to saved for easier waking up or packet sending

## Requirements
* nmap
* dialog
* awk
* sed

## Saved Devices file info:
* File has the following format:
  ```
  [DEVICE1 NAME]-[DEVICE1 MAC ADDRESS]
  [DEVICE1 NAME\]-\[DEVICE1 MAC ADDRESS]
  ...
  ```
* Must be on the same directory with the **hermann** executable
