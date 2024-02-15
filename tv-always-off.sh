#!/bin/bash

SLEEPTIME=5

echo "==================="
echo "TV Always Off Daemon"
echo "==================="

echo "Wait..."
sleep 3
echo "Forever loop..."

while true; do
  tv_state=$(echo 'pow 0' | cec-client -s -d 1)

  if [[ $tv_state == *'status: on'* ]]; then
    echo "TV is ON, trying to power off..."
    ./tv-power-off.sh
  else
    echo "TV is OFF."
  fi

  sleep $SLEEPTIME
done
