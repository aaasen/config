#
# ~/.bashrc
#

if [ -f ~/.dir_colors ]; then
    eval `dircolors ~/.dir_colors`
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR=emacs

PS1='\[\e[1m\]\u\[\e[m\] \[\e[1;30m\]{\[\e[m\]\w\[\e[m\]\[\e[1;30m\]}\[\e[m\] \[\e[1;30m\]\$\[\e[m\] \[\e[m'

complete -cf man
complete -cf pacman
complete -cf get
complete -cf rget
complete -cf lget

#sudo for autocompletion
complete -cf sudo
alias sudo='sudo '
alias s='sudo '

#ls
alias ls='ls --color=auto --group-directories-first'
alias la='ls -a' #all files
alias ll='ls -l' #long listing format
alias lx='ls -x' #grouped by file extension

#pacman
alias get="sudo pacman -S " #install package
alias sget="pacman -Ss " #query package database
alias uget="sudo pacman -Syu " #update system
alias rget="sudo pacman -Rs " #remove package
alias cget="pacman -Qdt | egrep -o '[a-z0-9-]+ '\ | sudo pacman -Rs || echo 'no unused orphan packages to remove'" #removes unused packages
alias lget="sudo pacman -U" #install local package (useful for AUR)

#system
alias sdown="sudo shutdown -h now"
alias suspend='sudo pm-suspend'

#miscellaneous super short names
alias a="alsamixer"
alias e="emacsclient -t"
alias se="sudo e"
alias l="less"
alias m="more"
alias g="grep"
alias eg="egrep"

#archiving
alias utar="tar -xf" #untar
alias atar="tar -cavf" #infer archive format from output file name
alias gtar="tar -czvf" #gzip
alias btar="tar -cjvf" #bz2
alias xtar="tar -cJvf" #xz

#log files
alias xlog="cat /var/log/Xorg.0.log | egrep -n -T \"(\(EE\)|\(WW\))\" | less"

#internet
alias snet="sudo rc.d stop network"
alias rnet="sudo rc.d restart network"
alias swicd="sudo rc.d start wicd"
alias rwicd="sudo rc.d restart wicd"
alias netwicd="sudo rc.d stop network && sudo rc.d start wicd && wicd-curses"
alias cwicd="wicd-curses"

#minecraft
#alias minecraft="export LD_LIBRARY_PATH=/usr/lib/jvm/java-7-openjdk/jre/lib/i386/; java -Xmx2048M -Xms1024M -jar /usr/local/games/minecraft/minecraft.jar"
#alias mineserver="cd /usr/local/games/minecraft && java -Xmx2048M -Xms1024M -jar server.jar nogui"

#graphics
alias fehimg='feh --image-bg black -zZ. --geometry 1366x768'
alias fehslide='fehimg -D 5'
alias fehfilter="sudo fehslide -A 'rm %F'"
alias fehsliderand='fehslide -z'

#media
alias yget="cd ~/vid && youtube-dl -t "

#audio 
alias n="ncmpcpp"
alias np="ncmpcpp pause"
alias ns="ncmpcpp stop"
alias nn="ncmpcpp next"
alias nb="ncmpcpp previous"
alias nu="ncmpcpp volume +10"
alias nd="ncmpcpp volume -10"

#cpu frequency scaling
alias cfs-ondemand="sudo cpufreq-set -r -g ondemand"
alias cfs-powersave="sudo cpufreq-set -r -g powersave"
alias cfs-view="watch grep MHz /proc/cpuinfo"
