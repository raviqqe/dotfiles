#!/bin/sh

. ~/.profile

while :
do
  cpu="$(uptime | grep -o 'load.*')"

  if upower --dump | grep percentage > /dev/null 2>&1
  then
    battery=" | battery: $(upower --dump | grep percentage | grep -om1 '[0-9]*%')"
  fi

  xsetroot -name "$(whoami)@$(hostname -s) | $cpu$battery | $(date)"
  sleep 0.2
done &

uxterm &
exec dwm
