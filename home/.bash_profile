#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    export PATH="${PATH}:/opt/android-sdk/tools"
    exec startx
fi
