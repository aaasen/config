# Lines configured by zsh-newuser-install
HISTFILE=~/.zshist
HISTSIZE=1000
SAVEHIST=2048
setopt appendhistory autocd extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/aasen/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U promptinit && promptinit
autoload -U colors && colors

if [ -f ~/.dir_colors ]; then
    eval `dircolors ~/.dir_colors`
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR=vim

if [ -n "$SSH_CLIENT" ]; then
    PS1="%{$fg[green]%}%B%m%b {%{$reset_color%}%{$fg[white]%}%{$reset_color%}%~} "
#    PS1=$'%{\e[1;32%}m%B%m%b %{\e[0m%}%{\e[1;30m%}{%\e[0m%}%~%{\e[1;30m%}}%{\e[0m%} '
else
    PS1="%{$fg[black]%}%B%m%b {%{$reset_color%}%{$fg[white]%}%{$reset_color%}%~} "
#    PS1=$'\e[1m%B%m%b \e[0m\e[1;30m{\e[0m%~\e[1;30m}\e[0m '
#    PS1=$'\e[1m$%B%m%b \e[0m\e[1;30m${\e[0m%~\e[1;30m$}\e[0m '
#    PS1=$'\e[0;31m$ \e[0m'
#    PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
fi

#ls
alias ls="ls --color=auto --group-directories-first"
alias la="ls -a" #all files
alias ll="ls -l" #long listing format
alias lx="ls -x" #grouped by file extension

#cd
alias ..="cd .."
alias j="cd .."
alias ...="cd ../.."
alias jj="cd ../.."

#sudo
alias s="sudo"

#pacman
alias pacman="pacman-color"
alias get="sudo pacman -S " #install package
alias sget="pacman -Ss " #search package database
alias uget="sudo pacman -Syu " #update system
alias rget="sudo pacman -Rs " #remove package
alias cget="pacman -Qdt | egrep -o '[a-z0-9-]+ '\ | sudo pacman -Rs || echo 'no unused orphan packages to remove'" #removes unused packages
alias iget="pacman -Qi " #information about package

#yaourt
alias yet="yaourt -S " #install package
alias syet="yaourt -Ss " #search package database
alias uyet="sudo yaourt -Syu " #update system
alias ryet="sudo yaourt -Rs " #remove package
alias iyet="yaourt -Qi " #information about package

#system
alias sdown="sudo shutdown -h now"
alias suspend="sudo pm-suspend"

#cpu frequency scaling
alias cfset="sudo cpufreq-set -r -g "

#ssh
alias ssh="ssh -C "
alias sshfs="sshfs -C "
alias spg="ssh phenom-glob"
alias spl="ssh phenom-loc"
alias sfspg="sshfs phenom-glob:/home/aasen phenom/"
alias sfspl="sshfs phenom-loc:/home/aasen phenom/"
alias sfsu="fusermount -u "
alias sfsfire="sshfs firedove:/home4/benelabo/ ~/mnt/firedove"

#screen
alias sc="screen"
alias sr="screen -r"

#miscellaneous super short names
alias a="alsamixer"
alias e="emacsclient -t"
alias se="sudo emacs"
alias v="vim"
alias sv="sudo vim"
alias n="nano"
alias l="less"
alias m="more" #hehe
alias g="grep"
alias eg="grep -E"
alias gr="grep -R --color"

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

#games
alias tf2="SDL_AUDIODRIVER=alsa LC_NUMERIC=POSIX steam steam://rungameid/440"

#graphics
alias atiup="sudo rm /etc/ati/amdpcsdb && echo 'start xmonad and then run amdccle'"

#media
alias yget="cd ~/vid && youtube-dl -t "
alias mplayer="mplayer -vo vaapi "

#ncmpcpp
alias n="ncmpcpp -s playlist "
alias np="ncmpcpp pause"
alias ns="ncmpcpp stop"
alias nn="ncmpcpp next"
alias nb="ncmpcpp prev"
alias nu="ncmpcpp volume +10"
alias nd="ncmpcpp volume -10"

#feh geometry option is for tiling window managers only
#alias fehimg="feh --image-bg black -zZ. --geometry 1366x768"
alias fehimg="feh --image-bg black -Z. --geometry 1366x768"
alias fehslide="fehimg -D 5"
alias fehsliderand="fehslide -z"

#apache
alias apaconf="sudo $EDITOR /etc/httpd/conf/httpd.conf"

#firefox
alias firedef="firefox -P default"
alias firedev="firefox -P dev -no-remote"

#system monitoring
#alias sysmonsuite="$(htop) & $(urxvtc -e cfsview $) $(urxvtc -e sensors &)"



#functions

function fehfilter() {
	fehslide -A 'echo %F && mv %F /home/aasen/final/'
}

function md() { #mkdir and cd into it
    mkdir -p "$1" && cd "$1"
}

function cd() { #cd into dir and then ls
    builtin cd "${@:-$HOME}" && ls -cr --color=auto --group-directories-first
}

function connected() { 
    ping -c1 -w2 google.com | grep -c '1 received';
}

function bac() {
    export VERSION_CONTROL=numbered
    cp --force --backup $1 $1
}

function sshinit() {
    eval $(ssh-agent)
    ssh-add /home/aasen/.ssh/phenom
}


function cfsview() {
    watch grep \"cpu MHz\" /proc/cpuinfo
}

function gfind() {
	grep -RE --color $1
}
