#!/bin/sh

. ~/.profile

uxterm &
sxhkd &
exec bspwm
