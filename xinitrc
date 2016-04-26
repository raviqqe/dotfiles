#!/bin/sh

. $HOME/.sh/util.sh


export LC_ALL=en_US.UTF-8

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=xim
export XMODIFIERS=@im=ibus
/usr/local/bin/mozc start
ibus-daemon -r --daemonize --xim

xset b off
xset s blank
xset s 60
xautolock -time 2 -locker slock &

if on_freebsd
then
  while :
  do
    identity="$(whoami)@$(hostname -s)"
    cpu_load=" | $(uptime | grep -o 'load.*')"
    date=" | $(TZ=Asia/Tokyo date | sed 's/  */ /g')"

    if acpiconf -i 0 > /dev/null 2>&1
    then
      capacity=$(acpiconf -i 0 | grep 'Remaining capacity:' |
                 grep -o '[^[:blank:]]*$')

      if [ -z $(acpiconf -i 0 | grep 'State:' | grep -o discharging) ]
      then
        charging=", charging"
      fi

      battery_state=" | battery: $capacity$charging"
    fi

    xsetroot -name "$identity$cpu_load$battery_state$date"
    sleep 0.3
  done &
fi

while :
do
  feh --bg-fill $(find "$HOME/.wallpapers/" \
                       -name *.png -or -name *.jpg -or -name *.jpeg | \
                  sort -R | head -n 1)
  sleep 1800
done &

urxvt &
exec dwm
