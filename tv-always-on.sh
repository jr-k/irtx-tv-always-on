#!/bin/bash

while true; do
  tv_state=$(echo 'pow 0' | cec-client -s -d 1)

  if [[ $tv_state == *'on'* ]]; then
    echo "La TV est allumée."
  else
    echo "La TV est éteinte."
  fi

  sleep 60
done