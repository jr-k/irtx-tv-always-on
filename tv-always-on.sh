#!/bin/bash

echo "TV Always On Daemon"
sleep 5
systemctl restart pigpiod

while true; do
  tv_state=$(echo 'pow 0' | cec-client -s -d 1)

  if [[ $tv_state == *'status: on'* ]]; then
    echo "TV is ON."
  else
    echo "TV is OFF, trying to power on..."
    ./tv-power-on.sh
  fi

  sleep 5
done
