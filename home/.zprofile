# executed upon login

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    export PATH="${PATH}:/opt/android-sdk/tools:/home/aasen/.depot_tools"
    exec startx
fi
