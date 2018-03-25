#!/bin/sh

. ~/.profile
. ~/.sh/util.sh


export LC_ALL=en_US.UTF-8

xset b off
xset s blank
xset s 180
xautolock -time 5 -locker slock &

while :
do
  identity="$(whoami)@$(hostname -s)"
  cpu_load=" | $(uptime | grep -o 'load.*')"
  date=" | $(TZ=Asia/Tokyo date | sed 's/  */ /g')"

  if upower --dump | grep percentage > /dev/null 2>&1
  then
    battery_state=" | battery: $(upower --dump | grep percentage | head -1 | grep -o '[0-9]*%')"
  fi

  xsetroot -name "$identity$cpu_load$battery_state$date"
  sleep 0.3
done &

while :
do
  feh --bg-fill $(find ~/.wallpapers/ \
                       -name *.png -or -name *.jpg -or -name *.jpeg | \
                  sort -R | head -n 1)
  sleep 1800
done &

urxvt &
exec dwm
