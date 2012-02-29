#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs


if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/* ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

xset +fp /usr/share/fonts/local
xset fp rehash

setxkbmap -option ctrl:swapcaps

# prepare the wm
xrdb -merge ~/.Xresources
xsetroot -cursor_name left_ptr
feh --bg-scale  ~/.res/arch-bg.jpg

urxvtd &
unclutter &
mpd &
emacs --daemon &
redshift -O 7000 &
xmonad
