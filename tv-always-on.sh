#!/bin/bash

SLEEPTIME=10

echo "==================="
echo "TV Always On Daemon"
echo "==================="

echo "Wait..."
sleep 3
echo "Forever loop..."

while true; do
  tv_state=$(echo 'pow 0' | cec-client -s -d 1)

  if [[ $tv_state == *'status: on'* ]]; then
    echo "TV is ON."
  else
    echo "TV is OFF, trying to power on..."
    ./tv-power-on.sh
  fi

  sleep $SLEEPTIME
done
