#!/bin/sh
picom &
nitrogen --restore
xrandr --output DisplayPort-0 --mode 1920x1080 --rate 144 --primary --left-of DisplayPort-2 --output DisplayPort-2 --mode 1920x1080 --rate 144 &
xsetroot -cursor_name left_ptr &
xrdb -merge ~/.Xresources
